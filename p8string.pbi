Global Dim _p8.s(255)

Procedure _Create_p8()
  Protected in
  Protected.l i
  Restore p8
  For i=16 To 255
    Read.s _p8(i)
  Next
  _p8(0)="set"
  DataSection
    p8:
    Data.u $25AE,0,$25A0,0,$25A1,0,$2059,0,$2058,0,$2016,0,$25C0,0,$25B6,0,$300C,0,$300D,0,$A5,0,$2022,0,$3001,0,$3002,0,$309B,0,$309C,0
    Data.u $20,0,$21,0,$22,0,$23,0,$24,0,$25,0,$26,0,$27,0,$28,0,$29,0,$2A,0,$2B,0,$2C,0,$2D,0,$2E,0,$2F,0
    Data.u $30,0,$31,0,$32,0,$33,0,$34,0,$35,0,$36,0,$37,0,$38,0,$39,0,$3A,0,$3B,0,$3C,0,$3D,0,$3E,0,$3F,0
    Data.u $40,0,$D835,$DE22,0,$D835,$DE23,0,$D835,$DE24,0,$D835,$DE25,0,$D835,$DE26,0,$D835,$DE27,0,$D835,$DE28,0,$D835,$DE29,0,$D835,$DE2A,0,$D835,$DE2B,0,$D835,$DE2C,0,$D835,$DE2D,0,$D835,$DE2E,0,$D835,$DE2F,0,$D835,$DE30,0
    Data.u $D835,$DE31,0,$D835,$DE32,0,$D835,$DE33,0,$D835,$DE34,0,$D835,$DE35,0,$D835,$DE36,0,$D835,$DE37,0,$D835,$DE38,0,$D835,$DE39,0,$D835,$DE3A,0,$D835,$DE3B,0,$5B,0,$5C,0,$5D,0,$5E,0,$5F,0
    Data.u $60,0,$61,0,$62,0,$63,0,$64,0,$65,0,$66,0,$67,0,$68,0,$69,0,$6A,0,$6B,0,$6C,0,$6D,0,$6E,0,$6F,0
    Data.u $70,0,$71,0,$72,0,$73,0,$74,0,$75,0,$76,0,$77,0,$78,0,$79,0,$7A,0,$7B,0,$7C,0,$7D,0,$7E,0,$25CB,0
    Data.u $2588,0,$2592,0,$D83D,$DC31,0,$2B07,$FE0F,0,$2591,0,$273D,0,$25CF,0,$2665,0,$2609,0,$C6C3,0,$2302,0,$2B05,$FE0F,0,$D83D,$DE10,0,$266A,0,$D83C,$DD7E,$FE0F,0,$25C6,0
    Data.u $2026,0,$27A1,$FE0F,0,$2605,0,$29D7,0,$2B06,$FE0F,0,$2C7,0,$2227,0,$274E,0,$25A4,0,$25A5,0,$3042,0,$3044,0,$3046,0,$3048,0,$304A,0,$304B,0
    Data.u $304D,0,$304F,0,$3051,0,$3053,0,$3055,0,$3057,0,$3059,0,$305B,0,$305D,0,$305F,0,$3061,0,$3064,0,$3066,0,$3068,0,$306A,0,$306B,0
    Data.u $306C,0,$306D,0,$306E,0,$306F,0,$3072,0,$3075,0,$3078,0,$307B,0,$307E,0,$307F,0,$3080,0,$3081,0,$3082,0,$3084,0,$3086,0,$3088,0
    Data.u $3089,0,$308A,0,$308B,0,$308C,0,$308D,0,$308F,0,$3092,0,$3093,0,$3063,0,$3083,0,$3085,0,$3087,0,$30A2,0,$30A4,0,$30A6,0,$30A8,0
    Data.u $30AA,0,$30AB,0,$30AD,0,$30AF,0,$30B1,0,$30B3,0,$30B5,0,$30B7,0,$30B9,0,$30BB,0,$30BD,0,$30BF,0,$30C1,0,$30C4,0,$30C6,0,$30C8,0
    Data.u $30CA,0,$30CB,0,$30CC,0,$30CD,0,$30CE,0,$30CF,0,$30D2,0,$30D5,0,$30D8,0,$30DB,0,$30DE,0,$30DF,0,$30E0,0,$30E1,0,$30E2,0,$30E4,0
    Data.u $30E6,0,$30E8,0,$30E9,0,$30EA,0,$30EB,0,$30EC,0,$30ED,0,$30EF,0,$30F2,0,$30F3,0,$30C3,0,$30E3,0,$30E5,0,$30E7,0,$25DC,0,$25DD,0  
  EndDataSection
EndProcedure

Procedure.s _addChar(byte.a)
  byte !$80
  If byte < 16 Or byte='[' Or byte = ']' Or byte = 255 Or byte=16 Or byte = ','
    ProcedureReturn _p8(255) + _p8(byte!$80)
  Else
    ProcedureReturn _p8(byte)
  EndIf    
EndProcedure

Structure sMem
  mem.a[0]
EndStructure

Procedure.s OutP8String(*mem.smem,picomem.l, size.l, limitbyte)
  Protected.s out,line.s
  Protected.l i
  
  If _p8(0) <> "set" : _create_p8() : EndIf
  
 
  out= "[[0x"+LCase(Hex(picomem))+","+#LF$
  For i=0 To size-1
    
    If i>0 And i % limitbyte = 0 And i<size-1
      out+ line+#LF$
      line=""
    EndIf
    
    line +_addChar(*mem\mem[i])
  Next
  
  If line
    out + line+#LF$ 
  EndIf
  out + "]]"+#LF$
  ProcedureReturn out
EndProcedure


Global *_dechar.Character
Procedure _decharStart(*mem)
  *_dechar = *mem
EndProcedure
Procedure.l _dechar()
  Protected.l i,c=-1
  For i=16 To 255
    If CompareMemory(*_dechar, @_p8(i), StringByteLength(_p8(i)))
      c = i
      *_dechar + StringByteLength(_p8(i)) 
      Break
    EndIf
  Next  
  If c = -1
    c = *_dechar\c
    *_dechar +2
  EndIf
  ProcedureReturn c
EndProcedure

Procedure.l InP8String(str.s, *mem.ascii,maxsize.l,block.l=0)
  Protected.l inside, incount,c,commapos
  Protected.s adr
  
  If _p8(0) <> "set" : _create_p8() : EndIf
    
  _decharStart(@str)
  Repeat
    c= _dechar()
    If c = 0 
      Break
    EndIf
    
    If inside 
      If c = ']'
        incount + 1
        If incount = 2
          Break
        EndIf
      Else   
        incount = 0
        If c = ',' 
          commapos + 1
        ElseIf c <> 10 And c <> 13
          If commapos = 0 + block*2
            adr + Chr(c)
          ElseIf commapos = 1 + block*2
            If c = 255
              c = _dechar() !$80
            EndIf
            c !$80
            *mem\a = c
            *mem+1
            maxsize - 1
            If maxsize=0
              Break
            EndIf
          EndIf
        EndIf
        
      EndIf
    Else
      If c = '['
        incount + 1
        If incount = 2
          inside = #True
          incount = 0
          commapos = 0
        EndIf
      Else
        incount = 0        
      EndIf
    EndIf  
      
    
  ForEver
  If LCase(Left(adr,2))="0x"
    adr="$"+Mid(adr,3)
  EndIf
  ProcedureReturn Val(adr)
EndProcedure

Procedure.s CombineP8String(str1.s,str2.s)
  Protected.s str
  str = str1 + str2
  ProcedureReturn ReplaceString(str,~"]]\n[[",",")
EndProcedure

; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 115
; FirstLine = 83
; Folding = --
; EnableXP