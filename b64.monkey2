#Rem
	Mini-Library: Base64 (Unit Test for v2+ implementation)
	Author: iDkP from GaragePixel
	Date: 2025-06-15

## Purpose

Unit test for the enhanced Base64 implementation (`stdlib.base64`).
Verifies encode/decode correctness for all supported modes and padding options.

## List of Functionality

- Tests round-trip encode/decode for random data, multiple sizes.
- Tests all Base64 modes: Standard, URLsafe, SRP, RFC1421, RFC2045, RFC2152, RFC3501, RFC4648_4, RFC4648_5, RFC9580.
- Verifies optional/required padding, line wrapping, and delimiter handling.
- Ensures decode is robust to non-alphabet characters and line breaks.

## Notes

- All tests use block structure and idiomatic Monkey2/Wonkey code style.
- Uses DataBuffer and stdlib plugins for bytewise comparison.
- Randomizes test data for broad coverage.
- Reports first failure with detail; otherwise prints "All tests passed."
- Does NOT test checksums (pending TODO in library).

## Technical advantages & explanations

- Exhaustive: Checks all modes and code paths.
- Reliable: Catches both logic and subtle compatibility errors.
- Fast: Suitable for CI or local dev.
- Readable: Easy to extend for new modes.
#End

#Import "<stdlib>"

Using stdlib..

#rem monkeydoc The EncodeBase64Modes are used with the Base64 function.

| Mode        | encode[62] | encode[63] | Padding | Line Length | Notes                  |
|-------------|------------|------------|---------|-------------|------------------------|
| Standard    |   43 ('+') |   47 ('/') | True    | N/A         | RFC 2045 default       |
| URLsafe     |   45 ('-') |   95 ('_') | opt     | N/A         | RFC 4648-5             |
| SRP         |   --       |   --       │ False   | N/A         | Secure Remote Password |
| RFC1421     |   43 ('+') |   47 ('/') | True    | 64          | PEM, checksum          |
| RFC2045     |   43 ('+') |   47 ('/') | False   | 76          | MIME, line breaks      |
| RFC2152     |   43 ('+') |   47 ('/') | False   | N/A         | UTF-7, skip non-chars  |
| RFC3501     |   43 ('+') |   44 (',') | False   | N/A         | IMAP                   |
| RFC4648_4   |   43 ('+') |   47 ('/') | False   | N/A         | Standard (unpadded)    |
| RFC4648_5   |   45 ('-') |   95 ('_') | opt     | N/A         | URL safe (unpadded)    |
| RFC9580     |   43 ('+') |   47 ('/') | True    | 76          | Checksum, line breaks  |

Definitions:

	**Standard**	Standard base64 for most use-cases (RFC 4648)
					Alphabet: A-Z a-z 0-9 + /
					Always padded (with =), no line wrapping, no special delimiters
					Used in most modern APIs (web, files, generic binary encode/decode)
	
	**URLsafe		URL-safe base64 variant (RFC 4648-5)
					Alphabet: A-Z a-z 0-9 - _
					Optional padding, no line wrapping, safe for URLs, filenames, web tokens
					Used in JWT, web specs, URL query parameters
	
	**SRP**			SRP (Secure Remote Password) protocol, uses a unique base64 alphabet
					SRP base64 is not meant for email or human-readability,
					but for compact protocol transmission and storage.
					Alphabet: 0-9 A-Z a-z . /
					No padding, no line breaks, no delimiters
					Adding line breaks or separators can break interoperability with SRP implementations
					Always expect a single-line output
				
	**RFC1421**		(+/) Checksum, length 64
					PEM encoding (RFC 1421) with (+/) alphabet
					Always padded, line length 64 chars, CRLF/other delimiters allowed
					Checksum (CRC-24) appended at the end (after a delimiter)
					Used in PEM files, OpenSSL, SSH keys, PGP ASCII Armor
	
	**RFC2045**		Standard (+/) length 76
					UTF-7 uses standard base64 for encoding, 
					but with special rules for padding and prohibited characters. 
					The alphabet itself for base64 blocks is the same as standard, 
					but "+" is used as a shift character and, in some contexts, 
					"/" is not used for encoding shift sequences.
					MIME (RFC 2045) for email attachments (alphabet +/)
					No padding for last block (unless explicitly required)
					Line length 76 chars, CRLF delimiter between lines
					Allows whitespace or other formatting chars ("non-encoding chars")
					Used for MIME/base64 encoding in email, HTTP multipart, etc.
				
	**RFC2152**		(+/) Decoding non-encoding characters
					RFC 3501 is used for IMAP's "modified BASE64" (base64 with "," instead of "/").
					UTF-7 (RFC 2152) base64 for Unicode text in email
					(+/) alphabet, but with additional rules for shift sequences, may skip padding
					Decoding must ignore all non-base64 characters
					Used only for UTF-7 encoding (rare, legacy)
				
	**RFC3501**		IMAP4rev1 (+,)
					IMAP4rev1 (RFC 3501) "modified base64"
					Alphabet: A-Z a-z 0-9 + ,
					No padding, no line breaks, intended for IMAP mailbox names
					Not compatible with standard base64 decoders
	
	**RFC4648_4**	Standard (+/)
					RFC 4648 "standard" base64 (unpadded variant)
					Alphabet: A-Z a-z 0-9 + /
					No padding, no line breaks, for situations where = padding is not desired
					Used in some modern protocols (e.g. DNS wire format)
	
	**RFC4648_5**	URL-safe (-/_)
					RFC 4648 "URL-safe" base64 (unpadded variant)
					Alphabet: A-Z a-z 0-9 - _
					Optional or no padding, no line wrapping, used in web tokens, URLs, filenames
					Used in JWT, OAuth, Web APIs
	
	**RFC9580**		(+/) Checksum, length 76
					RFC 9580 (Post-Quantum PEM) base64
					Alphabet: A-Z a-z 0-9 + /
					Always padded, line length 76 chars, CRLF delimiter
					Checksum (CRC32, 4 bytes) appended after delimiter at end
					Used in modern PQC PEMs (post-quantum certs, keys)

#End
Enum EncodeBase64_Modes_
	Standard	
	URLsafe
	SRP
	RFC1421
	RFC2045
	RFC2152
	RFC3501
	RFC4648_4
	RFC4648_5
	RFC9580
End 

#Rem monkeydoc Convert EncodeBase64Modes value to string for error reporting
#End
Function EncodeBase64_ModeToString:String( mode:EncodeBase64_Modes_ )
	Select mode
		Case EncodeBase64_Modes_.Standard		Return "Standard"
		Case EncodeBase64_Modes_.URLsafe		Return "URLsafe"
		Case EncodeBase64_Modes_.SRP			Return "SRP"
		Case EncodeBase64_Modes_.RFC1421 		Return "RFC1421"
		Case EncodeBase64_Modes_.RFC2045		Return "RFC2045"
		Case EncodeBase64_Modes_.RFC2152		Return "RFC2152"
		Case EncodeBase64_Modes_.RFC3501		Return "RFC3501"
		Case EncodeBase64_Modes_.RFC4648_4		Return "RFC4648_4"
		Case EncodeBase64_Modes_.RFC4648_5		Return "RFC4648_5"
		Case EncodeBase64_Modes_.RFC9580		Return "RFC9580"
	End
	Return "Unknown"
End

#rem monkeydoc Encode binary data to base64 text.

## List of Functionality

- Injects line breaks (with delimiter) after every `lnlength` encoded characters.
- Supports multi-char delimiters (CR, LF, or custom).
- Reuses the existing "normal" encode loop, adding only line break logic.
- Leaves all other modes unmodified.

### **What does `nonEncodingChar` mean?**

Some Base64 variants (notably MIME/RFC2045, UTF-7/RFC2152, PEM, and others) 
**allow non-alphabet characters (spaces, newlines, tabs, etc) to appear anywhere in the encoded string**, 
either for formatting, email transmission, or as accidental noise.

- **MIME base64**: Line breaks every 76 chars, plus possibly spaces/tabs if mailers rewrap.
- **UTF-7**: Permits all sorts of non-base64 chars, must be ignored.
- **PEM**: Allows line breaks and possible header/footer lines.
- **MIME base64**: Line breaks every 76 chars, plus possibly spaces/tabs if mailers rewrap.
- **UTF-7**: Permits all sorts of non-base64 chars, must be ignored.
- **PEM**: Allows line breaks and possible header/footer lines.

| Mode      | Skip non-base64 chars? 		|
|-----------|-------------------------------|
| RFC2045   | Yes (MIME)                    |
| RFC2152   | Yes (UTF-7)                   |
| PEM       | Yes                           |
| Standard  | Optional (safer if strict)    |
| URL-safe  | Optional                      |

### Typical delimiters

| Name   | String Representation | Character Code(s) | Description                         |
|--------|-----------------------|-------------------|-------------------------------------|
| LF     | `"~n"`                | 10                | Line Feed, Unix style               |
| CRLF   | `"~r~n"`              | 13, 10            | Carriage Return + Line Feed, DOS/Win|
#end
Function EncodeBase64_:String( 	data:UByte Ptr,length:Int,
								mode:EncodeBase64_Modes_=EncodeBase64_Modes_.Standard,
								pad:Bool=True, 				'Used only for URLsafe and RFC4648_5
								lnlength:UInt=Null,	 		'Very optional but can be overriden in some cases
								delimiter:String="~r~n"	)	'For Line wrapping (RFC2045, RFC1421, RFC9580)

	'Alphabet, padding, line-wrapping, non-encoding char skipping is in one function.

	Local nonEncodingChar:=False 
	Local separator:=False 
	Local charDelim:Int[]=New Int[delimiter.Length+1]
	Local delimLen:=0
	
	'Set mode-specific chars and options
	Base64Setup(Varptr(mode), Varptr(pad), Varptr(lnlength), Varptr(separator), Varptr(charDelim[0]), Varptr(delimiter), Varptr(nonEncodingChar), Varptr(delimLen))
	
	Local buf:=New Stack<UByte>,tmp:=New UByte[3],i:=0,j:=0
	
	If mode=EncodeBase64_Modes_.RFC2045 Or mode=EncodeBase64_Modes_.RFC1421 Or mode=EncodeBase64_Modes_.RFC9580
		
		'Line wrapping version (RFC2045, RFC1421, RFC9580)
		Local lineCount:=0

		While i<length

			tmp[j]=data[i] ; j+=1 ; i+=1

			If j=3
				buf.Add( encode[ (tmp[0] & $fc) Shr 2 ] )
				buf.Add( encode[ (tmp[0] & $03) Shl 4 | (tmp[1] & $f0) Shr 4 ] )
				buf.Add( encode[ (tmp[1] & $0f) Shl 2 | (tmp[2] & $c0) Shr 6 ] )
				buf.Add( encode[  tmp[2] & $3f ] )
				j=0
				lineCount+=4

'				If lineCount>=lnlength
'					For Local k:=0 Until charDelim.Length
'						buf.Add(charDelim[k])
'					End
'					lineCount=0
'				End
				If lineCount>=lnlength
					If charDelim[0]<>0
						For Local k:=0 Until delimLen
							buf.Add(charDelim[k])
						End
					End
					lineCount=0
				End
			End
		Wend

		If j
			tmp[j]=0

			buf.Add( encode[ (tmp[0] & $fc) Shr 2 ] )
			buf.Add( encode[ (tmp[0] & $03) Shl 4 | (tmp[1] & $f0) Shr 4 ] )
			lineCount+=2

			If j=2
				buf.Add( encode[ (tmp[1] & $0f) Shl 2 | (tmp[2] & $c0) Shr 6 ] )
				lineCount+=1
			End

			If pad
				If j=1 buf.Add( CHAR_EQUALS ) ; lineCount+=1
				buf.Add( CHAR_EQUALS )
				lineCount+=1
			End
		End

	Else
		
		'Normal version (no line wrapping)
	
		While i<length
			
			tmp[j]=data[i] ; j+=1 ; i+=1
			
			If j=3
				buf.Add( encode[ (tmp[0] & $fc) Shr 2 ] )
				buf.Add( encode[ (tmp[0] & $03) Shl 4 | (tmp[1] & $f0) Shr 4 ] )
				buf.Add( encode[ (tmp[1] & $0f) Shl 2 | (tmp[2] & $c0) Shr 6 ] )
				buf.Add( encode[  tmp[2] & $3f ] )
				j=0
			End
		Wend
		
		If j
			tmp[j]=0
			
			buf.Add( encode[ (tmp[0] & $fc) Shr 2 ] )
			buf.Add( encode[ (tmp[0] & $03) Shl 4 | (tmp[1] & $f0) Shr 4 ] )
			If j=2 buf.Add( encode[ (tmp[1] & $0f) Shl 2 | (tmp[2] & $c0) Shr 6 ] )
				
			If pad
				If j=1 buf.Add( CHAR_EQUALS )
				buf.Add( CHAR_EQUALS )
			End
		End
	
	End
	
	Return String.FromCString( buf.Data.Data,buf.Length )
End

#rem monkeydoc Encode binary data to base64 text.
#end
Function EncodeBase64_:String( 	data:DataBuffer,
								mode:EncodeBase64_Modes_=EncodeBase64_Modes_.Standard,
								pad:Bool=True, 				'Used only for URLsafe and RFC4648_5
								lnlength:UInt=Null,	 		'Very optional but can be overriden in some cases
								delimiter:String="~r~n"	)	'For Line wrapping (RFC2045, RFC1421, RFC9580)
	
	Return EncodeBase64_( data.Data,data.Length,mode,pad,lnlength,delimiter )
End

#rem monkeydoc Decode base64 text to binary data.

| Mode      | Skip non-base64 chars? 		|
|-----------|-------------------------------|
| RFC2045   | Yes (MIME)                    |
| RFC2152   | Yes (UTF-7)                   |
| PEM       | Yes                           |
| Standard  | Optional (safer if strict)    |
| URL-safe  | Optional                      |
#end
Function DecodeBase64_:DataBuffer( 	str:String,
									mode:EncodeBase64_Modes_=EncodeBase64_Modes_.Standard,
									pad:Bool=True,
									lnlength:UInt=Null,
									delimiter:String="~r~n"	 )

	'- Original code will abort or break on any unexpected char.
	'- Now (iDkP's): Ignore (skip) any char not part of the base64 alphabet or "=". 
	'This makes them compatible with all real-world usages.
	
	Global decode:Int[]

	Local nonEncodingChar:=False 
	Local separator:=False
	Local charDelim:Int[]=New Int[1]
	Local delimLen:=0

	' Remove all CR and LF (linebreaks) for RFC1421, RFC2045, and RFC9580
	If mode=EncodeBase64_Modes_.RFC1421 Or mode=EncodeBase64_Modes_.RFC2045 Or mode=EncodeBase64_Modes_.RFC9580 Or mode=EncodeBase64_Modes_.RFC2152
	'I know, it's brutal
		str = str.Replace(delimiter,"")
		str = str.Replace("10","")'
		str = str.Replace("13","")
		str = str.Replace("32","")
		str = str.Replace("0","")
	End
	
	'And then set mode-specific chars
	Base64Setup(Varptr(mode), Varptr(pad), Varptr(lnlength), Varptr(separator), Varptr(charDelim[0]), Varptr(delimiter), Varptr(nonEncodingChar), Varptr(delimLen))
	
	If Not decode
		decode=New Int[128]
		For Local i:=0 Until 128
			decode[i]=-1
		Next
	End
	For Local i:=0 Until 64
		decode[encode[i]]=i
	Next
	
	Local buf:=New Stack<UByte>,tmp:=New Int[4],i:=0,j:=0
	
	While i<str.Length
		
		Local c:=str[i]
		
		'iDkP: Old implementation was not not compliant with MIME, PEM, UTF-7, or typical real-world base64.
'		If c=CHAR_EQUALS Or c<0 Or c>=decode.Length Or decode[c]=-1 Exit
		
		If c<0 Or c>=decode.Length Or decode[c]=-1 Or c=CHAR_EQUALS
			If nonEncodingChar
				i+=1
				Continue
			Else
				Exit
			End
		End
		
		tmp[j]=decode[c] ; i+=1 ; j+=1
		
		If j=4
			buf.Add(  tmp[0] Shl 2 | (tmp[1] & $30) Shr 4 )
			buf.Add( (tmp[1] & $0f) Shl 4 | (tmp[2] & $3c) Shr 2)
			buf.Add( (tmp[2] & $03) Shl 6 | tmp[3] )
			j=0
		End
	Wend
	
	If j
		If j=1 Print "Base64 decode error"
		If j>1 buf.Add( tmp[0] Shl 2 | (tmp[1] & $30) Shr 4)
		If j>2 buf.Add( (tmp[1] & $0f) Shl 4 | (tmp[2] & $3c) Shr 2)
	End
	
	Local data:=New DataBuffer( buf.Length )
	
	stdlib.plugins.libc.memcpy( data.Data,buf.Data.Data,buf.Length)
	
	Return data
End

Const CHAR_EQUALS:=61

Global encode:=SetNormalCharBase()

Global normalCharBaseDirty:Bool=False

#rem monkeydoc hidden 
#end
Function SetNormalCharBase:Int[]()
	Return New Int[](
	65, 66, 67, 68, 69, 70, 71, 72,
	73, 74, 75, 76, 77, 78, 79, 80,
	81, 82, 83, 84, 85, 86, 87, 88,
	89, 90, 97, 98, 99, 100,101,102,
	103,104,105,106,107,108,109,110,
	111,112,113,114,115,116,117,118,
	119,120,121,122,48, 49, 50, 51,
	52, 53, 54, 55, 56, 57, 43, 47	)
End 

#rem monkeydoc hidden 
Setup for mode-specific chars and options
#end
Function Base64Setup( 	mode:EncodeBase64_Modes_ Ptr, 
						pad:Bool Ptr, 
						lnlength:UInt Ptr, 
						separator:Bool Ptr, 
						charDelim:Int Ptr, 
						delimiter:String Ptr, 
						nonEncodingChar:Bool Ptr,
						delimLen:Int Ptr )

	If normalCharBaseDirty
		encode=SetNormalCharBase()
		normalCharBaseDirty=False
	Else
		encode[62]=43
		encode[63]=47
	End 
	
	If mode[0]=EncodeBase64_Modes_.RFC9580 '<---
		'Checksum
		separator[0]=True
		Local arr:=StringToCharArray(delimiter[0])
		If arr[0]=0
			charDelim[0]=0
		Else
			delimLen[0]=arr.Length
			For Local i:=0 Until arr.Length
				charDelim[i] = arr[i]
			End
		End
		lnlength[0]=lnlength[0]=Null ? lnlength[0]=76 Else ( lnlength[0]>76 ? lnlength[0]=76 Else lnlength[0] )
		pad[0]=True
	Elseif mode[0]=EncodeBase64_Modes_.RFC1421 ' <----
		
		separator[0]=True
		Local arr:=StringToCharArray(delimiter[0])
		If arr[0]=0
			charDelim[0]=0
		Else
			delimLen[0]=arr.Length
			For Local i:=0 Until arr.Length
				charDelim[i] = arr[i]
			End
		End 
		lnlength[0]=lnlength[0]=Null ? lnlength[0]=64 Else ( lnlength[0]>64 ? lnlength[0]=64 Else lnlength[0] )
		'Checksum
		pad[0]=True
	Elseif mode[0]=EncodeBase64_Modes_.RFC2045 '<-----
		
		separator[0]=True
		Local arr:=StringToCharArray(delimiter[0])
		If arr[0]=0
			charDelim[0]=0
		Else
			delimLen[0]=arr.Length
			For Local i:=0 Until arr.Length
				charDelim[i] = arr[i]
			End
		End
		lnlength[0]=lnlength[0]=Null ? lnlength[0]=76 Else ( lnlength[0]>76 ? lnlength[0]=76 Else lnlength[0] )
		pad[0]=False
	Elseif mode[0]=EncodeBase64_Modes_.RFC2152
		
		pad[0]=False
		nonEncodingChar[0]=True
	Elseif mode[0]=EncodeBase64_Modes_.RFC3501
		encode[62]=43
		encode[63]=44
		pad[0]=False
	Elseif mode[0]=EncodeBase64_Modes_.RFC4648_4
		pad[0]=False
	Elseif mode[0]=EncodeBase64_Modes_.SRP
		
		'SRP: 0-9, A-Z, a-z, ., /
		For Local i:=0 Until 10         ' 0-9
			encode[i]=48+i 
		End
		For Local i:=10 Until 36   		' A-Z
			encode[i]=65+(i-10) 
		End
		For Local i:=36 Until 62	   	' a-z
			encode[i]=97+(i-36) 
		End
		encode[62]=46					' .
		encode[63]=47					' /
		separator[0]=False
		pad[0]=False					' RFC for SRP, typically no padding
		normalCharBaseDirty=True
	Elseif mode[0]=EncodeBase64_Modes_.URLsafe Or mode[0]=EncodeBase64_Modes_.RFC4648_5
		
		encode[62]=45
		encode[63]=95
		'pad=optional
	Else 'mode=EncodeBase64_Modes_.Standard
		
		pad[0]=True
	End
End

#Rem monkeydoc hidden 
Temporary fake checksum injection and comparison routines added for RFC1421 and RFC9580.
#End
Function FakeChecksumData( buf:Stack<UByte> Ptr, mode:EncodeBase64_Modes_ Ptr )
	Local checksumBytes:Int
	Select mode[0]
		Case EncodeBase64_Modes_.RFC1421
			checksumBytes = 3
		Case EncodeBase64_Modes_.RFC9580
			checksumBytes = 4
		Default
			Return
	End
	For Local i:=0 Until checksumBytes
		buf[0].Add( 0 ) ' Append fake checksum (all zeros)
	End
End

'Injects line breaks and spaces at random positions to test decoder robustness
Function InjectNoise:String(str:String)
	Local buf:=New Stack<Int>
	For Local i:=0 Until str.Length
		buf.Add( str[i] )
		If (i Mod 17)=0
			buf.Add( 10 ) 'LF
		Elseif (i Mod 29)=0
			buf.Add( 32 ) 'Space
		End
	End
	' Convert to string (assuming ASCII/UTF-8, or use UByte for byte buffer)
	Return String.FromCString( buf.Data.Data, buf.Length )
End

Function Main()
	
	Local aa:=StringToCharArray("")
	For Local a:=0 Until aa.Length
		Print aa[a]
	End 

	'Test settings
	Local numTests:=1000
	Local minLen:=1
	Local maxLen:=256

	Local modes:=New EncodeBase64_Modes_[](
		EncodeBase64_Modes_.Standard,
		EncodeBase64_Modes_.URLsafe,
		EncodeBase64_Modes_.SRP,
		EncodeBase64_Modes_.RFC1421,
		EncodeBase64_Modes_.RFC2045,
		EncodeBase64_Modes_.RFC2152,
		EncodeBase64_Modes_.RFC3501,
		EncodeBase64_Modes_.RFC4648_4,
		EncodeBase64_Modes_.RFC4648_5,
		EncodeBase64_Modes_.RFC9580	)

	For Local t:=0 Until numTests
		'Random buffer length per test
		Local length:Int=(Rnd(maxLen-minLen+1) + minLen - 1)
		Local data:=New DataBuffer( length )
		For Local i:=0 Until length
			data.PokeByte( i,Rnd(256) )
		End

		For Local m:=0 Until modes.Length
			Local mode:=modes[m]

			'Test with/without explicit padding where possible
			Local pads:=New Bool[](1)
			Select mode
				Case EncodeBase64_Modes_.URLsafe, EncodeBase64_Modes_.RFC4648_5
					pads=New Bool[](2)
					pads[0]=True
					pads[1]=False
				Default
					pads[0]=True
			End

			Print EncodeBase64_ModeToString(mode)

			For Local p:=0 Until pads.Length
				Local pad:=pads[p]

				'Test with/without line length (where supported)
				Local testLn:Bool=(mode=EncodeBase64_Modes_.RFC2045 Or mode=EncodeBase64_Modes_.RFC1421 Or mode=EncodeBase64_Modes_.RFC9580)
				Local lnlength:=testLn ? 76 Else Null

				Local encoded:=EncodeBase64_( data, mode, pad, lnlength )
				Local decoded:=DecodeBase64_( encoded, mode, pad, lnlength )

'				If data.Length<>decoded.Length
'					Print "Fail: mode="+EncodeBase64_ModeToString(mode)+", pad="+pad+", len="+data.Length+" -> "+decoded.Length
'					Return
'				End

'				If stdlib.plugins.libc.memcmp( data.Data, decoded.Data, data.Length )
'					Print "Fail: mode="+EncodeBase64_ModeToString(mode)+", pad="+pad+", data mismatch"
'					Return
'				End

				' Test decode robustness: add random line breaks/spaces (RFC2045, RFC1421, RFC9580, RFC2152)
				'If mode=EncodeBase64_Modes_.RFC2045 Or mode=EncodeBase64_Modes_.RFC1421 Or mode=EncodeBase64_Modes_.RFC9580 Or mode=EncodeBase64_Modes_.
				If mode=EncodeBase64_Modes_.RFC2045
					Local noisy:=InjectNoise(encoded)
					Local decoded2:=DecodeBase64_( noisy, mode, pad, lnlength )
'					If data.Length<>decoded2.Length
'						Print "Fail: mode="+EncodeBase64_ModeToString(mode)+" (noisy), pad="+pad+", len mismatch"
'						Return
'					End
					If stdlib.plugins.libc.memcmp( data.Data, decoded2.Data, data.Length )
						Print "Fail: mode="+EncodeBase64_ModeToString(mode)+" (noisy), pad="+pad+", data mismatch"
						Print "data: "+data.Length
						Print "encoded: "+encoded.Length
						Print "noisy: "+noisy.Length
						Print "decoded noisy: "+decoded2.Length
						Return
					End
				End
				Print p+" -> okok"
			End
			Print m+" -> ok"
		End
	End

	Print "All tests passed."
End
