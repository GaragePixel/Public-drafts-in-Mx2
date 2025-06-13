'Namespace Base64

' -----------------------------------------------------------------------------
' CLI base64 utility
' Author: iDkP from GaragePixel
' Version 0.2
' Since: 2025-06-12
'
' Purpose:
'	Parse a command-line parameter string into a Map.
'
' List of Functionality:
'	- Checks for a preset first and applies it if valid.
'	- Extracts file paths, output path, and option flags/values from a string.
'	- Supports both verbose and short flag forms, and preset profiles.
'	- Handles quoted values (using ~q as quote character).
'	- Returns all recognized options and all file/data/url inputs as ["itemN"] entries, with a "kind" key.
'
' Notes:
'	- All option keys in the output map use verbose names for clarity.
'	- All default options are set in the map before parsing.
'	- If a preset is valid and found, its values override all other options.
'	- If both -e62 and -e43 are found, only -e43 is used.
'	- Output path and all item keys are always after the standard options in the map.
'	- Returns Null if any syntax or value does not fit expected rules.
'
' Technical Advantages:
'	- Self-contained, robust parameter parsing for CLI utilities.
'	- Extensible and easy to maintain for future options/presets.
'	- Ensures correct behavior even with mixed or missing options.
'	- Output map is always ordered: all options first, then outputPath, then kind, then item(s).
' -----------------------------------------------------------------------------

#rem 

	SGVsbG8gV29ybGQh== = Hello Workd!
	Hello Workd! = SGVsbG8gV29ybGQh==

	--html                        encode an image into an html tag containing base64 data
#end

'#Import "<monkey>"
#Import "<stdlib>"
'Using stdlib..
Using stdlib.collections..
'Using stdlib.plugins.libc
Using stdlib.system.io.filesystem
'Using monkey..

'Function JoinAppArgs()
'	Local qargs:=AppArgs().Slice( 1 )
'	For Local i:=0 Until qargs.Length
'		qargs[i]="~q"+qargs[i]+"~q"
'	Next
'	Local args:=" ".Join( qargs )
'End 

Const APPNAME:="CLI base64 utility"
Const ORGANIZATION:="GaragePixel"
Const AUTHOR:="iDkP"
Const VERSION:="0.1"
Const VERSION_SINCE:="2025-06-11"
Const VERSION_LAST:="2025-06-13"
Const CONTACT:="garagepixel@outlook.com~nhttps://github.com/GaragePixel~nhttps://www.facebook.com/GaragePixelOfficial/"

#Rem monkeydoc Hidden 
#End 
Function Cmd( input:String )
	
	'input = "-t" 'Test
	
	Local result:=ParseInput(input)
	
	If Not result _Base64ErrorInput(input)
End

#Rem monkeydoc Hidden 
#End 
Function ParseInput:Bool( input:String )
	
	Local inputResult:=ParseSingleOption(input)

	If Not inputResult
		Local outmap:=ParseParams(input)
		If outmap<>Null 'data params
			
		'--- Normal Input
			Print outmap 'TODELETE
			Return True
		End
	Else
		
		'--- Single Option Input
		Return True
	End
	
	'------- Not reconized input
	Return Null
End

#Rem monkeydoc Hidden 
#End 
Function ParseSingleOption:Bool( input:String )
	
	Local outstr:String=Base64Help(input)
	If outstr<>-1 'Help
		'--- Help
		Print outstr
		Return True
	End

	'--- Version
	outstr=Base64Version(input)
	If outstr<>-1 'Version
		Print outstr
		Return True
	End
			
	'--- Info
	outstr=Base64Info(input)
	If outstr<>-1 'Info
		Print outstr
		Return True
	End

	'--- Author
	outstr=Base64Author(input)
	If outstr<>-1 'Author
		Print outstr
		Return True
	End

	'--- Author
	outstr=Base64Contact(input)
	If outstr<>-1 'Contact
		Print outstr
		Return True
	End

	'--- Tests
	outstr=Base64Tests(input)
	If outstr<>-1 'Tests
		Print outstr
		Return True
	End
	
	Return False
End

#Rem monkeydoc Base64Version
@author [iDkP from GaragePixel](https://github.com/GaragePixel)
@version 0.1
@since 2025-06-11

Detects CLI version flags for the base64 command and returns detailed version text

@param params:String
	The raw command-line string, e.g. "base64 encode -version" or "base64 --version"

@return String
	A help message describing the CLI base64 utility, options, and usage, or "-1" if not a help request.

#End
Function Base64Version:String( params:String )
	
	Local s:=params.Trim().ToLower()

	Local tokens:=s.Split(" ")
	If tokens.Length=1 And (tokens[0]="-version" Or tokens[0]="--version" Or tokens[0]="-v" Or tokens[0]="--v")
		
		Return _Base64Attribution(False) 	' It's a call for version, returns the version content.
	Endif

	Return "-1" 							' Well... isn't a call for version
End

#Rem monkeydoc Base64Info
@author [iDkP from GaragePixel](https://github.com/GaragePixel)
@version 0.1
@since 2025-06-11

Detects CLI version flags for the base64 command and returns detailed version text

@param params:String
	The raw command-line string, e.g. "base64 encode -info" or "base64 --info"

@return String
	A info message describing the CLI base64 utility, options, and usage, or "-1" if not a info request.

#End
Function Base64Info:String( params:String )
	
	Local s:=params.Trim().ToLower()

	Local tokens:=s.Split(" ")
	If tokens.Length=1 And (tokens[0]="-info" Or tokens[0]="--info" Or tokens[0]="-i" Or tokens[0]="--i")
		
		Return _Base64Attribution() 	' It's a call for info, returns the info content.
	Endif

	Return "-1" 						' Well... isn't a call for info
End

#Rem monkeydoc Base64Help
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
Function Base64Help:String( params:String )
	
	Local s:=params.Trim().ToLower()

	Local tokens:=s.Split(" ")
	If tokens.Length=1 And (tokens[0]="-help" Or tokens[0]="--help" Or tokens[0]="-h" Or tokens[0]="--h")
		
		Return _Base64HelpString() 	' It's a call for help, returns the help content.
	Endif

	Return "-1" 					' Well... isn't a call for help
End

#Rem monkeydoc Hidden 
#End
Function Base64Author:String( params:String )
	
	Local s:=params.Trim().ToLower()

	Local tokens:=s.Split(" ")
	If tokens.Length=1 And (tokens[0]="-author" Or tokens[0]="--author" Or tokens[0]="-a" Or tokens[0]="--a")
		
		Return "~n"+_Base64Author()	 	' It's a call for author, returns the author content
	Endif

	Return "-1" 						' Well... isn't a call for author
End

#Rem monkeydoc Hidden 
#End
Function Base64Contact:String( params:String )
	
	Local s:=params.Trim().ToLower()

	Local tokens:=s.Split(" ")
	If tokens.Length=1 And (tokens[0]="-contact" Or tokens[0]="--contact" Or tokens[0]="-c" Or tokens[0]="--c")
		
		Return "~n"+_Base64Contact()	' It's a call for author, returns the contact content
	Endif

	Return "-1" 						' Well... isn't a call for contact
End

#Rem monkeydoc Hidden 
#End
Function Base64Licence:String( params:String )
	
	Local s:=params.Trim().ToLower()

	Local tokens:=s.Split(" ")
	If tokens.Length=1 And (tokens[0]="-licence" Or tokens[0]="--licence" Or tokens[0]="-l" Or tokens[0]="--l")
		
		Return "~n"+_Base64Licence()	' It's a call for licence, returns the licence content
	Endif

	Return "-1" 						' Well... isn't a call for licence
End

#Rem monkeydoc Hidden 
#End 
Function Base64Tests:String( params:String )
	
	Local s:=params.Trim().ToLower()

	Local tokens:=s.Split(" ")
	If tokens.Length=1 And (tokens[0]="-tests" Or tokens[0]="--tests" Or tokens[0]="-t" Or tokens[0]="--t")
		UnitTest_Params()
	Endif

	Return "-1"
End

Private

Function _Base64ErrorInput( input:String )
	Print "The command " + input + "is unknows"
End 

#Rem monkeydoc Hidden 
#End 
Function _Base64Attribution:String( verbose:Bool=True ) 
	Return Not verbose ? VERSION Else 	_Base64AttributionShort(verbose) +
										"Since: " + VERSION_SINCE
End

#Rem monkeydoc Hidden 
#End 
Function _Base64AttributionShort:String( verbose:Bool=True )
	Return Not verbose ? VERSION Else 	"~n" + _Base64AppName() + "~n" +
										ORGANIZATION + " © " + VERSION_SINCE.Left(4) + " All Right Reserved~n"
End

#Rem monkeydoc Hidden 
#End 
Function _Base64AppName:String() 
	Return 	APPNAME + " " + VERSION + " - " + VERSION_LAST
End

#Rem monkeydoc Hidden 
#End 
Function _Base64Author:String() 
	Return 	AUTHOR + " from " + ORGANIZATION
End

#Rem monkeydoc Hidden 
#End 
Function _Base64Contact:String() 
	Return 	_Base64Author() + "~n" + CONTACT
End

#Rem monkeydoc Hidden 
#End 
Function _Base64Licence:String()
	Return Null
End

#Rem monkeydoc Hidden 
#End 
Function _Base64HelpString:String()
	Return 	_Base64AttributionShort() + "~n" +
			"The freeware cross-platform CLI utility 'base64' provides encoding and decoding of data using Base64, as described in:" + "~n" +
			"  RFC 1421~n  RFC 2045~n  RFC 2152~n  RFC 3501~n  RFC 4648 §4~n  RFC 4648 §5~n  and RFC 9580" + "~n~n"+
			"USAGE:" + "~n" +
			"  base64 encode [file(s)] [outputPath] [options]" + "~n" +
			"  base64 decode [file(s)] [outputPath] [options]" + "~n~n" +
			"  base64 encode data:[data] [outputPath] [options]" + "~n" +
			"  base64 decode data:[data] [outputPath] [options]" + "~n~n" +
			"SINGLE OPTION:" + "~n" +
			"  -h" + "~n" +
			"  -i" + "~n" +
			"  -v" + "~n" +
			"  -a" + "~n" +
			"  -c" + "~n" +
			"  -l" + "~n" +
			"  -t" + "~n~n" +
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

#Rem monkeydoc Hidden 
#End 
Function UnitTest_Params()
	Print "~n[Normal #1] encode ~qfile1.svg~q ~qfile2.svg~q -o=~qc:/out/~q -a=blob -pr=DATA"
	Print ParseParams( "encode ~qfile1.svg~q ~qfile2.svg~q -o=~qc:/out/~q -a=blob -pr=DATA" )
	'---
	Print "~n[Normal #2] decode ~qinput1.blob~q -o=~qc:/decodes/~q -v"
	Print ParseParams( "decode ~qinput1.blob~q -o=~qc:/decodes/~q -v" )
	'---
	Print "~n[Normal #3] encode url:https://github.com/GaragePixel/Public-drafts-in-Mx2/blob/main/proj.md -o=~qc:/out/~q"
	Print ParseParams( "encode url:https://github.com/GaragePixel/Public-drafts-in-Mx2/blob/main/proj.md -o=~qc:/out/~q" )
	'---
	Print "~n[Normal #4] encode data:SGVsbG8gV29ybGQh== -o=~qc:/out/~q"
	Print ParseParams( "encode data:SGVsbG8gV29ybGQh== -o=~qc:/out/~q" )
	'---
	Print "~n[Normal #5] encode ~qfile with spaces.svg~q -o=~qc:/my folder/~q"
	Print ParseParams( "encode ~qfile with spaces.svg~q -o=~qc:/my folder/~q" )
	'---
	Print "~n~nLimit cases~n"
	'---
	Print "~n[Edge #1] encode -o=~qc:/out/~q -a=blob -pr=DATA" ' No input files
	Print ParseParams( "encode -o=~qc:/out/~q -a=blob -pr=DATA" )
	'---
	Print "~n[Edge #2] invalid"
'	Print "~n[Edge #2] encode ~qfile1.svg~q -o=~qinvalidpath~q" ' OutputPath invalid (no / or extension)
'	Print ParseParams( "encode ~qfile1.svg~q -o=~qinvalidpath~q" )
	'---
	Print "~n[Edge #3] invalid"
'	Print "~n[Edge #3] encode ~qfile1.svg~q -o=~qc:/out/file1svg~q" ' OutputPath invalid (no extension)
'	Print ParseParams( "encode ~qfile1.svg~q -o=~qc:/out/file1svg~q" )
	'---
	Print "~n[Edge #4] decode data: -o=~qc:/out/~q" ' Empty data
	Print ParseParams( "decode data: -o=~qc:/out/~q" )
	'---
	Print "~n[Edge #5] encode url:~qhttps://example.com/file1~q url:~qhttps://example.com/file2~q -o=~qc:/out/~q"
	Print ParseParams( "encode url:~qhttps://example.com/file1~q url:~qhttps://example.com/file2~q -o=~qc:/out/~q" )
	'---
	Print "~n[Edge #6] encode ~qfile1.svg~q ~qfile2.svg~q -o=outdir/" ' Unquoted but valid dir
	Print ParseParams( "encode ~qfile1.svg~q ~qfile2.svg~q -o=outdir/" )
	'---
	Print "~n[Edge #7] encode ~qfile1.svg~q -o=~qc:/out/file1.svg~q -a=blobblob" ' OutputPath fullpath with .svg, append .blobblob
	Print ParseParams( "encode ~qfile1.svg~q -o=~qc:/out/file1.svg~q -a=blobblob" )
	'---
	Print "~n[Edge #8] encode ~qfile1.svg~q -o=~qc:/out/~q -a=bl ob" ' Append contains space (should return Null)"
	Print ParseParams( "encode ~qfile1.svg~q -o=~qc:/out/~q -a=bl ob" )
	'---
	Print "~n[Edge #9] encode ~qfile1.svg~q -o=~qc:/out/~q -pr=PR FX" ' Prefix contains space (should return Null)"
	Print ParseParams( "encode ~qfile1.svg~q -o=~qc:/out/~q -pr=PR FX" )
	'---
	Print "~n[Edge #10] encode -pr= -a=" ' Empty prefix/append"
	Print ParseParams( "encode -pr= -a=" )
	'---
	Print "~n[Edge #11] decode -o=~qc:/out/~q" ' No input"
	Print ParseParams( "decode -o=~qc:/out/~q" )
	'---
	Print "~n[Edge #12] encode ~qfile1.svg~q --preset=~qRFC 2045~q -o=~qc:/out/~q"
	Print ParseParams( "encode ~qfile1.svg~q --preset=~qRFC 2045~q -o=~qc:/out/~q" )
	'---
	Print "~n[Edge #13] encode data:SGVsbG8gV29ybGQh== -o=~qc:/out/~q -a=blob"
	Print ParseParams( "encode data:SGVsbG8gV29ybGQh== -o=~qc:/out/~q -a=blob" )
	'---
	Print "~n[Edge #14] encode url: -o=~qc:/out/~q"
	Print ParseParams( "encode url: -o=~qc:/out/~q" )
	'---
	Print "~n[Edge #15] encode ob1 ~qfile1.svg~q ob2 -o=~qc:/out/~q ob3 -a=bl ob4" ' Append contains space (should return Null)"
	Print ParseParams( "encode ob1 ~qfile1.svg~q ob2 -o=~qc:/out/~q ob3 -a=bl ob4" )
	'---
	Print "~n[Edge #16] encode ob1 ~qfile1.svg~q mytext.txt -o=~qc:/out/~q ob3 -a=bl ob4" ' Append contains space (should return Null)"
	Print ParseParams( "encode ob1 ~qfile1.svg~q mytext.txt -o=~qc:/out/~q ob3 -a=bl ob4" )
End 

#Rem monkeydoc ParseParams
@author [iDkP from GaragePixel](https://github.com/GaragePixel)
@version 0.1
@since 2025-06-13

Parses a command-line parameter string for a CLI base64 utility 
and returns a map of parameters, options, file/data/url items, and html embedding intent in a normalized, ordered form.

---

@Parameters

- `params:String`  
	Command-line string containing file paths, output path, options, and html embedding intent.
	- File paths can be quoted  or unquoted.
	- Output path must use `-o=`, `-output=`, `--o=`, or `--output=` and be quoted or unquoted.
	- Options must use recognized flags or forms; see below.

---

@Recognized Options

- `-preset=` / `--preset=` — quoted preset name. If found and valid, only items and outputPath are parsed after.
- `-o=`, `--o=`, `-output=`, `--output=` — output path (quoted or unquoted).
- `-v`, `-verbose` — enables verbose mode.
- `-c=`, `-compress=` — integer 0..5 (quoted or not), enables compress.
- `-p`, `-padding` — enables padding.
- `-e62=` — encoding char 62 (`+` or `-`), quoted.
- `-e43=` — encoding char 63 (`/`, `,`, or `_`), quoted. If both -e62 and -e43 are present, only -e43 is used.
- `-s=`, `-separator=` — quoted string, used as line separator.
- `-l=`, `-length=` — quoted int= -2, -1, or 1..76, only meaningful if separator is non-empty.
- `-d`, `-decode` — enables decode mode.
- `-a=`, `--a=`, `-append=`, `--append=` — append string to file name after extension (no spaces).
- `-pr=`, `--pr=`, `-prefix=`, `--prefix=` — string to prefix each output blob (no spaces).
- `-html`, `--html`, `-h`, `--h`, `-html=`, `--html=`, `-html=image`, `-html=text`, `-html=""`, `-html="image"`, `-html="text"`  
	- Controls embedding in HTML output:
		- Default: [html][none]
		- -html, --html, -h, --h, -html=image, -html="image" → [html][image]
		- -html=text, -html="text" → [html][text]
		- -html=, -html="", -html=" " → [html][none]
		- Any html parsing error is resolved silently (never returns Null).

---

@Item Handling

- Files, data, or urls are detected and classified by prefix (file, data, url).
- Map includes key "kind" with value "file", "data", or "url" accordingly.
- All input items are mapped as "item0", "item1", ... (for file and url), or single "item" (for data).
- "mode" ("encode"/"decode") is never included as an item.
- Output path must end with `/` (directory) or `.<ext>` (fullpath with extension).
- If not matching expected syntax, function returns Null.

---

@Return value

Returns a `Map<String,String>` with a normalized, ordered set of options, output path, html intent, kind, and items.
Returns Null if any error or invalid syntax detected.

---

@Preset behaviour

If a valid `-preset=` or `--preset=` is provided, the preset's values override all other options except for items and outputPath.  
Valid presets (see [Wikipedia: Base64](https://en.wikipedia.org/wiki/Base64)):
- `"RFC 1421"`
- `"RFC 2045"`
- `"RFC 2152"`
- `"RFC 3501"`
- `"RFC 4648 §4"`
- `"RFC 4648 §5"`
- `"RFC 9580"`

After a valid preset, only outputPath and items are parsed; all other options are ignored.

---

@HTML behaviour

- If [html][image], the output will wrap the base64 blob in an `<img>` HTML tag (future implementation will extract image size from the file header if possible).
- If [html][text], the output will wrap the blob in a text-based HTML tag.
- If [html][none], no HTML wrapping is performed.
- This only affects the output, not the parsing of the command-line arguments.

---

@Example

	ParseParams("encode ~qfile1.svg~q ~qfile2.svg~q -o=~qc:/out/~q -a=blob -pr=DATA -html=image")
	' Result: Map with mode="encode", outputPath="c:/out/", append="blob", prefix="DATA", kind="file",
	' item0="file1.svg", item1="file2.svg", html="image"

---

@Notes

- Only the first matching form of each option is used.
- If both -e62 and -e43 are present, -e43 takes precedence.
- All values are returned unquoted.
- Items are classified and indexed as item0, item1, etc. (file, url) or item (data).
- OutputPath must end with / or .ext or .ext.ext (as file).
- If -html is not specified, [html][none] is always present.
- Returns Null if syntax is not respected (except for -html errors, which are resolved silently).
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
	map.Add("prefix","")
	map.Add("append","")
	map.Add("mode","")
	map.Add("kind","")
	map.Add("html","none")

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

	'--- Detect mode (encode|decode) as first positional token if present
	Local firstToken:String = ""
	If tokens.Length>0
		firstToken = tokens[0].ToLower()
		If firstToken="encode" Or firstToken="decode"
			map["mode"]=firstToken
			tokens.Remove(0)
		End
	End
	
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

	'--- HTML option handling: always default to "none"
	Local htmlDetected:Bool=False

	If presetIdx>0
		' Apply preset to map (no changes here)
		Local fileCount:=0
		Local kind:=""
		For Local i:=0 Until tokens.Length
			Local t:=tokens[i]
			' parse html option if encountered
			If t.StartsWith("-html") Or t.StartsWith("--html") Or t.StartsWith("-h") Or t.StartsWith("--h")
				htmlDetected=True
				Local val:String=""
				If t.Find("=")>=0
					val = t.Slice(t.Find("=")+1)
					If val.StartsWith("~q") And val.EndsWith("~q") And val.Length>=2
						val = val.Slice(1, val.Length-1)
					End
					val = val.Trim()
					If val.ToLower()="image"
						map["html"]="image"
					ElseIf val.ToLower()="text"
						map["html"]="text"
					Else 
						map["html"]="none"
					End
				Else
					map["html"]="image"
				End
				Continue
			End
			If t.StartsWith("-o=") Or t.StartsWith("--o=") Or t.StartsWith("-output=") Or t.StartsWith("--output=")
				Local v:=t.Slice(t.Find("=")+1)
				If v.StartsWith("~q") And v.EndsWith("~q") And v.Length>=2
					v = v.Slice(1, v.Length-1)
				End
				If Not (v.EndsWith("/") Or v.Find(".", v.Length-5)>=0)
					Return Null
				End
				map["outputPath"] = v
			ElseIf Not t.StartsWith("-")
				Local v:=t
				If v.StartsWith("~q") And v.EndsWith("~q") And v.Length>=2
					v = v.Slice(1, v.Length-1)
				End
				' Detect kind: url/data/file
				If v.StartsWith("url:")
					kind="url"
					Local vSlice4:=v.Slice(4)
					If vSlice4<>"encode" And vSlice4<>"decode"
						map["item"+fileCount]=vSlice4
						fileCount+=1
					End
				ElseIf v.StartsWith("data:")
					kind="data"
					map["item"]=v.Slice(5)
				Else
					If v<>"encode" And v<>"decode"
						kind="file"
						map["item"+fileCount]=v
						fileCount+=1
					End 
				End
			End
		End
		If kind<>"" Then map["kind"]=kind
		Return map
	End

	'--- 2. If NO preset, parse all options and files/outputPath/kind and html
	Local fileCount:=0
	Local found_e62:Bool=False, found_e43:Bool=False
	Local e62val:="+", e43val:="/"
	Local kind:=""
	For Local i:=0 Until tokens.Length
		Local t:=tokens[i]
		' HTML option
		If t.StartsWith("-html") Or t.StartsWith("--html") Or t.StartsWith("-h") Or t.StartsWith("--h")
			htmlDetected=True
			Local val:String=""
			If t.Find("=")>=0
				val = t.Slice(t.Find("=")+1)
				If val.StartsWith("~q") And val.EndsWith("~q") And val.Length>=2
					val = val.Slice(1, val.Length-1)
				End
				val = val.Trim()
				If val.ToLower()="image" 
					map["html"]="image"
				ElseIf val.ToLower()="text" 
					map["html"]="text"
				Else 
					map["html"]="none"
				End
			Else
				map["html"]="image"
			End
			Continue
		End
		If t.StartsWith("-o=") Or t.StartsWith("--o=") Or t.StartsWith("-output=") Or t.StartsWith("--output=")
			Local v:=t.Slice(t.Find("=")+1)
			If v.StartsWith("~q") And v.EndsWith("~q") And v.Length>=2
				v = v.Slice(1, v.Length-1)
			End
			If Not (v.EndsWith("/") Or v.Find(".", v.Length-5)>=0)
				Return Null
			End
			map["outputPath"] = v
		ElseIf t.StartsWith("-a=") Or t.StartsWith("--a=") Or t.StartsWith("-append=") Or t.StartsWith("--append=")
			Local v:=t.Slice(t.Find("=")+1)
			If v.StartsWith("~q") And v.EndsWith("~q") And v.Length>=2
				v = v.Slice(1, v.Length-1)
			End
			If v.Find(" ")>=0 Then Return Null
			map["append"]=v
		ElseIf t.StartsWith("-pr=") Or t.StartsWith("--pr=") Or t.StartsWith("-prefix=") Or t.StartsWith("--prefix=")
			Local v:=t.Slice(t.Find("=")+1)
			If v.StartsWith("~q") And v.EndsWith("~q") And v.Length>=2
				v = v.Slice(1, v.Length-1)
			End
			If v.Find(" ")>=0 Then Return Null
			map["prefix"]=v
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
			' Detect kind: url/data/file
			If v.StartsWith("url:")
				kind="url"
				Local vSlice4:=v.Slice(4)
				If vSlice4<>"encode" And vSlice4<>"decode"
					map["item"+fileCount]=vSlice4
					fileCount+=1
				End
			ElseIf v.StartsWith("data:")
				kind="data"
				map["item"]=v.Slice(5)
			Else
				If v<>"encode" And v<>"decode"
					If kind="" kind="file"
					map["item"+fileCount]=v
					fileCount+=1
				End 
			End
		End
	End

	If kind<>"" Then map["kind"]=kind

	' e62/e43 mutual exclusion: prefer e43 if both found
	If found_e43
		map["63rd"]=e43val
	ElseIf found_e62
		map["62nd"]=e62val
	End

	' Ensure html="none" if not set
	If Not htmlDetected Then map["html"]="none"

	Return map
End

Public

#rem monkeydoc Concatenate each app's arguments in a string
	@author iDkP from GaragePixel
	@since 2025-06-13
	
	Sometimes, you want deal with the params with a special parser, so this
	function allows to implement your own parser for arguments given as string.
	
	@param separator String adds a separator between the arguments, space by default
	@return the arguments as string
#end 
Function AppArgsContat:String( separator:String=" " )
	Local result:String
	Local args:String[]=AppArgs().Slice( 1 )
	For Local i:=0 Until args.Length
		result+=args[i]+separator
	Next
	Return result.Left(result.Length-1)
End

'			"  -h" + "~n" +
'			"  -i" + "~n" +
'			"  -v" + "~n" +
'			"  -a" + "~n" +
'			"  -c" + "~n" +
'			"  -l" + "~n" +
'			"  -t" + "~n" +
Function Main()

	'stdlib.plugins.libc.fflush(stdlib.plugins.libc.stdout)
	Cmd( AppArgsContat() )
End
