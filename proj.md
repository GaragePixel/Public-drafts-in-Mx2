Namespace CLIbase64

' -----------------------------------------------------------------------------
' CLI base64 utility
' Author: iDkP from GaragePixel
' Version 0.1
' Since: 2025-06-11
'
' Purpose:
'	Parse a command-line parameter string into a Map.
'
' List of Functionality:
'	- Checks for a preset first and applies it if valid.
'	- Extracts file paths, output path, and option flags/values from a string.
'	- Supports both verbose and short flag forms, and preset profiles.
'	- Handles quoted values (using ~q as quote character).
'	- Returns all recognized options and all file paths as ["fileN"] entries.
'
' Notes:
'	- All option keys in the output map use verbose names for clarity.
'	- All default options are set in the map before parsing.
'	- If a preset is valid and found, its values override all other options.
'	- If both -e62 and -e43 are found, only -e43 is used.
'
' Technical Advantages:
'	- Self-contained, robust parameter parsing for CLI utilities.
'	- Extensible and easy to maintain for future options/presets.
'	- Ensures correct behavior even with mixed or missing options.
' -----------------------------------------------------------------------------

'#Import "<std>"
#Import "<stdlib>"

'Using std..
Using stdlib..

Const VERSION:="0.1"
Const VERSION_SINCE:="2025-06-11"

#Rem Wonkeydoc Base64Help
@author [iDkP from GaragePixel](https://github.com/GaragePixel)
@version 0.1
@since 2025-06-11

Detects CLI help flags for the base64 command and returns detailed help text for
the ParseParams function, covering both encode and decode usages and options.

@param params:String
	The raw command-line string, e.g. "base64 encode -help" or "base64 --help"

@return String
	A help message describing the CLI base64 utility, options, and usage, or "" if not a help request.

#End
Function Base64Help:String(params:String)
	
	Local s:=params.Trim().ToLower()

	Local tokens:=s.Split(" ")
	If tokens.Length=1 And (tokens[0]="-help" Or tokens[0]="--help" Or tokens[0]="-h" Or tokens[0]="--h")
		
		Return _Base64HelpString() 	' It's a call for help, returns the help content.
	Endif

	Return "-1" 					' Well... isn't a call for help
End

#rem 

	SGVsbG8gV29ybGQh== = Hello Workd!
	Hello Workd! = SGVsbG8gV29ybGQh==

	--html                        encode an image into an html tag containing base64 data
#end

Function _Base64attribution:String() 
	Return 	"CLI base64 utility" + "~n" +
			"Author: iDkP from GaragePixel" + "~n" +
			"Version "+VERSION+"~n" +
			"Since: "+VERSION_SINCE+"~n~n"
End

Function _Base64HelpString:String()
	Return 	_Base64attribution() +
			"The freeware cross-platform CLI utility 'base64' provides encoding and decoding of data using Base64, as described in:" + "~n" +
			"  RFC 1421~n  RFC 2045~n  RFC 2152~n  RFC 3501~n  RFC 4648 §4~n  RFC 4648 §5~n  and RFC 9580" + "~n~n"+
			"USAGE:" + "~n" +
			"  base64 encode [file(s)] [outputPath] [options]" + "~n" +
			"  base64 decode [file(s)] [outputPath] [options]" + "~n~n" +
			"  base64 encode data:[data] [outputPath] [options]" + "~n" +
			"  base64 decode data:[data] [outputPath] [options]" + "~n~n" +
			"ARGUMENTS:" + "~n" +
			"  encode | decode       Selects the operation mode (encoding or decoding)." + "~n" +
			"  file(s)               One or more input files (quoted with ~q if containing spaces)." + "~n" +
			"  -o=~qpath~q         Output path, may use -o:, -output:, --o:, --output: (quoted)." + "~n" +
			"  -preset=~qNAME~q    Apply a Base64 preset (see below); disables other options." + "~n" +
			"  -v | -verbose         Enable verbose output." + "~n" +
			"  -c:N | -compress:N    Compression level (0-5)." + "~n" +
			"  -p | -padding         Enable output padding ('=' characters)." + "~n" +
			"  -e62:~q+ | -~q      Set encoding character 62 ('+' or '-')." + "~n" +
			"  -e43:~q/ | , | _~q  Set encoding character 63 ('/', ',' or '_')." + "~n" +
			"  -s:~qSEQ~q          Separator string (for encoded output line splitting)." + "~n" +
			"  -l:NN | -length:NN    Line length for output (used with separator)." + "~n" +
			"  -d | -decode          Decoding non-encoding characters." + "~n~n" +
			"PRESETS VALUE:" + "~n" +
			"  RFC_1421, RFC_2045, RFC_2152, RFC_3501, RFC_4648_4, RFC_4648_5, RFC_9580" + "~n~n" +
			"NOTES:" + "~n" +
			"  - Use ~q for quoting file or argument values." + "~n" +
			"  - If both -e62 and -e43 are present, -e43 takes precedence." + "~n" +
			"  - When a preset is used, only files and outputPath are processed." + "~n" +
			"  - If outputPath isn't precised, the output in send to the CMD." + "~n~n" +
			"EXAMPLE USAGE:" + "~n~n" +
			"  base64 encode ~qfile1.svg~q ~qfile2.txt~q -o:~qc:/~q" + "~n" +
			"  base64 encode ~qfile1.svg~q ~qfile2.txt~q -o:~qc:/~q -v" + "~n" +
			"  base64 encode ~qfile1.svg~q ~qfile2.txt~q --o:~qc:/~q --preset:RFC_2045" + "~n~n" +
			"  base64 encode data:light wor --:c:/ --preset:RFC_2045" + "~n" +
			"  base64 decode data:bGlnaHQgd29y -o:c:/ -preset:RFC_2045" + "~n~n" +
			"  base64 encode url:https://github.com/GaragePixel/readme.md -preset:RFC_2045" + "~n" +
			"  base64 decode url:https://github.com/GaragePixel/readme.md -o:~qc:/tmp.txt~q -preset:RFC_2045" + "~n"
End

#Rem wonkeydoc ParseParams
@author [iDkP from GaragePixel](https://github.com/GaragePixel)
@version 0.1
@since 2025-06-11

Parses a command-line parameter string for a CLI base64 utility 
and returns a map of parameters, options, and file paths in a normalized form.

---

@Parameters

- `params:String`  
	Command-line string containing file paths, output path, and options.
	- File paths can be quoted with ~q (Monkey2/Wonkey safe), or unquoted.
	- Output path must use `-o=`, `-output=`, `--o=`, or `--output=` and be quoted.
	- Options must use recognized flags or forms; see below.

---

@Recognized Options

- `-preset=` / `--preset=` — quoted preset name. If found and valid, only files and outputPath are parsed after.
- `-o=`, `--o=`, `-output=`, `--output=` — output path (quoted).
- `-v`, `-verbose` — enables verbose mode.
- `-c=`, `-compress=` — integer 0..5 (quoted or not), enables compress.
- `-p`, `-padding` — enables padding.
- `-e62=` — encoding char 62 (`+` or `-`), quoted.
- `-e43=` — encoding char 63 (`/`, `,`, or `_`), quoted. If both -e62 and -e43 are present, only -e43 is used.
- `-s=`, `-separator=` — quoted string, used as line separator.
- `-l=`, `-length=` — quoted int= -2, -1, or 1..76, only meaningful if separator is non-empty.
- `-d`, `-decode` — enables decode mode.

---

@Return value

Returns a `Map<String,String>` with a normalized set of options, output path, and files.

- Always includes these option keys with default values:
	- `"verbose"`: `"false"`
	- `"62nd"`: `"+"`
	- `"63rd"`: `"/"`
	- `"padding"`: `"true"`
	- `"separator"`: `""`
	- `"length"`: `"0"`
	- `"decode"`: `"false"`
	- `"compress"`: `"false"`
	- `"outputPath"`: `"-1"`
	- `"preset"`: `""`
- Each file path is stored as `"file0"`, `"file1"`, etc., unquoted.

---

@Preset behaviour

If a valid `-preset=` or `--preset=` is provided, the preset's values override all other options except for files and outputPath.  
Valid presets (see [Wikipedia: Base64](https://en.wikipedia.org/wiki/Base64)):

- `"RFC 1421"`
- `"RFC 2045"`
- `"RFC 2152"`
- `"RFC 3501"`
- `"RFC 4648 §4"`
- `"RFC 4648 §5"`
- `"RFC 9580"`

After a valid preset, only outputPath and files are parsed; all other options are ignored.

---

@Example

	ParseParams("img1.svg img2.svg -o=~qout/~q -v -c=2 -e62=~q-~q -s=~q~n~q -l=76")
	' Result: Map with file0="img1.svg", file1="img2.svg", outputPath="out/", verbose="true", compress="true", 62nd="-", separator="~n", length="76"

---

@Notes

- Only the first matching form of each option is used.
- If both -e62 and -e43 are present, -e43 takes precedence.
- All values are returned unquoted.
- Files are indexed as file0, file1, etc.
#End
Function ParseParams:Map<String,String>( params:String )

	Local map:=New Map<String,String>
	
	'--- Set default values
	map.Add("verbose","false")
	map.Add("62nd","+")
	map.Add("63rd","/")
	map.Add("padding","true")
	map.Add("separator","")
	map.Add("length","0")
	map.Add("decode","false")
	map.Add("compress","false")
	map.Add("outputPath","-1")
	map.Add("preset","")

	'--- Preset profiles (hard-coded for clarity)
	Local presets:=New Map<String,Int>
	presets.Add("RFC 1421",1)
	presets.Add("RFC 2045",2)
	presets.Add("RFC 2152",3)
	presets.Add("RFC 3501",4)
	presets.Add("RFC 4648 §4",5)
	presets.Add("RFC 4648 §5",6)
	presets.Add("RFC 9580",7)

	'--- Tokenize param string (split by spaces, except inside ~q..~q)
	Local tokens:=New Stack<String>
	Local curr:String = ""
	Local inQuote:=False
	For Local i:=0 Until params.Length
		Local c:String = params.Slice(i, i+1)
		If c="~q"
			inQuote = Not inQuote
			curr+=c
		ElseIf c=" " And Not inQuote
			If curr.Trim().Length>0 Then tokens.Add(curr.Trim())
			curr=""
		Else
			curr+=c
		End
	End
	If curr.Trim().Length>0 tokens.Add(curr.Trim())

	'--- 1. Check for preset FIRST, and apply if valid
	Local presetIdx:Int = 0
	Local presetVal:String = ""
	For Local i:=0 Until tokens.Length
		Local t:=tokens[i]
		If t.StartsWith("-preset=") Or t.StartsWith("--preset=")
			presetVal = t.Slice(t.Find("=")+1)
			If presetVal.StartsWith("~q") And presetVal.EndsWith("~q") And presetVal.Length>=2
				presetVal = presetVal.Slice(1, presetVal.Length-1)
			End
			If presets.Contains(presetVal)
				presetIdx = presets[presetVal]
				map["preset"] = presetVal
			Else
				map["preset"] = ""
			End
			Exit
		End
	End

	If presetIdx>0
		' Apply preset to map
		Select presetIdx
			Case 1 ' RFC 1421
				map["62nd"] = "+"
				map["63rd"] = "/"
				map["padding"] = "true"
				map["separator"] = "~r~n"
				map["length"] = "64"
				map["decode"] = "false"
				map["compress"] = "false"
			Case 2 ' RFC 2045
				map["62nd"] = "+"
				map["63rd"] = "/"
				map["padding"] = "true"
				map["separator"] = "r~n"
				map["length"] = "76"
				map["decode"] = "false"
				map["compress"] = "false"
			Case 3 ' RFC 2152
				map["62nd"] = "+"
				map["63rd"] = "-"
				map["padding"] = "false"
				map["separator"] = ""
				map["length"] = "0"
				map["decode"] = "false"
				map["compress"] = "false"
			Case 4 ' RFC 3501
				map["62nd"] = "+"
				map["63rd"] = ","
				map["padding"] = "false"
				map["separator"] = ""
				map["length"] = "0"
				map["decode"] = "false"
				map["compress"] = "false"
			Case 5 ' RFC 4648 §4
				map["62nd"] = "+"
				map["63rd"] = "/"
				map["padding"] = "true"
				map["separator"] = ""
				map["length"] = "0"
				map["decode"] = "false"
				map["compress"] = "false"
			Case 6 ' RFC 4648 §5
				map["62nd"] = "-"
				map["63rd"] = "_"
				map["padding"] = "false"
				map["separator"] = ""
				map["length"] = "0"
				map["decode"] = "false"
				map["compress"] = "false"
			Case 7 ' RFC 9580
				map["62nd"] = "+"
				map["63rd"] = "/"
				map["padding"] = "true"
				map["separator"] = "~n"
				map["length"] = "64"
				map["decode"] = "false"
				map["compress"] = "false"
		End

		' After preset, parse ONLY files and outputPath
		Local fileCount:=0
		For Local i:=0 Until tokens.Length
			Local t:=tokens[i]
			If t.StartsWith("-o=") Or t.StartsWith("--o=") Or t.StartsWith("-output=") Or t.StartsWith("--output=")
				Local v:=t.Slice(t.Find("=")+1)
				If v.StartsWith("~q") And v.EndsWith("~q") And v.Length>=2
					v = v.Slice(1, v.Length-1)
				End
				map["outputPath"] = v
			ElseIf Not t.StartsWith("-")
				Local v:=t
				If v.StartsWith("~q") And v.EndsWith("~q") And v.Length>=2
					v = v.Slice(1, v.Length-1)
				End
				map["file"+fileCount] = v
				fileCount+=1
			End
		End
		Return map
	End

	'--- 2. If NO preset, parse all options and files/outputPath
	Local fileCount:=0
	Local found_e62:Bool=False, found_e43:Bool=False
	Local e62val:="+", e43val:="/"
	For Local i:=0 Until tokens.Length
		Local t:=tokens[i]
		If t.StartsWith("-o=") Or t.StartsWith("--o=") Or t.StartsWith("-output=") Or t.StartsWith("--output=")
			Local v:=t.Slice(t.Find("=")+1)
			If v.StartsWith("~q") And v.EndsWith("~q") And v.Length>=2
				v = v.Slice(1, v.Length-1)
			End
			map["outputPath"] = v
'		ElseIf t.StartsWith("-preset=") Or t.StartsWith("--preset=")
'			' already checked above, skip
		ElseIf t="-v" Or t="-verbose"
			map["verbose"] = "true"
		ElseIf t="-p" Or t="-padding"
			map["padding"] = "true"
		ElseIf t="-d" Or t="-decode"
			map["decode"] = "true"
		ElseIf t.StartsWith("-c=") Or t.StartsWith("-compress=")
			Local v:=t.Slice(t.Find("=")+1)
			If v.StartsWith("~q") And v.EndsWith("~q") And v.Length>=2
				v = v.Slice(1, v.Length-1)
			End
			If Int(v)>=0 And Int(v)<=5 Then map["compress"] = "true"
		ElseIf t.StartsWith("-e62=")
			Local v:=t.Slice(t.Find("=")+1)
			If v.StartsWith("~q") And v.EndsWith("~q") And v.Length>=2
				v = v.Slice(1, v.Length-1)
			End
			If v="+" Or v="-" Then found_e62=True; e62val=v
		ElseIf t.StartsWith("-e43=")
			Local v:=t.Slice(t.Find("=")+1)
			If v.StartsWith("~q") And v.EndsWith("~q") And v.Length>=2
				v = v.Slice(1, v.Length-1)
			End
			If v="/" Or v="," Or v="_" 
				found_e43=True
				e43val=v
			End
		ElseIf t.StartsWith("-s=") Or t.StartsWith("-separator=")
			Local v:=t.Slice(t.Find("=")+1)
			If v.StartsWith("~q") And v.EndsWith("~q") And v.Length>=2
				v = v.Slice(1, v.Length-1)
			End
			map["separator"] = v
		ElseIf t.StartsWith("-l=") Or t.StartsWith("-length=")
			Local v:=t.Slice(t.Find("=")+1)
			If v.StartsWith("~q") And v.EndsWith("~q") And v.Length>=2
				v = v.Slice(1, v.Length-1)
			End
			Local iv:=Int(v)
			If iv=-2 Or iv=-1 Or (iv>=1 And iv<=76) map["length"] = v
		ElseIf Not t.StartsWith("-")
			Local v:=t
			If v.StartsWith("~q") And v.EndsWith("~q") And v.Length>=2
				v = v.Slice(1, v.Length-1)
			End
			map["file"+fileCount] = v
			fileCount+=1
		Endif
	End

	' e62/e43 mutual exclusion: prefer e43 if both found
	If found_e43
		map["63rd"]=e43val
	ElseIf found_e62
		map["62nd"]=e62val
	End

	Return map
End

Function PrintMap(map:Map<String,String>)
	For Local item:=Eachin map 
		Print "["+item.Key+"]["+item.Value+"]"
	End 
End

Function Main()
	'Print Base64Help("-help")
	'Print _Base64HelpString()
	PrintMap( ParseParams( "~qfile1.svg~q ~qfile2.svg~q -o=~qc:\~q -p" ) )
End 
