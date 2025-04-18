# PC-98 Internet Capabilities
*Implementation by iDkP from GaragePixel - 2025-04-13 - Aida v4*

## Purpose
This document provides technical context on the NEC PC-9800 series computers' internet capabilities, limitations, and considerations for historical accuracy in retro-styled visual novel implementations.

## Functionality
- Limited dial-up connectivity via external serial modems
- Text-based network access through terminal emulators
- Japanese-language BBS (Bulletin Board System) connectivity
- Basic email capabilities through specialized clients
- Limited web browsing on later models only
- Protocol support primarily for SLIP/PPP, FTP, and Telnet

## Implementation Notes

### Hardware Connectivity
The PC-98 series did not include built-in internet connectivity. Internet access required:

1. External modem (typically 1200-9600 baud, later models up to 56kbps)
2. Connection via RS-232C serial port
3. For later models, expansion cards providing Ethernet capabilities existed but were rare

### Software Support
Internet software on PC-98 was extremely limited:

```wonkey
' Example: PC-98 network capability detection
Function DetectPC98NetworkCapabilities:NetworkCapabilities()
	Local capabilities:NetworkCapabilities = New NetworkCapabilities
	
	' Check for COM port availability
	capabilities.serialPortAvailable = CheckCOMPortStatus()
	
	' Check available memory (minimum 640KB needed for most network software)
	capabilities.sufficientMemory = (GetAvailableConventionalMemory() > 640 * 1024)
	
	' Most PC-98 models had minimal or no TCP/IP capability
	capabilities.tcpIPAvailable = False
	
	' Check for presence of network drivers
	If FileExists("NETDRV.SYS") Or FileExists("PKTDRV.SYS")
		capabilities.packetDriverAvailable = True
	Endif
	
	Return capabilities
End
```

### Network Protocol Support
PC-98 internet connectivity was primarily limited to:

1. Terminal emulation for direct BBS connections
2. Basic SLIP/PPP protocol support (later models)
3. Primitive TCP/IP stack implementations with significant limitations

Most online activities consisted of:
- Text-based BBS connections
- Basic file transfers
- Simple email via specialized Japanese clients
- Very limited web browsing (late-era PC-98 only)

## Technical Advantages

### Japanese Character Support
Unlike many Western computers of the era, PC-98 had native Japanese language support that enabled Japanese-language BBS systems:

```wonkey
' PC-98 Japanese character encoding for network communications
Class PC98CharacterEncoder
	Method EncodeShiftJIS:Int[](text:String)
		' PC-98 used Shift-JIS encoding for Japanese text
		Local encoded:Int[] = New Int[text.Length * 2]  ' Potential 2 bytes per character
		Local outIndex:Int = 0
		
		For Local i:Int = 0 Until text.Length
			Local c:Int = text[i]
			
			' Check if character is Japanese
			If c > 127
				' Apply Shift-JIS encoding rules
				' First byte in range 0x81-0x9F or 0xE0-0xEF
				' Second byte in range 0x40-0x7E or 0x80-0xFC
				Local sjis:Int[] = ConvertToShiftJIS(c)
				encoded[outIndex] = sjis[0]
				outIndex += 1
				encoded[outIndex] = sjis[1]
				outIndex += 1
			Else
				' ASCII character
				encoded[outIndex] = c
				outIndex += 1
			Endif
		Next
		
		' Trim array to actual size
		Return encoded.Slice(0, outIndex)
	End
End
```

### BBS-Centric Communication
PC-98's online experience focused on Japanese BBS systems rather than the web:

```wonkey
' PC-98 BBS connection handler
Class PC98BBSConnector
	Field comPort:Int
	Field baudRate:Int
	Field terminal:TerminalEmulator
	
	Method New(port:Int, baud:Int)
		Self.comPort = port       ' Typically COM1 (1) or COM2 (2)
		Self.baudRate = baud      ' Usually 2400, 9600, or 14400 for PC-98
		Self.terminal = New TerminalEmulator()
	End
	
	Method Connect:Bool(phoneNumber:String, username:String, password:String)
		' Set modem to command mode
		WriteSerialCommand("ATZ")
		
		' Dial the BBS phone number
		WriteSerialCommand("ATDT" + phoneNumber)
		
		' Wait for CONNECT response
		If WaitForResponse("CONNECT", 30)
			' Handle login sequence
			WaitForPrompt("login:")
			WriteSerialText(username)
			WaitForPrompt("password:")
			WriteSerialText(password)
			Return True
		Endif
		
		Return False
	End
End
```

### Time Period Considerations
By the time mainstream internet usage became common in Japan (mid-to-late 1990s), the PC-98 was already being phased out:

```wonkey
' PC-98 era internet timeline
Function CreateInternetTimeline:TimelineEvent[]()
	Local timeline:TimelineEvent[] = New TimelineEvent[6]
	
	timeline[0] = New TimelineEvent("1984", "PC-98 series launched, no network capabilities")
	timeline[1] = New TimelineEvent("1986-1990", "BBS systems become popular in Japan, accessible via PC-98 with modems")
	timeline[2] = New TimelineEvent("1993", "Limited internet connectivity possible through dial-up and specialized software")
	timeline[3] = New TimelineEvent("1995", "Windows 95 released, begins to supplant PC-98 for internet usage")
	timeline[4] = New TimelineEvent("1996-1997", "Web browsers become available but run poorly on aging PC-98 architecture")
	timeline[5] = New TimelineEvent("1998-2000", "PC-98 platform phased out as Windows-based PCs become dominant for internet")
	
	Return timeline
End
```

### Visual Novel Implementation Considerations
For historical accuracy in a PC-98 style visual novel:

1. Any "online" experiences should be BBS-based rather than web-based
2. Interface should reflect terminal-style connections rather than graphical browsers
3. Connection speeds should be extremely slow (1200-9600 baud for most authentic experience)
4. Network features should be text-dominant with minimal graphics

A historically accurate PC-98 visual novel set in the early-to-mid 1990s would likely showcase:
- Characters connecting to text-based message boards
- ASCII art instead of images
- Long connection times and slow data transfer
- Distinctive modem connection sounds
- Japanese-specific BBS culture and etiquette

For a PC-98 style visual novel, internet capabilities would be extremely limited and primitive compared to modern expectations, focusing on text-based communication rather than multimedia web experiences.

# PC-98 Network Capabilities Assessment
*Implementation by iDkP from GaragePixel - 2025-04-13 - Aida v1.2*

## Purpose
This document assesses the technical feasibility of implementing network capabilities on NEC PC-9800 series computers to support dream image reference transmission via websockets, examining historical constraints and potential workarounds for implementing modern networking protocols on vintage hardware.

## Functionality
- Historical network capabilities of PC-98 systems (1982-2000)
- Serial modem connectivity specifications and limitations
- Available network protocols during the PC-98 era
- Maximum achievable bandwidth and latency characteristics
- Feasibility of retrofitting modern protocols to vintage hardware
- Minimum requirements for transmitting dream image references
- Technical workarounds for implementing websocket-like functionality
- Memory and CPU constraints affecting network operations

## Implementation Notes

### Historical Context
The PC-98 series existed from 1982 to 2000, spanning multiple networking eras. Network capabilities evolved dramatically during this timeframe:

```monkey2
Function GetPC98NetworkingEraCapabilities:NetworkCapabilities(year:Int)
	Local capabilities:NetworkCapabilities = New NetworkCapabilities
	
	If year < 1985
		' Early PC-98 era: Minimal networking
		capabilities.maxBaudRate = 1200
		capabilities.hasModem = False
		capabilities.hasTCPIP = False
		capabilities.internetCapable = False
	Elseif year < 1990
		' Mid PC-98 era: Basic BBS access
		capabilities.maxBaudRate = 9600
		capabilities.hasModem = True
		capabilities.hasTCPIP = False
		capabilities.internetCapable = False
	Elseif year < 1995
		' Late PC-98 era: Early internet
		capabilities.maxBaudRate = 28800
		capabilities.hasModem = True
		capabilities.hasTCPIP = True
		capabilities.internetCapable = True
		capabilities.maxKBps = 2.88  ' ~2.88 KB/sec theoretical max
	Else
		' Final PC-98 era: Declining platform, Windows dominance
		capabilities.maxBaudRate = 56000
		capabilities.hasModem = True
		capabilities.hasTCPIP = True
		capabilities.internetCapable = True
		capabilities.maxKBps = 5.6   ' ~5.6 KB/sec theoretical max
	Endif
	
	Return capabilities
End
```

### Hardware Constraints
PC-98 network connectivity was severely constrained by hardware limitations:

1. **Serial Communication**: Limited to RS-232C ports at 9600-19200 baud (common), with later models supporting up to 56kbps via external modems
2. **Memory Limitations**: Most PC-98 models had 640KB-2MB RAM, severely limiting buffer sizes for network operations
3. **CPU Performance**: 8MHz-16MHz processors struggled with complex protocol processing
4. **Expansion Options**: Some later PC-98 models supported expansion cards for Ethernet (10BASE-T)
5. **No Built-in Modems**: Required external hardware for any connectivity

### Protocol Support
PC-98 systems had limited protocol support that evolved over time:

```monkey2
Function GetPC98ProtocolSupport:StringMap<Bool>(year:Int)
	Local protocols:StringMap<Bool> = New StringMap<Bool>
	
	' Always available
	protocols["XModem"] = True
	protocols["YModem"] = True
	protocols["ASCII"] = True
	
	' Mid-era protocols
	If year >= 1988
		protocols["ZModem"] = True
		protocols["SLIP"] = True
	Endif
	
	' Later protocols
	If year >= 1993
		protocols["PPP"] = True
		protocols["TCP/IP"] = True
		protocols["FTP"] = True
		protocols["Telnet"] = True
		protocols["NNTP"] = True
	Endif
	
	' Very late protocols (limited support)
	If year >= 1996
		protocols["HTTP/1.0"] = True
		protocols["POP3"] = True
		protocols["SMTP"] = True
	Endif
	
	' Modern protocols (not supported)
	protocols["HTTP/1.1"] = False
	protocols["WebSockets"] = False
	protocols["SSL/TLS"] = False
	protocols["SSH"] = False
	
	Return protocols
End
```

### Feasibility Analysis for Dream Reference Transmission

```monkey2
Function AnalyzeWebSocketFeasibility:FeasibilityReport()
	Local report:FeasibilityReport = New FeasibilityReport
	
	' Calculate minimum data size for dream reference
	Local minReferenceSize:Int = CalculateMinDreamReferenceSize()
	report.minimumDataSize = minReferenceSize
	
	' Analyze transmission time at different connection speeds
	report.transmissionTimeAt2400bps = (minReferenceSize * 8) / 2400.0
	report.transmissionTimeAt9600bps = (minReferenceSize * 8) / 9600.0
	report.transmissionTimeAt28kbps = (minReferenceSize * 8) / 28800.0
	report.transmissionTimeAt56kbps = (minReferenceSize * 8) / 56000.0
	
	' Determine protocol compatibility
	report.websocketDirectlySupported = False
	report.websocketEmulationPossible = True
	report.minimumYearFeasible = 1995  ' Requires TCP/IP stack
	
	' Memory requirements
	report.minimumRAMRequired = 1024  ' KB
	
	Return report
End

Function CalculateMinDreamReferenceSize:Int()
	' Optimized binary format for dream reference
	Local size:Int = 0
	
	' Dreamer ID: 1 byte (assuming small set of dreamers)
	size += 1
	
	' Dream symbols: 3 bytes (1 byte per symbol ID, assuming 3 symbols)
	size += 3
	
	' Coherence score: 1 byte (quantized to 0-255)
	size += 1
	
	' Dream ID: 4 bytes (simplified ID)
	size += 4
	
	' Protocol overhead: ~10 bytes
	size += 10
	
	Return size
End
```

### WebSocket Feasibility
True WebSocket protocol is completely infeasible on PC-98 hardware due to:
1. WebSocket protocol didn't exist until 2011 (PC-98 discontinued in 2000)
2. Requires TLS/SSL support rarely available on PC-98
3. Handshake process exceeds memory capacity of most PC-98 systems
4. TCP/IP stacks on PC-98 lacked extended header support

### Practical Alternatives
A simplified alternative approach would be feasible on late-model PC-98 systems:

```monkey2
Class SimplifiedNetworkProtocol
	Field serialPort:SerialDevice
	Field buffer:DataBuffer
	Field connected:Bool = False
	Field transmitQueue:List<DataPacket>
	
	Method New(portName:String, baudRate:Int)
		Self.serialPort = New SerialDevice(portName, baudRate)
		Self.buffer = New DataBuffer(1024)  ' 1KB buffer
		Self.transmitQueue = New List<DataPacket>
	End
	
	Method Connect:Bool(serverAddress:String)
		' Attempt connection via modem
		Self.serialPort.Write("ATDT" + serverAddress + "~r")
		
		Local result:String = Self.serialPort.ReadLine()
		Self.connected = (result.Contains("CONNECT"))
		
		Return Self.connected
	End
	
	Method SendDreamReference:Bool(reference:DreamReference)
		' Optimize dream reference for transmission
		Local packet:DataPacket = CompressDreamReference(reference)
		
		' If connected, send immediately
		If Self.connected
			Return TransmitPacket(packet)
		Else
			' Queue for later transmission
			Self.transmitQueue.AddLast(packet)
			Return False
		Endif
	End
	
	Method CompressDreamReference:DataPacket(reference:DreamReference)
		' Create minimal binary representation
		Local packet:DataPacket = New DataPacket(20)  ' Max size
		
		' Header: 0x01 (dream reference type)
		packet.WriteByte(0x01)
		
		' Dreamer ID: 1 byte code
		packet.WriteByte(GetDreamerCode(reference.dreamerId))
		
		' Symbol count: 1 byte
		packet.WriteByte(reference.symbolIds.Length)
		
		' Symbols: 1 byte each
		For Local i:Int = 0 Until Min(reference.symbolIds.Length, 15)
			packet.WriteByte(GetSymbolCode(reference.symbolIds[i]))
		Next
		
		' Coherence: 1 byte (0-255)
		packet.WriteByte(Int(reference.coherenceScore * 255))
		
		' Timestamp: 4 bytes (32-bit)
		packet.WriteInt(reference.timestamp)
		
		' Checksum: 1 byte
		packet.WriteByte(CalculateChecksum(packet))
		
		Return packet
	End
End
```

## Technical Advantages

### Minimal Data Format
The dream reference transmission system can be optimized for extremely low bandwidth:

1. **Binary Encoding**: Using a custom binary protocol instead of text-based formats (like JSON) reduces size by ~80%
2. **Symbol Codebook**: Pre-shared symbol tables allow 8-bit references to symbols instead of string IDs
3. **Quantized Metrics**: Converting floating-point values to 8-bit integers (0-255) saves significant bandwidth
4. **Differential Updates**: Sending only changes rather than complete dream data
5. **Batch Processing**: Accumulating multiple dream references for periodic transmission

This approach could reduce each dream reference to approximately 20 bytes, which even at 2400 baud would transmit in less than 0.1 seconds.

### Offline Operation
The limited connectivity of PC-98 systems necessitates a primarily offline approach:

```monkey2
Class PC98DreamNetworkManager
	Field localDreams:List<DreamReference>
	Field onlineMode:Bool = False
	Field connectionSchedule:ConnectionSchedule
	Field lastSyncTime:Int
	
	Method New()
		Self.localDreams = New List<DreamReference>
		Self.connectionSchedule = New ConnectionSchedule()
		Self.lastSyncTime = 0
	End
	
	Method AddLocalDream:Void(dream:DreamReference)
		Self.localDreams.AddLast(dream)
		
		' Save to disk immediately
		SaveDreamToLocalStorage(dream)
	End
	
	Method SyncWithServer:Bool()
		' Check if it's time to connect
		If Not ShouldConnectNow() Return False
		
		' Connect to service
		Local connection:NetworkConnection = EstablishConnection()
		If Not connection Return False
		
		' Upload pending dreams
		For Local dream:DreamReference = EachIn Self.localDreams
			If dream.timestamp > Self.lastSyncTime
				connection.SendDream(dream)
			Endif
		Next
		
		' Download rankings and other dreams
		DownloadUpdates(connection)
		
		' Update last sync time
		Self.lastSyncTime = Millisecs()
		
		' Disconnect to save costs
		connection.Close()
		
		Return True
	End
End
```

This approach acknowledges the dial-up nature of PC-98 connectivity, where being constantly connected was impractical and expensive.

### Cross-Era Compatibility
A properly designed system could span multiple PC-98 hardware generations:

```monkey2
Function GetNetworkCapabilityTier:Int(hardware:PC98Hardware)
	' Tier 0: No networking support
	' Tier 1: Basic serial only (XModem)
	' Tier 2: Modem support, basic protocols
	' Tier 3: TCP/IP capable, internet access
	
	If hardware.year < 1985 Return 0
	
	If hardware.hasRS232C Return 1
	
	If hardware.hasModem Return 2
	
	If hardware.memoryKB >= 1024 And hardware.hasTCPIP Return 3
	
	Return 1
End

Function GetOptimalProtocol:String(tier:Int)
	Select tier
		Case 0
			Return "None"
		Case 1
			Return "XModem"
		Case 2
			Return "ZModem"
		Case 3
			Return "TCP/IP"
	End
	
	Return "None"
End
```

By supporting tiered functionality, the dream sharing system could work across different PC-98 models with graceful feature degradation.

### Realistic Assessment
WebSockets specifically are completely infeasible on PC-98 hardware. However, a dream reference system using simplified protocols is technically possible on late-era PC-98 systems with these limitations:

1. **Connection Limitations**: Dial-up only, intermittent connectivity
2. **Speed Constraints**: 2.4-5.6 KBps maximum theoretical throughput
3. **Protocol Simplification**: Custom binary protocol instead of WebSockets
4. **Local Operation**: Primarily offline operation with periodic synchronization
5. **Hardware Requirements**: Late-model PC-98 (1995+) with at least 1MB RAM
6. **Software Complexity**: Custom networking stack required, not standard libraries

The dream reference system would need to be reimagined as a dial-up BBS-style service rather than a real-time WebSocket implementation, but could achieve similar functionality with appropriate design compromises.

### Conclusion
While true WebSocket functionality is impossible on PC-98 hardware, a simplified dream reference transmission system using period-appropriate networking technologies is technically feasible on late-model PC-98 systems. The system would require significant design compromises but could achieve the core goal of sharing symbolic dream references between users.

