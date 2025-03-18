#Import "<stdlib>"
#Import "<sdk_mojo>"

Using stdlib..
Using sdk_mojo..

' Tools
' Authored by iDkP from GaragePixel
' 2025-03-17
' Aida 4
'
' Implements various drawing tools for the pixel editor with tablet support
' Each tool handles mouse/tablet input and updates the active layer

Class Tool
	Field Name:String
	Field _editor:PixelEditor
	Field _icon:Image
	Field _size:Float = 10.0
	Field _hardness:Float = 1.0
	Field _lastX:Float
	Field _lastY:Float
	Field _lastPressure:Float = 1.0
	
	Method New(name:String, editor:PixelEditor)
		Name = name
		_editor = editor
		LoadIcon()
	End
	
	Method LoadIcon()
		' Implementation will load an icon for the tool
		' Placeholder as icons would be loaded from resources
		_icon = Null
	End
	
	Method OnBeginStroke(x:Float, y:Float, pressure:Float, tiltX:Float, tiltY:Float) Virtual
		_lastX = x
		_lastY = y
		_lastPressure = pressure
	End
	
	Method OnStrokePoint(x:Float, y:Float, pressure:Float, tiltX:Float, tiltY:Float) Virtual
		' Base implementation does nothing
	End
	
	Method OnEndStroke(x:Float, y:Float, pressure:Float, tiltX:Float, tiltY:Float) Virtual
		' Base implementation does nothing
	End
	
	Method RenderPreview(canvas:Canvas) Virtual
		' Base implementation does nothing
	End
	
	Method GetIcon:Image()
		Return _icon
	End

	Property Size:Float() 
		Return _size
	Setter(value:Float)
		_size = Clamp(value, 1.0, 100.0)
	End
	
	Property Hardness:Float()
		Return _hardness
	Setter(value:Float)
		_hardness = Clamp(value, 0.0, 1.0)
	End
End

Class BrushTool Extends Tool
	Method New(name:String, editor:PixelEditor)
		Super.New(name, editor)
	End
	
	Method OnBeginStroke(x:Float, y:Float, pressure:Float, tiltX:Float, tiltY:Float) Override
		Super.OnBeginStroke(x, y, pressure, tiltX, tiltY)
		
		' Apply pressure to brush size
		Local effectiveSize:= _size * pressure
		
		' Draw the point
		_editor.ActiveLayer.DrawPixel(Int(x), Int(y), _editor.CurrentColor, effectiveSize, _hardness)
	End
	
	Method OnStrokePoint(x:Float, y:Float, pressure:Float, tiltX:Float, tiltY:Float) Override
		' Calculate effective brush size based on pressure
		Local effectiveSize:= _size * pressure
		
		' Interpolate stroke between last and current point
		_editor.ActiveLayer.DrawLine(
			Int(_lastX), Int(_lastY), 
			Int(x), Int(y), 
			_editor.CurrentColor, 
			effectiveSize,
			_hardness	)
		
		' Remember last position
		_lastX = x
		_lastY = y
		_lastPressure = pressure
	End
	
	Method RenderPreview(canvas:Canvas) Override
		' Draw a preview circle at the current brush position
		canvas.Color = New Color(_editor.CurrentColor.R, _editor.CurrentColor.G, _editor.CurrentColor.B, 0.5)
		canvas.DrawCircle(_lastX, _lastY, _size * _lastPressure / 2)
		
		' Draw outline
		canvas.Color = Color.White
		canvas.Alpha = 0.8
		canvas.DrawCircle(_lastX, _lastY, _size * _lastPressure / 2)
	End
End

Class PencilTool Extends Tool
	Method New(name:String, editor:PixelEditor)
		Super.New(name, editor)
		_size = 1.0  ' Pencil has fixed size
		_hardness = 1.0  ' And full hardness
	End
	
	Method OnBeginStroke(x:Float, y:Float, pressure:Float, tiltX:Float, tiltY:Float) Override
		Super.OnBeginStroke(x, y, pressure, tiltX, tiltY)
		
		' Draw the point (pencil ignores pressure for size)
		_editor.ActiveLayer.DrawPixel(Int(x), Int(y), _editor.CurrentColor, _size, _hardness)
	End
	
	Method OnStrokePoint(x:Float, y:Float, pressure:Float, tiltX:Float, tiltY:Float) Override
		' Interpolate stroke between last and current point
		' Pencil ignores pressure for size, but may use it for opacity
		Local color:= _editor.CurrentColor
		Local modifiedColor:= New Color(color.R, color.G, color.B, color.A * pressure)
		
		_editor.ActiveLayer.DrawLine(
			Int(_lastX), Int(_lastY), 
			Int(x), Int(y), 
			modifiedColor, 
			_size,
			_hardness	)
		
		' Remember last position
		_lastX = x
		_lastY = y
		_lastPressure = pressure
	End
	
	Method RenderPreview(canvas:Canvas) Override
		' Draw a small preview dot at the current position
		canvas.Color = _editor.CurrentColor
		canvas.Alpha = 0.8
		canvas.DrawCircle(_lastX, _lastY, _size)
	End
End

Class EraserTool Extends Tool
	Method New(name:String, editor:PixelEditor)
		Super.New(name, editor)
	End
	
	Method OnBeginStroke(x:Float, y:Float, pressure:Float, tiltX:Float, tiltY:Float) Override
		Super.OnBeginStroke(x, y, pressure, tiltX, tiltY)
		
		' Apply pressure to eraser size
		Local effectiveSize:= _size * pressure
		
		' Draw transparent point (erase)
		_editor.ActiveLayer.DrawPixel(Int(x), Int(y), Color.None, effectiveSize, _hardness)
	End
	
	Method OnStrokePoint(x:Float, y:Float, pressure:Float, tiltX:Float, tiltY:Float) Override
		' Calculate effective eraser size based on pressure
		Local effectiveSize:= _size * pressure
		
		' Erase line between last and current point
		_editor.ActiveLayer.DrawLine(
			Int(_lastX), Int(_lastY), 
			Int(x), Int(y), 
			Color.None, 
			effectiveSize,
			_hardness	)
		
		' Remember last position
		_lastX = x
		_lastY = y
		_lastPressure = pressure
	End
	
	Method RenderPreview(canvas:Canvas) Override
		' Draw a preview circle at the current eraser position
		canvas.Color = Color.White
		canvas.Alpha = 0.3
		canvas.DrawCircle(_lastX, _lastY, _size * _lastPressure / 2)
		
		' Draw outline
		canvas.Color = Color.White
		canvas.Alpha = 0.8
		canvas.DrawCircle(_lastX, _lastY, _size * _lastPressure / 2)
	End
End

Class ColorPickerTool Extends Tool
	Method New(name:String, editor:PixelEditor)
		Super.New(name, editor)
	End
	
	Method OnBeginStroke(x:Float, y:Float, pressure:Float, tiltX:Float, tiltY:Float) Override
		Super.OnBeginStroke(x, y, pressure, tiltX, tiltY)
		
		' Get color at point
		Local pixelX:= Int(x)
		Local pixelY:= Int(y)
		
		If pixelX >= 0 And pixelX < _editor.ActiveLayer.GetPixmap().Width And
		   pixelY >= 0 And pixelY < _editor.ActiveLayer.GetPixmap().Height
			Local pixmap:= _editor.ActiveLayer.GetPixmap()
			Local pickedColor:= pixmap.GetPixel(pixelX, pixelY)
			
			' Only pick if not fully transparent
			If pickedColor.A > 0
				_editor.CurrentColor = pickedColor
			End
		End
	End
	
	Method RenderPreview(canvas:Canvas) Override
		' Draw a preview circle at the current position
		canvas.Color = Color.White
		canvas.Alpha = 0.8
		canvas.DrawCircle(_lastX, _lastY, 10)
		
		' Draw crosshair
		canvas.DrawLine(_lastX-10, _lastY, _lastX+10, _lastY)
		canvas.DrawLine(_lastX, _lastY-10, _lastX, _lastY+10)
	End
End

Class FillTool Extends Tool
	Field _tolerance:Float = 0.1
	
	Method New(name:String, editor:PixelEditor)
		Super.New(name, editor)
	End
	
	Method OnBeginStroke(x:Float, y:Float, pressure:Float, tiltX:Float, tiltY:Float) Override
		Super.OnBeginStroke(x, y, pressure, tiltX, tiltY)
		
		' Fill area
		_editor.ActiveLayer.Fill(Int(x), Int(y), _editor.CurrentColor, _tolerance)
	End
	
	Property Tolerance:Float()
		Return _tolerance
	Setter(value:Float)
		_tolerance = Clamp(value, 0.0, 1.0)
	End
	
	Method RenderPreview(canvas:Canvas) Override
		' Draw a preview at the current position
		canvas.Color = _editor.CurrentColor
		canvas.Alpha = 0.5
		canvas.DrawCircle(_lastX, _lastY, 5)
		
		' Draw fill icon
		canvas.Color = Color.White
		canvas.Alpha = 0.8
		canvas.DrawCircle(_lastX, _lastY, 8)
	End
End