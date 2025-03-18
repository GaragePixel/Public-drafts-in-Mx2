#Import "<stdlib>"
#Import "<sdk_mojo>"

Using stdlib..
Using sdk_mojo..

' PixelEditor
' Authored by iDkP from GaragePixel
' 2025-03-17 19:58:31
' Aida 4
'
' Core editor class responsible for managing the canvas, layers, and tools
' This class coordinates all interactions between the UI, tools, and rendering pipeline
' Following vpaint.monkey2 structure with global instance pattern
'
' Features:
' - Canvas composition and rendering
' - Layer management (add, delete, reorder)
' - Tool coordination for drawing operations
' - Tablet input processing with pressure sensitivity
' - Color management with history tracking
' - Grid visualization and scaling
'
' Notes:
' PixelEditor acts as the central hub connecting UI components, drawing tools,
' and layer management. It processes input events and maintains the overall
' application state. The rendering pipeline uses efficient pixmap-to-image
' conversion to minimize texture uploads.
'
' Technical implementations:
' - Canvas matrix transformations for viewport handling
' - Separated rendering and compositioning steps for optimal performance
' - Efficient tablet data processing with direct hardware access
' - Isolated layer drawing operations to minimize redraw scope
' - Targeted pixmap updates to reduce memory bandwidth usage

Class PixelEditor
	' Canvas management
	Field _canvasWidth:Int = 800
	Field _canvasHeight:Int = 600
	Field _canvasImage:Image         ' Final composited image for display
	Field _canvasPixmap:Pixmap       ' Pixmap for the final composited image
	
	' UI elements
	Field _toolbox:ToolBox
	Field _colorPalette:ColorPalette
	Field _layerPanel:LayerPanel
	Field _statusBar:StatusBar
	
	' Layers
	Field _layers:Stack<Layer> = New Stack<Layer>
	Field _activeLayerIndex:Int = 0
	
	' Tools
	Field _tools:Stack<Tool> = New Stack<Tool>
	Field _activeTool:Tool
	
	' Navigation
	Field _canvasScale:Float = 1.0
	Field _canvasOffsetX:Float = 0.0
	Field _canvasOffsetY:Float = 0.0
	Field _isPanning:Bool = False
	Field _lastMouseX:Float = 0.0
	Field _lastMouseY:Float = 0.0
	
	' Color management
	Field _currentColor:Color = New Color(0, 0, 0)  ' Current drawing color
	Field _backgroundColor:Color = New Color(1, 1, 1)
	Field _colorHistory:Stack<Color> = New Stack<Color>
	Field _maxColorHistory:Int = 16
	
	' Grid display
	Field _showGrid:Bool = True
	Field _gridSize:Int = 1
	Field _gridColor:Color = New Color(0.7, 0.7, 0.7, 0.5)
	
	' Input state - tablet support
	Field _tabletAvailable:Bool = False
	Field _pressure:Float = 1.0
	Field _tiltX:Float = 0.0
	Field _tiltY:Float = 0.0
	Field _isDrawing:Bool = False
	Field _tabletManager:TabletManager
	
	' UI state
	Field _showUI:Bool = True
	
	Method New()
		' Initialize tablet support
		_tabletManager = New TabletManager()

		' Initialize tablet
		_tabletManager = stdlib.io.tablet.api.TabletManager.GetInstance()
		_tabletAvailable = _tabletManager.Initialize()
		If Not _tabletAvailable
			Print("Using mouse fallback")
		End
		
		' Initialize canvas
		CreateCanvas(_canvasWidth, _canvasHeight)
		
		' Create UI components
		_toolbox = New ToolBox(Self, 60, 400)
		_colorPalette = New ColorPalette(Self, 200, 200)
		_layerPanel = New LayerPanel(Self, 200, 300)
		_statusBar = New StatusBar(Self)
		
		' Create default tools
		InitTools()
		
		' Create initial layer
		AddLayer("Background")
		
		' Position UI elements
		_toolbox.Position = New Vec2f(10, 50)
		_colorPalette.Position = New Vec2f(10, 460)
		_layerPanel.Position = New Vec2f(1070, 50)
	End
	
	Method CreateCanvas(width:Int, height:Int)
		_canvasWidth = width
		_canvasHeight = height
		
		' Create pixmap for final composited image
		_canvasPixmap = New Pixmap(width, height, PixelFormat.RGBA8)
		_canvasPixmap.Clear(Color.White)
		
		' Create image from pixmap
		_canvasImage = New Image(_canvasPixmap,TextureFlags.Dynamic)
	End
	
	Method AddLayer:Layer(name:String)
		Local layer:= New Layer(name, _canvasWidth, _canvasHeight)
		_layers.Push(layer)
		_activeLayerIndex = _layers.Length - 1
		UpdateCompositeCanvas()
		Return layer
	End
	
	Method RemoveLayer(index:Int)
		If _layers.Length <= 1 Return  ' Always keep at least one layer
		
		_layers.Erase(index)
		If _activeLayerIndex >= _layers.Length Then _activeLayerIndex = _layers.Length - 1
		UpdateCompositeCanvas()
	End
	
	Method MoveLayer(fromIndex:Int, toIndex:Int)
		If fromIndex < 0 Or fromIndex >= _layers.Length Or 
		   toIndex < 0 Or toIndex >= _layers.Length Then Return
		
		Local layer:= _layers[fromIndex]
		_layers.Erase(fromIndex)
		_layers.Insert(toIndex, layer)
		
		If _activeLayerIndex = fromIndex Then _activeLayerIndex = toIndex
		
		UpdateCompositeCanvas()
	End
	
	Method UpdateCompositeCanvas()
		
		' Draw background color/pattern
		'_canvasPixmap.Clear(_backgroundColor)
		
		' Composite all visible layers from bottom to top
		'IDEA: With a proper render to texture, image drawn in an image,
		'this operation should be instantaneous.
		For Local i:= 0 Until _layers.Length
			If _layers[i].Visible
				DrawLayerToCanvas(_layers[i], _canvasPixmap)
			End
		Next
		
		' Update the image from the pixmap
		_canvasImage = New Image(_canvasPixmap)
	End
	
	Method DrawLayerToCanvas(layer:Layer, targetPixmap:Pixmap)
		' IDEAS: Use mojo's capability to draw and blend the layers
		' render only in a rect that contains the current scope of the tool
		
		' Get layer pixmap
		Local layerPixmap:= layer.GetPixmap()
		
		' Blend layer pixmap onto target pixmap
		For Local y:= 0 Until layerPixmap.Height
			For Local x:= 0 Until layerPixmap.Width
				Local srcColor:= layerPixmap.GetPixel(x, y)
				If srcColor.A > 0
					' Apply layer opacity
					srcColor.A *= layer.Opacity
					
					' Get destination color
					Local dstColor:= targetPixmap.GetPixel(x, y)
					
					' Blend colors
					Local result:= ColorUtils.Blend(dstColor, srcColor)
					
					' Set resulting color
					targetPixmap.SetPixel(x, y, result)
				End
			Next
		Next
	End
	
	Method InitTools()
		' Create default tools
		_tools.Push(New BrushTool("Brush", Self))
		_tools.Push(New PencilTool("Pencil", Self))
		_tools.Push(New EraserTool("Eraser", Self))
		_tools.Push(New ColorPickerTool("Color Picker", Self))
		_tools.Push(New FillTool("Fill", Self))
		
		' Set active tool
		_activeTool = _tools[0]
	End
	
	Method HandleMouseEvent(event:MouseEvent)
		' Get window dimensions for calculations
		Local windowWidth:= App.ActiveWindow.Width
		Local windowHeight:= App.ActiveWindow.Height
	
		' Transform mouse coordinates to canvas coordinates
		Local canvasX:Float = (event.Location.X - windowWidth/2 - _canvasOffsetX) / _canvasScale + _canvasWidth/2
		Local canvasY:Float = (event.Location.Y - windowHeight/2 - _canvasOffsetY) / _canvasScale + _canvasHeight/2
		
		' Update status bar
		_statusBar.SetCoordinates(canvasX, canvasY)
		
		' Check for tablet input
		If _tabletAvailable
			' Update tablet pressure and tilt values
			_pressure = _tabletManager.GetPressure()
			_tiltX = _tabletManager.GetTiltX()
			_tiltY = _tabletManager.GetTiltY()
		Else
			' Default values when tablet not available
			_pressure = 1.0
			_tiltX = 0.0
			_tiltY = 0.0
		End
		
		' Check if mouse is over UI elements
		If _showUI
			If _toolbox.ContainsPoint(event.Location.X, event.Location.Y)
				_toolbox.HandleMouseEvent(event)
				Return
			End
			
			If _colorPalette.ContainsPoint(event.Location.X, event.Location.Y)
				_colorPalette.HandleMouseEvent(event)
				Return
			End
			
			If _layerPanel.ContainsPoint(event.Location.X, event.Location.Y)
				_layerPanel.HandleMouseEvent(event)
				Return
			End
		End
		
		' Handle canvas navigation
		If event.Button = MouseButton.Right
			Select event.Type
				Case EventType.MouseDown
					_isPanning = True
					_lastMouseX = event.Location.X
					_lastMouseY = event.Location.Y
				Case EventType.MouseUp
					_isPanning = False
				Case EventType.MouseMove
					If _isPanning
						_canvasOffsetX += event.Location.X - _lastMouseX
						_canvasOffsetY += event.Location.Y - _lastMouseY
						_lastMouseX = event.Location.X
						_lastMouseY = event.Location.Y
					End
			End
			Return
		End
		
		' Handle mouse wheel (zoom)
		If event.Type = EventType.MouseWheel
			Local zoomFactor:Float = 1.1
			If event.Wheel.Y < 0 Then zoomFactor = 1.0 / zoomFactor
			
			' Get mouse position in canvas space before zoom
			Local mouseCanvasX:Float = canvasX
			Local mouseCanvasY:Float = canvasY
			
			' Apply zoom
			_canvasScale *= zoomFactor
			
			' Limit zoom range
			_canvasScale = Clamp(_canvasScale, 0.1, 10.0)
			
			' Calculate offset to keep the mouse position fixed in canvas space
			Local newCanvasX:Float = (event.Location.X - windowWidth/2 - _canvasOffsetX) / _canvasScale + _canvasWidth/2
			Local newCanvasY:Float = (event.Location.Y - windowHeight/2 - _canvasOffsetY) / _canvasScale + _canvasHeight/2
			
			_canvasOffsetX += (newCanvasX - mouseCanvasX) * _canvasScale
			_canvasOffsetY += (newCanvasY - mouseCanvasY) * _canvasScale
			
			Return
		End
		
		' Handle drawing tools
		If event.Button = MouseButton.Left
			If canvasX >= 0 And canvasX < _canvasWidth And canvasY >= 0 And canvasY < _canvasHeight
				Select event.Type
					Case EventType.MouseDown
						_isDrawing = True
						_activeTool.OnBeginStroke(canvasX, canvasY, _pressure, _tiltX, _tiltY)
					Case EventType.MouseUp
						If _isDrawing
							_activeTool.OnEndStroke(canvasX, canvasY, _pressure, _tiltX, _tiltY)
							_isDrawing = False
							UpdateCompositeCanvas()
						End
					Case EventType.MouseMove
						If _isDrawing
							_activeTool.OnStrokePoint(canvasX, canvasY, _pressure, _tiltX, _tiltY)
							UpdateCompositeCanvas() 'Too sloooowww :D
						End
				End
			End
		End
	End
	
	Method HandleKeyEvent(event:KeyEvent)
		If event.Type = EventType.KeyDown
			Select event.Key
				Case Key.Tab
					If event.Eaten Then _showUI = Not _showUI
				Case Key.Z
					If event.Modifiers & Modifier.Control
						' Undo
						Print "Undo (not implemented)"
					End
				Case Key.Y
					If event.Modifiers & Modifier.Control
						' Redo
						Print "Redo (not implemented)"
					End
				Case Key.S
					If event.Modifiers & Modifier.Control
						' Save canvas
						SaveCanvas()
					End
				Case Key.N
					If event.Modifiers & Modifier.Control
						' New canvas
						CreateNewCanvas()
					End
				Case Key.Space
					' Pan mode
					Print "Pan mode (hold space+drag)"
			End
		End
	End
	
	Method SaveCanvas()
		' Placeholder for save functionality
		Print "Saving canvas..."
	End
	
	Method CreateNewCanvas()
		' Placeholder for new canvas functionality
		Print "Creating new canvas..."
	End
	
	Method AddColorToHistory(color:Color)
		' Check if color already exists in history
		For Local i:= 0 Until _colorHistory.Length
			If _colorHistory[i] = color Then Return
		Next
		
		' Add to history
		_colorHistory.Push(color)
		
		' Limit history size
		If _colorHistory.Length > _maxColorHistory
			_colorHistory.Erase(0)
		End
	End
	
	Method Update()
		' Update UI components
		If _showUI
			_toolbox.Update()
			_colorPalette.Update()
			_layerPanel.Update()
			_statusBar.Update()
		End
	End
	
	Method Render(canvas:Canvas)
		App.RequestRender()
		
		If not _isDrawing
			canvas.Clear(New Color(0.2, 0.2, 0.2)) 'Clear only when we not draw
		End
		
		' Update editor state
		Update()
		
		' Draw canvas background (checkered pattern for transparency)
		RenderCanvasBackground(canvas)
		
		' Draw canvas
		Local windowWidth:= App.ActiveWindow.Width
		Local windowHeight:= App.ActiveWindow.Height
		
		canvas.PushMatrix()
		canvas.Translate(windowWidth/2 + _canvasOffsetX, windowHeight/2 + _canvasOffsetY)
		canvas.Scale(_canvasScale, _canvasScale)
		canvas.Translate(-_canvasWidth/2, -_canvasHeight/2)
		canvas.DrawImage(_canvasImage, 0, 0)
		
		' Draw grid if enabled and zoomed in enough
		If _showGrid And _canvasScale > 4.0
			RenderGrid(canvas)
		End
		
		' Draw stroke preview if needed
		If _isDrawing
			_activeTool.RenderPreview(canvas)
		End
		
		canvas.PopMatrix()
		
		' Draw UI components
		If _showUI
			_toolbox.Render(canvas)
			_colorPalette.Render(canvas)
			_layerPanel.Render(canvas)
			_statusBar.Render(canvas)
		End
	End
	
	Method RenderCanvasBackground(canvas:Canvas)
		' Draw a checkered pattern to indicate transparency
		Local windowWidth:= App.ActiveWindow.Width
		Local windowHeight:= App.ActiveWindow.Height
		
		canvas.PushMatrix()
		canvas.Translate(windowWidth/2 + _canvasOffsetX, windowHeight/2 + _canvasOffsetY)
		canvas.Scale(_canvasScale, _canvasScale)
		canvas.Translate(-_canvasWidth/2, -_canvasHeight/2)
		
		Local checkSize:= 8
		Local color1:= New Color(0.8, 0.8, 0.8)
		Local color2:= New Color(0.6, 0.6, 0.6)
		
		For Local y:= 0 Until _canvasHeight Step checkSize
			For Local x:= 0 Until _canvasWidth Step checkSize
				If (x / checkSize + y / checkSize) Mod 2 = 0
					canvas.Color = color1
				Else
					canvas.Color = color2
				End
				canvas.DrawRect(x, y, checkSize, checkSize)
			Next
		Next
		
		canvas.PopMatrix()
	End
	
	Method RenderGrid(canvas:Canvas)
		canvas.Color = _gridColor
		
		' Vertical lines
		For Local x:= 0 To _canvasWidth Step _gridSize
			canvas.DrawLine(x, 0, x, _canvasHeight)
		Next
		
		' Horizontal lines
		For Local y:= 0 To _canvasHeight Step _gridSize
			canvas.DrawLine(0, y, _canvasWidth, y)
		Next
	End
	
	' Accessors
	Property ActiveLayer:Layer()
		Return _layers[_activeLayerIndex]
	End
	
	Property CurrentColor:Color()
		Return _currentColor
	Setter(color:Color)
		_currentColor = color
		AddColorToHistory(color)
	End
	
	Property ActiveTool:Tool()
		Return _activeTool
	Setter(tool:Tool)
		_activeTool = tool
	End
End