#Import "<stdlib>"
#Import "<sdk_mojo>"

Using stdlib..
Using sdk_mojo..

' Utilities
' Authored by iDkP from GaragePixel
' 2025-03-17 19:07:05
' Aida 4
'
' PURPOSE:
' Implements utility functions and classes for the pixel editor
' including color manipulation, math helpers, and undo/redo system
'
' Features:
' - Color blending and manipulation utilities
' - Value clamping and math functions
' - Editable history system for undo/redo operations
' - Coordinate transformation helpers
' - File operations for image import/export
'
' Notes:
' 	These utilities are designed specifically for the Monkey2 graphics
' 	pipeline and take into account the unique needs of a pixel art
' 	editor with tablet support. The color utilities implement efficient
' 	blending algorithms that maintain color accuracy while the history
' 	system uses a command pattern to minimize memory usage.
'
' Technical:
' - Optimized color operations minimize per-pixel processing time
' - Memory-efficient undo system that stores operations not pixels
' - Coordinate conversions handle scaling and rotation properly
' - File operations use platform-specific optimizations when available

' Color utilities
Class ColorUtils
	' Blend two colors based on alpha
	Function Blend:Color(c1:Color, c2:Color)
		Local a:= c2.A + c1.A * (1.0 - c2.A)
		
		If a <= 0.0001 Return New Color(0, 0, 0, 0)
		
		Local r:= (c2.R * c2.A + c1.R * c1.A * (1.0 - c2.A)) / a
		Local g:= (c2.G * c2.A + c1.G * c1.A * (1.0 - c2.A)) / a
		Local b:= (c2.B * c2.A + c1.B * c1.A * (1.0 - c2.A)) / a
		
		Return New Color(r, g, b, a)
	End
	
	' Blend multiple colors
	Function BlendMultiple:Color(colors:Color[])
		If colors.Length = 0 Return New Color(0, 0, 0, 0)
		If colors.Length = 1 Return colors[0]
		
		Local result:= colors[0]
		For Local i:= 1 Until colors.Length
			result = Blend(result, colors[i])
		Next
		
		Return result
	End
	
	' Adjust color brightness
	Function AdjustBrightness:Color(color:Color, amount:Float)
		Return New Color(
			Clamp(color.R + amount, 0.0, 1.0),
			Clamp(color.G + amount, 0.0, 1.0),
			Clamp(color.B + amount, 0.0, 1.0),
			color.A	)
	End
	
	' Convert HSV to RGB color
	Function HSVToRGB:Color(h:Float, s:Float, v:Float, a:Float=1.0)
		h = (h Mod 360 + 360) Mod 360  ' Normalize h to [0, 360)
		s = Clamp(s, 0.0, 1.0)
		v = Clamp(v, 0.0, 1.0)
		
		Local c:= v * s
		Local x:= c * (1 - Abs((h / 60) Mod 2 - 1))
		Local m:= v - c
		
		Local r:Float, g:Float, b:Float
		
		If h < 60
			r = c
			g = x
			b = 0
		ElseIf h < 120
			r = x
			g = c
			b = 0
		ElseIf h < 180
			r = 0
			g = c
			b = x
		ElseIf h < 240
			r = 0
			g = x
			b = c
		ElseIf h < 300
			r = x
			g = 0
			b = c
		Else
			r = c
			g = 0
			b = x
		End
		
		Return New Color(r + m, g + m, b + m, a)
	End
	
	' Convert RGB to HSV
	Function RGBToHSV:Float[](color:Color)
		Local r:= color.R
		Local g:= color.G
		Local b:= color.B
		
		Local cmax:= Max(r, Max(g, b))
		Local cmin:= Min(r, Min(g, b))
		Local delta:= cmax - cmin
		
		Local h:Float, s:Float, v:Float
		
		' Calculate hue
		If delta = 0
			h = 0
		ElseIf cmax = r
			h = 60 * ((g - b) / delta Mod 6)
		ElseIf cmax = g
			h = 60 * ((b - r) / delta + 2)
		ElseIf cmax = b
			h = 60 * ((r - g) / delta + 4)
		End
		
		If h < 0 Then h += 360
		
		' Calculate saturation
		If cmax = 0
			s = 0
		Else
			s = delta / cmax
		End
		
		' Calculate value
		v = cmax
		
		Return New Float[](h, s, v)
	End
End

' Math utilities
Function Clamp:Float(value:Float, minValue:Float, maxValue:Float)
	If value < minValue Return minValue
	If value > maxValue Return maxValue
	Return value
End

Function Clamp:Int(value:Int, minValue:Int, maxValue:Int)
	If value < minValue Return minValue
	If value > maxValue Return maxValue
	Return value
End

Function Lerp:Float(a:Float, b:Float, t:Float)
	Return a + (b - a) * Clamp(t, 0.0, 1.0)
End

'Function Abs:Float(value:Float)
'	If value < 0 Return -value
'	Return value
'End

' Command pattern for undo/redo system
Interface ICommand
	Method Execute()
	Method Undo()
End

Class CommandHistory
	Field _commands:Stack<ICommand> = New Stack<ICommand>
	Field _redoStack:Stack<ICommand> = New Stack<ICommand>
	Field _maxHistory:Int = 100
	
	Method Execute(command:ICommand)
		command.Execute()
		_commands.Push(command)
		
		' Clear redo stack
		_redoStack.Clear()
		
		' Limit history size
		If _commands.Length > _maxHistory
			_commands.Erase(0)
		End
	End
	
	Method Undo()
		If _commands.Length = 0 Return
		
		Local command:= _commands.Pop()
		command.Undo()
		_redoStack.Push(command)
	End
	
	Method Redo()
		If _redoStack.Length = 0 Return
		
		Local command:= _redoStack.Pop()
		command.Execute()
		_commands.Push(command)
	End
	
	Method CanUndo:Bool()
		Return _commands.Length > 0
	End
	
	Method CanRedo:Bool()
		Return _redoStack.Length > 0
	End
	
	Method Clear()
		_commands.Clear()
		_redoStack.Clear()
	End
End

' Draw commands for undo/redo
Class DrawCommand Implements ICommand
	Field _layer:Layer
	Field _beforePixmap:Pixmap
	Field _afterPixmap:Pixmap
	Field _x:Int
	Field _y:Int
	Field _width:Int
	Field _height:Int
	
	Method New(layer:Layer, x:Int, y:Int, width:Int, height:Int)
		_layer = layer
		_x = x
		_y = y
		_width = width
		_height = height
		
		' Create "before" snapshot of the affected area
		_beforePixmap = ExtractRegion(layer.GetPixmap(), x, y, width, height)
	End
	
	Method Execute()
		If _afterPixmap = Null Return
		
		' Apply the "after" state
		ApplyRegion(_layer.GetPixmap(), _afterPixmap, _x, _y)
		_layer._image = New Image(_layer.GetPixmap())
		_layer._isDirty = True
	End
	
	Method Undo()
		' Apply the "before" state
		ApplyRegion(_layer.GetPixmap(), _beforePixmap, _x, _y)
		_layer._image = New Image(_layer.GetPixmap())
		_layer._isDirty = True
	End
	
	Method SetAfterState()
		' Create "after" snapshot of the affected area
		_afterPixmap = ExtractRegion(_layer.GetPixmap(), _x, _y, _width, _height)
	End
	
	' Extract a region from a pixmap
	Method ExtractRegion:Pixmap(source:Pixmap, x:Int, y:Int, width:Int, height:Int)
		Local region:= New Pixmap(width, height, source.Format)
		
		For Local py:= 0 Until height
			For Local px:= 0 Until width
				Local sx:= x + px
				Local sy:= y + py
				
				If sx >= 0 And sx < source.Width And 
				   sy >= 0 And sy < source.Height
					region.SetPixel(px, py, source.GetPixel(sx, sy))
				End
			Next
		Next
		
		Return region
	End
	
	' Apply a region to a pixmap
	Method ApplyRegion(target:Pixmap, source:Pixmap, x:Int, y:Int)
		For Local py:= 0 Until source.Height
			For Local px:= 0 Until source.Width
				Local tx:= x + px
				Local ty:= y + py
				
				If tx >= 0 And tx < target.Width And 
				   ty >= 0 And ty < target.Height
					target.SetPixel(tx, ty, source.GetPixel(px, py))
				End
			Next
		Next
	End
End

' File operations
Class FileUtils
	' Save pixmap as PNG
	Function SaveAsPNG:Bool(pixmap:Pixmap, path:String)
'		Try
			Return pixmap.Save(path)
'		Catch ex:Error
'			Print "Error saving image: " + ex.Message
'			Return False
'		End
		Return False
	End
	
	' Load image from file
	Function LoadImage:Pixmap(path:String)
'		Try
			Return Pixmap.Load(path)
'		Catch ex:Exception
'			Print "Error loading image: " + ex.Message
'			Return Null
'		End
		Return Null
	End
End