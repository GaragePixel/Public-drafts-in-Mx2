#Import "<stdlib>"
#Import "<sdk_mojo>"

Using stdlib..
Using sdk_mojo..

' Layer
' Implements a single image layer for the pixel art editor with
' independent visibility, opacity, and transformation controls
'
' FUNCTIONALITY:
' - Pixmap-based image storage with alpha support
' - Opacity controls for layer blending
' - Visibility toggle
' - Thumbnail generation for layer panel
' - Direct pixel manipulation
'
' NOTES:
' Each layer maintains its own pixmap for pixel-level operations
' and generates Images as needed for rendering. Modifications to
' layers mark them as dirty to optimize rendering updates.
'
' TECHNICAL ADVANTAGES:
' - Efficient pixmap storage with minimal memory usage
' - Lazy thumbnail generation for UI performance
' - Dirty state tracking for optimized rendering
' - Proper alpha-channel handling for transparency

Class Layer
	Field _name:String
	Field _pixmap:Pixmap           ' Main layer pixmap
	Field _image:Image             ' Cached image for rendering
	Field _thumbnailPixmap:Pixmap  ' Thumbnail pixmap for layer panel
	Field _thumbnailImage:Image    ' Cached thumbnail image
	Field _visible:Bool = True
	Field _opacity:Float = 1.0
	Field _isDirty:Bool = True     ' Tracks if layer needs update
	
	Method New(name:String, width:Int, height:Int)
		_name = name
		_pixmap = New Pixmap(width, height, PixelFormat.RGBA8)
		_pixmap.Clear(Color.None)
		_image = New Image(_pixmap)
		
		' Create thumbnail pixmap (50x50)
		_thumbnailPixmap = New Pixmap(50, 50, PixelFormat.RGBA8)
		_thumbnailPixmap.Clear(Color.None)
		UpdateThumbnail()
	End
	
	Method DrawPixel(x:Int, y:Int, color:Color, size:Int = 1, hardness:Float = 1.0)
		' Ensure coordinates are valid
		If x < 0 Or x >= _pixmap.Width Or y < 0 Or y >= _pixmap.Height Return
		
		' Mark layer as dirty
		_isDirty = True
		
		If size <= 1
			' Fast path for single pixel
			_pixmap.SetPixel(x, y, color)
		Else
			' Draw larger brush
			Local radius:= size / 2.0
			Local radiusSquared:= radius * radius
			Local hardnessMultiplier:= 1.0 / (1.0 - hardness)
			
			For Local py:= y - size Until y + size
				For Local px:= x - size Until x + size
					If px >= 0 And px < _pixmap.Width And py >= 0 And py < _pixmap.Height
						Local distX:= px - x
						Local distY:= py - y
						Local distSquared:= distX * distX + distY * distY
						
						If distSquared < radiusSquared
							Local alpha:= 1.0
							
							' Apply hardness
							If hardness < 1.0
								Local distance:= Sqrt(distSquared)
								Local normalizedDist:= distance / radius
								
								If normalizedDist > hardness
									alpha = (1.0 - normalizedDist) * hardnessMultiplier
									alpha = Max(0.0, alpha)
								End
							End
							
							Local pixelColor:= color
							pixelColor.A *= alpha
							
							' Blend with existing pixel
							Local existingColor:= _pixmap.GetPixel(px, py)
							Local blendedColor:= ColorUtils.Blend(existingColor, pixelColor)
							_pixmap.SetPixel(px, py, blendedColor)
						End
					End
				Next
			Next
		End
		
		' Update image
		_image = New Image(_pixmap)
	End
	
	Method Fill(x:Int, y:Int, color:Color, tolerance:Float = 0.1)
		' Bounds check
		If x < 0 Or x >= _pixmap.Width Or y < 0 Or y >= _pixmap.Height Return
		
		' Mark layer as dirty
		_isDirty = True
		
		' Get target color
		Local targetColor:= _pixmap.GetPixel(x, y)
		
		' Don't fill if already same color
		If targetColor = color Return
		
		' Calculate tolerance range for each component
		Local rMin:= Max(0.0, targetColor.R - tolerance)
		Local rMax:= Min(1.0, targetColor.R + tolerance)
		Local gMin:= Max(0.0, targetColor.G - tolerance)
		Local gMax:= Min(1.0, targetColor.G + tolerance)
		Local bMin:= Max(0.0, targetColor.B - tolerance)
		Local bMax:= Min(1.0, targetColor.B + tolerance)
		Local aMin:= Max(0.0, targetColor.A - tolerance)
		Local aMax:= Min(1.0, targetColor.A + tolerance)
		
		' Stack for flood fill algorithm
		Local stack:= New Stack<Vec2i>()
		stack.Push(New Vec2i(x, y))
		
		' Visited pixels tracking
		Local visited:= New Bool[_pixmap.Width, _pixmap.Height]
		
		' Perform flood fill
		While stack.Length > 0
			Local pos:= stack.Pop()
			Local px:= pos.X
			Local py:= pos.Y
			
			' Skip if already visited or out of bounds
			If px < 0 Or px >= _pixmap.Width Or py < 0 Or py >= _pixmap.Height Or visited[px, py]
				Continue
			End
			
			' Check if pixel is within tolerance range
			Local c:= _pixmap.GetPixel(px, py)
			If c.R >= rMin And c.R <= rMax And
			   c.G >= gMin And c.G <= gMax And
			   c.B >= bMin And c.B <= bMax And
			   c.A >= aMin And c.A <= aMax
				
				' Mark as visited
				visited[px, py] = True
				
				' Set new color
				_pixmap.SetPixel(px, py, color)
				
				' Add neighbors to stack
				stack.Push(New Vec2i(px + 1, py))
				stack.Push(New Vec2i(px - 1, py))
				stack.Push(New Vec2i(px, py + 1))
				stack.Push(New Vec2i(px, py - 1))
			End
		Wend
		
		' Update image
		_image = New Image(_pixmap)
	End
	
	Method Clear(color:Color = Null)
		If color = Null Then color = Color.None
		
		_pixmap.Clear(color)
		_image = New Image(_pixmap)
		_isDirty = True
		UpdateThumbnail()
	End
	
	Method UpdateThumbnail()
		' Check if thumbnail dimensions match
		If _thumbnailPixmap.Width <> 50 Or _thumbnailPixmap.Height <> 50
			_thumbnailPixmap = New Pixmap(50, 50, PixelFormat.RGBA8)
		End
		
		' Scale source image to thumbnail size
		_thumbnailPixmap.Clear(Color.None)
		
		' Manual scaling
		Local scaleX:Float = Float(_pixmap.Width) / _thumbnailPixmap.Width
		Local scaleY:Float = Float(_pixmap.Height) / _thumbnailPixmap.Height
		
		For Local ty:= 0 Until _thumbnailPixmap.Height
			For Local tx:= 0 Until _thumbnailPixmap.Width
				Local sx:= Int(tx * scaleX)
				Local sy:= Int(ty * scaleY)
				
				If sx >= 0 And sx < _pixmap.Width And sy >= 0 And sy < _pixmap.Height
					_thumbnailPixmap.SetPixel(tx, ty, _pixmap.GetPixel(sx, sy))
				End
			Next
		Next
		
		' Create image from thumbnail
		_thumbnailImage = New Image(_thumbnailPixmap)
	End
	
	Method GetPixel:Color(x:Int, y:Int)
		If x < 0 Or x >= _pixmap.Width Or y < 0 Or y >= _pixmap.Height Return Color.None
		Return _pixmap.GetPixel(x, y)
	End
	
	Method GetImage:Image()
		If _isDirty
			_image = New Image(_pixmap)
			_isDirty = False
		End
		Return _image
	End
	
	Method GetThumbnailImage:Image()
		If _isDirty
			UpdateThumbnail()
		End
		Return _thumbnailImage
	End
	
	Method GetPixmap:Pixmap()
		Return _pixmap
	End
	
	Method Resize(width:Int, height:Int)
		Local newPixmap:= New Pixmap(width, height, PixelFormat.RGBA8)
		newPixmap.Clear(Color.None)
		
		' Copy existing content
		For Local y:= 0 Until Min(_pixmap.Height, height)
			For Local x:= 0 Until Min(_pixmap.Width, width)
				newPixmap.SetPixel(x, y, _pixmap.GetPixel(x, y))
			Next
		Next
		
		_pixmap = newPixmap
		_image = New Image(_pixmap)
		_isDirty = True
		UpdateThumbnail()
	End

	Method DrawLine(x1:Int, y1:Int, x2:Int, y2:Int, color:Color, size:Int, hardness:Float)
		' Mark layer as dirty
		_isDirty = True
		
		' Calculate line parameters using Bresenham's algorithm
		Local dx:= Abs(x2 - x1)
		Local dy:= Abs(y2 - y1)
		Local sx:= x1 < x2 ? 1 Else -1
		Local sy:= y1 < y2 ? 1 Else -1
		Local err:= dx - dy
		
		' For pressure interpolation
		Local totalDistance:= Sqrt(dx * dx + dy * dy)
		Local currentDistance:Float = 0
		
		' Current position
		Local x:= x1
		Local y:= y1
		
		' Keep drawing until we reach the end point
		While True
			' Draw pixel at current position
			DrawPixel(x, y, color, size, hardness)
			
			' Exit if we've reached the end point
			If x = x2 And y = y2 Then Exit
			
			' Calculate current distance for interpolation if needed
			currentDistance = Sqrt((x - x1) * (x - x1) + (y - y1) * (y - y1))
			
			' Bresenham's algorithm core
			Local e2:= 2 * err
			If e2 > -dy
				err -= dy
				x += sx
			End
			
			If e2 < dx
				err += dx
				y += sy
			End
		Wend
		
		' Update image after drawing the entire line
		_image = New Image(_pixmap)
	End
	
	Property Name:String()
		Return _name
	Setter(value:String)
		_name = value
	End
	
	Property Visible:Bool()
		Return _visible
	Setter(value:Bool)
		_visible = value
	End
	
	Property Opacity:Float()
		Return _opacity
	Setter(value:Float)
		_opacity = Clamp(value, 0.0, 1.0)
	End
End