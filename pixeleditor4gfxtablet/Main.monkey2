#Rem
The MIT License (MIT)

Copyright (c) 2025 iDkP from GaragePixel

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
#End

#Import "<stdlib>"
#Import "<sdk_mojo>"
#Import "PixelEditor"
#Import "Layer"
#Import "Tools"
#Import "UI"
#Import "Utilities"

Using stdlib..
Using sdk_mojo..

' PixelArtEditor (demonstration program for the tablet driver in std.io)
' Authored by iDkP from GaragePixel
' 2025-03-17
' Aida 4
'
' Professional-grade pixel art creation tool with tablet support for pressure-sensitive 
' drawing, layer management, and comprehensive artist tools.
' A feature-rich drawing application showcasing tablet capabilities
' with pressure sensitivity and advanced brush tools.

' Features:
' - Pressure-sensitive drawing with advanced tablet support
' - Multiple drawing tools: brush, pencil, eraser, fill, color picker
' - Layer system with opacity control, visibility toggle, and reordering
' - Canvas navigation with zoom and pan
' - Color palette with history tracking
' - Grid overlay for precise pixel editing
' - Movable UI panels
'
' Controls:
' - Left mouse button / Pen: Draw
' - Right mouse button: Pan canvas
' - Mouse wheel: Zoom in/out
' - Space + drag: Pan canvas (alternative)
' - Tab: Toggle UI visibility
' - Ctrl+Z: Undo
' - Ctrl+Y: Redo
' - Ctrl+S: Save canvas
' - Ctrl+N: New canvas

' Notes:
' This implementation follows the vpaint.monkey2 structure using a global
' instance pattern rather than extending App. The main loop is handled
' directly with a window in Main() function to better match the standard
' Monkey2 coding style.
'
' Technical Advantages:
' - Direct window handling for more precise event control
' - Memory-efficient stroke data representation
' - Responsive UI with minimal impact on drawing performance
' - Efficient layer composition minimizing texture updates
' - Direct tablet hardware access for precise pressure detection
' - Smooth drawing experience
' - Matrix-based coordinate handling for accurate zoom and pan
' - Memory-efficient stroke representation for responsive performance

' Global editor instance
Global gEditor:PixelEditor

Global TITLE:="PixelArt Editor - GaragePixel"

Class EditorWindow Extends Window
	Method New(title:String, width:Int, height:Int)
		Super.New(title, width, height, WindowFlags.Resizable)
		Self.ClearEnabled=False 
	End
	
	Method OnRender(canvas:Canvas) Override
		'canvas.Clear(New Color(0.2, 0.2, 0.2)) 'Not really needed here
		canvas.TextureFilteringEnabled=False
		gEditor.Render(canvas)
	End
	
	Method OnKeyEvent(event:KeyEvent) Override
		gEditor.HandleKeyEvent(event)
	End
	
	Method OnMouseEvent(event:MouseEvent) Override
		gEditor.HandleMouseEvent(event)
	End
End

Global instance:AppInstance

Function Main()
	Print TITLE
	instance = New AppInstance	
	New EditorWindow(TITLE, 1280, 720)
	' Create editor instance
	gEditor = New PixelEditor()
	App.Run()
End