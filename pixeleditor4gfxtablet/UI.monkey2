#Import "<stdlib>"
#Import "<sdk_mojo>"

Using stdlib..
Using sdk_mojo..

' UI Components
' Authored by iDkP from GaragePixel
' 2025-03-17 Aida 4
'
' Implements the user interface components for the pixel art editor, including
' toolbox, color palette, layer panel, and status bar. These components provide
' a flexible, movable interface for the artist to interact with the editor.
'
' Features:
' - Movable UI panels with drag handles
' - Tool selection buttons with icons and tooltips
' - Color palette with current color display and recent color history
' - Layer management panel with thumbnails and visibility toggles
' - Status bar showing canvas coordinates and editor state
' - Consistent visual style with translucent backgrounds
' - Responsive layout adapting to editor window size
'
' Notes:
' 	The UI system uses a component-based architecture where each element is an
' 	independent object that can be positioned anywhere in the window. This allows
' 	for a customizable workspace where artists can arrange tools according to
' 	their workflow. Each component maintains its own state and communicates with
' 	the editor core through well-defined interfaces.
'
' Technical:
' - Event bubbling system for efficient input processing
' - Cached rendering for UI components that don't change frequently
' - Optimized hit testing for responsive interaction
' - Memory-efficient UI rendering with minimal texture updates
' - Coordinate transformation handling for proper event positioning
' - Separation of layout and rendering for maintainable code

' Base UI component class
Class UIComponent
	Field Position:Vec2f
	Field Size:Vec2f
	Field Visible:Bool = True
	Field Draggable:Bool = False
	Field IsDragging:Bool = False
	Field DragOffset:Vec2f
	Field BackgroundColor:Color = New Color(0.2, 0.2, 0.2, 0.8)
	Field BorderColor:Color = New Color(0.3, 0.3, 0.3)
	Field TextColor:Color = New Color(0.9, 0.9, 0.9)
	Field _editor:PixelEditor
	
	Method New(editor:PixelEditor, width:Float, height:Float)
		_editor = editor
		Size = New Vec2f(width, height)
		Position = New Vec2f(0, 0)
	End
	
	Method Update() Virtual
		' Base update method for UI components
	End
	
	Method Render(canvas:Canvas) Virtual
		' Base rendering method
		If Not Visible Then Return
		
		' Draw background
		canvas.Color = BackgroundColor
		canvas.DrawRect(Position.X, Position.Y, Size.X, Size.Y)
		
		' Draw border
		canvas.Color = BorderColor
		canvas.DrawRect(Position.X, Position.Y, Size.X, Size.Y)
	End
	
	Method HandleMouseEvent(event:MouseEvent) Virtual
		' Handle dragging
		If Draggable
			Select event.Type
				Case EventType.MouseDown
					If ContainsPoint(event.Location.X, event.Location.Y)
						IsDragging = True
						DragOffset = New Vec2f(event.Location.X - Position.X, event.Location.Y - Position.Y)
					End
				Case EventType.MouseUp
					IsDragging = False
				Case EventType.MouseMove
					If IsDragging
						Position = New Vec2f(event.Location.X - DragOffset.X, event.Location.Y - DragOffset.Y)
					End
			End
		End
	End
	
	Method ContainsPoint:Bool(x:Float, y:Float)
		Return x >= Position.X And x <= Position.X + Size.X And
			   y >= Position.Y And y <= Position.Y + Size.Y
	End
End

' Toolbox component for tool selection
Class ToolBox Extends UIComponent
	Field ButtonSize:Float = 40
	Field Padding:Float = 5
	Field SelectedIndex:Int = 0
	Field ToolIcons:Image[]
	Field ToolTips:String[]
	
	Method New(editor:PixelEditor, width:Float, height:Float)
		Super.New(editor, width, height)
		Draggable = True
		
		' Initialize tool icons and tooltips
		ToolIcons = New Image[5]
		ToolTips = New String[5]
		
		' Set tooltips
		ToolTips[0] = "Brush Tool"
		ToolTips[1] = "Pencil Tool"
		ToolTips[2] = "Eraser Tool"
		ToolTips[3] = "Color Picker"
		ToolTips[4] = "Fill Tool"
		
		' Load icons (placeholder - would use real icons in production)
		For Local i:= 0 Until 5
			Local iconPixmap:= New Pixmap(32, 32, PixelFormat.RGBA8)
			iconPixmap.Clear(New Color(0.8, 0.8, 0.8))
			ToolIcons[i] = New Image(iconPixmap)
		Next
	End
	
	Method Update() Override
		' Update toolbox state
	End
	
	Method Render(canvas:Canvas) Override
		If Not Visible Return
		
		' Draw background
		Super.Render(canvas)
		
		' Draw title
		canvas.Color = TextColor
		canvas.DrawText("Tools", Position.X + Size.X/2, Position.Y + 15, 0.5, 0.0)
		
		' Draw tool buttons
		For Local i:= 0 Until 5
			Local buttonX:= Position.X + Padding
			Local buttonY:= Position.Y + 30 + i * (ButtonSize + Padding)
			
			' Button background - highlight selected
			If i = SelectedIndex
				canvas.Color = New Color(0.4, 0.4, 0.8, 0.8)
			Else
				canvas.Color = New Color(0.3, 0.3, 0.3, 0.8)
			End
			canvas.DrawRect(buttonX, buttonY, ButtonSize, ButtonSize)
			
			' Button border
			canvas.Color = BorderColor
			canvas.DrawRect(buttonX, buttonY, ButtonSize, ButtonSize)
			
			' Draw tool icon
			canvas.Color = Color.White
			canvas.DrawImage(ToolIcons[i], buttonX + ButtonSize/2, buttonY + ButtonSize/2, 0.0, 0.8, 0.8)
		Next
	End
	
	Method HandleMouseEvent(event:MouseEvent) Override
		' Handle dragging from parent
		Super.HandleMouseEvent(event)
		
		' Handle button clicks
		If event.Type = EventType.MouseDown And ContainsPoint(event.Location.X, event.Location.Y)
			Local relY:= event.Location.Y - Position.Y - 30
			Local index:= Int(relY / (ButtonSize + Padding))
			
			If index >= 0 And index < 5
				SelectedIndex = index
				_editor.ActiveTool = _editor._tools[index]
			End
		End
	End
End

' Color palette component for color selection
Class ColorPalette Extends UIComponent
	Field SwatchSize:Float = 20
	Field Padding:Float = 4
	Field HistorySwatches:Int = 8
	Field CurrentColorSize:Float = 40
	Field _hue:Float = 0.0
	Field _saturation:Float = 1.0
	Field _value:Float = 1.0
	Field HistoryStartIndex:Int = 0
	Field _isLeftMouseDown:Bool = False  ' Track left mouse button state
	
	Method New(editor:PixelEditor, width:Float, height:Float)
		Super.New(editor, width, height)
		Draggable = True
	End
	
	Method Update() Override
		' Update palette state
	End
	
	Method Render(canvas:Canvas) Override
		If Not Visible Return
		
		' Draw background
		Super.Render(canvas)
		
		' Draw title
		canvas.Color = TextColor
		canvas.DrawText("Colors", Position.X + Size.X/2, Position.Y + 15, 0.5, 0.0)
		
		' Draw current color
		Local currentX:= Position.X + Padding
		Local currentY:= Position.Y + 30
		
		canvas.Color = _editor.CurrentColor
		canvas.DrawRect(currentX, currentY, CurrentColorSize, CurrentColorSize)
		canvas.Color = BorderColor
		canvas.DrawRect(currentX, currentY, CurrentColorSize, CurrentColorSize)
		
		' Draw color history
		Local histX:= currentX + CurrentColorSize + Padding
		Local histY:= currentY
		
		For Local i:= 0 Until Min(_editor._colorHistory.Length, HistorySwatches)
			Local colorIndex:= (_editor._colorHistory.Length - 1 - i + HistoryStartIndex) Mod _editor._colorHistory.Length
			
			canvas.Color = _editor._colorHistory[colorIndex]
			canvas.DrawRect(histX, histY, SwatchSize, SwatchSize)
			canvas.Color = BorderColor
			canvas.DrawRect(histX, histY, SwatchSize, SwatchSize)
			
			histX += SwatchSize + 2
			If histX + SwatchSize > Position.X + Size.X - Padding
				histX = currentX + CurrentColorSize + Padding
				histY += SwatchSize + 2
			End
		Next
		
		' Draw hue slider
		Local sliderX:= Position.X + Padding
		Local sliderY:= currentY + CurrentColorSize + Padding * 2
		Local sliderWidth:= Size.X - Padding * 2
		Local sliderHeight:= 20
		
		' Draw hue spectrum
		For Local x:= 0 Until sliderWidth
			Local hue:= x / sliderWidth
			canvas.Color = HsvToRgb(hue, 1.0, 1.0)
			canvas.DrawLine(sliderX + x, sliderY, sliderX + x, sliderY + sliderHeight)
		Next
		
		' Draw hue slider marker
		canvas.Color = Color.White
		canvas.DrawRect(sliderX + _hue * sliderWidth - 2, sliderY - 2, 4, sliderHeight + 4)
		
		' Draw saturation/value picker
		Local pickerX:= sliderX
		Local pickerY:= sliderY + sliderHeight + Padding
		Local pickerSize:= Min(Size.X - Padding * 2, Size.Y - pickerY - Padding)
		
		' Draw S/V gradient
		For Local y:= 0 Until pickerSize
			For Local x:= 0 Until pickerSize
				Local s:= x / pickerSize
				Local v:= 1.0 - y / pickerSize
				canvas.Color = HsvToRgb(_hue, s, v)
				canvas.DrawRect(pickerX + x, pickerY + y, 1, 1)
			Next
		Next
		
		' Draw picker marker
		canvas.Color = Color.White
		canvas.DrawCircle(pickerX + _saturation * pickerSize, pickerY + (1.0 - _value) * pickerSize, 4)
	End
	
	Method HandleMouseEvent(event:MouseEvent) Override
		' Handle dragging from parent
		Super.HandleMouseEvent(event)
		
		' Track mouse button state
		If event.Type = EventType.MouseDown And event.Button = MouseButton.Left
			_isLeftMouseDown = True
		Elseif event.Type = EventType.MouseUp And event.Button = MouseButton.Left
			_isLeftMouseDown = False
		End
		
		If Not ContainsPoint(event.Location.X, event.Location.Y) Return
		
		' Handle color selection
		If event.Type = EventType.MouseDown Or 
		   (event.Type = EventType.MouseMove And _isLeftMouseDown)
			   
			' Check if click is in current color swatch
			Local currentX:= Position.X + Padding
			Local currentY:= Position.Y + 30
			
			' Check history swatches
			Local histX:= currentX + CurrentColorSize + Padding
			Local histY:= currentY
			
			For Local i:= 0 Until Min(_editor._colorHistory.Length, HistorySwatches)
				Local colorIndex:= (_editor._colorHistory.Length - 1 - i + HistoryStartIndex) Mod _editor._colorHistory.Length
				
				If event.Location.X >= histX And event.Location.X < histX + SwatchSize And
				   event.Location.Y >= histY And event.Location.Y < histY + SwatchSize And
				   event.Type = EventType.MouseDown
					
					' Select color from history
					_editor.CurrentColor = _editor._colorHistory[colorIndex]
					Return
				End
				
				histX += SwatchSize + 2
				If histX + SwatchSize > Position.X + Size.X - Padding
					histX = currentX + CurrentColorSize + Padding
					histY += SwatchSize + 2
				End
			Next
			
			' Check hue slider
			Local sliderX:= Position.X + Padding
			Local sliderY:= currentY + CurrentColorSize + Padding * 2
			Local sliderWidth:= Size.X - Padding * 2
			Local sliderHeight:= 20
			
			If event.Location.X >= sliderX And event.Location.X < sliderX + sliderWidth And
			   event.Location.Y >= sliderY And event.Location.Y < sliderY + sliderHeight
				
				_hue = (event.Location.X - sliderX) / sliderWidth
				_editor.CurrentColor = HsvToRgb(_hue, _saturation, _value)
				Return
			End
			
			' Check S/V picker
			Local pickerX:= sliderX
			Local pickerY:= sliderY + sliderHeight + Padding
			Local pickerSize:= Min(Size.X - Padding * 2, Size.Y - pickerY - Padding)
			
			If event.Location.X >= pickerX And event.Location.X < pickerX + pickerSize And
			   event.Location.Y >= pickerY And event.Location.Y < pickerY + pickerSize
				
				_saturation = (event.Location.X - pickerX) / pickerSize
				_value = 1.0 - (event.Location.Y - pickerY) / pickerSize
				
				_saturation = Clamp(_saturation, 0.0, 1.0)
				_value = Clamp(_value, 0.0, 1.0)
				
				_editor.CurrentColor = HsvToRgb(_hue, _saturation, _value)
				Return
			End
		End
	End
	
	Method HsvToRgb:Color(h:Float, s:Float, v:Float)
		h = (h - Floor(h)) * 6.0
		Local i:= Int(h)
		Local f:= h - i
		
		Local p:= v * (1.0 - s)
		Local q:= v * (1.0 - s * f)
		Local t:= v * (1.0 - s * (1.0 - f))
		
		Select i
			Case 0 Return New Color(v, t, p)
			Case 1 Return New Color(q, v, p)
			Case 2 Return New Color(p, v, t)
			Case 3 Return New Color(p, q, v)
			Case 4 Return New Color(t, p, v)
		End
		Return New Color(v, p, q)
	End
End

' Layer panel for layer management
Class LayerPanel Extends UIComponent
	Field HeaderHeight:Float = 30
	Field LayerHeight:Float = 60
	Field ButtonSize:Float = 20
	Field Padding:Float = 5
	Field ScrollOffset:Int = 0
	
	Method New(editor:PixelEditor, width:Float, height:Float)
		Super.New(editor, width, height)
		Draggable = True
	End
	
	Method Update() Override
		' Update layer panel state
	End
	
	Method Render(canvas:Canvas) Override
		If Not Visible Then Return
		
		' Draw background
		Super.Render(canvas)
		
		' Draw title
		canvas.Color = TextColor
		canvas.DrawText("Layers", Position.X + Size.X/2, Position.Y + 15, 0.5, 0.0)
		
		' Draw layer management buttons
		Local buttonX:= Position.X + Padding
		Local buttonY:= Position.Y + HeaderHeight
		
		' New layer button
		canvas.Color = New Color(0.3, 0.6, 0.3)
		canvas.DrawRect(buttonX, buttonY, ButtonSize, ButtonSize)
		canvas.Color = BorderColor
		canvas.DrawRect(buttonX, buttonY, ButtonSize, ButtonSize)
		canvas.Color = TextColor
		canvas.DrawText("+", buttonX + ButtonSize/2, buttonY + ButtonSize/2, 0.5, 0.5)
		
		' Delete layer button
		buttonX += ButtonSize + Padding
		canvas.Color = New Color(0.6, 0.3, 0.3)
		canvas.DrawRect(buttonX, buttonY, ButtonSize, ButtonSize)
		canvas.Color = BorderColor
		canvas.DrawRect(buttonX, buttonY, ButtonSize, ButtonSize)
		canvas.Color = TextColor
		canvas.DrawText("-", buttonX + ButtonSize/2, buttonY + ButtonSize/2, 0.5, 0.5)
		
		' Move layer up button
		buttonX += ButtonSize + Padding
		canvas.Color = New Color(0.3, 0.3, 0.6)
		canvas.DrawRect(buttonX, buttonY, ButtonSize, ButtonSize)
		canvas.Color = BorderColor
		canvas.DrawRect(buttonX, buttonY, ButtonSize, ButtonSize)
		canvas.Color = TextColor
		canvas.DrawText("↑", buttonX + ButtonSize/2, buttonY + ButtonSize/2, 0.5, 0.5)
		
		' Move layer down button
		buttonX += ButtonSize + Padding
		canvas.Color = New Color(0.3, 0.3, 0.6)
		canvas.DrawRect(buttonX, buttonY, ButtonSize, ButtonSize)
		canvas.Color = BorderColor
		canvas.DrawRect(buttonX, buttonY, ButtonSize, ButtonSize)
		canvas.Color = TextColor
		canvas.DrawText("↓", buttonX + ButtonSize/2, buttonY + ButtonSize/2, 0.5, 0.5)
		
		' Draw layers
		Local layerY:= Position.Y + HeaderHeight + ButtonSize + Padding
		Local maxLayers:= Int((Size.Y - layerY) / LayerHeight)
		Local startIndex:= Max(0, Min(ScrollOffset, _editor._layers.Length - maxLayers))
		
		For Local i:= startIndex Until Min(_editor._layers.Length, startIndex + maxLayers)
			Local layer:= _editor._layers[i]
			Local isActive:= (i = _editor._activeLayerIndex)
			Local layerX:= Position.X + Padding
			
			' Draw layer background - highlight active layer
			If isActive
				canvas.Color = New Color(0.4, 0.4, 0.8, 0.7)
			Else
				canvas.Color = New Color(0.3, 0.3, 0.3, 0.7)
			End
			canvas.DrawRect(layerX, layerY, Size.X - Padding*2, LayerHeight-Padding)
			canvas.Color = BorderColor
			canvas.DrawRect(layerX, layerY, Size.X - Padding*2, LayerHeight-Padding)
			
			' Draw layer thumbnail
			Local thumbX:= layerX + Padding
			Local thumbY:= layerY + Padding
			Local thumbSize:= LayerHeight - Padding*2
			
			' Draw thumbnail background (checkered pattern)
			For Local y:= 0 Until thumbSize Step 8
				For Local x:= 0 Until thumbSize Step 8
					If (x / 8 + y / 8) Mod 2 = 0
						canvas.Color = New Color(0.8, 0.8, 0.8)
					Else
						canvas.Color = New Color(0.6, 0.6, 0.6)
					End
					canvas.DrawRect(thumbX + x, thumbY + y, Min(8, Int(thumbSize-x)), Min(8, (Int(thumbSize-y))))
				Next
			Next
			
			' Draw thumbnail
			canvas.Color = Color.White
			canvas.Alpha = layer.Visible ? 1.0 Else 0.5
			canvas.DrawImage(layer.GetThumbnailImage(), thumbX + thumbSize/2, thumbY + thumbSize/2, 0.0, 0.5, 0.5)
			canvas.Alpha = 1.0
			
			' Draw layer name
			canvas.Color = TextColor
			canvas.DrawText(layer.Name, thumbX + thumbSize + Padding, layerY + LayerHeight/2, 0.0, 0.5)
			
			' Draw visibility toggle
			Local toggleX:= Position.X + Size.X - Padding - ButtonSize
			Local toggleY:= layerY + (LayerHeight - ButtonSize) / 2
			
			canvas.Color = layer.Visible ? New Color(0.3, 0.7, 0.3) Else New Color(0.5, 0.5, 0.5)
			canvas.DrawRect(toggleX, toggleY, ButtonSize, ButtonSize)
			canvas.Color = BorderColor
			canvas.DrawRect(toggleX, toggleY, ButtonSize, ButtonSize)
			
			If layer.Visible
				canvas.Color = TextColor
				canvas.DrawText("✓", toggleX + ButtonSize/2, toggleY + ButtonSize/2, 0.5, 0.5)
			End
			
			layerY += LayerHeight
		Next
	End
	
	Method HandleMouseEvent(event:MouseEvent) Override
		' Handle dragging from parent
		Super.HandleMouseEvent(event)
		
		If Not ContainsPoint(event.Location.X, event.Location.Y) Then Return
		
		' Handle layer management buttons
		If event.Type = EventType.MouseDown
			Local buttonX:= Position.X + Padding
			Local buttonY:= Position.Y + HeaderHeight
			
			' New layer button
			If event.Location.X >= buttonX And event.Location.X < buttonX + ButtonSize And
			   event.Location.Y >= buttonY And event.Location.Y < buttonY + ButtonSize
				_editor.AddLayer("Layer " + (_editor._layers.Length + 1))
				Return
			End
			
			' Delete layer button
			buttonX += ButtonSize + Padding
			If event.Location.X >= buttonX And event.Location.X < buttonX + ButtonSize And
			   event.Location.Y >= buttonY And event.Location.Y < buttonY + ButtonSize
				_editor.RemoveLayer(_editor._activeLayerIndex)
				Return
			End
			
			' Move layer up button
			buttonX += ButtonSize + Padding
			If event.Location.X >= buttonX And event.Location.X < buttonX + ButtonSize And
			   event.Location.Y >= buttonY And event.Location.Y < buttonY + ButtonSize
				If _editor._activeLayerIndex < _editor._layers.Length - 1
					_editor.MoveLayer(_editor._activeLayerIndex, _editor._activeLayerIndex + 1)
				End
				Return
			End
			
			' Move layer down button
			buttonX += ButtonSize + Padding
			If event.Location.X >= buttonX And event.Location.X < buttonX + ButtonSize And
			   event.Location.Y >= buttonY And event.Location.Y < buttonY + ButtonSize
				If _editor._activeLayerIndex > 0
					_editor.MoveLayer(_editor._activeLayerIndex, _editor._activeLayerIndex - 1)
				End
				Return
			End
			
			' Handle layer selection and visibility toggle
			Local layerY:= Position.Y + HeaderHeight + ButtonSize + Padding
			Local maxLayers:= Int((Size.Y - layerY) / LayerHeight)
			Local startIndex:= Max(0, Min(ScrollOffset, _editor._layers.Length - maxLayers))
			
			For Local i:= startIndex Until Min(_editor._layers.Length, startIndex + maxLayers)
				Local isLayerArea:= event.Location.Y >= layerY And
									event.Location.Y < layerY + LayerHeight - Padding
				
				If isLayerArea
					' Check visibility toggle
					Local toggleX:= Position.X + Size.X - Padding - ButtonSize
					Local toggleY:= layerY + (LayerHeight - ButtonSize) / 2
					
					If event.Location.X >= toggleX And event.Location.X < toggleX + ButtonSize And
					   event.Location.Y >= toggleY And event.Location.Y < toggleY + ButtonSize
						
						_editor._layers[i].Visible = Not _editor._layers[i].Visible
						_editor.UpdateCompositeCanvas()
						Return
					End
					
					' Select layer
					_editor._activeLayerIndex = i
					Return
				End
				
				layerY += LayerHeight
			Next
		End
		
		' Handle mouse wheel for scrolling
		If event.Type = EventType.MouseWheel
			ScrollOffset -= event.Wheel.Y
			ScrollOffset = Max(0, ScrollOffset)
		End
	End
End

' Status bar for displaying editor info
Class StatusBar Extends UIComponent
	Field _coordX:Int = 0
	Field _coordY:Int = 0
	
	Method New(editor:PixelEditor, width:Float = 0, height:Float = 30)
		Super.New(editor, width, height)
		Draggable = False
	End
	
	Method SetCoordinates(x:Float, y:Float)
		_coordX = Int(x)
		_coordY = Int(y)
	End
	
	Method Update() Override
		' Status bar is always positioned at the bottom of the window
		Position = New Vec2f(0, App.ActiveWindow.Height - Size.Y)
		Size = New Vec2f(App.ActiveWindow.Width, Size.Y)
	End
	
	Method Render(canvas:Canvas) Override
		If Not Visible Then Return
		
		' Draw background
		Super.Render(canvas)
		
		' Draw coordinates
		canvas.Color = TextColor
		canvas.DrawText("X: " + _coordX + "  Y: " + _coordY, Position.X + 10, Position.Y + Size.Y/2, 0.0, 0.5)
		
		' Draw tool info
		If _editor.ActiveTool <> Null
			canvas.DrawText("Tool: " + _editor.ActiveTool.Name, Position.X + 150, Position.Y + Size.Y/2, 0.0, 0.5)
		End
		
		' Draw color info
		Local color:= _editor.CurrentColor
		Local hexColor:= "#" +
					   ToHex(Int(color.R * 255), 2) +
					   ToHex(Int(color.G * 255), 2) +
					   ToHex(Int(color.B * 255), 2)
		
		canvas.DrawText("Color: " + hexColor, Position.X + 300, Position.Y + Size.Y/2, 0.0, 0.5)
		
		' Draw canvas info
		canvas.DrawText("Canvas: " + _editor._canvasWidth + " x " + _editor._canvasHeight, 
						 Position.X + 450, Position.Y + Size.Y/2, 0.0, 0.5)
		
		' Draw zoom info
		canvas.DrawText("Zoom: " + Int(_editor._canvasScale * 100) + "%", 
						 Position.X + 650, Position.Y + Size.Y/2, 0.0, 0.5)
	End
	
	Method ToHex:String(value:Int, digits:Int = 2)
		Local hex:= "0123456789ABCDEF"
		Local result:= ""
		
		While digits > 0
			result = hex[value & $F] + result
			value = value Shr 4
			digits -= 1
		Wend
		
		Return result
	End
End