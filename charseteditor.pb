EnableExplicit

#title = "Charset editor for Pico8"

Global.s fontname
Global.l size=10,style

XIncludeFile("p8string.pbi")

Structure sP8sci
  str.s
  name.s
EndStructure
Global Dim p8sci.sP8sci(255)

Procedure CreateP8sci()
  Protected.l i
  Restore p8sci
  
  For i=0 To 255
    Read.s p8sci(i)\str
    Read.s p8sci(i)\name 
  Next
  
;   Protected.s str
;   For i=64*2 To 64*2+63
;     str+p8sci(i)\str
;   Next
;  SetClipboardText(str)
  
  ProcedureReturn
  DataSection
    p8sci: 
    Data.u $005C, $0030, $0, ~"Terminate printing"                   ;0 $0
    Data.u $005C, $002A, $0, ~"Repeat next character"                ;1 $1
    Data.u $005C, $0023, $0, ~"Draw solid background"                ;2 $2
    Data.u $005C, $002D, $0, ~"Move cursor horizontally"             ;3 $3
    Data.u $005C, $007C, $0, ~"Move cursor vertically"               ;4 $4
    Data.u $005C, $002B, $0, ~"Move cursor"                          ;5 $5
    Data.u $005C, $005E, $0, ~"Special command"                      ;6 $6
    Data.u $005C, $0061, $0, ~"Audio command"                        ;7 $7
    Data.u $005C, $0062, $0, ~"Backspace"                            ;8 $8
    Data.u $005C, $0074, $0, ~"Tab"                                  ;9 $9
    Data.u $005C, $006E, $0, ~"Newline"                              ;10 $A
    Data.u $005C, $0076, $0, ~"Decorate previous character"          ;11 $B
    Data.u $005C, $0066, $0, ~"Set foreground color"                 ;12 $C
    Data.u $005C, $0072, $0, ~"Carriage return"                      ;13 $D
    Data.u $005C, $0031, $0034, $0, ~"Switch font defined at 0x5600" ;14 $E
    Data.u $005C, $0031, $0035, $0, ~"Switch font to default"        ;15 $F
    Data.u $25AE, $0, ~"Vertical rectangle"                          ;16 $10
    Data.u $25A0, $0, ~"Filled square"                               ;17 $11
    Data.u $25A1, $0, ~"Hollow square"                               ;18 $12
    Data.u $2059, $0, ~"Five dot"                                    ;19 $13
    Data.u $2058, $0, ~"Four dot"                                    ;20 $14
    Data.u $2016, $0, ~"Pause"                                       ;21 $15
    Data.u $25C0, $0, ~"Back"                                        ;22 $16
    Data.u $25B6, $0, ~"Forward"                                     ;23 $17
    Data.u $300C, $0, ~"Japanese starting quote"                     ;24 $18
    Data.u $300D, $0, ~"Japanese ending quote"                       ;25 $19
    Data.u $00A5, $0, ~"Yen sign"                                    ;26 $1A
    Data.u $2022, $0, ~"Interpunct"                                  ;27 $1B
    Data.u $3001, $0, ~"Japanese comma"                              ;28 $1C
    Data.u $3002, $0, ~"Japanese full stop"                          ;29 $1D
    Data.u $309B, $0, ~"Japanese dakuten"                            ;30 $1E
    Data.u $309C, $0, ~"Japanese handakuten"                         ;31 $1F
    Data.u $0020, $0, ~" "                                           ;32 $20
    Data.u $0021, $0, ~"!"                                           ;33 $21
    Data.u $0022, $0, ~"\""                                          ;34 $22
    Data.u $0023, $0, ~"#"                                           ;35 $23
    Data.u $0024, $0, ~"$"                                           ;36 $24
    Data.u $0025, $0, ~"%"                                           ;37 $25
    Data.u $0026, $0, ~"&"                                           ;38 $26
    Data.u $0027, $0, ~"'"                                           ;39 $27
    Data.u $0028, $0, ~"("                                           ;40 $28
    Data.u $0029, $0, ~")"                                           ;41 $29
    Data.u $002A, $0, ~"*"                                           ;42 $2A
    Data.u $002B, $0, ~"+"                                           ;43 $2B
    Data.u $002C, $0, ~","                                           ;44 $2C
    Data.u $002D, $0, ~"-"                                           ;45 $2D
    Data.u $002E, $0, ~"."                                           ;46 $2E
    Data.u $002F, $0, ~"/"                                           ;47 $2F
    Data.u $0030, $0, ~"0"                                           ;48 $30
    Data.u $0031, $0, ~"1"                                           ;49 $31
    Data.u $0032, $0, ~"2"                                           ;50 $32
    Data.u $0033, $0, ~"3"                                           ;51 $33
    Data.u $0034, $0, ~"4"                                           ;52 $34
    Data.u $0035, $0, ~"5"                                           ;53 $35
    Data.u $0036, $0, ~"6"                                           ;54 $36
    Data.u $0037, $0, ~"7"                                           ;55 $37
    Data.u $0038, $0, ~"8"                                           ;56 $38
    Data.u $0039, $0, ~"9"                                           ;57 $39
    Data.u $003A, $0, ~":"                                           ;58 $3A
    Data.u $003B, $0, ~";"                                           ;59 $3B
    Data.u $003C, $0, ~"<"                                           ;60 $3C
    Data.u $003D, $0, ~"="                                           ;61 $3D
    Data.u $003E, $0, ~">"                                           ;62 $3E
    Data.u $003F, $0, ~"?"                                           ;63 $3F
    Data.u $0040, $0, ~"@"                                           ;64 $40
    Data.u $0061, $0, ~"A"                                           ;65 $41
    Data.u $0062, $0, ~"B"                                           ;66 $42
    Data.u $0063, $0, ~"C"                                           ;67 $43
    Data.u $0064, $0, ~"D"                                           ;68 $44
    Data.u $0065, $0, ~"E"                                           ;69 $45
    Data.u $0066, $0, ~"F"                                           ;70 $46
    Data.u $0067, $0, ~"G"                                           ;71 $47
    Data.u $0068, $0, ~"H"                                           ;72 $48
    Data.u $0069, $0, ~"I"                                           ;73 $49
    Data.u $006A, $0, ~"J"                                           ;74 $4A
    Data.u $006B, $0, ~"K"                                           ;75 $4B
    Data.u $006C, $0, ~"L"                                           ;76 $4C
    Data.u $006D, $0, ~"M"                                           ;77 $4D
    Data.u $006E, $0, ~"N"                                           ;78 $4E
    Data.u $006F, $0, ~"O"                                           ;79 $4F
    Data.u $0070, $0, ~"P"                                           ;80 $50
    Data.u $0071, $0, ~"Q"                                           ;81 $51
    Data.u $0072, $0, ~"R"                                           ;82 $52
    Data.u $0073, $0, ~"S"                                           ;83 $53
    Data.u $0074, $0, ~"T"                                           ;84 $54
    Data.u $0075, $0, ~"U"                                           ;85 $55
    Data.u $0076, $0, ~"V"                                           ;86 $56
    Data.u $0077, $0, ~"W"                                           ;87 $57
    Data.u $0078, $0, ~"X"                                           ;88 $58
    Data.u $0079, $0, ~"Y"                                           ;89 $59
    Data.u $007A, $0, ~"Z"                                           ;90 $5A
    Data.u $005B, $0, ~"["                                           ;91 $5B
    Data.u $005C, $005C, $0, ~"\\"                                   ;92 $5C
    Data.u $005D, $0, ~"]"                                           ;93 $5D
    Data.u $005E, $0, ~"^"                                           ;94 $5E
    Data.u $005F, $0, ~"_"                                           ;95 $5F
    Data.u $0060, $0, ~"`"                                           ;96 $60
    Data.u $0041, $0, ~"a"                                           ;97 $61
    Data.u $0042, $0, ~"b"                                           ;98 $62
    Data.u $0043, $0, ~"c"                                           ;99 $63
    Data.u $0044, $0, ~"d"                                           ;100 $64
    Data.u $0045, $0, ~"e"                                           ;101 $65
    Data.u $0046, $0, ~"f"                                           ;102 $66
    Data.u $0047, $0, ~"g"                                           ;103 $67
    Data.u $0048, $0, ~"h"                                           ;104 $68
    Data.u $0049, $0, ~"i"                                           ;105 $69
    Data.u $004A, $0, ~"j"                                           ;106 $6A
    Data.u $004B, $0, ~"k"                                           ;107 $6B
    Data.u $004C, $0, ~"l"                                           ;108 $6C
    Data.u $004D, $0, ~"m"                                           ;109 $6D
    Data.u $004E, $0, ~"n"                                           ;110 $6E
    Data.u $004F, $0, ~"o"                                           ;111 $6F
    Data.u $0050, $0, ~"p"                                           ;112 $70
    Data.u $0051, $0, ~"q"                                           ;113 $71
    Data.u $0052, $0, ~"r"                                           ;114 $72
    Data.u $0053, $0, ~"s"                                           ;115 $73
    Data.u $0054, $0, ~"t"                                           ;116 $74
    Data.u $0055, $0, ~"u"                                           ;117 $75
    Data.u $0056, $0, ~"v"                                           ;118 $76
    Data.u $0057, $0, ~"w"                                           ;119 $77
    Data.u $0058, $0, ~"x"                                           ;120 $78
    Data.u $0059, $0, ~"y"                                           ;121 $79
    Data.u $005A, $0, ~"z"                                           ;122 $7A
    Data.u $007B, $0, ~"{"                                           ;123 $7B
    Data.u $007C, $0, ~"|"                                           ;124 $7C
    Data.u $007D, $0, ~"}"                                           ;125 $7D
    Data.u $007E, $0, ~"~"                                           ;126 $7E
    Data.u $25CB, $0, ~"Hollow circle"                               ;127 $7F
    Data.u $2588, $0, ~"Rectangle"                                   ;128 $80
    Data.u $2592, $0, ~"Checkerboard"                                ;129 $81
    Data.u $D83D, $DC31, $0, ~"Jelpi"                                ;130 $82
    Data.u $2B07, $FE0F, $0, ~"Down key"                             ;131 $83
    Data.u $2591, $0, ~"Dot pattern"                                 ;132 $84
    Data.u $273D, $0, ~"Throwing star"                               ;133 $85
    Data.u $25CF, $0, ~"Ball"                                        ;134 $86
    Data.u $2665, $0, ~"Heart"                                       ;135 $87
    Data.u $2609, $0, ~"Eye"                                         ;136 $88
    Data.u $C6C3, $0, ~"Man"                                         ;137 $89
    Data.u $2302, $0, ~"House"                                       ;138 $8A
    Data.u $2B05, $FE0F, $0, ~"Left key"                             ;139 $8B
    Data.u $D83D, $DE10, $0, ~"Face"                                 ;140 $8C
    Data.u $266A, $0, ~"Musical note"                                ;141 $8D
    Data.u $D83C, $DD7E, $FE0F, $0, ~"O key"                         ;142 $8E
    Data.u $25C6, $0, ~"Diamond"                                     ;143 $8F
    Data.u $2026, $0, ~"Ellipsis"                                    ;144 $90
    Data.u $27A1, $FE0F, $0, ~"Right key"                            ;145 $91
    Data.u $2605, $0, ~"Five-pointed star"                           ;146 $92
    Data.u $29D7, $0, ~"Hourglass"                                   ;147 $93
    Data.u $2B06, $FE0F, $0, ~"Up key"                               ;148 $94
    Data.u $02C7, $0, ~"Birds"                                       ;149 $95
    Data.u $2227, $0, ~"Sawtooth"                                    ;150 $96
    Data.u $274E, $0, ~"X key"                                       ;151 $97
    Data.u $25A4, $0, ~"Horiz lines"                                 ;152 $98
    Data.u $25A5, $0, ~"Vert lines"                                  ;153 $99
    Data.u $3042, $0, ~"a"                                           ;154 $9A
    Data.u $3044, $0, ~"i"                                           ;155 $9B
    Data.u $3046, $0, ~"u"                                           ;156 $9C
    Data.u $3048, $0, ~"e"                                           ;157 $9D
    Data.u $304A, $0, ~"o"                                           ;158 $9E
    Data.u $304B, $0, ~"ka"                                          ;159 $9F
    Data.u $304D, $0, ~"ki"                                          ;160 $A0
    Data.u $304F, $0, ~"ku"                                          ;161 $A1
    Data.u $3051, $0, ~"ke"                                          ;162 $A2
    Data.u $3053, $0, ~"ko"                                          ;163 $A3
    Data.u $3055, $0, ~"sa"                                          ;164 $A4
    Data.u $3057, $0, ~"shi"                                         ;165 $A5
    Data.u $3059, $0, ~"su"                                          ;166 $A6
    Data.u $305B, $0, ~"se"                                          ;167 $A7
    Data.u $305D, $0, ~"so"                                          ;168 $A8
    Data.u $305F, $0, ~"ta"                                          ;169 $A9
    Data.u $3061, $0, ~"chi"                                         ;170 $AA
    Data.u $3064, $0, ~"tsu"                                         ;171 $AB
    Data.u $3066, $0, ~"te"                                          ;172 $AC
    Data.u $3068, $0, ~"to"                                          ;173 $AD
    Data.u $306A, $0, ~"na"                                          ;174 $AE
    Data.u $306B, $0, ~"ni"                                          ;175 $AF
    Data.u $306C, $0, ~"nu"                                          ;176 $B0
    Data.u $306D, $0, ~"ne"                                          ;177 $B1
    Data.u $306E, $0, ~"no"                                          ;178 $B2
    Data.u $306F, $0, ~"ha"                                          ;179 $B3
    Data.u $3072, $0, ~"hi"                                          ;180 $B4
    Data.u $3075, $0, ~"fu"                                          ;181 $B5
    Data.u $3078, $0, ~"he"                                          ;182 $B6
    Data.u $307B, $0, ~"ho"                                          ;183 $B7
    Data.u $307E, $0, ~"ma"                                          ;184 $B8
    Data.u $307F, $0, ~"mi"                                          ;185 $B9
    Data.u $3080, $0, ~"mu"                                          ;186 $BA
    Data.u $3081, $0, ~"me"                                          ;187 $BB
    Data.u $3082, $0, ~"mo"                                          ;188 $BC
    Data.u $3084, $0, ~"ya"                                          ;189 $BD
    Data.u $3086, $0, ~"yu"                                          ;190 $BE
    Data.u $3088, $0, ~"yo"                                          ;191 $BF
    Data.u $3089, $0, ~"ra"                                          ;192 $C0
    Data.u $308A, $0, ~"ri"                                          ;193 $C1
    Data.u $308B, $0, ~"ru"                                          ;194 $C2
    Data.u $308C, $0, ~"re"                                          ;195 $C3
    Data.u $308D, $0, ~"ro"                                          ;196 $C4
    Data.u $308F, $0, ~"wa"                                          ;197 $C5
    Data.u $3092, $0, ~"wo"                                          ;198 $C6
    Data.u $3093, $0, ~"n"                                           ;199 $C7
    Data.u $3063, $0, ~"Sokuon"                                      ;200 $C8
    Data.u $3083, $0, ~"Digraph: ya"                                 ;201 $C9
    Data.u $3085, $0, ~"Digraph: yu"                                 ;202 $CA
    Data.u $3087, $0, ~"Digraph: yo"                                 ;203 $CB
    Data.u $30A2, $0, ~"a"                                           ;204 $CC
    Data.u $30A4, $0, ~"i"                                           ;205 $CD
    Data.u $30A6, $0, ~"u"                                           ;206 $CE
    Data.u $30A8, $0, ~"e"                                           ;207 $CF
    Data.u $30AA, $0, ~"o"                                           ;208 $D0
    Data.u $30AB, $0, ~"ka"                                          ;209 $D1
    Data.u $30AD, $0, ~"ki"                                          ;210 $D2
    Data.u $30AF, $0, ~"ku"                                          ;211 $D3
    Data.u $30B1, $0, ~"ke"                                          ;212 $D4
    Data.u $30B3, $0, ~"ko"                                          ;213 $D5
    Data.u $30B5, $0, ~"sa"                                          ;214 $D6
    Data.u $30B7, $0, ~"shi"                                         ;215 $D7
    Data.u $30B9, $0, ~"su"                                          ;216 $D8
    Data.u $30BB, $0, ~"se"                                          ;217 $D9
    Data.u $30BD, $0, ~"so"                                          ;218 $DA
    Data.u $30BF, $0, ~"ta"                                          ;219 $DB
    Data.u $30C1, $0, ~"chi"                                         ;220 $DC
    Data.u $30C4, $0, ~"tsu"                                         ;221 $DD
    Data.u $30C6, $0, ~"te"                                          ;222 $DE
    Data.u $30C8, $0, ~"to"                                          ;223 $DF
    Data.u $30CA, $0, ~"na"                                          ;224 $E0
    Data.u $30CB, $0, ~"ni"                                          ;225 $E1
    Data.u $30CC, $0, ~"nu"                                          ;226 $E2
    Data.u $30CD, $0, ~"ne"                                          ;227 $E3
    Data.u $30CE, $0, ~"no"                                          ;228 $E4
    Data.u $30CF, $0, ~"ha"                                          ;229 $E5
    Data.u $30D2, $0, ~"hi"                                          ;230 $E6
    Data.u $30D5, $0, ~"fu"                                          ;231 $E7
    Data.u $30D8, $0, ~"he"                                          ;232 $E8
    Data.u $30DB, $0, ~"ho"                                          ;233 $E9
    Data.u $30DE, $0, ~"ma"                                          ;234 $EA
    Data.u $30DF, $0, ~"mi"                                          ;235 $EB
    Data.u $30E0, $0, ~"mu"                                          ;236 $EC
    Data.u $30E1, $0, ~"me"                                          ;237 $ED
    Data.u $30E2, $0, ~"mo"                                          ;238 $EE
    Data.u $30E4, $0, ~"ya"                                          ;239 $EF
    Data.u $30E6, $0, ~"yu"                                          ;240 $F0
    Data.u $30E8, $0, ~"yo"                                          ;241 $F1
    Data.u $30E9, $0, ~"ra"                                          ;242 $F2
    Data.u $30EA, $0, ~"ri"                                          ;243 $F3
    Data.u $30EB, $0, ~"ru"                                          ;244 $F4
    Data.u $30EC, $0, ~"re"                                          ;245 $F5
    Data.u $30ED, $0, ~"ro"                                          ;246 $F6
    Data.u $30EF, $0, ~"wa"                                          ;247 $F7
    Data.u $30F2, $0, ~"wo"                                          ;248 $F8
    Data.u $30F3, $0, ~"n"                                           ;249 $F9
    Data.u $30C3, $0, ~"Sokuon"                                      ;250 $FA
    Data.u $30E3, $0, ~"Digraph: ya"                                 ;251 $FB
    Data.u $30E5, $0, ~"Digraph: yu"                                 ;252 $FC
    Data.u $30E7, $0, ~"Digraph: yo"                                 ;253 $FD
    Data.u $25DC, $0, ~"Left arc"                                    ;254 $FE
    Data.u $25DD, $0, ~"Right arc"                                   ;255 $FF
  EndDataSection
EndProcedure

Global.s CurrentFile = GetCurrentDirectory() + "font.lua"

Structure sChar
  b.a[8]
EndStructure
Structure sCharSet
  StructureUnion
    c.sChar[256]
    mem.a[256*8]
  EndStructureUnion
EndStructure

Global CharSet.sCharSet
Global DefCharset.sCharSet

Procedure CreateDefault()
  Protected str.s="00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"+
                  "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"+
                  "0e0e0e0e0e000000000e0e0e00000000000e0a0e00000000000a040a00000000000a000a00000000000a0a0a0000000002060e0602000000080c0e0c08000000"+
                  "0e08080800000000000202020e0000000a0e040e04000000000004000000000000000008040000000000000c0c0000000a0a000000000000040a040000000000"+
                  "000000000000000004040400040000000a0a0000000000000a0e0a0e0a0000000e0c060e040000000a0204080a0000000c0c060a0e0000000408000000000000"+
                  "040808080400000004020202040000000a040e040a00000000040e0400000000000000040800000000000e000000000000000000040000000204040408000000"+
                  "0e0a0a0a0e0000000c0404040e0000000e020e080e0000000e0206020e0000000a0a0e02020000000e080e020e00000008080e0a0e0000000e02020202000000"+
                  "0e0a0e0a0e0000000e0a0e0202000000000400040000000000040004080000000204080402000000000e000e0000000008040204080000000e02060004000000"+
                  "040a0a080600000000060a0e0a000000000c0c0a0e0000000006080806000000000c0a0a0c000000000e0c0806000000000e0c08080000000006080a0e000000"+
                  "000a0a0e0a000000000e04040e000000000e04040c000000000a0c0a0a0000000008080806000000000e0e0a0a000000000c0a0a0a00000000060a0a0c000000"+
                  "00060a0e0800000000040a0c06000000000c0a0c0a000000000608020c000000000e040404000000000a0a0a06000000000a0a0e04000000000a0a0e0e000000"+
                  "000a04040a000000000a0e020c000000000e02080e0000000c0808080c00000008040404020000000602020206000000040a000000000000000000000e000000"+
                  "04020000000000000e0a0e0a0a0000000e0a0c0a0e00000006080808060000000c0a0a0a0e0000000e080c080e0000000e080c08080000000608080a0e000000"+
                  "0a0a0e0a0a0000000e0404040e0000000e0404040c0000000a0a0c0a0a000000080808080e0000000e0e0a0a0a0000000c0a0a0a0a000000060a0a0a0c000000"+
                  "0e0a0e0808000000040a0a0c060000000e0a0c0a0a00000006080e020c0000000e040404040000000a0a0a0a060000000a0a0a0e040000000a0a0a0e0e000000"+
                  "0a0a040a0a0000000a0a0e020e0000000e0204080e00000006040c040600000004040404040000000c0406040c00000000020e080000000000040a0400000000"+
                  "efefefefef000000aa45aa45aa00000028efababc7000000c76c6ceec7000000882288228800000002c38387800000008347c7c783000000c6c7c78301000000"+
                  "83c6eec6830000008383c7838200000083c7ef45c5000000c76e6c6ec7000000efabef28ef000000c101010707000000c76c6d6cc70000000183c78301000000"+
                  "0000aa0000000000c7ec6cecc70000000183efc744000000c7830183c7000000c7ee6c6cc7000000000aa440000000000088452200000000c76dee6dc7000000"+
                  "ef00ef00ef000000aaaaaaaaaa0000000702874b460000008848484a04000000038740408300000001870142850000002702c72a4600000044af848405000000"+
                  "8701c38806000000800304038000000044e544448400000087400004c300000001c3800403000000040404448300000001c701030100000084cf840483000000"+
                  "c380e702c1000000040ec404c40000000f04078083000000c720204081000000c78001018000000001c10204c3000000c40e84e181000000e5240405e4000000"+
                  "09c72d6b66000000854e44ecc4000000c32529292600000084c584c5850000004c64444483000000030001452b0000000003844820000000ebe988cbab000000"+
                  "c7c30187470000000642e7468000000042270226c300000005c3a526c000000087028722c100000082c7420101000000c5a6a4c0010000000283028706000000"+
                  "0104c740830000004444464081000000c78142e4c000000002c6434662000000c7814224c0000000854e444c8400000007628341e10000000204064d89000000"+
                  "000007800100000000058f840200000000020f8a0b0000000002030607000000c740820204000000c00107010100000001c7444081000000c7010101c7000000"+
                  "80e781828400000002c74244c400000001c701c701000000c34244800100000002e3848001000000c7404040c700000042e74240800000000640468003000000"+
                  "c74080814600000002c74202c10000004442408003000000c7444bc0030000008301c7010200000045454080030000008300c701020000000202834202000000"+
                  "01c701010200000000830000c7000000c74041804300000001c7c0a701000000404040800700000080424222240000000487040483000000c740408003000000"+
                  "038448200000000001c7014545000000c740820180000000c300c7008700000001024224e7000000204180610600000087028702c300000002c7420202000000"+
                  "83808080c70000008780878087000000c700c740810000004242424080000000828282a2c40000000404448407000000c7444444c7000000c744408003000000"+
                  "c740c340810000000640408007000000008a80010600000000028782020000000000030187000000008381808300000001026c800100000001806c0201000000"
  
  Protected.l char,y,b
  Protected.l pos = 1
  For char=0 To 255
    For y = 0 To 7
      b = Val("$"+Mid(str,pos+1,1)+Mid(str,pos,1))
      pos + 2   
      ;Debug ""+char+" "+y+" "+b
      CharSet\c[char]\b[y] = Val("%"+ ReverseString(Right("00000000"+Bin(b),8)) )
    Next
  Next
  CharSet\mem[0]=4
  CharSet\mem[1]=8
  CharSet\mem[2]=6
  
  DefCharset = CharSet
  
  
  
EndProcedure

Procedure rol(a,n=1)
  While n>0
    a = (a << 1) &$fe | ((a>>7)&1)
    n-1
  Wend
  ProcedureReturn a
EndProcedure

Procedure ror(a,n=1)
  While n>0
    a = (a>>1) &$7f | (a<<7 & $80)
    n-1
  Wend
  ProcedureReturn a
EndProcedure

Global win, g_charset, g_char, g_char, g_labelChar, g_toclipboard, g_save, g_fromClipboard, g_load, g_setDefault, g_importFont
Global Dim g_options(4)
Global.l CurrentChar = 'a'

Procedure DrawCharset()
  Protected.l x, y, char
  Protected.l dy,dx
  
  StartDrawing( CanvasOutput(g_charset) )
  For y=0 To 15
    For x=0 To 15
      char = y<<4 | x
      If char > 0
        For dy = 0 To 7
          For dx = 0 To 7
            If CharSet\c[char]\b[dy] & (1 << dx)
              If y<<4 | x = CurrentChar
                Box( (x*8 + dx)*4, (y*8 + dy)*4, 4, 4, #Red)
              Else
                Box( (x*8 + dx)*4, (y*8 + dy)*4, 4, 4, #White)
              EndIf
            Else
              Box( (x*8 + dx)*4, (y*8 + dy)*4, 4, 4, #Black)
            EndIf
          Next
        Next
      Else
        Box(0,0,8*4,8*4, RGB(60,60,60) )
      EndIf
      
      If y= 15
        Line(x*8*4,0,1,16*8*4, RGB(60,60,60) )
      EndIf
    Next
    Line(0,y*8*4,16*8*4,1,RGB(60,60,60))
  Next
  StopDrawing()
EndProcedure

Procedure DrawChar()
  Protected.l dx,dy
  
  StartDrawing( CanvasOutput(g_char) )
  For dy = 0 To 7
    For dx = 0 To 7
      If CharSet\c[CurrentChar]\b[dy] & (1 << dx)
        Box( dx * 64, dy * 64, 64, 64, #White)
      Else
        Box( dx * 64, dy * 64, 64, 64, #Black)
      EndIf
      
      If dy= 7
        Line(dx*64, 0, 1, 8*64, RGB(60,60,60) )
      EndIf
    Next
    Line(0, dy*64, 8*64,1,RGB(60,60,60))
  Next
  
  If CurrentChar >127
    Line(CharSet\mem[1]*64, 0, 1, 8*64, RGB(160,160,160) )
  Else
    Line(CharSet\mem[0]*64, 0, 1, 8*64, RGB(160,160,160) )
  EndIf
  Line(0, charset\mem[2]*64, 8*64,1,RGB(160,160,160))
  
  
  StopDrawing()
  
  
  SetGadgetText(g_labelChar,RSet(""+CurrentChar,3,"0") +" 0x"+ RSet(Hex(CurrentChar),2,"0") +" "+ p8sci(CurrentChar)\str + " - "+p8sci(CurrentChar)\name)
  
  DrawCharset()
  
EndProcedure

Procedure PlotChar(x.l,y.l, bool.l)
  If bool
    CharSet\c[CurrentChar]\b[y] | (1 << x)
  Else
    CharSet\c[CurrentChar]\b[y] & ~(1 << x)
  EndIf
  
  StartDrawing( CanvasOutput(g_char) )
  Box ( x*64+1, y*64+1, 63, 63, #White * bool)
  StopDrawing()
  
  Protected.l dx = CurrentChar & $F
  Protected.l dy = CurrentChar >> 4
  StartDrawing( CanvasOutput(g_charset) )
  Box( (dx*8 + x)*4, (dy*8 + y)*4, 4,4, #Red * bool)
  Line(dx*8*4,0,1,16*8*4, RGB(60,60,60) )
  Line(0,dy*8*4,16*8*4,1,RGB(60,60,60))
  StopDrawing()
EndProcedure

Procedure drawOptions()
  Protected.l i
  For i = 0 To 4
    SetGadgetState(g_options(i), CharSet\mem[i])
  Next
EndProcedure

Procedure ToClipboard()
  SetClipboardText( OutP8String(@charset\mem[0],$5600,SizeOf(sCharSet),256) )
EndProcedure

Procedure FromClipboard()
  Protected.s str
  
  If MessageRequester(#title, "Copy from Clipboard?", #PB_MessageRequester_YesNo) = #PB_MessageRequester_No
    ProcedureReturn
  EndIf
  
  str = GetClipboardText()
  str = ReplaceString(str, #CRLF$, #LF$)
  str = ReplaceString(str, #LFCR$, #LF$)
  str = ReplaceString(str, #CR$, #LF$)
  InP8String(str,@CharSet\mem[0],SizeOf(sCharSet))
  DrawChar()
  drawOptions()
  
EndProcedure

Procedure Save()
  Protected.s file
  Protected.l out
  file= SaveFileRequester(#title + " - SAVE", CurrentFile,"lua|*.lua|all|*.*",0)
  
  If file
    
    If SelectedFilePattern() = 0 And GetExtensionPart(file)=""
      file+".lua"
    EndIf
    
    out = CreateFile(#PB_Any, file)
    If out
      WriteString(out, OutP8String(@charset\mem[0],$5600,SizeOf(sCharSet),256) )
      CloseFile(out)
      CurrentFile = file
    Else
      MessageRequester(#title, "Can't create file:" + #LF + file,#PB_MessageRequester_Error)
    EndIf
  EndIf
EndProcedure

Procedure load()
  Protected.s file, str
  Protected.l in
  file = OpenFileRequester(#title + " - Load", CurrentFile,"lua|*.lua|all|*.*",0)
  If file
    in = ReadFile(#PB_Any, file)
    If in 
      While Not Eof(in) And Len(str) < 1024*8 ; max should be around 6 kb!
        str + ReadString(in) + #LF$
      Wend
      CloseFile(in)
      CurrentFile = file
      InP8String(str,@CharSet\mem[0],SizeOf(sCharSet))
      DrawChar()
      drawOptions()
    Else
      MessageRequester(#title, "Can't load file:" + #LF + file,#PB_MessageRequester_Error)      
    EndIf
  EndIf
EndProcedure  


win=OpenWindow(#PB_Any,0,0,5 + 16*8*4 + 5 + 8*64 + 5, 5 + 20 + 5 + 16*8*4 + 5 + 20 + 5, #title, #PB_Window_ScreenCentered | #PB_Window_SystemMenu)

g_charset   = CanvasGadget(#PB_Any, 5             , 5 + 20 +5, 16*8*4, 16*8*4)
g_char      = CanvasGadget(#PB_Any, 5 + 16*8*4 + 5, 5 + 20 +5, 8*64, 8*64)
g_labelChar = TextGadget  (#PB_Any, 5 + 16*8*4 + 5, 5        , 8*64, 20, "--")

Define.s str
Define.l x,i

x = 5
For i=0 To 4
  Select i
    Case 0: str = "Lo Width:"
    Case 1: str = "Hi Width:"
    Case 2: str = "Height:"
    Case 3: str = "Offset X:"
    Case 4: str = "Offset Y:"
  EndSelect
  TextGadget  (#PB_Any, x, 5+ 20 + 5 + 16*8*4 + 5+2, 50, 20, str, #PB_Text_Right): x+55
  g_options(i) = SpinGadget(#PB_Any, x, 5+ 20 + 5 + 16*8*4 + 5, 40, 20, 0, 16, #PB_Spin_Numeric  ): x+40
  SetGadgetData(g_options(i), i+1)
  x+5
Next

x = 5 + 16*8*4 + 5 
g_toclipboard   = ButtonGadget(#PB_Any, x, 5 + 20 + 5 + 16*8*4 + 6, 75,20,"Copy") : x + 80 
g_save          = ButtonGadget(#PB_Any, x, 5 + 20 + 5 + 16*8*4 + 6, 75,20,"Save") : x +80
g_fromClipboard = ButtonGadget(#PB_Any, x, 5 + 20 + 5 + 16*8*4 + 6, 75,20,"Paste") : x +80
g_load          = ButtonGadget(#PB_Any, x, 5 + 20 + 5 + 16*8*4 + 6, 75,20,"Load") : x +80
g_setDefault    = ButtonGadget(#PB_Any, x, 5 + 20 + 5 + 16*8*4 + 6, 75,20,"char to original") : x +80
g_importFont    = ButtonGadget(#PB_Any, x, 5 + 20 + 5 + 16*8*4 + 6, 75,20,"Import Font") : x +80

Enumeration
#men_left
#men_right
#men_up
#men_down
EndEnumeration

; Define in, pos = 0, len = SizeOf(sCharSet)/2
; in = ReadFile(#PB_Any,"chargen")
; FileSeek(in, len*2)
; ReadData( in, @CharSet\mem[64*8], 32*8)
; ReadData( in, @CharSet\mem[32*8], 32*8)
; FileSeek( in, 8,#PB_Relative)
; ReadData( in, @CharSet\mem[97*8], 26*8)
; FileSeek( in, 4*16*8)
; ReadData( in, @CharSet\mem[128*8+32*8], 4*16*8)
; CloseFile(in)
; For i=pos To pos+len-1
;    CharSet\mem[i] = Val("%" + ReverseString( RSet( Bin(charset\mem[i]),8,"0")))
;  Next
; For i=128*8+32*8 To 128*8+32*8 + 4*16*8 -1
;    CharSet\mem[i] = Val("%" + ReverseString( RSet( Bin(charset\mem[i]),8,"0")))
;  Next
; charset\mem[0]=8
; charset\mem[1]=8
; charset\mem[2]=8
; charset\mem[3]=0
; charset\mem[4]=0
; charset\mem[5]=0
; charset\mem[6]=0
; charset\mem[7]=0

CreateP8sci()

CreateDefault()

DrawChar()
drawOptions()

AddKeyboardShortcut(win,#PB_Shortcut_Left,#men_left)
AddKeyboardShortcut(win,#PB_Shortcut_Right,#men_right)
AddKeyboardShortcut(win,#PB_Shortcut_Up,#men_up)
AddKeyboardShortcut(win,#PB_Shortcut_Down,#men_down)

Define.l x,y, zoomButton, char
Repeat
  Select WaitWindowEvent()
    Case #PB_Event_CloseWindow
      Break
      
    Case #PB_Event_Menu
      Select EventMenu()
        Case #men_left
          For i=0 To 7
            CharSet\c[CurrentChar]\b[i] = ror(CharSet\c[CurrentChar]\b[i])
          Next
          DrawChar()
          
        Case #men_right
          For i=0 To 7
            CharSet\c[CurrentChar]\b[i] = rol(CharSet\c[CurrentChar]\b[i])
          Next
          DrawChar()
          
        Case #men_up
          x = CharSet\c[CurrentChar]\b[0]
          For i=0 To 6
            CharSet\c[CurrentChar]\b[i] = CharSet\c[CurrentChar]\b[i+1]
          Next
          CharSet\c[CurrentChar]\b[7] = x
          DrawChar()
          
        Case #men_down
          x = CharSet\c[CurrentChar]\b[7]
          For i=7 To 1 Step -1
            CharSet\c[CurrentChar]\b[i] = CharSet\c[CurrentChar]\b[i-1]
          Next
          CharSet\c[CurrentChar]\b[0] = x
          DrawChar()
        
      EndSelect
      
          
    Case #PB_Event_Gadget
      Select EventGadget() 
        Case g_importFont
          
          If FontRequester(fontname,size,style)
            Define font,img
            Define.l i,dx,dy,byte,c
            
            fontname=SelectedFontName()
            size=SelectedFontSize()
            style=SelectedFontStyle()
            font = LoadFont(#PB_Any,fontname,size,style)
            
            If font
              img = CreateImage(#PB_Any,8,8)
              StartDrawing(ImageOutput(img))
              DrawingFont(FontID(font))
              For i=1 To 255
                Box(0,0,8,8,#Black)
                DrawText(0,0,p8sci(i)\str+" ",#White,#Black)
                For dy = 0 To 7
                  byte=0
                  For dx = 0 To 7
                    c=Point(dx,dy)
                    byte | Bool(Red(c)>64)<<dx                    
                  Next
                  CharSet\c[i]\b[dy]= byte
                Next
              Next
              StopDrawing()
              DrawChar()
              drawOptions()
              FreeFont(font)
              FreeImage(img)

            EndIf
          EndIf
            
        Case g_toclipboard
          ToClipboard()
          
        Case g_save
          save()
          
        Case g_fromClipboard
          FromClipboard()
          
        Case g_load
          load()
          
        Case g_charset
          x = GetGadgetAttribute(g_charset, #PB_Canvas_MouseX) / (4*8)
          y = GetGadgetAttribute(g_charset, #PB_Canvas_MouseY) / (4*8)
          If x>=0 And x<16 And y>=0 And y<16 And Not( x=0 And y=0)              
            Select EventType() 
                
              Case #PB_EventType_LeftClick
                CurrentChar = y << 4 | x
                DrawChar()
                
              Case #PB_EventType_RightClick
                char = y << 4 | x
                For i=0 To 7
                  CharSet\c[char]\b[i] = CharSet\c[CurrentChar]\b[i]
                Next
                CurrentChar = char
                DrawChar()
                
            EndSelect            
          EndIf
          
        Case g_setDefault
          For i=0 To 7
            CharSet\c[CurrentChar]\b[i] = DefCharset\c[CurrentChar]\b[i]
          Next
          DrawChar()
          
        Case g_char
          Select EventType()
            Case #PB_EventType_MouseLeave, #PB_EventType_LeftButtonUp, #PB_EventType_RightButtonUp, #PB_EventType_MouseEnter
              zoomButton = -1
            Case #PB_EventType_LeftButtonDown
              zoomButton = 1
            Case #PB_EventType_RightButtonDown
              zoomButton = 0
          EndSelect
          
          Select EventType()
            Case #PB_EventType_LeftButtonDown, #PB_EventType_RightButtonDown, #PB_EventType_MouseMove
              If zoomButton >= 0
                x = GetGadgetAttribute(g_char, #PB_Canvas_MouseX) / 64
                y = GetGadgetAttribute(g_char, #PB_Canvas_MouseY) / 64
                If x>=0 And x<8 And y>=0 And y<8
                  PlotChar(x,y,zoomButton)
                EndIf
              EndIf
          EndSelect
          
        Default
          i= GetGadgetData( EventGadget() )
          If i>0 And i<=5
            charset\mem[i-1] = GetGadgetState( EventGadget() )
            DrawChar()
          EndIf
          
      EndSelect
      
      
  EndSelect
  
  
  
  
  
ForEver 








; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 155
; FirstLine = 117
; Folding = ---
; EnableXP
; UseIcon = charseteditor_pixelated.ico
; Executable = charseteditor.exe