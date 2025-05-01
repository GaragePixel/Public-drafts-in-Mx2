'-------------------------------------------------
' InkPlayer - Simple Ink Story Player for Testing
'-------------------------------------------------
' iDkP from GaragePixel
' 2025-05-01, Aida 4
'
' Purpose:
'
' A simple player to test Ink stories. Loads a story,
' compiles it into JSON, and uses the InkRuntime's state
' system to play through the story, displaying text and
' handling choices.
'
' List of Functionality:
'
' - Load and compile an Ink story into JSON.
' - Use InkRuntime to play through the story.
' - Display story text and handle choices via keyboard input.
'
' Notes:
'
' This implementation focuses strictly on functionality
' and excludes advanced graphical rendering or mouse interactions.
'
' Technical Advantages:
'
' - Lightweight and focused on story functionality.
' - Utilizes the InkRuntime state system for seamless story progression.
'
Namespace sdk_games.parsers.ink.player

#Import "<stdlib>"
#Import "<sdk_games>"
#Import "<sdk_mojo>"

Using stdlib.io.json..
Using stdlib.graphics..
Using stdlib.collections..
Using stdlib.system..
Using sdk_games.parsers.ink..
Using sdk_mojo.m2..

'-------------------------------------------------
' InkPlayer Class Definition
'-------------------------------------------------
Class InkPlayer

	Private

		Field runtime:InkRuntime
		Field storyText:String
		Field choices:Stack<JsonObject>
		Field selectedChoice:Int = 0

	Public

		Method New()
			' Initialize the runtime and state
			runtime = New InkRuntime()
			storyText = ""
			choices = New Stack<JsonObject>()
		End

		Method LoadStory(json:JsonObject)
			' Load the story into the runtime
			runtime.LoadStory(json)
			AdvanceStory()
		End

		Method AdvanceStory()
			' Progress the story and update state
			storyText = runtime.AdvanceStory()
			choices = runtime.GetChoices()
			selectedChoice = 0
		End

		Method DisplayStory()
			' Display the story text and choices in the console
			Print("Story:")
			Print(storyText)
			Print("")

			' Display the choices
			Local i:Int = 1
			For Local choice:JsonObject = Eachin choices
				Print(i + ". " + choice["text"].ToString())
				i += 1
			End
		End


End

'-------------------------------------------------
' Program Entry Point
'-------------------------------------------------
Function Main()
	' Path to the Ink file
	Local InkStoryStr:String = LoadTextFile("Z:\\$$5__MAD2nd\\__MONKEY2\\PROJECTS2025\\TestFoxSpiritRomancheIntro01.json")
	Print InkStoryStr
	
	' Compile the Ink story into JSON
	Local json:JsonObject = JsonObject.Parse(InkStoryStr)
	Print json.ToString()
	InkStoryStr = Null ' Free the memory

	' Create an InkPlayer instance
	Local player:InkPlayer = New InkPlayer()
	player.LoadStory(json)

	player.DisplayStory()
	Print player.runtime.AdvanceStory()
	player.DisplayStory()
	Print player.runtime.AdvanceStory()
	player.DisplayStory()

	' Play through the story
'	While Not player.runtime.CurrentState.IsComplete() ' Use IsComplete directly
'		player.DisplayStory()
		'player.HandleInput()
'	Wend

	Print("The story has ended.")
End

'-------------------------------------------------
' LoadTextFile Function
'-------------------------------------------------
Function LoadTextFile:String(filePath:String, defaultContent:String="")
	' Check if file path is valid
	If filePath.Trim() = "" Then
		Print("Error: Empty file path provided")
		Return defaultContent
	End

	' Open the file stream
	Local fileStream:Stream = Stream.Open(filePath, "r")
	If fileStream = Null Then
		Print("Warning: Could not open file: " + filePath)
		Return defaultContent
	End

	' Read the file content
	Local content:String = ""

	' Read until end of file
	While Not fileStream.Eof
		Local line:String = fileStream.ReadLine()
		content += line
		If Not fileStream.Eof Then content += "~n"
	Wend

	' Close the stream
	fileStream.Close()

	Return content
End
