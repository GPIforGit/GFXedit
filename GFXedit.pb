EnableExplicit
UsePNGImageDecoder()
UsePNGImageEncoder()
UseJPEGImageDecoder()
UseTGAImageDecoder()
UseTIFFImageDecoder()

XIncludeFile "p8string.pbi"

;- start
;TODO Map shows flags
Global.s cart

#title = "GFXedit for Pico8"
#version = "1.0"

#defZoom=4

#border= 5 * #defZoom / 4

#bar = 8 * #defZoom / 4

#GFXWidth = 128 * #defZoom
#GFXHeight = 128 * #defZoom
#GFXX = #border
#GFXY = #border+16

#GFXWidth2 = 128 * #defZoom
#GFXHeight2 = 64 * #defZoom
#GFXX2 = #border
#GFXY2 = #border+16 + #GFXHeight2 + #border

#GFXUpTabX = #GFXX
#GFXUpTabY = #border

#GFXDownTabX = #GFXX
#GFXDownTabY = #GFXY + #GFXHeight +#border

#GFXFlagsX = #GFXX
#GFXFlagsY = #GFXDownTabY + 16 + #border

#GFXMenuX = #GFXX
#GFXMenuY = #GFXFlagsY + 16+#border

#GFXMainMenuX = #gfxx + #GFXWidth - 75
#GFXMainMenuY = #GFXY + #GFXHeight +#border +#bar+1


#GFXCellSize = #GFXWidth / 16

#mapTabX = #GFXX+#GFXWidth + #border
#mapTabY = #border

#mapX = #mapTabX
#mapY = #mapTabY+16

#mapWidthMax = 128 * #defZoom * 3
#mapWidthDefault = 128 * #defZoom * 1.5
#mapWidthMin = 128 * #defZoom
#mapRightWindow = #bar + 1 + #border
Global.l MapWidth = #mapWidthMin


#mapHeightMin = 128 * #defZoom
#mapHeightDefault = 128 * #defZoom 
#mapHeightMax = 128 * #defZoom * 3
#mapDownWindow =  #bar+1 + #border + 16*4+#border +#border
Global.l mapHeight = #mapHeightDefault

Global.l mapBarX ;= #mapX+#mapWidthMax+1
Global.l mapBarY ;= #mapY+mapHeight+1

Global.l mainMenuX, mainMenuY

Global.l mapMenuY ; = mapBarY + #bar + #border
#mapMenuX = #mapX

Global.l mapMenuZoomX = #MapMenux + mapWidth - 16*5
;mapMenuY = mapMenuY

Global.l mapMenuColorX = mapMenuZoomX -16 - 16*8
;mapMenuY = mapMenuY

#winWmin     = #mapX + #mapWidthMin + #mapRightWindow
#winWdefault = #mapX + #mapWidthDefault + #mapRightWindow
#winWMax     = #mapX + #mapWidthMax + #mapRightWindow
;#winh = #border + #GFXHeight + #border + 16 + #border
#winHmin     = #mapY + #mapHeightMin + #mapDownWindow
#winHdefault = #mapY + #mapHeightDefault + #mapDownWindow
#winHmax     = #mapY + #mapHeightMax + #mapDownWindow
#minZoom = #MapWidthMax / (128.0*8.0)  

Global.l mapCameraX, mapCameraY, mapBarW, mapBarH, mapCellSize, MapCursorIcon, MapCursorX, MapCursorY
Global.l mapZoomFactor=1, MapColor=7, mapShowID, mapShowGrid, mapBackColor=0, mapCopyTrans=#True, mapHiNb
Global.l mapFlashSelection 

Global.l GFXSelX,GFXSelY,SelectionW=1,SelectionH=1,GFXCurrentFlagIcon,GFXShowFlags, GFXShowIDs, GFXShowCount
Global.l GFXCursorIcon, GFXMap_ReplaceIcon, GFXGrid

Global font
Global win
Global spr_dot, spr_bar, spr_font, spr_gfx, spr_shadow, spr_label

Global.l flash15

Global Dim color.l(15)
Global Dim spr_color(15)
Global Dim GFX_Count(255)

Global.l UpdateGFX, UpdateMap

Enumeration
  #Map_Drawmode_none
  #Map_Drawmode_Stamp
  #Map_Drawmode_Box
  #Map_Drawmode_SmartBox
EndEnumeration
Global.l MapDrawmode = #Map_Drawmode_stamp


Enumeration
  #GrabMouse_None
  #GrabMouse_GFX
  #GrabMouse_MAP
  #GrabMouse_MAPMinimap
  #GrabMouse_Outside
  #GrabMouse_Menu
EndEnumeration

Enumeration tab
  #tab_map
  #tab_sprite
  #tab_sprHi
  #tab_sprLo
  #tab_sprMinimap
  #tab_label
EndEnumeration
Global.l mapTab = #tab_map, GFXUpTab = #tab_sprLo, GFXDownTab = #tab_sprHi

Enumeration mapmode
  #mapmode_none
  #mapmode_scrollH
  #mapmode_scrollW
  #mapmode_MapLeftStamp
  #mapmode_MapLeftBox
  #mapmode_MapLeftSmartBox
  #mapmode_MapShow
  #mapmode_MapCopy
EndEnumeration

If Not InitSprite()
  MessageRequester(#title, "Can't open opengl")
  End
EndIf

color(00)=RGBA(0, 0, 0, 255); black
color(01)=RGBA(29, 43, 83, 255); dark blue
color(02)=RGBA(126, 37, 83, 255); purple
color(03)=RGBA(0, 135, 81, 255) ; dark green
color(04)=RGBA(171, 82, 54, 255); brown
color(05)=RGBA(95, 87, 79, 255) ; dark gray
color(06)=RGBA(194, 195, 199, 255); light gray
color(07)=RGBA(255, 241, 232, 255); white
color(08)=RGBA(255, 0, 77, 255)   ; magenta
color(09)=RGBA(255, 163, 0, 255)  ; gold
color(10)=RGBA(255, 236, 39, 255) ; yellow
color(11)=RGBA(0, 228, 54, 255)   ; green
color(12)=RGBA(41, 173, 255, 255) ; blue
color(13)=RGBA(131, 118, 156, 255); cyan
color(14)=RGBA(255, 119, 168, 255); pink
color(15)=RGBA(255, 204, 170, 255); skin

#mem_gfx = $0   
#mem_shared = $1000 
#mem_map = $2000
#mem_gff = $3000
#mem_music = $3100
#mem_sfx = $3200

#mem_temp = $3100; = temp-data! - overwrites music and sfx!

#mem_label = $6000; = Screen-memory - not a ROM-Value. 
#mem_END = $8000


Structure sPico
  mem.a[#mem_end]  
EndStructure
Structure sCopy
  icon.a[128*64]
EndStructure
CompilerIf Not Defined(sMem,#PB_Structure)
  Structure sMem
    mem.a[0]
  EndStructure
CompilerEndIf

Global.sCopy PicoCopy
Global.sCopy ColorCopy: ColorCopy\icon[0] = 7 
Global.sPico Pico
Global.sPico NewList PicoBackup()
Global.l SelectionColorW = 1, SelectionColorH = 1

Enumeration
  #what_outside
  #what_gfx
  #what_map
  #what_gff
  #what_music
  #what_sfx
  #what_label
  #what_lua
EndEnumeration

Prototype p_menuitemsCallback(*parameter)

Structure sMenuItem
  x.l
  y.l
  w.l
  h.l
  flag.l
  str.s
  spr.l
  callback.p_menuitemsCallback
  *parameter
EndStructure
EnumerationBinary menuflag
  #menuflag_none
  #menuflag_hidden
  #menuflag_selected
  #menuflag_left
  #menuflag_color
  #menuflag_colordot
  #menuflag_Disabled
EndEnumeration

Global NewMap MenuItems.sMenuItem()

Enumeration ;- enumeration men
  #Men_zoom1
  #Men_zoom10=#Men_zoom1+9
  #men_up
  #men_down
  #men_left
  #men_right 
  #men_upSlow
  #men_downSlow
  #men_leftSlow
  #men_rightSlow
  #men_undo
  #men_redo
  #menu_leftIcon
  #men_upIcon
  #men_downIcon
  #men_leftIcon
  #men_rightIcon
  #men_color0
  #men_color15 = #men_color0 + 15
  #men_replace
  #men_replaceCompleteWorld
  #men_replaceUpperHalf  
  #men_replaceDummy
  #men_loadCart
  #men_saveCart
  #men_export
  
  #men_export_pngFile_fullGFX
  #men_export_pngFile_logGFX
  #men_export_pngFile_hiGFX
  #men_export_pngFile_fullMAP
  #men_export_pngFile_loMAP
  #men_export_pngFile_hiMAP
  #men_export_pngFile_label
  #men_export_pngFile_map_screen
  #men_export_pngFile_selection
  
  #men_export_pngClip_fullGFX
  #men_export_pngClip_logGFX
  #men_export_pngClip_hiGFX
  #men_export_pngClip_fullMAP
  #men_export_pngClip_loMAP
  #men_export_pngClip_hiMAP
  #men_export_pngClip_label
  #men_export_pngClip_map_screen
  #men_export_pngClip_selection
  
  #men_export_luaClip_full
  #men_export_luaClip_fullGFX
  #men_export_luaClip_sprite_lo
  #men_export_luaClip_map_lo
  #men_export_luaClip_shared
  #men_export_luaClip_gff  
  #men_export_luaClip_label
  
  #men_export_luaFile_full
  #men_export_luaFile_fullGFX
  #men_export_luaFile_sprite_lo
  #men_export_luaFile_map_lo
  #men_export_luaFile_shared
  #men_export_luaFile_gff  
  #men_export_luaFile_label
  
  #men_import
  #men_import_pngFile_fullGFX
  #men_import_pngFile_loGFX
  #men_import_pngFile_hiGFX
  #men_import_pngFile_label
  #men_import_pngFile_map_screen
  #men_import_pngFile_selection
  
  #men_import_pngClip_fullGFX
  #men_import_pngClip_loGFX
  #men_import_pngClip_hiGFX
  #men_import_pngClip_label
  #men_import_pngClip_map_screen
  #men_import_pngClip_selection
  
  #men_import_luaClip_full
  #men_import_luaClip_fullGFX
  #men_import_luaClip_sprite_lo
  #men_import_luaClip_map_lo
  #men_import_luaClip_shared
  #men_import_luaClip_gff  
  #men_import_luaClip_label
  
  #men_import_luaFile_full
  #men_import_luaFile_FullGFX
  #men_import_luaFile_sprite_lo
  #men_import_luaFile_map_lo
  #men_import_luaFile_shared
  #men_import_luaFile_gff  
  #men_import_luaFile_label
  
  #men_copy
  #men_paste
  #men_pasteImage
  #men_pasteText
EndEnumeration

EnumerationBinary
  #Text_none
  #Text_back
EndEnumeration

Enumeration Timer
  #tim_flash15
EndEnumeration

;- declare
Declare GFX_CountUsed()
Declare.l Text_Width(str.s)
Declare Text_Draw(x.l,y.l,str.s, flags.l = #Text_none)
Declare Label_Create()
Declare.a Map_GetIcon(x.l, y.l)

;-

Procedure.l SmartChoice(x.l,SelLen.l,Linelen.l) ; for smart box und lines
  If x=0 
    ProcedureReturn 0
  ElseIf x = Linelen-1
    ProcedureReturn SelLen-1
  EndIf
  If SelLen = 1
    ProcedureReturn 0
  ElseIf SelLen = 2
    If x < lineLen/2
      ProcedureReturn 0
    Else
      ProcedureReturn 1
    EndIf
  EndIf
  ProcedureReturn (x-1) * (SelLen-2) / (linelen-2)+1
EndProcedure
Procedure ToogleLong(*value.long)
  *value\l = Bool( Not *value\l)
EndProcedure
Procedure.l FindBestColorIndex(rgb)
  Protected.l i,r,g,b,d,c,dest=999999
  For i=0 To 15
    r = Red(color(i)) - Red(rgb)
    g = Green(color(i)) - Green(rgb)
    b = Blue(color(i)) - Blue(rgb)
    d = r*r + g*g + b*b
    If d<=dest
      dest=d
      c=i
    EndIf
  Next
  ProcedureReturn c
EndProcedure
Procedure PostMenu(value)
  PostEvent(#PB_Event_Menu, win, value)
EndProcedure
Procedure Window_Resize()
  Protected.l NewWidth = WindowWidth(win)
  Protected.l NewHeight = WindowHeight(win)
  #cellsize = 8 * #defZoom
  MapWidth = WindowWidth(win) - #mapRightWindow - #mapx
  MapWidth / #cellsize
  MapWidth * #cellsize
  NewWidth = #mapx + MapWidth + #mapRightWindow    
  
  mapHeight = WindowHeight(win) - #mapDownWindow - #mapy
  mapHeight / #cellsize
  mapHeight * #cellsize
  NewHeight = #mapy + mapHeight + #mapDownWindow    
  
  If NewWidth <> WindowWidth(win) Or NewHeight <> WindowHeight(win)
    ResizeWindow(win, #PB_Ignore, #PB_Ignore, NewWidth, NewHeight)
  EndIf
  
  mapBarX = #mapX + MapWidth + 1
  mapBarY = #mapY + mapHeight + 1
  mapMenuY = mapBarY + #bar + #border
  mapMenuZoomX = NewWidth - #border - 16 * 3 - #border - 75
  mapMenuColorX = mapMenuZoomX -#border - 16 * 4
  
  mainMenuX = NewWidth - #border - 75
  mainMenuY = mapBarY + #bar + #border
  
EndProcedure
Procedure _Create128x128(spr, mem, backcolor)
  StartDrawing( SpriteOutput( spr ) )
  DrawingMode(#PB_2DDrawing_AllChannels)
  
  Protected.l pos = mem
  Protected.l x,y,c
  For y=0 To 16*8-1
    For x=0 To 16*8-1 Step 2
      c =  pico\mem[pos] & $f : If c = 0 : c= backcolor : EndIf
      Plot(x,y, color(c))
      
      c = pico\mem[pos]>>4  & $f : If c = 0 : c= backcolor : EndIf      
      Plot(x+1,y, color( c))
      pos+1
    Next
  Next
  
  StopDrawing()
  
EndProcedure

;-
Global.l _Mouse_Grab
Procedure.l Mouse_Grab(type.l)
  If _Mouse_Grab = #GrabMouse_None Or _Mouse_Grab = type
    _Mouse_Grab = type
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure
Procedure.l Mouse_Release(Type)
  If _Mouse_Grab = type
    _Mouse_Grab = #GrabMouse_None
  EndIf
EndProcedure

;-
Procedure Menu_Set(name.s, x.l, y.l, w.l, str.s, flag.l,*callback=#Null,*parameter=#Null)
  Protected.l ww,yy
  Static.l hh
  With MenuItems(UCase(name))
    \x = x
    \y = y
    \w = w    
    \h = 16
    \flag = flag
    \callback = *callback
    \parameter = *parameter
    
    If \str <> str Or \spr = #Null
      \str = str
      
      If \spr
        FreeSprite(\spr)
        \spr = #Null
      EndIf
      
      If hh <= 0 
        StartDrawing(SpriteOutput(spr_font))
        DrawingFont(FontID(font))
        hh=TextHeight(str)
        StopDrawing()
      EndIf
      
      ww = w*hh/16
      \spr = CreateSprite(#PB_Any,ww,hh*5)
      
      StartDrawing(SpriteOutput(\spr))
      DrawingFont(FontID(font))
      w = TextWidth(str)
      If \flag & #menuflag_left
        yy = 0
        str=" "+str
      Else
        yy = (ww-w)/2
      EndIf
      
      Box     ( 0,hh*0,ww,hh,RGB(60,60,60))
      Box     ( 0,hh*1,ww,hh,RGB(115,115,115))
      Box     ( 0,hh*2,ww,hh,RGB(100,100,100))
      Box     ( 0,hh*3,ww,hh,RGB(155,155,155))
      Box     ( 0,hh*4,ww,hh,RGB(80, 80, 80))
      If \flag & #menuflag_color
        Box (3,hh*0+3,ww-6,hh-6,color(Val(str)))
        Box (3,hh*1+3,ww-6,hh-6,color(Val(str)))
        Box (1,hh*2+1,ww-2,hh-2,color(Val(str)))
        Box (1,hh*3+1,ww-2,hh-2,color(Val(str)))
        Box (4,hh*4+4,ww-8,hh-8,color(Val(str)))
      ElseIf \flag & #menuflag_colordot
        DrawText(yy,hh*0,str  ,color(Val(str)+8),RGB(60,60,60))
        DrawText(yy,hh*1,str  ,color(Val(str)+8),RGB(115,115,115))
        Box     ( 1,hh*2,ww-2,hh,color(Val(str)+8))
        DrawText(yy,hh*2,str  ,RGB(0,0,0),color(Val(str)+8))
        Box     ( 1,hh*3,ww-2,hh,color(Val(str)+8))
        DrawText(yy,hh*3,str  ,RGB(55,55,55),color(Val(str)+8))
        DrawText(yy,hh*4,str  ,color(Val(str)+8),RGB(80,80,80))        
      Else
        DrawText(yy,hh*0,str  ,RGB(150,150,150),RGB(60,60,60))
        DrawText(yy,hh*1,str  ,RGB(205,205,205),RGB(115,115,115))
        DrawText(yy,hh*2,str  ,color(9),RGB(100,100,100))
        DrawText(yy,hh*3,str  ,color(10),RGB(155,155,155))
        DrawText(yy,hh*4,str  ,RGB(0,0,0),RGB(80,80,80))
      EndIf
      StopDrawing()
      
    EndIf
    
  EndWith
EndProcedure

Procedure Menu_Draw(x.l, y.l, click.l)
  Protected.l pos,h
  
  ForEach MenuItems()
    With menuitems()
      If Not \flag & #menuflag_hidden
        If \flag & #menuflag_Disabled
          pos = 4
        ElseIf \flag & #menuflag_selected 
          pos = 2
        Else
          pos = 0
        EndIf
        
        If x >= \x And x < \x + \w And y >= \y And y < \y + \h And Not \flag & #menuflag_Disabled
          pos + 1
          If click
            If \callback
              \callback(\parameter)
            EndIf
          EndIf
        EndIf
        
        ClipSprite(\spr, #PB_Default, #PB_Default, #PB_Default, #PB_Default)
        h= SpriteHeight(\spr) / 5
        ClipSprite(\spr, #PB_Default, h*pos, #PB_Default, h)
        DisplaySprite(\spr, \x, \y)
      EndIf
    EndWith
    
  Next
EndProcedure 

;-


Global clipX,ClipY,ClipX2,ClipY2
Procedure Screen_Clip(x=0,y=0,w=#winWMax,h=#winHmax)
  clipX=x
  ClipY=y
  ClipX2=w+x
  ClipY2=h+y
EndProcedure

Procedure Screen_Sprite(spr, x.l, y.l, ww.l, hh.l, alpha.l = 255)
  If x < clipX
    ww - (clipX-x)
    x = clipX
  EndIf
  If y < clipY
    hh - (clipY-y)
    y = clipY
  EndIf
  If x+ww >= ClipX2
    ww = ClipX2-x 
  EndIf
  If y+hh >= ClipY2
    hh = clipY2-y
  EndIf
  
  If ww>0 And hh>0 And x+ww >= clipX And y+hh >= clipY
    ClipSprite(spr,#PB_Default,#PB_Default,#PB_Default,#PB_Default)
    ZoomSprite(spr,ww,hh)
    If alpha = 255
      DisplaySprite(spr,x,y)
    Else
      DisplayTransparentSprite(spr,x,y,alpha)
    EndIf
  EndIf
EndProcedure

Procedure Screen_Sprite2(Spr,x.l,y.l,ww.l,hh.l,x2.l,y2.l,w2.l,h2.l,alpha.l=255)
  If x < clipX
    ww - (clipX-x)
    w2 - (clipX-X)* w2 / ww 
    x2 + (clipx-x)* w2 / ww
    x = clipX
  EndIf
  If y < clipY
    hh - (clipY-y)
    h2 - (clipY-y)* h2 / hh
    y2 + (clipy-y)* h2 / hh
    y = clipY
  EndIf
  If x+ww >= ClipX2
    w2 = (clipX2-x)* w2 / ww
    ww = ClipX2-x 
  EndIf
  If y+hh >= ClipY2
    h2 = (clipY2-y)* h2 / hh
    hh = clipY2-y
  EndIf
  
  If ww>0 And hh>0 And x+ww >= clipX And y+hh >= clipY
    ClipSprite(spr,x2,y2,w2,h2)
    ZoomSprite(spr,ww,hh)
    If Alpha = 255
      DisplaySprite(spr,x,y)
    Else
      DisplayTransparentSprite(spr, x, y, alpha)
    EndIf
  EndIf
EndProcedure

Procedure Screen_Shadow(x.l, y.l ,ww.l ,hh.l)
  If x < clipX
    ww - (clipX-x)
    x = clipX
  EndIf
  If y < clipY
    hh - (clipY-y)
    y = clipY
  EndIf
  If x+ww >= ClipX2
    ww = ClipX2-x 
  EndIf
  If y+hh >= ClipY2
    hh = clipY2-y
  EndIf
  
  If ww>0 And hh>0 And x+ww >= clipX And y+hh >= clipY
    ClipSprite(spr_shadow,#PB_Default,#PB_Default,#PB_Default,#PB_Default)
    ZoomSprite(spr_shadow,ww,hh)
    DisplayTransparentSprite(spr_shadow,x,y)
  EndIf
EndProcedure
Procedure Box_Draw(x.l,y.l,w.l,h.l, col=7)
  ;   StartDrawing(ScreenOutput())
  ;   DrawingMode(#PB_2DDrawing_Outlined)
  ;   Box( x-1, y-1, w+2, h+2, #Black)
  ;   Box( x-2, y-2, w+4, h+4, #White)
  ;   Box( x-3, y-3, w+6, h+6, #Black)  
  ;   StopDrawing()
  Screen_Sprite(spr_color(0),x-3,y-3,w+6,1)
  Screen_Sprite(spr_color(0),x-3,y-1,w+6,1)
  Screen_Sprite(spr_color(0),x-3,y+h,w+6,1)
  Screen_Sprite(spr_color(0),x-3,y+h+2,w+6,1)
  
  Screen_Sprite(spr_color(0),x-3  ,y-3,1,h+6)
  Screen_Sprite(spr_color(0),x-1  ,y-3,1,h+6)
  Screen_Sprite(spr_color(0),x+w  ,y-3,1,h+6)
  Screen_Sprite(spr_color(0),x+w+2,y-3,1,h+6)
  
  Screen_Sprite(spr_color(col),x-2,y-2,w+4,1)
  Screen_Sprite(spr_color(col),x-2,y+h+1,w+4,1)
  
  Screen_Sprite(spr_color(col),x-2  ,y-2,1,h+4)
  Screen_Sprite(spr_color(col),x+w+1,y-2,1,h+4)
  
EndProcedure
;-
Procedure pico_clear()
  FillMemory(@pico\mem, SizeOf(pico\mem))  
EndProcedure

Procedure pico_backup()
  While NextElement(PicoBackup())
    DeleteElement(PicoBackup())
  Wend
  
  While ListSize(picobackup())>100
    PushListPosition(PicoBackup())
    FirstElement(PicoBackup())
    DeleteElement(PicoBackup())
    PopListPosition(PicoBackup())
  Wend
  
  If ListIndex(PicoBackup())>=0
    If CompareMemory(pico,PicoBackup(),SizeOf(spico))=1
      ProcedureReturn
    EndIf
  EndIf
  AddElement(PicoBackup())
  CopyStructure(pico,PicoBackup(),sPico)
EndProcedure

Procedure pico_clearbackup()
  ClearList(PicoBackup())
EndProcedure

Procedure pico_undo()
  If ListIndex(PicoBackup()) = ListSize(PicoBackup())-1
    pico_backup()
    PreviousElement(PicoBackup())
  EndIf  
  
  If ListIndex(PicoBackup()) >= 0
    CopyStructure(PicoBackup(),pico,sPico)
    PreviousElement(PicoBackup())
  EndIf
  UpdateGFX = #True
  UpdateMap = #True
  Label_Create()
EndProcedure
Procedure pico_redo()
  NextElement(PicoBackup())
  If ListIndex(PicoBackup()) >= 0
    CopyStructure(PicoBackup(),pico,sPico)
  EndIf  
  UpdateGFX = #True
  UpdateMap = #True
  Label_Create()
EndProcedure

;-
Procedure GFX_GetPixel(spr.l,x.l,y.l)
  Protected.l pos
  If spr<0 Or spr>255 Or x<0 Or x>7 Or y<0 Or y>7
    ProcedureReturn -1
  EndIf
  
  pos = #mem_gfx + (spr >>4 &$F) * 16*4*8 + (spr &$f)*4
  pos + x/2 + y * 16*4
  
  If x & 1
    ProcedureReturn pico\mem[pos]>>4 & $f
  Else
    ProcedureReturn pico\mem[pos] & $f
  EndIf
EndProcedure

Procedure GFX_SetPixel(spr.l,x.l,y.l,c.l)
  Protected.l pos
  If spr<0 Or spr>255 Or x<0 Or x>7 Or y<0 Or y>7
    ProcedureReturn -1
  EndIf
  
  pos = #mem_gfx + (spr >>4 &$F) * 16*4*8 + (spr &$f)*4
  pos + x/2 + y * 16*4
  
  UpdateGFX = #True
  
  Protected.l ret = pico\mem[pos]
  If x & 1
    pico\mem[pos] = ret & $f + C<<4 & $f0
  Else
    pico\mem[pos] = c & $f + ret & $f0
  EndIf
  ProcedureReturn ret
EndProcedure

Procedure GFX_Copy(s.l,d.l)
  If s<0 Or s>255 Or d<0 Or d>255
    ProcedureReturn
  EndIf
  
  pico_backup()
  UpdateGFX = #True

  
  Protected.l y, posS, posD
  posS = #mem_gfx + (s >>4 &$F) * 16*4*8 + (s &$f)*4
  posD = #mem_gfx + (d >>4 &$F) * 16*4*8 + (d &$f)*4
  
  For y=0 To 7
    PokeL(@pico\mem[posD], PeekL(@pico\mem[posS]) )
    posS + 16*4
    posD + 16*4
  Next
  
  pico\mem[#mem_gff+d] = pico\mem[#mem_gff+s]
    
EndProcedure

Procedure GFX_Create()
  If spr_gfx = #Null
    spr_gfx = CreateSprite(#PB_Any,16*8,16*8,#PB_Sprite_AlphaBlending)
  EndIf
  _Create128x128(spr_gfx,#mem_gfx,mapBackColor)
EndProcedure  
Procedure GFX_DrawIcon(icon.l,x.l,y.l,ww.l,hh.l,alpha.l=255)
  Protected.l icon2
  If mapHiNb And icon > 127
    Protected.s str = Right("0"+Hex(icon),2)
    icon2 = pico\mem[#mem_gff + icon]
    screen_sprite2(spr_gfx,x,y,ww,hh, (icon2 & $f)*8, (icon2 >> 4 & $f)*8,8,8,alpha)
    Screen_Shadow(x,y,ww,hh )
    Text_Draw(x+ (ww- Text_Width(str)) / 2, y + (hh-16)/2, str)
  Else
    screen_sprite2(spr_gfx,x,y,ww,hh, (icon & $f)*8, (icon >> 4 & $f)*8,8,8,alpha)
  EndIf
EndProcedure  
Procedure GFX_CountUsed()
  Protected.l x,y
  For x = 0 To 255
    GFX_Count(x) = 0
  Next
  For y = 0 To 63
    For x = 0 To 127
      GFX_Count( Map_GetIcon(x,y) ) +1
    Next
  Next
EndProcedure
Procedure GFX_IconInSelection(icon)
  Protected.l dx, dy
  For dy = 0 To selectionH-1
    For dx = 0 To selectionW-1
      If PicoCopy\icon[ dy*128 + dx] = icon
        ProcedureReturn #True
      EndIf
    Next
  Next
  ProcedureReturn #False
EndProcedure
Procedure GFX_ToogleFlag(flag.i)
   pico\mem[#mem_gff + GFXCurrentFlagIcon ] ! (1<<flag)  
EndProcedure  

Procedure.l GFX_IsHalf()
  ProcedureReturn Bool( GFXDownTab = #tab_sprMinimap )
EndProcedure

Procedure GFX_DrawHalf(x.l,y.l,whichTab.l)
  Protected.l offsetY
  Protected.l dx, dy, b, i
  Protected spr
  
  Select whichTab
    Case #tab_sprLo
      offsetY = 0
    Case #tab_sprHi
      offsetY = 8
    Default
      Debug "GFX_DrawHalf: unknown tab"
  EndSelect
  
  For dy = 0 To 7
    For dx = 0 To 15
      GFX_DrawIcon( (dy + offsetY)<<4 + dx, x + dx * #GFXCellSize, y + dy * #GFXCellSize, #GFXCellSize, #GFXCellSize)
    Next
  Next
  
  
  If GFXShowFlags | GFXShowIDs | GFXShowCount
    Screen_Shadow(x,y,#GFXWidth2,#GFXHeight2)
  EndIf
  
  If GFXShowFlags
    #sprPixel = #GFXCellSize / 8
    For dy = 0 To 7
      ;blackbar
      Screen_Sprite(spr_color(0), x, y + dy * #GFXCellSize + 7 * #sprPixel - 1 ,#GFXWidth2 ,1)
      
      For dx = 0 To 15
        b = pico\mem[#mem_gff + dx + (dy + offsetY)<<4 ] ; get flag
        For i= 0 To 7
          If b>>i & 1
            spr = spr_color(i+8)
          Else
            spr = spr_dot
          EndIf
          Screen_Sprite(spr, x + dx * #GFXCellSize + i * #sprPixel, y + dy * #GFXCellSize + 7 * #sprPixel, #sprPixel, #sprPixel)
        Next
        
      Next
      ;blackbar
      Screen_Sprite(spr_color(0), x,  y + dy * #GFXCellSize + 8 * #sprPixel, #GFXWidth2 , 1)     
    Next
  EndIf
  
  If GFXShowIDs
    For dy = 0 To 7
      For dx = 0 To 15
        Text_Draw(x + dx * #GFXCellSize, y + dy * #GFXCellSize, Hex(dy + offsetY) + Hex(dx) ) 
      Next
    Next
  EndIf
  
  If GFXShowCount
    For dy = 0 To 7
      For dx = 0 To 15
        Text_Draw(x + dx * #GFXCellSize, y + dy * #GFXCellSize + 16, ""+GFX_Count(dx + (dy + offsetY)<<4 ))
        If GFX_Count(dx + (dy + offsetY)<<4) = 0
          Screen_Shadow(x + dx * #GFXCellSize, y + dy * #GFXCellSize, #GFXCellSize, #GFXCellSize)
        EndIf
      Next
    Next
  EndIf
  
  If GFXGrid
    For dx = 0 To 15
      Screen_Sprite(spr_dot,x + dx * #GFXCellSize, y, 1, #GFXCellSize*8)
      If dx < 8
        Screen_Sprite(spr_dot,x,y + dx * #GFXCellSize, #GFXCellSize*16,1)
      EndIf      
    Next   
  EndIf
  
EndProcedure

Procedure GFX_SetUpTab(value)
  GFXUpTab = value
EndProcedure

Procedure GFX_SetDownTab(value)
  GFXDownTab = value
  If value = #tab_sprHi
    GFXUpTab = #tab_sprLo
  EndIf  
EndProcedure

Procedure GFX_Draw()
  Protected.l b, i,icon
  Protected.l dy, dx
    
  Screen_Clip(#GFXX-3,#GFXY-3,#GFXWidth+6,#GFXHeight2+6)
 
  Select GFXUpTab
    Case #tab_sprHi, #tab_sprLo
      GFX_DrawHalf(#gfxX, #gfxY, GFXUpTab)
  EndSelect
  
  Screen_Clip(#GFXX2-3,#GFXY2-3,#GFXWidth2+6,#GFXHeight2+6)
  
  Select GFXDownTab
    Case #tab_sprHi, #tab_sprLo
      GFX_DrawHalf(#gfxX2, #gfxY2, GFXDownTab)
      
    Case #tab_sprMinimap
      #minimapCell = #GFXWidth / 128

  
      For dy = 0 To 63
        For dx = 0 To 127
          icon = Map_GetIcon(dx,dy)
          GFX_DrawIcon( icon, #GFXX2 + dx * #minimapCell, #GFXY2 + dy * #minimapCell, #minimapCell, #minimapCell) 
          If mapFlashSelection
            If  GFX_IconInSelection(icon)
              If flash15
                Screen_Sprite(spr_color(7), #GFXX2 + dx * #minimapCell, #GFXY2 + dy * #minimapCell, #minimapCell, #minimapCell,128)
              EndIf
            Else
              Screen_Shadow(#GFXX2 + dx * #minimapCell, #GFXY2 + dy * #minimapCell, #minimapCell, #minimapCell )
            EndIf
          EndIf
          

          
        Next
      Next
      
      ;Screen-Seperator
      For dy = 0 To 63 Step 16
        Screen_Sprite(spr_dot,#GFXX2,  #GFXY2 +  dy * #minimapCell, #GFXWidth2,1)
      Next
      For dx = 0 To 127 Step 16
        Screen_Sprite(spr_dot,#GFXX2 + dx * #minimapCell,  #GFXY2 , 1, #GFXHeight2)
      Next
      
      ;Shadow outside visible
      If Not mapFlashSelection
        If mapTab = #tab_map
          Protected.l x,y,w,h
          If mapCellSize >0
            x = #GFXX2 + mapCameraX * #minimapCell
            y = #GFXY2 + mapCameraY * #minimapCell
            w = MapWidth / mapCellSize * #minimapCell
            h = mapHeight / mapCellSize * #minimapCell
            Screen_Shadow(#GFXX2, #GFXY2, #GFXWidth, y-#GFXY2)
            screen_shadow(#GFXX2, y+h , #GFXWidth2, #GFXY2+#GFXHeight2 - y - h)
            Screen_Shadow(#GFXX2, y, x-#GFXX2, h)
            Screen_Shadow(x+w, y, #GFXX2+#GFXWidth2 -x - w, h)          
            Box_Draw( x, y , w, h)       
          EndIf
        Else
          Screen_Shadow(#GFXX2, #GFXY2, #GFXWidth2,#GFXHeight2)      
        EndIf
      Else
        If mapTab = #tab_map
          If mapCellSize >0
            x = #GFXX2 + mapCameraX * #minimapCell
            y = #GFXY2 + mapCameraY * #minimapCell
            w = MapWidth / mapCellSize * #minimapCell
            h = mapHeight / mapCellSize * #minimapCell
          EndIf
          Box_Draw( x, y , w, h)       
        EndIf
      EndIf
  EndSelect
     
  Screen_Clip()
  
  ;  Show Flags for Icon
  If GFXCurrentFlagIcon >= 0
    b = pico\mem[#mem_gff + GFXCurrentFlagIcon ]
    dx = #GFXFlagsX
    If MapCursorX >= 0 And MapCursorY >= 0
      Text_Draw(dx, #GFXFlagsY,Right("0"+Hex(MapCursorX),2)+"x"+Right("0"+Hex(MapCursorY),2))
    EndIf
    dx+8*5+5
    Text_Draw(dx, #GFXFlagsY,Right("0"+Hex(GFXCurrentFlagIcon),2))
    dx + 16+5
    ClipSprite(spr_gfx, (GFXCurrentFlagIcon & $F)*8, (GFXCurrentFlagIcon>>4 & $f)*8,8,8)
    ZoomSprite(spr_gfx,16,16)
    DisplaySprite(spr_gfx,dx,#GFXFlagsY) 
    dx + 16+5
    For i= 0 To 7
      Menu_Set("sprFlags"+i, dx, #GFXFlagsY, 16, Str(i), (( b>>i & 1) * #menuflag_selected) | #menuflag_colordot,@GFX_ToogleFlag(),i)
      dx + 16
    Next
  Else
    For i= 0 To 7
      Menu_Set("sprFlags"+i, #GFXFlagsX+16*i, #GFXFlagsY, 16, Str(i), #menuflag_hidden | #menuflag_colordot)
    Next
  EndIf
  
  menu_set("TabGFXUpLo", #GFXUpTabX + 100*0, #GFXUpTabY, 100, "Low" , #menuflag_selected * Bool(GFXUpTab = #tab_sprLo), @GFX_SetUpTab(), #tab_sprLo)
  If GFX_IsHalf()
    menu_set("TabGFXUpHi", #GFXUpTabX + 100*1, #GFXUpTabY, 100, "High", #menuflag_selected * Bool(GFXUpTab = #tab_sprHi), @GFX_SetUpTab(), #tab_sprHi)
  Else
    menu_set("TabGFXUpHi", #GFXUpTabX + 100*1, #GFXUpTabY, 100, "High", #menuflag_Disabled, @GFX_SetUpTab(), #tab_sprHi)
  EndIf
  
  menu_set("TabGFXDownLo" , #GFXDownTabX + 100*0, #GFXDownTabY, 100, "Low"    , #menuflag_Disabled                                     , @GFX_SetDownTab(), #tab_sprHi) ; never possible, but looks nicer
  menu_set("TabGFXDownHi" , #GFXDownTabX + 100*1, #GFXDownTabY, 100, "High"   , #menuflag_selected * Bool(GFXDownTab = #tab_sprHi)     , @GFX_SetDownTab(), #tab_sprHi)
  menu_set("TabGFXDownMap", #GFXDownTabX + 100*2, #GFXDownTabY, 100, "MiniMap", #menuflag_selected * Bool(GFXDownTab = #tab_sprMinimap), @GFX_SetDownTab(), #tab_sprMinimap)

  
  
  Menu_Set("SprShowFlag"   ,#GFXMenuX           ,#GFXMenuY,75,"Flags"  , #menuflag_selected * GFXShowFlags  , @ToogleLong(), @GFXShowFlags)
  Menu_Set("GFXShowIDs"    ,#GFXMenuX+(75+1)*1  ,#GFXMenuY,75,"ID"     , #menuflag_selected * GFXShowIDs    , @ToogleLong(), @GFXShowIDs)
  Menu_Set("GFXShowCount"  ,#GFXMenuX+(75+1)*2  ,#GFXMenuY,75,"Count"  , #menuflag_selected * GFXShowCount  , @ToogleLong(), @GFXShowCount)
  Menu_Set("GFXGrid"       ,#GFXMenuX+(75+1)*3  ,#GFXMenuY,75,"Grid"   , #menuflag_selected * GFXGrid       , @ToogleLong(), @GFXGrid)
  ;Menu_Set("SprShowMinimap",#GFXMenuX+(75+1)*3  ,#GFXMenuY,75,"MiniMap", #menuflag_selected * sprShowMinimap, @ToogleLong(), @sprShowMinimap)
  
EndProcedure

Procedure GFX_HandleMouseHalf(mx.l, my.l, btn.l, oldBtn.l, x.l,y.l, whichTab.l, SpecialKey.l)
  Protected.l OffsetY
  Protected.l dx, dy, icon, xx, yy
  Static.l startx, starty
  
  Select whichTab
    Case #tab_sprLo
      OffsetY = 0
    Case #tab_sprHi
      OffsetY = 8
  EndSelect
 
  mx - x
  my - y
  
  ; Release when no Button is pressed
  If btn = 0
    Mouse_Release(#GrabMouse_GFX)
  EndIf
  
  
  If Not( mx >= 0 And my >= 0 And mx < #GFXWidth2 And my < #GFXHeight2)
    
  Else
  
    mx= mx / #GFXCellSize
    my= my / #GFXCellSize + OffsetY
    
    GFXCursorIcon = (my << 4) + mx
      
    ; red border for copy to
    If btn = 0 ;mapTab = #tab_sprite; And SelectionW=1 And SelectionH = 1
      Box_Draw( x + mx * #GFXCellSize, y + (my - OffsetY) * #GFXCellSize, SelectionW * #GFXCellSize, Selectionh * #GFXCellSize,8)
      
    EndIf  
    
    If btn&2 And Not oldBtn & 2 And SpecialKey And SelectionW=1 And SelectionH = 1
      ; Replace in map
      GFXMap_ReplaceIcon = GFXCursorIcon
      PostMenu(#men_replace)
      
    ElseIf btn & 2 And Not oldBtn & 2 And Mouse_Grab(#GrabMouse_GFX)
      ; replace in gfx
      GFXSelX = mx
      GFXSelY = my      
       
      For dy = 0 To SelectionH-1
        For dx = 0 To SelectionW-1
          If GFXSelX + dx < 16 And GFXSelY + dy <16
            GFX_Copy( PicoCopy\icon[dy * 128 + dx], (GFXSelY+dy)<<4 + (GFXSelX+dx))
          EndIf
        Next
      Next
      
      PicoCopy\icon[0] = GFXSelY<<4 + GFXSelX       
      
    ElseIf btn & 1 And Mouse_Grab(#GrabMouse_GFX)
      ; select gfx
      
      If  Not oldbtn & 1
        startx = mx
        starty = my
      EndIf
      
      If startX <= mX
        GFXSelX = startX
        SelectionW = mx-startx+1
      Else
        GFXSelX = mX
        SelectionW = startX-mx+1
      EndIf
      If startY <= mY
        GFXSelY = startY
        SelectionH = my-startY+1
      Else
        GFXSelY = mY
        SelectionH = startY-mY+1
      EndIf
      
;       If GFXSelX + SelectionH > 16
;         SelectionH = 16-GFXSelX
;       EndIf
;       
;       If GFXSelY + SelectionW > 16
;         SelectionW = 16-GFXSelY
;       EndIf    
      
      For dy = 0 To SelectionH-1
        For dx = 0 To SelectionW-1
          picocopy\icon[dx+dy*128] = (GFXSelY + dy)<<4 + (GFXSelX + dx )
        Next
      Next
    EndIf
  EndIf
  
  If GFXSelX >= 0 And GFXSelX < 16 And
     GFXSelY >= 0 And GFXSelY < 16
    If (GFXSelY-OffsetY)+SelectionH > 0 And (GFXSelY-OffsetY) < 8
      Box_Draw(x + GFXSelX * #GFXCellSize, y + (GFXSelY-OffsetY) * #GFXCellSize, SelectionW * #GFXCellSize, SelectionH * #GFXCellSize)   
    EndIf
  Else
    If SelectionW>1 Or SelectionH>1  
      For dy = 0 To SelectionH-1
        For dx = 0 To SelectionW-1
          icon = PicoCopy\icon[dx + dy*128]
          yy = icon>>4 & $f - OffsetY
          xx = icon & $f
          Box_Draw(#GFXX + xx * #GFXCellSize, #GFXY + yy * #GFXCellSize, #GFXCellSize, #GFXCellSize)
        Next
      Next
    EndIf
  EndIf
    
EndProcedure

Procedure GFX_HandleMouse(mx.l,my.l,btn.l, SpecialKey)
  Static oldBtn.l  
  Protected.l x,y
  
  GFXCursorIcon = -1
    
  Screen_Clip(#GFXX-3,#GFXY-3,#GFXWidth+6,#GFXHeight2+6)
 
  Select GFXUpTab
    Case #tab_sprHi, #tab_sprLo
      GFX_HandleMouseHalf(mx, my, btn, oldBtn, #gfxX, #gfxY, GFXUpTab, SpecialKey)
  EndSelect
  
  Screen_Clip(#GFXX2-3,#GFXY2-3,#GFXWidth2+6,#GFXHeight2+6)
  
  Select GFXDownTab
    Case #tab_sprHi, #tab_sprLo
      GFX_HandleMouseHalf(mx, my, btn, oldBtn, #gfxX2, #gfxY2, GFXDownTab, SpecialKey)
      
    Case #tab_sprMinimap
      x = mx - #gfxx2
      y = my - #gfxy2
      If btn = 0
        Mouse_Release(#GrabMouse_MAPMinimap)
      ElseIf x >= 0 And x < #GFXWidth2 And y >= 0 And y <= #GFXHeight2 And Mouse_Grab(#GrabMouse_MAPMinimap)
        If btn & 1 
          mapCameraX = (x / #minimapCell) & $f0 - (MapWidth/mapCellSize -16)/2
          mapCameraY = (y / #minimapCell) & $f0 - (mapHeight/mapCellSize -16)/2
        ElseIf btn & 2 And mapCellSize > 0
          mapCameraX = (x / #minimapCell) - (MapWidth / mapCellSize)/2
          mapCameraY = (y / #minimapCell) - (mapHeight / mapCellSize)/2
        EndIf
      EndIf

  EndSelect    
   

  If GFXCursorIcon >= 0
    GFXCurrentFlagIcon = GFXCursorIcon
  ElseIf MapCursorIcon >= 0 
    GFXCurrentFlagIcon = MapCursorIcon
  ElseIf GFXSelX >= 0 And GFXSelY >= 0 And SelectionW = 1 And SelectionH = 1
    GFXCurrentFlagIcon = PicoCopy\icon[0]
  Else
    GFXCurrentFlagIcon = -1
  EndIf
  
  
  oldBtn = btn
  
  Screen_Clip()
  
  
  ProcedureReturn #True
EndProcedure
Procedure GFX_MoveCursor(dx.l,dy.l)
  If GFXSelX<0 Or GFXSelY<0
    GFXSelX = 0
    GFXSelY = 0
    SelectionW = 1
    SelectionH = 1
  Else
    GFXSelX + dx
    GFXSelY + dy
    While GFXSelX < 0 
      GFXSelX + 16
    Wend
    While GFXSelX > 15
      GFXSelX -16
    Wend
    While GFXSelY < 0 
      GFXSelY + 16
    Wend
    While GFXSelY > 15
      GFXSelY -16
    Wend
    SelectionW = 1
    SelectionH = 1
  EndIf
  PicoCopy\icon[0] = GFXSelY<<4 + GFXSelX
EndProcedure

;-
Procedure Label_Create()
  If spr_label = #Null
    spr_label = CreateSprite(#PB_Any,16*8,16*8,#PB_Sprite_AlphaBlending)
  EndIf
  _Create128x128(spr_label,#mem_label,0)
EndProcedure  
;- 


Macro AddLine(s) : AddElement(WriteLine()) : WriteLine() = s : EndMacro

Procedure.l Cartridge_Save(rom.s)
  Protected in,out
  Protected.s line,backup,str
  Protected.l readit,i,pos,swapit,size,linelen,a,empty
  NewList WriteLine.s()
  
  in = ReadFile(#PB_Any,rom)
  If in =0
    addline("pico-8 cartridge // http://www.pico-8.com")
    addline("version 33")
    addline("__lua__")
    addline("-- Project name")
    addline("-- by you")
  Else
    readit = #True
    While Not Eof(in)
      line = ReadString(in)
      If Left(line,2)="__" And Right(line,2)="__"
        Select line
          Case "__gfx__", "__label__", "__gff__","__map__"
            readit = #False
          Default
            readit = #True
        EndSelect
      EndIf
      If readit
        AddLine(line)
      EndIf
    Wend
    CloseFile(in)
    i=1
    Repeat
      backup=GetPathPart(rom)+GetFilePart(rom,#PB_FileSystem_NoExtension)+"(backup "+i+").p8"
      If FileSize(backup) = -1 ;not found
        Break
      EndIf
      i+1
    ForEver
    CopyFile(rom,backup)
  EndIf
  
  
  
  For i=0 To 3
    Select i
      Case 0 
        addline("__gfx__")
        pos = #mem_gfx
        swapit = #True
        linelen=64
        size = 128*64
      Case 1
        addline("__label__")
        pos = #mem_label
        swapit = #True
        linelen =64
        size = 128*64
      Case 2
        addline("__gff__")
        pos = #mem_gff
        swapit = #False
        linelen = 128
        size = 256
      Case 3
        addline("__map__")
        pos = #mem_map
        swapit = #False
        linelen = 128
        size = 128*32
    EndSelect
   
    While size > 0
      empty = #True
      For a=size-linelen To size-1
        If pico\mem[pos+a] <> 0
          empty = #False
          Break
        EndIf
      Next
      If empty
        size-linelen
      Else
        Break
      EndIf
    Wend
    
    str=""
    For a=0 To size-1
      If a>0 And a % linelen = 0
        addline(str)
        str=""
      EndIf
      If swapit
        str + LCase(Hex(pico\mem[pos] & $f)) + LCase(Hex(pico\mem[pos] >> 4 & $f))
      Else
        str + LCase(Hex(pico\mem[pos] >> 4 & $f)) + LCase(Hex(pico\mem[pos] & $f))
      EndIf
      pos+1
    Next
    If str
      addline(str)
    EndIf
    
    
  Next
  
  out = CreateFile(#PB_Any,rom)
  If out
    ForEach WriteLine()
      WriteStringN(out,WriteLine())
    Next   
    CloseFile(out)
  Else
    MessageRequester(#title,"Can't write file." + #LF$ + rom)
  EndIf
    
  
EndProcedure

Procedure.l Cartridge_Load(rom.s)
  Protected in
  in=ReadFile(#PB_Any,rom)
  If in = 0 
    MessageRequester(#title,"Can't read file." + #LF$ + rom)
    ProcedureReturn #False
  EndIf
  
  pico_clear()
  
  Protected.l what = #what_outside
  Protected.l pos,i
  Protected.s line
  While Not Eof(in)
    line = ReadString( in )
    Select line
      Case "__gfx__"
        pos = #mem_gfx
        what = #what_gfx
      Case "__label__"
        pos = #mem_label
        what = #what_label
      Case "__gff__"
        pos = #mem_gff
        what = #what_gff
      Case "__map__"
        pos = #mem_map
        what = #what_map
      Case "__sfx__"
        pos = #mem_sfx
        what = #what_sfx
      Case "__music__"
        pos = #mem_music
        what = #what_music
      Case "__lua__"
        pos = 0
        what = #what_lua
      Default
        
        Select what
          Case #what_gfx, #what_map, #what_gff, #what_label;, #what_sfx, #what_music
            i=1
            While i < Len(line)
              While Mid(line,i,1)<" "
                i+1
              Wend
              If pico\mem[pos]<>0
                Debug "LOAD COLLISION"
              EndIf
              If what = #what_gfx Or what = #what_label
                pico\mem[pos]= Val("$" + Mid(line,i+1,1)+Mid(line,i,1))
              Else
                pico\mem[pos]= Val("$" + Mid(line,i,2))
              EndIf  
              
              i+2
              pos+1
            Wend
        EndSelect
        
    EndSelect    
  Wend
  CloseFile(in)
  
  GFX_Create()
  
  Label_Create()
  
  pico_clearbackup()
  
  GFX_CountUsed()
  
  ProcedureReturn #True
  
EndProcedure

Structure sTextField
  x.l
  w.l
EndStructure

;-
Global Dim textField.sTextField(255)
Global.l TextH;,TextW
Procedure Text_Init()
  If spr_font = #Null
    spr_font = CreateSprite(#PB_Any, 32 * 255, 32, #PB_Sprite_AlphaBlending)
  EndIf
  If font = #Null
    font = LoadFont(#PB_Any,"Arial",10)
  EndIf
  
  Protected.l i,xx
  
  StartDrawing(SpriteOutput(spr_font))
  DrawingMode(#PB_2DDrawing_AlphaBlend)
  DrawingFont(FontID(font))
  TextH = TextHeight("1")
  For I=0 To 255
    textField(i)\x = xx
    DrawText(xx+1,1,Chr(i),RGBA(0,0,0,255),0)
    xx=DrawText(xx,0,Chr(i),-1,0)
    textField(i)\w = xx-textField(i)\x
    xx+10
  Next  
  StopDrawing()
  
EndProcedure

Procedure Text_Draw(x.l,y.l,str.s, flags.l = #Text_none)
  Protected.l w,i,c
  If flags & #Text_back
    For i=Len(str) To 1 Step -1
      c=Asc(Mid(str,i,1))
      ClipSprite(spr_font, textField(c)\x, 0, textField(c)\w+1, textH+1)
      x- textField(c)\w
      DisplayTransparentSprite(spr_font,x,y)
    Next
  Else
    For i=1 To Len(str)
      c=Asc(Mid(str,i,1))
      
      ClipSprite(spr_font, textField(c)\x, 0, textField(c)\w+1, textH+1)
      DisplayTransparentSprite(spr_font,x,y)
      x+ textField(c)\w
    Next
  EndIf
EndProcedure

Procedure.l Text_Width(str.s)
  Protected.l w,i,c
  For i=1 To Len(str)
    c=Asc(Mid(str,i,1))
    w+ textField(c)\w
  Next
  ProcedureReturn w
EndProcedure
  
;-
Procedure.a Map_GetIcon(x.l, y.l)
  Protected.l pos
  If y<0
    ProcedureReturn -1
  ElseIf y<32
    pos = #mem_map + 128 * y 
  ElseIf y<64
    pos = #mem_shared + 128 * (y-32)
  Else
    ProcedureReturn -1
  EndIf
  If x<0 Or x>127
    ProcedureReturn -1
  EndIf
  pos + x
  ProcedureReturn pico\mem[pos]
EndProcedure




Procedure.a Map_SetIcon(x.l, y.l, Icon.a)
  Protected.l pos
  
  If x<0 Or x>127
    ProcedureReturn -1
  EndIf
  
  If y<0
    ProcedureReturn -1
  ElseIf y<32
    pos = #mem_map + 128 * y 
    UpdateMap = #True
  ElseIf y<64
    pos = #mem_shared + 128 * (y-32)
    UpdateGFX = #True
  Else
    ProcedureReturn -1
  EndIf
  
  pos + x
  Protected.a ret = pico\mem[pos]
  pico\mem[pos]=icon
  
  ProcedureReturn ret
EndProcedure


Procedure Map_Drawmode_Set(value)
  MapDrawmode = value  
EndProcedure

Procedure Map_ZoomFactor_set(value)
  mapZoomFactor = value
EndProcedure

Procedure Map_ColorSet(value)
  If mapTab = #tab_sprite
    MapColor = value
    ColorCopy\icon[0] = value
    SelectionColorH = 1
    SelectionColorW = 1
  ElseIf maptab = #tab_map
    mapBackColor = value
    UpdateGFX = #True
  EndIf
EndProcedure

Procedure Map_TagSet(value)
  Static.l x,y
  Static.l zoom
  If mapTab = #tab_map
    x = mapCameraX
    y = mapCameraY
    zoom = mapZoomFactor
  ElseIf value = #tab_map
    mapCameraX = x
    mapCameraY = y
    mapZoomFactor = zoom
  EndIf
  If value = #tab_sprite
    mapCameraX = 0
    mapCameraY = 0
    If SelectionW >= 3 Or SelectionH >= 3
      mapZoomFactor = 5
    ElseIf SelectionW = 2 Or SelectionH = 2
      mapZoomFactor = 3
    Else
      mapZoomFactor= 1
    EndIf 
  ElseIf value = #tab_label
    mapCameraX = 0
    mapcameraY = 0
    mapZoomFactor = 1
  EndIf
  mapTab = value
EndProcedure

Procedure Map_Draw()
  Protected.l pos,c,cx,cy,spr,icon
  
  Protected.l x,y,w,h
  Protected.l sx, sy, maxX, maxY,maxPos
  
  Protected.l ww,hh
  Protected.f mapzoom
  
  Screen_Clip(#mapX,#mapY,MapWidth,mapHeight)
  
  If mapTab = #tab_map
    ww = 128
    hh = 64
  ElseIf mapTab = #tab_sprite
    ww = 8 * SelectionW
    hh = 8 * SelectionH
  ElseIf maptab = #tab_label
    ww = 128
    hh = 128
  EndIf
  
  Menu_Set("TabMapMap",    #mapTabX    , #mapTabY, 100, "Map",    Bool(mapTab = #tab_map   ) * #menuflag_selected, @Map_TagSet(), #tab_map)
  Menu_Set("TabMapSprite", #mapTabX+100, #mapTabY, 100, "Sprite", Bool(mapTab = #tab_sprite) * #menuflag_selected, @Map_TagSet(), #tab_sprite)
  menu_set("TabMapLabel",  #mapTabX+200, #mapTabY, 100, "Label" , Bool(mapTab = #tab_label ) * #menuflag_selected, @Map_TagSet(), #tab_label)
  ; check zoom
  If mapTab = #tab_map
    mapzoom =   (mapHeight)/(16.0*8.0 * ((mapZoomFactor-1)*0.5 +1))
  ElseIf mapTab = #tab_sprite
    mapzoom =   (mapHeight)/(8.0*8.0 * ((mapZoomFactor-1)*0.5 +1) )
  ElseIf maptab = #tab_label
    mapzoom = mapHeight / hh
  EndIf
  
  If MapWidth/ww < mapHeight/hh
    If mapZoom * ww*8 < MapWidth
      mapZoom =  MapWidth / (ww*8)
    EndIf
  Else
    If mapZoom * hh*8 < mapHeight
      mapZoom = mapHeight / (hh*8)
    EndIf
  EndIf
  
  If mapzoom <= 0.5 
    mapzoom = 0.5
  EndIf
  
  mapCellSize = Int( mapZoom * 8  )
  
  If mapCellSize < 1
    mapCellSize = 1
  EndIf
  
  ; bilinear filtering on small zooms
  If mapCellSize < 8 ;Or zoom % 8 <> 0
    SpriteQuality(#PB_Sprite_BilinearFiltering)
  Else
    SpriteQuality(#PB_Sprite_NoFiltering)
  EndIf
  
  ; clip map-vision to screen
  maxX = ww - MapWidth / mapCellSize
  maxY = hh - mapHeight / mapCellSize
  
  If maxX<0 : maxX = 0 : EndIf
  If maxY<0 : maxY = 0 : EndIf
  
  If mapCameraX > maxX : mapCameraX = maxX : EndIf
  If mapCameraY > maxY : mapCameraY = maxY : EndIf
  
  If mapCameraX <0 : mapCameraX = 0 :EndIf
  If mapCameraY <0 : mapCameraY = 0 :EndIf
  
  
  If maptab = #tab_label
    Screen_Sprite(spr_label,#mapX,#mapy,ww*mapzoom,hh*mapzoom)
     
  ElseIf mapTab = #tab_sprite
    y = mapCameraY
    sy = 0
    While sy < mapHeight And y < hh
      x = mapCameraX
      sx = 0
      While sx < MapWidth And x < ww
        spr = PicoCopy\icon[ (y/8) * 128 + (x/8) ]
        c = GFX_GetPixel(spr,x & $7, y & $7)
        
        screen_sprite(spr_color(c), sx + #mapX, sy + #mapY, mapCellSize, mapCellSize)
        
        If mapShowID And (sx=0 And sy=0) Or (sx=0 And y%8=0) Or (y%8 = 0 And x % 8=0)
          Text_Draw(sx + #mapX, sy + #mapY, Right("0"+Hex(spr),2)) 
        EndIf
        
        x+1
        sx + mapCellSize
      Wend
      
      y+1
      sy + mapCellSize
    Wend
    
  ElseIf mapTab = #tab_map
    
    y = mapCameraY 
    sy=0
    
    While sy < mapHeight
      If y<32
        pos = #mem_map + 128 * y 
      ElseIf y<64
        pos = #mem_shared + 128 * (y-32)
      Else
        Break
      EndIf
      maxPos = pos + 128
      
      x = mapCameraX
      pos + x
      sx=0  
      While sx < MapWidth And pos < maxPos
        c=pico\mem[pos] & $ff
        
        
        If mapHiNb And c > 127
          Protected.s str = Right("0"+Hex(c),2)
          icon = pico\mem[#mem_gff + c]
          Screen_Sprite2(spr_gfx,sx + #mapX, sy + #mapY, mapCellSize , mapCellSize ,  (icon & $f) *8, ((icon >> 4) & $f) *8, 8, 8)
          Screen_Shadow(sx + #mapX, sy + #mapY, mapCellSize , mapCellSize )
          Text_Draw(sx + #mapX +(mapCellSize - Text_Width(str))/2, sy + #mapY + (mapCellSize - 16)/2, str)
        Else
          Screen_Sprite2(spr_gfx,sx + #mapX, sy + #mapY, mapCellSize , mapCellSize ,  (c & $f) *8, ((c >> 4) & $f) *8, 8, 8)
        EndIf
       
        If mapShowID
          Screen_Shadow(sx + #mapX, sy + #mapY, mapCellSize , mapCellSize )
          Text_Draw(sx + #mapX, sy + #mapY, Right("0"+Hex(c),2)) 
        EndIf
        
        If mapFlashSelection
          If  GFX_IconInSelection(c)
            If flash15
              Screen_Sprite(spr_color(7),sx + #mapX, sy + #mapY, mapCellSize , mapCellSize,128)
            EndIf
          Else
            Screen_Shadow(sx + #mapX, sy + #mapY, mapCellSize , mapCellSize )
          EndIf
        EndIf
        
        pos+1
        x+1
        sx + mapCellSize
      Wend
      
      y+1
      sy + mapCellSize
    Wend
    
  EndIf
  
  SpriteQuality(#PB_Sprite_NoFiltering)
  
  ; screen-splitter-bars
  If maptab = #tab_map Or mapTab = #tab_sprite
    If mapShowGrid
      sx=-mapCameraX * mapCellSize
      ClipSprite(spr_bar,#PB_Default,#PB_Default,#PB_Default,#PB_Default)
      ZoomSprite(spr_bar, 1,mapHeight)
      While sx < MapWidth
        If sx>0
          DisplaySprite(spr_bar,sx + #mapX,0 + #mapY)
        EndIf
        sx + mapCellSize
      Wend
      
      sy=-mapCameraY * mapCellSize
      ClipSprite(spr_bar,#PB_Default,#PB_Default,#PB_Default,#PB_Default)
      ZoomSprite(spr_bar, MapWidth,1)
      While sy < mapHeight
        If sy > 0 
          DisplaySprite(spr_bar,0+ #mapX, sy + #mapY)
        EndIf
        
        sy +  mapCellSize
      Wend
    EndIf
    
    
    If  mapTab = #tab_map
      w=16
    ElseIf mapTab = #tab_sprite
      w=8
    EndIf
    
    sx=-mapCameraX * mapCellSize
    ClipSprite(spr_dot,#PB_Default,#PB_Default,#PB_Default,#PB_Default)
    ZoomSprite(spr_dot, 1,mapHeight)
    While sx < MapWidth
      If sx>0
        DisplaySprite(spr_dot,sx + #mapX,0 + #mapY)
      EndIf
      sx + w * mapCellSize
    Wend
    
    sy=-mapCameraY * mapCellSize
    ClipSprite(spr_dot,#PB_Default,#PB_Default,#PB_Default,#PB_Default)
    ZoomSprite(spr_dot, MapWidth,1)
    While sy < mapHeight
      If sy > 0 
        DisplaySprite(spr_dot,0+ #mapX, sy + #mapY)
      EndIf
      
      sy + w * mapCellSize
    Wend
  EndIf
  
  ; scrollbars 
  If mapTab = #tab_sprite Or maptab = #tab_map
    If maxY > 0
      h = (mapHeight-2) *  (mapHeight/mapCellSize) / hh
      y = (mapHeight-2 -h) * mapCameraY / maxY
    Else
      h = mapHeight -2
      y = 0
    EndIf
    
    ClipSprite(spr_bar,#PB_Default,#PB_Default,#PB_Default,#PB_Default)
    ZoomSprite(spr_bar, #bar,mapHeight)
    DisplaySprite(spr_bar, mapBarX, #mapY)
    
    ClipSprite(spr_dot,#PB_Default,#PB_Default,#PB_Default,#PB_Default)
    ZoomSprite(spr_dot, #bar-2,h)
    DisplaySprite(spr_dot, mapBarX +1, #mapY + 1 + y)
    
    If maxX > 0
      w = (MapWidth-2) *  (MapWidth/mapCellSize) / ww
      x = (MapWidth-2 -w) * mapCameraX / maxX
    Else
      w = MapWidth -2
      x = 0
    EndIf
    
    ClipSprite(spr_bar,#PB_Default,#PB_Default,#PB_Default,#PB_Default)
    ZoomSprite(spr_bar, MapWidth, #bar)
    DisplaySprite(spr_bar, #mapX, mapBarY)
    
    ClipSprite(spr_dot,#PB_Default,#PB_Default,#PB_Default,#PB_Default)
    ZoomSprite(spr_dot, w, #bar-2)
    DisplaySprite(spr_dot, #mapx + 1 + x, mapBarY+1)
    
    mapBarW = w
    mapBarH = h
  EndIf
  
  Menu_Set("BtnMapStamp"   , #mapMenuX, mapMenuY       , 75,"Stamp"   , Bool(MapDrawmode = #Map_Drawmode_stamp) * #menuflag_selected   , @Map_Drawmode_Set(), #Map_Drawmode_stamp)
  Menu_Set("BtnMapBox"     , #mapMenuX, mapMenuY + 17*1, 75,"Box"     , Bool(MapDrawmode = #Map_Drawmode_Box  ) * #menuflag_selected   , @Map_Drawmode_Set(), #Map_Drawmode_Box)
  menu_set("BtnMapSmattbox", #mapMenuX, mapMenuY + 17*2, 75,"SmartBox", Bool(MapDrawmode = #Map_Drawmode_SmartBox) * #menuflag_selected, @Map_Drawmode_Set(), #Map_Drawmode_SmartBox)
  
  Menu_Set("BtnShowDraw", #mapMenuX + 75+5,mapMenuY      ,75,"ID"  , mapShowID   * #menuflag_selected, @ToogleLong(), @mapShowID)
  Menu_Set("BtnShowGrid", #mapMenuX + 75+5,mapMenuY +17*1,75,"Grid", mapShowGrid * #menuflag_selected, @ToogleLong(), @mapShowGrid)
  
  Menu_Set("BtnCopyTrans", #mapMenuX + 75+5+75+5,mapMenuY     ,75,"Copy 00"  , mapCopyTrans      * #menuflag_selected, @ToogleLong(), @mapCopyTrans)
  menu_set("btnFlashSel" , #mapMenuX + 75+5+75+5,mapMenuY+17*1,75,"Find Sel.", mapFlashSelection * #menuflag_selected, @ToogleLong(), @mapFlashSelection)
  Menu_Set("BtnhiNb"     , #mapMenuX + 75+5+75+5,mapMenuY+17*2,75,"Hi as Hex", mapHiNb * #menuflag_selected, @ToogleLong(), @mapHiNb)
  
  Protected.l i
  For i = 0 To 9
    Menu_Set("zoom"+i, mapMenuZoomX + 16*(i % 3), mapMenuY+(i/3)*16, 16, Str(i+1),(Bool(mapZoomFactor = i+1) * #menuflag_selected) | (#menuflag_hidden*Bool(maptab=#tab_label)), @Map_ZoomFactor_set(), i+1)
  Next  
  
  If mapTab = #tab_map
    c = mapBackColor
  ElseIf mapTab = #tab_sprite
    c = MapColor
  ElseIf maptab = #tab_label
    c = -1
  EndIf
  For i = 0 To 15
    Menu_Set("color"+i, mapMenuColorX + 16*(i & $3), mapMenuY+ 16*(i >> 2 &$3), 16, Str(i),(Bool(c = i) * #menuflag_selected) | (#menuflag_hidden*Bool(maptab=#tab_label)) | #menuflag_color, @Map_ColorSet(), i)
  Next  
  
  menu_set("BtnMainLoad",   mainMenuX, mainMenuY     , 75,"Load Cart",0,@PostMenu(),#men_loadCart)
  menu_set("BtnMainSave",   mainMenuX, mainMenuY+17*1, 75,"Merge Cart",0,@PostMenu(),#men_saveCart)
  menu_set("BtnMainExport", mainMenuX, mainMenuY+17*2, 75,"Export",0,@PostMenu(), #men_export)
  menu_set("BtnMainImport", mainMenuX, mainMenuY+17*3, 75,"Import",0,@PostMenu(), #men_import)

  Screen_Clip()
  
EndProcedure

Procedure Map_HandleMouse(x.l,y.l,btn.l)
  Static.l oldBtn, ok
  Static.l mapmode
  Protected.l dx,dy,w,h,icon,xx,yy,c,oldIcon
  Static.l startX,startY,endX,endY
  
  Screen_Clip(#mapX-3, #mapY-3, MapWidth+6, mapHeight+6)
  
  MapCursorIcon = -1
  MapCursorX = -1 
  MapCursorY = -1
  
  If btn = 0
    Mouse_Release(#GrabMouse_MAP)
  EndIf
  
  If  mapmode = #mapmode_none And maptab <> #tab_label
    ; ScrollH
    If x >= mapBarX And x < mapBarX+#bar And
       y >= #mapy And y < #mapY+mapHeight
      If btn & 1 And Mouse_Grab(#GrabMouse_MAP)   
        mapmode = #mapmode_scrollH
      EndIf      
      
      ; ScrollW  
    ElseIf x >= #mapX And x < #mapX+MapWidth And
           y >= mapBarY And y < mapBarY + #bar
      If btn & 1 And Mouse_Grab(#GrabMouse_MAP)    
        mapmode = #mapmode_scrollW
      EndIf      
    EndIf
    
    ; map
    If x >= #mapX And x < #mapX + MapWidth And
       y >= #mapY And y <#mapY + mapHeight
      If btn & 1 And Mouse_Grab(#GrabMouse_MAP)
        Select MapDrawmode
          Case #Map_Drawmode_Stamp    : mapmode = #mapmode_MapLeftStamp
          Case #Map_Drawmode_Box      : mapmode = #mapmode_MapLeftBox
          Case #Map_Drawmode_SmartBox : mapmode = #mapmode_MapLeftSmartBox
        EndSelect
        startX=-1
        startY=-1
        pico_backup()
      ElseIf btn & 2 And Mouse_Grab(#GrabMouse_MAP)
        startX = -1
        startY = -1
        mapmode = #mapmode_MapCopy
      Else
        mapmode = #mapmode_MapShow
      EndIf
    EndIf
  EndIf
  
  ;Rubberband
  If (mapmode = #mapmode_MapLeftBox And btn&1) Or
     (mapmode = #mapmode_MapLeftSmartBox And btn&1) Or
     (mapmode = #mapmode_MapCopy And btn&2)
    
    If x >= #mapX And x < #mapX + MapWidth And
       y >= #mapY And y <#mapY + mapHeight
      x = (x - #mapX) / mapCellSize
      y = (y - #mapY) / mapCellSize
      If startX = -1 Or startY = -1
        startX = x
        startY = y
      Else
        endX = x
        endY = y
      EndIf         
      
      If startx > x
        xx = x
        w = startx-x + 1
      Else
        xx = startx
        w = x-startx +1
      EndIf
      
      If starty > y
        yy = y
        h = starty-y +1
      Else
        yy = starty
        h = y-starty +1
      EndIf
      
      Box_Draw(#mapX + xx * mapCellSize, #mapY + yy * mapCellSize, w * mapCellSize, h * mapCellSize)
      
      If mapmode = #mapmode_MapLeftBox Or mapmode = #mapmode_MapLeftSmartBox
        For dy = 0 To h - 1
          For dx = 0 To w - 1
            If mapmode = #mapmode_MapLeftBox
              icon = (dy % selectionH) * 128 + (dx % selectionW)
            Else
              icon = SmartChoice(dy, selectionH, h) * 128 + SmartChoice(dx, SelectionW, w) 
            EndIf
            
            GFX_DrawIcon( PicoCopy\icon[icon], 
                          #mapX + (xx+dx) * mapCellSize, #mapy + (yy+dy) * mapCellSize, mapCellSize, mapCellSize,128)
            Next
          Next
      EndIf
      
    EndIf
  EndIf
  
  
  
  Select mapmode
    Case #mapmode_none
      ;nothing
      
    Case #mapmode_MapShow
      x = (x - #mapX) / mapCellSize 
      y = (y - #mapY) / mapCellSize
      
      If mapTab = #tab_map 
        xx = x + mapCameraX
        yy = y + mapCameraY
        If xx >= 0 And xx < 128 And yy >=0 And yy < 64
          Box_Draw(#mapX + x * mapCellSize, #mapy + y * mapCellSize, SelectionW * mapCellSize, SelectionH * mapCellSize)
          
          For dy = 0 To selectionH - 1
            For dx = 0 To SelectionW - 1
              GFX_DrawIcon( PicoCopy\icon[dy*128+dx], #mapX + (x+dx) * mapCellSize, #mapy + (y+dy) * mapCellSize,mapCellSize,mapCellSize,128)
            Next
          Next
          
          MapCursorIcon = Map_GetIcon(xx,yy)
          MapCursorX = xx
          MapCursorY = yy
        EndIf
      ElseIf mapTab = #tab_sprite
        dy = (y+mapCameraX)/8
        dx = (x+mapCameraY)/8
        If dx >=0 And dy>= 0 And dx < SelectionW And dy< SelectionH
          Box_Draw(#mapX + x * mapCellSize, #mapy + y * mapCellSize, SelectionColorW * mapCellSize, SelectionColorH * mapCellSize,MapColor)
          MapCursorIcon = PicoCopy\icon[dy*128+dx]
          MapCursorX = x+mapCameraX
          MapCursorY = y+mapCameraY
        EndIf
      EndIf
      
      
      mapmode = #mapmode_none
      
    Case #mapmode_MapCopy
      If x >= #mapX And x < #mapX + MapWidth And
         y >= #mapY And y <#mapY + mapHeight
        If Not  btn & 2
          If startX > endX : Swap startX,endX : EndIf
          If startY > endY : Swap startY,endY : EndIf
          
          w = endX-startX; no -1 because of for-next!
          h = endY-startY
          
          ok = #True
          For dy = 0 To h
            For dx = 0 To w      
              
              If mapTab = #tab_sprite
                
                x= mapCameraX + startX + dX
                y= mapCameraY + startY + dy
                xx = x/8
                yy = y/8
                If xx >=0 And yy>= 0 And xx < SelectionW And yy < SelectionH
                  icon = PicoCopy\icon[ yy * 128 + xx ]
                  ColorCopy\icon[dy*128 + dx] = GFX_GetPixel(icon, x & $7, y & $7)
                EndIf
                
              ElseIf mapTab = #tab_map
                
                picocopy\icon[dy*128 + dx] = Map_GetIcon( mapCameraX + startX + dx, mapCameraY + startY + dy) 
              
                If picocopy\icon[0] + dy<<4 + dx <> picocopy\icon[dy*128 + dx]
                  ok = #False
                EndIf
              EndIf
              
            Next
          Next
          
          If mapTab = #tab_map
            
            If Not ok
              GFXSelX = -1
              GFXSelY = -1
            Else
              GFXSelX = picocopy\icon[0] & $F
              GFXSelY = picocopy\icon[0] >>4 & $F
            EndIf
            SelectionH = h+1
            SelectionW = w+1
            
          ElseIf mapTab = #tab_sprite
            SelectionColorH = h+1
            SelectionColorW = w+1
            mapcolor = 7 ; white border!
            
          EndIf
          
          mapmode = #mapmode_none
        EndIf  
      EndIf
      
    Case #mapmode_MapLeftBox, #mapmode_MapLeftSmartBox
      If x >= #mapX And x < #mapX + MapWidth And
         y >= #mapY And y <#mapY + mapHeight
        If Not  btn & 1
          If startX > endX : Swap startX,endX : EndIf
          If startY > endY : Swap startY,endY : EndIf
          w = endX-startX; no -1 because of for-next!
          h = endY-startY
          
          x = mapCameraX + StartX
          y = mapCameraY + StartY
          
          For dy = 0 To h
            For dx = 0 To w
              
              If mapTab = #tab_map
                If mapmode = #mapmode_MapLeftBox
                  xx = dx % selectionW
                  yy = dy % selectionH
                Else
                  xx = SmartChoice(dx, SelectionW, w+1) 
                  yy = SmartChoice(dy, selectionH, h+1)
                EndIf
                
                icon = picocopy\icon[yy*128 + xx]
                If icon > 0 Or mapCopyTrans Or (SelectionH=1 And SelectionW = 1)
                  oldIcon = Map_SetIcon( x + dx, y + dy, icon) 
                  If mapHiNb And oldIcon<128 And pico\mem[#mem_gff + Icon] = 0
                    pico\mem[#mem_gff + Icon]=oldIcon
                  EndIf
                    
                EndIf
                
              ElseIf mapTab = #tab_sprite
               
                xx = (x+dx)/8
                yy = (y+dy)/8
                If xx >=0 And yy>= 0 And xx < SelectionW And yy< SelectionH
                  icon = PicoCopy\icon[ yy * 128 + xx ]
                  c = ColorCopy\icon[(dy % SelectionColorH) *128+ (dx % SelectionColorW) ]
                  If c > 0 Or mapCopyTrans Or (SelectionColorW=1 And SelectionColorH=1)
                    GFX_SetPixel(icon,(x+dx) & $7, (y+dy) & $7, c)
                  EndIf
                EndIf
                
                
              EndIf
                
            Next
          Next
          
          
          mapmode = #mapmode_none
        EndIf
        
        
        
      ElseIf Not btn&1
        mapmode = #mapmode_none
      EndIf 
      
    Case #mapmode_MapLeftStamp
      If x >= #mapX And x < #mapX + MapWidth And
         y >= #mapY And y <#mapY + mapHeight
        If btn & 1
          x = (x - #mapX) / mapCellSize + mapCameraX
          y = (y - #mapY) / mapCellSize + mapCameraY
          
          If mapTab = #tab_map
            
            For dy = 0 To SelectionH-1
              For dx = 0 To SelectionW-1
                icon = picocopy\icon[dy*128 + dx]
                If icon > 0 Or mapCopyTrans Or (SelectionH=1 And SelectionW = 1)
                  oldicon = Map_SetIcon( x+dx, y+dy, icon )
                  If mapHiNb And oldIcon < 128 And pico\mem[#mem_gff + Icon] = 0
                    pico\mem[#mem_gff + Icon]=oldIcon
                  EndIf
                EndIf
              Next
            Next
            
          ElseIf mapTab = #tab_sprite
            
            For dy = 0 To SelectionColorH-1
              For dx = 0 To SelectionColorW-1
                xx = (x+dx)/8
                yy = (y+dy)/8
                If xx >=0 And yy>= 0 And xx < SelectionW And yy< SelectionH
                  icon = PicoCopy\icon[ yy * 128 + xx ]
                  c = ColorCopy\icon[dy*128+dx]
                  If c > 0 Or mapCopyTrans Or (SelectionColorW=1 And SelectionColorH=1)
                    GFX_SetPixel(icon,(x+dx) & $7, (y+dy) & $7, c)
                  EndIf
                EndIf
              Next
            Next
            
          EndIf
            
        Else
          mapmode = #mapmode_none
        EndIf
      ElseIf Not btn&1
        mapmode = #mapmode_none
      EndIf
      
    Case #mapmode_scrollH
      If btn & 1        
        If mapTab = #tab_map
          h = 64
        ElseIf mapTab = #tab_sprite
          h = SelectionH * 8
        EndIf
        
        mapCameraY = (y-#mapy - mapBarH/2) * h / (mapHeight)
      Else
        mapmode = #mapmode_none
      EndIf   
      
    Case #mapmode_scrollW
      If btn & 1        
        If mapTab = #tab_map
          w = 128
        ElseIf mapTab = #tab_sprite
          w = SelectionW * 8
        EndIf
        
        mapCameraX = (x-#mapX - mapBarW/2) * w / (MapWidth)
      Else
        mapmode = #mapmode_none
      EndIf   
      
    Default
      Debug "UNKNOWN MAPMODE: " + mapmode
      mapmode = #mapmode_none
      
  EndSelect
  
   Screen_Clip()
  
  oldBtn = btn
  
EndProcedure

Procedure Map_ReplaceIcon(s.l,d.l,full.l)
  Protected.l dx,dy
  pico_backup()
  For dy = 0 To 31 + 32 * full
    For dx = 0 To 127
      If Map_GetIcon(dx,dy) = s
        Map_SetIcon(dx, dy, d)
      EndIf
    Next
  Next
  
EndProcedure
;-
Procedure _SaveSprite(spr,file.s,format)
  If file <> "<<clip"
    SaveSprite(spr,file,format)
  Else
    StartDrawing(SpriteOutput(spr))
    Protected img = GrabDrawingImage(#PB_Any,0,0,OutputWidth(),OutputHeight())
    StopDrawing()
    SetClipboardImage(img)
    FreeImage(img)
  EndIf
EndProcedure  

Procedure _SaveSpritePart(spr,x,y,w,h,file.s)
  Protected backup,saveit
  backup = GrabSprite(#PB_Any, 0,0,w,h)
 
  ClipSprite(spr,x,y,w,h)
  DisplaySprite(spr,0,0)
  
  saveit = GrabSprite(#PB_Any, 0,0,w,h)
  _SaveSprite(saveit, file, #PB_ImagePlugin_PNG)
  FreeSprite(saveit)
  
  DisplaySprite(backup, 0,0)
  FreeSprite(backup)
EndProcedure
Procedure _SaveMap(start,size,file.s,xstart=0,xsize=128,selection=#False)
  Protected backup,saveit
  Protected.l x,y,icon
  backup = GrabSprite(#PB_Any,0,0,xsize*8,size*8)
  
  For x=0 To xsize-1
    For y=0 To size-1
      If selection
        icon = PicoCopy\icon[ (start+y) * 128 + (xstart+x) ]
      Else
        icon=Map_GetIcon(x+xstart,y+start)
      EndIf
      ClipSprite(spr_gfx, (icon & $f)*8, (icon >> 4 & $f)*8,8,8)
      DisplaySprite(spr_gfx,x*8,y*8)
    Next
  Next
  
  saveit = GrabSprite(#PB_Any, 0,0,xsize*8,size*8)
  _SaveSprite(saveit, file, #PB_ImagePlugin_PNG)
  FreeSprite(saveit)
  
  DisplaySprite(backup, 0,0)
  FreeSprite(backup)
EndProcedure

Procedure _export_png(what.l, file.s)  
  ClipSprite(spr_gfx,#PB_Default,#PB_Default,#PB_Default,#PB_Default)
  
  Select what.l
    Case #men_export_pngFile_fullGFX, #men_export_pngClip_fullGFX
      _SaveSpritePart(spr_gfx,0,0,128,128,file)
    Case #men_export_pngFile_logGFX, #men_export_pngClip_logGFX
      _SaveSpritePart(spr_gfx,0,0,128,64,file)
    Case #men_export_pngFile_hiGFX, #men_export_pngClip_hiGFX
      _SaveSpritePart(spr_gfx,0,64,128,64,file)
    Case #men_export_pngFile_fullMAP, #men_export_pngClip_fullMAP
      _SaveMap(0,64,file)
    Case #men_export_pngFile_loMAP, #men_export_pngClip_loMAP
      _SaveMap(0,32,file)
    Case #men_export_pngFile_hiMAP, #men_export_pngClip_hiMAP
      _SaveMap(32,32,file)
    Case #men_export_pngFile_label, #men_export_pngClip_label
      _SaveSprite(spr_label,file,#PB_ImagePlugin_PNG)
    Case #men_export_pngFile_map_screen, #men_export_pngClip_map_screen
      Protected.l mapx,mapy
      mapX = (mapCameraX + MapWidth/mapCellSize/2) >> 4 << 4
      MapY = (mapCameraY + mapHeight/mapCellSize/2) >> 4 << 4
      _SaveMap(mapy,16,file,mapx,16)
    Case #men_export_pngFile_selection, #men_export_pngClip_selection 
      _SaveMap(0,SelectionH,file,0,selectionw,#True)
      
  EndSelect
EndProcedure

Procedure export_pngFile(what.l) 
  Protected.s file
  file = SaveFileRequester(#title+" - export png",GetPathPart(cart)+"image.png","png|*.png|all|*.*",0)
  If file ="" 
    ProcedureReturn
  EndIf
  If GetExtensionPart(file)=""
    file+".png"
  EndIf  
  _export_png(what,file)
EndProcedure

Procedure export_pngClip(what)
  _export_png(what,"<<clip")
EndProcedure

Procedure.s _export_luaClip(what.l)
  Protected.l start,size,linewidth=256
  Protected.s out
  Select what
    Case #men_export_luaClip_full, #men_export_luaFile_full
      start = #mem_gfx    : size = $3100 
    Case #men_export_luaClip_fullGFX, #men_export_luaFile_fullGFX
      start = #mem_gfx    : size = $2000
    Case #men_export_luaClip_sprite_lo, #men_export_luaFile_sprite_lo
      start = #mem_gfx    : size = $1000
    Case #men_export_luaClip_map_lo, #men_export_luaFile_map_lo
      start = #mem_map    : size = $1000
    Case #men_export_luaClip_shared, #men_export_luaFile_shared
      start = #mem_shared : size = $1000
    Case #men_export_luaClip_gff, #men_export_luaFile_gff
      start = #mem_gff    : size = 256 : linewidth = 128
    Case #men_export_luaClip_label, #men_export_luaFile_label
      start = #mem_label  : size = $2000
  EndSelect
  
  out = OutP8String(@pico\mem[start],start,size,linewidth)
  ProcedureReturn out
EndProcedure

Procedure export_luaClip(what.l)
  SetClipboardText( _export_luaClip(what))
EndProcedure                 

Procedure Export_LUAFile(what.l)
  Protected.s file
  Protected out
  file = SaveFileRequester(#title+" - export lua",GetPathPart(cart)+"data.lua","lua|*.lua|all|*.*",0)
  If file ="" 
    ProcedureReturn
  EndIf
  If GetExtensionPart(file)=""
    file+".lua"
  EndIf
  
  out = CreateFile(#PB_Any,file)
  If out
    WriteStringN(out, _export_luaClip(what))
    CloseFile(out)
  Else
    MessageRequester(#title,"Can't create file"+#LF$+file)
  EndIf  
EndProcedure     

;   #gfxByteWidth = 4
;   #gfxByteLine = 16 * #gfxByteWidth
;   #gfxByteLine = 128

Procedure _import_png(what.l, file.s)   
  Protected.l w,h,x,y,pos
  Protected img
  
  Select what
    Case #men_import_pngFile_fullGFX, #men_import_pngClip_fullGFX
      pos = #mem_gfx    : w = 128 : h = 128
    Case #men_import_pngFile_loGFX, #men_import_pngClip_loGFX
      pos = #mem_gfx    : w = 128 : h = 64
    Case #men_import_pngFile_hiGFX, #men_import_pngClip_hiGFX
      pos = #mem_shared : w = 128 : h = 64
    Case #men_import_pngFile_label, #men_import_pngClip_label
      pos = #mem_label  : w = 128 : h = 128
    Case #men_import_pngFile_map_screen, #men_import_pngClip_map_screen
      pos = #mem_temp : w = 128 : h = 128
    Case #men_import_pngFile_selection, #men_import_pngClip_selection
      pos = #mem_temp : w = SelectionW * 8 : h = SelectionH * 8
  EndSelect
  
  If file<> "<<clip"
    img = LoadImage(#PB_Any,file)
    If img = 0
      MessageRequester(#title,"Can't load" + #LF$ + file)
      ProcedureReturn
    EndIf
  Else
    img = GetClipboardImage(#PB_Any)
    If img = 0
      ProcedureReturn
    EndIf
  EndIf
  
  pico_backup()
  
  If ImageWidth(img) <> w Or ImageHeight(img) <> h 
    If MessageRequester(#title,"Wrong image size, resize?" + #LF$ + "Needed " + w + "x" + h +", Image " + ImageWidth(img) + " x " + ImageHeight(img), #PB_MessageRequester_YesNo) = #PB_MessageRequester_Yes
      ResizeImage(img, w, h, #PB_Image_Smooth)
    Else
      FillMemory(@pico\mem[pos], 64 * h)
      If w > ImageWidth(img)
        w = ImageWidth(img)
      EndIf
      If h > ImageHeight(img)
        h = ImageHeight(img)
      EndIf
    EndIf
  EndIf
  
  StartDrawing(ImageOutput(img))
  For y = 0 To h-1
    For x = 0 To w-1 Step 2
      pico\mem[ pos + y*64 + x/2 ] = FindBestColorIndex( Point(x,y) ) | FindBestColorIndex( Point(x+1,y) ) << 4
    Next
  Next
  StopDrawing()
  
  Protected.l mapx,mapy,dx,dy,i,choose, srcAdr, gfxAdr, ok    
  If what = #men_import_pngFile_selection Or what = #men_import_pngClip_selection
    For y=0 To selectionH-1
      For x=0 To selectionW-1
        srcAdr = #mem_temp + x*4 + y*4*8*16
        i = PicoCopy\icon[ y * 128 + x ]
        gfxAdr = #mem_gfx + (i & $F)*4 + (i >> 4 & $f)*4*8*16
        
        For dy = 0 To 7
          For dx = 0 To 3
            pico\mem[gfxAdr + dx + dy*4*16] = pico\mem[srcAdr + dx + dy*4*16]
          Next
        Next
      Next
    Next
    
  ElseIf what = #men_import_pngFile_map_screen Or what = #men_import_pngClip_map_screen
    mapX = (mapCameraX + MapWidth/mapCellSize/2) >> 4 << 4
    MapY = (mapCameraY + mapHeight/mapCellSize/2) >> 4 << 4
    
    For y = 0 To 15
      For x = 0 To 15
        ;search fitting charakter
        srcAdr = #mem_temp + x*4 + y*4*8*16
        choose = -1
        For i=0 To 255
          gfxAdr = #mem_gfx + (i & $F)*4 + (i >> 4 & $f)*4*8*16
          ok = #True
          For dy = 0 To 7
            For dx = 0 To 3
              If pico\mem[gfxAdr + dx + dy*4*16] <> pico\mem[srcAdr + dx + dy*4*16]
                ok = #False
                Break 2
              EndIf
            Next
          Next
          If ok
            choose = i
            Break
          EndIf
        Next
        
        ;add charakter if needed
        If choose = -1
          ; search empty
          For i=1 To 255
            gfxAdr = #mem_gfx + (i & $F)*4 + (i >> 4 & $f)*4*8*16
            ok = #True
            For dy = 0 To 7
              For dx = 0 To 3
                If pico\mem[gfxAdr + dx + dy*4*16] <> 0
                  ok = #False
                  Break 2
                EndIf
              Next
            Next
            If ok
              choose = i
              Break
            EndIf
          Next
          ; add to empty
          If choose > 0 
            gfxAdr = #mem_gfx + (choose & $F)*4 + (choose >> 4 & $f)*4*8*16
            ok = #True
            For dy = 0 To 7
              For dx = 0 To 3
                pico\mem[gfxAdr + dx + dy*4*16] = pico\mem[srcAdr + dx + dy*4*16]
              Next
            Next
          EndIf          
        EndIf
        
        If choose >= 0
          Map_SetIcon(mapx+x,mapy+y,choose)
        EndIf
        
      Next
    Next
  EndIf
  
  FreeImage(img)
  
  FillMemory(@pico\mem[#mem_temp], 64 * h) ; clear temp
  UpdateGFX = #True
  UpdateMap = #True
  Label_Create()
EndProcedure

Procedure import_pngFile(what.l)
  Protected.s file
  file = OpenFileRequester(#title+" - import image",GetPathPart(cart)+"image.png","image|*.png;*.tif;*.tiff;*.tga;*.jpg;*.gif;*.bmp|all|*.*",0)
  If file ="" Or FileSize(file) <= 0 
    ProcedureReturn
  EndIf
  _import_png(what,file)
EndProcedure

Procedure import_pngClip(what.l)
  _import_png(what,"<<clip")
EndProcedure


Procedure.s _import_luaClip(what.l,str.s)
  Protected.l start,size,linewidth=256
  
  pico_backup()
  
  Select what
    Case #men_import_luaClip_full, #men_import_luaFile_full
      start = #mem_gfx    : size = $3100    
    Case #men_import_luaClip_fullGFX, #men_import_luaFile_fullGFX
      start = #mem_gfx    : size = $2000
    Case #men_import_luaClip_sprite_lo, #men_import_luaFile_sprite_lo
      start = #mem_gfx    : size = $1000
    Case #men_import_luaClip_map_lo, #men_import_luaFile_map_lo
      start = #mem_map    : size = $1000
    Case #men_import_luaClip_shared, #men_import_luaFile_shared
      start = #mem_shared : size = $1000
    Case #men_import_luaClip_gff, #men_import_luaFile_gff
      start = #mem_gff    : size = 256 : linewidth = 128
    Case #men_import_luaClip_label, #men_import_luaFile_label
      start = #mem_label  : size = $2000
  EndSelect
  InP8String(str,@pico\mem[start],size)
  UpdateGFX = #True
  UpdateMap = #True
  Label_Create()
EndProcedure

Procedure import_luaClip(what.l)
  _import_luaClip(what, GetClipboardText() )  
EndProcedure                 

Procedure Import_LUAFile(what.l)
  Protected.s file, str
  Protected in
  file = OpenFileRequester(#title+" - import lua",GetPathPart(cart)+"data.lua","lua|*.lua|all|*.*",0)
  If file ="" Or FileSize(file) <= 0
    ProcedureReturn
  EndIf
  
  in = ReadFile(#PB_Any,file)
  If in = 0 
    MessageRequester(#title,"Can't open file." + #LF$ + file)
    ProcedureReturn
  EndIf
  
  While Not Eof(in)
    str + ReadString(in) + #LF$
  Wend
  CloseFile(in)
  
  _import_luaClip(what, str)  
EndProcedure    

;-


;-start





;Define.s cart = "C:\Programme_NoInstall\pico-8\config\carts\demos\jelpi.p8"
;Define.s cart = "C:\Programme_NoInstall\pico-8\config\carts\games\cel.pb.p8"
;Define.s cart = "C:\Programme_NoInstall\pico-8\config\carts\pacman4.p8"

win = OpenWindow(#PB_Any, 0,0, #winWdefault, #winHdefault ,#title+" - Version "+#version,#PB_Window_SystemMenu|#PB_Window_Invisible|#PB_Window_SizeGadget)
If win=0 
  MessageRequester(#title, "Can't open window")
  End
EndIf

WindowBounds(win, #winWmin, #winHmin, #winWMax, #winHmax)
Window_Resize()
SetWindowColor(win, RGB(80,80,80))

If Not OpenWindowedScreen(WindowID(win),0,0,#winWMax,#winHmax,#False,0,0)
  MessageRequester(#title, "Can't open screen")
  End
EndIf

SetFrameRate(30)



spr_dot = CreateSprite(#PB_Any,1,1)
StartDrawing(SpriteOutput(spr_dot))
Plot(0,0,RGB(40,40,40))
StopDrawing()

spr_bar = CreateSprite(#PB_Any,1,1)
StartDrawing(SpriteOutput(spr_bar))
Plot(0,0,RGB(150,150,150))
StopDrawing()

spr_shadow = CreateSprite(#PB_Any,1,1,#PB_Sprite_AlphaBlending )
StartDrawing(SpriteOutput(spr_shadow))
DrawingMode(#PB_2DDrawing_AllChannels)
Plot(0,0,RGBA(0,0,0,128))
StopDrawing()


Define.l i
For i=0 To 15
  spr_color(i) = CreateSprite(#PB_Any,1,1,#PB_Sprite_AlphaBlending)
  StartDrawing(SpriteOutput(spr_color(i)))
  DrawingMode(#PB_2DDrawing_AllChannels)
  Plot(0,0,color(i))
  StopDrawing()
Next

Text_Init()

For i=0 To 8
  AddKeyboardShortcut(win, #PB_Shortcut_Pad1+i, #Men_zoom1+i)
Next
AddKeyboardShortcut(win, #PB_Shortcut_Pad0, #Men_zoom10)

For i=0 To 7
  AddKeyboardShortcut(win, #PB_Shortcut_1+i, #men_color0+i)
  AddKeyboardShortcut(win, #PB_Shortcut_Shift | #PB_Shortcut_1+i, #men_color0+8+i)
Next

AddKeyboardShortcut(win, #PB_Shortcut_Up,#men_upIcon)
AddKeyboardShortcut(win, #PB_Shortcut_Down,#men_downIcon)
AddKeyboardShortcut(win, #PB_Shortcut_Left,#men_leftIcon)
AddKeyboardShortcut(win, #PB_Shortcut_Right,#men_rightIcon)
AddKeyboardShortcut(win, #PB_Shortcut_W,#men_upIcon)
AddKeyboardShortcut(win, #PB_Shortcut_S,#men_downIcon)
AddKeyboardShortcut(win, #PB_Shortcut_A,#men_leftIcon)
AddKeyboardShortcut(win, #PB_Shortcut_D,#men_rightIcon)

AddKeyboardShortcut(win,#PB_Shortcut_Control | #PB_Shortcut_Up,#men_up)
AddKeyboardShortcut(win,#PB_Shortcut_Control | #PB_Shortcut_Down,#men_down)
AddKeyboardShortcut(win,#PB_Shortcut_Control | #PB_Shortcut_Left,#men_left)
AddKeyboardShortcut(win,#PB_Shortcut_Control | #PB_Shortcut_Right,#men_right)
AddKeyboardShortcut(win,#PB_Shortcut_Control | #PB_Shortcut_W,#men_up)
AddKeyboardShortcut(win,#PB_Shortcut_Control | #PB_Shortcut_S,#men_down)
AddKeyboardShortcut(win,#PB_Shortcut_Control | #PB_Shortcut_A,#men_left)
AddKeyboardShortcut(win,#PB_Shortcut_Control | #PB_Shortcut_D,#men_right)

AddKeyboardShortcut(win,#PB_Shortcut_Shift | #PB_Shortcut_Up,#men_upSlow)
AddKeyboardShortcut(win,#PB_Shortcut_Shift | #PB_Shortcut_Down,#men_downSlow)
AddKeyboardShortcut(win,#PB_Shortcut_Shift | #PB_Shortcut_Left,#men_leftSlow)
AddKeyboardShortcut(win,#PB_Shortcut_Shift | #PB_Shortcut_Right,#men_rightSlow)
AddKeyboardShortcut(win,#PB_Shortcut_Shift | #PB_Shortcut_W,#men_upSlow)
AddKeyboardShortcut(win,#PB_Shortcut_Shift | #PB_Shortcut_S,#men_downSlow)
AddKeyboardShortcut(win,#PB_Shortcut_Shift | #PB_Shortcut_A,#men_leftSlow)
AddKeyboardShortcut(win,#PB_Shortcut_Shift | #PB_Shortcut_D,#men_rightSlow)

AddKeyboardShortcut(win,#PB_Shortcut_Control | #PB_Shortcut_Z, #men_undo)
AddKeyboardShortcut(win,#PB_Shortcut_Control | #PB_Shortcut_Y, #men_redo)

AddKeyboardShortcut(win,#PB_Shortcut_Control | #PB_Shortcut_C, #men_copy)
AddKeyboardShortcut(win,#PB_Shortcut_Control | #PB_Shortcut_V, #men_paste)

;- create menus
CreatePopupMenu(#men_replace)
MenuItem(#men_replaceDummy,"Replace white selection with red-mark icon")
MenuItem(#men_replaceCompleteWorld,"complete map")
MenuItem(#men_replaceUpperHalf,"unshared map")
DisableMenuItem(#men_replace, #men_replaceDummy, #True)

CreatePopupMenu(#men_copy)
OpenSubMenu("Copy IMAGE")
MenuItem(#men_export_pngClip_fullGFX, "Sprites complete")
MenuItem(#men_export_pngClip_logGFX, "Sprites low")
MenuItem(#men_export_pngClip_hiGFX,"Sprites high")
MenuItem(#men_export_pngClip_fullMAP, "Map complete")
MenuItem(#men_export_pngClip_loMAP, "Map low")
MenuItem(#men_export_pngClip_hiMAP,"Map high")
MenuItem(#men_export_pngClip_label,"Label")
MenuItem(#men_export_pngClip_map_screen,"Map screen (center)")
MenuItem(#men_export_pngClip_selection,"Sprite selection")
CloseSubMenu()
OpenSubMenu("Copy LUA")
MenuItem(#men_export_luaClip_full,"Complete")
MenuItem(#men_export_luaClip_fullGFX,"Sprites complete")
MenuItem(#men_export_luaClip_sprite_lo,"Sprites low")
MenuItem(#men_export_luaClip_shared,"Shared (sprite && map high)")
MenuItem(#men_export_luaClip_map_lo,"Map low")
MenuItem(#men_export_luaClip_gff,"Sprite flags")
MenuItem(#men_export_luaClip_label,"Label (as screen data)")
CloseSubMenu()


CreatePopupMenu(#men_export)
OpenSubMenu("IMAGE - file")
MenuItem(#men_export_pngFile_fullGFX, "Sprites complete")
MenuItem(#men_export_pngFile_logGFX, "Sprites low")
MenuItem(#men_export_pngFile_hiGFX,"Sprites high")
MenuItem(#men_export_pngFile_fullMAP, "Map complete")
MenuItem(#men_export_pngFile_loMAP, "Map low")
MenuItem(#men_export_pngFile_hiMAP,"Map high")
MenuItem(#men_export_pngFile_label,"Label")
MenuItem(#men_export_pngFile_map_screen,"Map screen (center)")
MenuItem(#men_export_pngFile_selection,"Sprite selection")
CloseSubMenu()
OpenSubMenu("LUA - file")
MenuItem(#men_export_luaFile_full,"Complete")
MenuItem(#men_export_luaFile_fullGFX,"Sprites complete")
MenuItem(#men_export_luaFile_sprite_lo,"Sprites low")
MenuItem(#men_export_luaFile_map_lo,"Map low")
MenuItem(#men_export_luaFile_shared,"Shared (sprite && map high)")
MenuItem(#men_export_luafile_gff,"Sprite flags")
MenuItem(#men_export_luaFile_label,"Label (as screen data)")
CloseSubMenu()
MenuBar()
OpenSubMenu("IMAGE - clipboard")
MenuItem(#men_export_pngClip_fullGFX, "Sprites complete")
MenuItem(#men_export_pngClip_logGFX, "Sprites low")
MenuItem(#men_export_pngClip_hiGFX,"Sprites high")
MenuItem(#men_export_pngClip_fullMAP, "Map complete")
MenuItem(#men_export_pngClip_loMAP, "Map low")
MenuItem(#men_export_pngClip_hiMAP,"Map high")
MenuItem(#men_export_pngClip_label,"Label")
MenuItem(#men_export_pngClip_map_screen,"Map screen (center)")
MenuItem(#men_export_pngClip_selection,"Sprite selection")
CloseSubMenu()
OpenSubMenu("LUA - clipboard")
MenuItem(#men_export_luaClip_full,"Complete")
MenuItem(#men_export_luaClip_fullGFX,"Sprites complete")
MenuItem(#men_export_luaClip_sprite_lo,"Sprites low")
MenuItem(#men_export_luaClip_shared,"Shared (sprite && map high)")
MenuItem(#men_export_luaClip_map_lo,"Map low")
MenuItem(#men_export_luaClip_gff,"Sprite flags")
MenuItem(#men_export_luaClip_label,"Label (as screen data)")
CloseSubMenu()

CreatePopupMenu(#men_pasteImage)
MenuItem(#men_import_pngClip_fullGFX,"Sprite complete")
MenuItem(#men_import_pngClip_loGFX,"Sprite low")
MenuItem(#men_import_pngClip_hiGFX,"Sprite high")
MenuItem(#men_import_pngClip_label,"Label")
MenuItem(#men_import_pngClip_map_screen,"Map screen (center)")
MenuItem(#men_import_pngClip_selection,"Sprite selection")

CreatePopupMenu(#men_pasteText)
MenuItem(#men_import_luaClip_full,"Complete")
MenuItem(#men_import_luaClip_fullGFX,"Sprites complete")
MenuItem(#men_import_luaClip_sprite_lo,"Sprites low")
MenuItem(#men_import_luaClip_shared,"Shared (sprite && map high)")
MenuItem(#men_import_luaClip_map_lo,"Map low")
MenuItem(#men_import_luaClip_gff,"Sprite flags")
MenuItem(#men_import_luaClip_label,"Label")

CreatePopupMenu(#men_import)
OpenSubMenu("IMAGE - file")
MenuItem(#men_import_pngFile_fullGFX,"Sprite complete")
MenuItem(#men_import_pngFile_loGFX,"Sprite low")
MenuItem(#men_import_pngFile_hiGFX,"Sprite high")
MenuItem(#men_import_pngFile_label,"Label")
MenuItem(#men_import_pngFile_map_screen,"Map screen (center)")
MenuItem(#men_import_pngFile_selection,"Sprite selection")
CloseSubMenu()
OpenSubMenu("LUA - file")
MenuItem(#men_import_luaFile_full,"Complete")
MenuItem(#men_import_luaFile_FullGFX,"Sprites complete")
MenuItem(#men_import_luaFile_sprite_lo,"Sprites low")
MenuItem(#men_import_luaFile_map_lo,"Map low")
MenuItem(#men_import_luaFile_shared,"Shared (sprite && map high)")
MenuItem(#men_import_luafile_gff,"Sprite flags")
MenuItem(#men_import_luaFile_label,"Label")
CloseSubMenu()
MenuBar()
OpenSubMenu("IMAGE - clipboard")
MenuItem(#men_import_pngClip_fullGFX,"Sprite complete")
MenuItem(#men_import_pngClip_loGFX,"Sprite low")
MenuItem(#men_import_pngClip_hiGFX,"Sprite high")
MenuItem(#men_import_pngClip_label,"Label")
MenuItem(#men_import_pngClip_map_screen,"Map screen (center)")
MenuItem(#men_import_pngClip_selection,"Sprite selection")
CloseSubMenu()
OpenSubMenu("LUA - clipboard")
MenuItem(#men_import_luaClip_full,"Complete")
MenuItem(#men_import_luaClip_fullGFX,"Sprites complete")
MenuItem(#men_import_luaClip_sprite_lo,"Sprites low")
MenuItem(#men_import_luaClip_shared,"Shared (sprite && map high)")
MenuItem(#men_import_luaClip_map_lo,"Map low")
MenuItem(#men_import_luaClip_gff,"Sprite flags")
MenuItem(#men_import_luaClip_label,"Label")
CloseSubMenu()



SpriteQuality(#PB_Sprite_NoFiltering)

;Cartridge_Load(cart)
pico_clear()
GFX_Create()
Label_Create()
pico_clearbackup()
GFX_CountUsed()

AddWindowTimer(win, #tim_flash15, 1000/15)

HideWindow(win,#False,#PB_Window_ScreenCentered)

Define event,img
Define.l mbutton
Define.l mclick
Define.l MClickX, MClickY, d
Define.l DoResize, SpecialKey
Define.s str
Repeat
  mclick = 0
  DoResize = #False

  SpecialKey = 0
  

  Repeat
    event= WindowEvent()
    Select event
      Case #PB_Event_Timer
        flash15 ! 1
        
      Case #PB_Event_RestoreWindow, #PB_Event_SizeWindow        
        DoResize = #True
      Case #PB_Event_DeactivateWindow
        mbutton = 0
        mclick = 0
        
      Case #WM_LBUTTONDOWN
        mbutton | 1
        mClickX = WindowMouseX(win)
        mClickY = WindowMouseY(win)
        SpecialKey = EventwParam() & (8+4)
      Case #WM_LBUTTONUP
        mbutton & ~1
        mclick | 1
        SpecialKey = EventwParam() & (8+4)
      Case #WM_RBUTTONDOWN
        mbutton | 2
        mClickX = WindowMouseX(win)
        mClickY = WindowMouseY(win)
        SpecialKey = EventwParam() & (8+4)
      Case #WM_RBUTTONUP
        mbutton & ~2
        mclick | 2
        SpecialKey = EventwParam() & (8+4)
        
      Case #WM_MOUSEWHEEL
        Define.w wheel
        wheel=EventwParam()>>$10 & $ffff
        wheel / 120
        If mapTab = #tab_map
          PicoCopy\icon[0] = (PicoCopy\icon[0]+wheel) & $ff
          GFXSelX = PicoCopy\icon[0] & $F
          GFXSelY = PicoCopy\icon[0] >>4 & $f
          SelectionH = 1
          SelectionW = 1
        ElseIf mapTab = #tab_sprite
          MapColor = (MapColor + wheel) & $f
          ColorCopy\icon[0] = MapColor 
          SelectionColorH = 1
          SelectionColorW = 1
        EndIf
        
      Case #PB_Event_CloseWindow
        Break 2
        
      Case #PB_Event_Menu ;- menu
        mbutton = 0
        Select EventMenu()
          Case #Men_zoom1 To #Men_zoom10
            mapZoomFactor = EventMenu() - #Men_zoom1 +1
            
          Case #men_left
            d = mapCameraX +MapWidth/mapCellSize/2       
            mapCameraX = (d & $f0 -16)  - (MapWidth/mapCellSize -16)/2
          Case #men_right
            d = mapCameraX +MapWidth/mapCellSize/2            
            mapCameraX = (d & $f0 +16)  - (MapWidth/mapCellSize -16)/2            
          Case #men_up  
            d = mapCameray +mapHeight/mapCellSize/2       
            mapCameray = (d & $f0 -16)  - (mapHeight/mapCellSize -16)/2
          Case #men_down
            d = mapCameraY +mapHeight/mapCellSize/2            
            mapCameraY= (d & $f0 +16)  - (mapHeight/mapCellSize -16)/2
            
          Case #men_leftSlow            
            mapCameraX -1
          Case #men_rightSlow            
            mapCameraX +1
          Case #men_upSlow
            mapCameray -1
          Case #men_downSlow
            mapCameraY +1
            
          Case #men_leftIcon        
            GFX_MoveCursor(-1,0)
          Case #men_rightIcon         
            GFX_MoveCursor(1,0)
          Case #men_upIcon
            GFX_MoveCursor(0,-1)
          Case #men_downIcon
            GFX_MoveCursor(0,1)
            
          Case #men_color0 To #men_color15
            Map_ColorSet(EventMenu() - #men_color0)
            
          Case #men_undo
            pico_undo()
          Case #men_redo
            pico_redo()
            
          Case #men_replace
            DisplayPopupMenu(#men_replace,WindowID(win))
                       
          Case #men_replaceCompleteWorld, #men_replaceUpperHalf
            Map_ReplaceIcon(PicoCopy\icon[0], GFXMap_ReplaceIcon, Bool(EventMenu() = #men_replaceCompleteWorld) )
            
          Case #men_loadCart
            str = OpenFileRequester(#title+" - Load Cart", cart, "p8|*.p8|all|*.*",0)
            If str <>"" And FileSize(str)> 0 
              Cartridge_Load(str)
              cart = str
            EndIf
            
          Case #men_saveCart
            str = SaveFileRequester(#title+" - Merge Cart", cart, "p8|*.p8|all|*.*",0)
            If str <>"" 
              Cartridge_Save(str)
              cart = str
            EndIf
            
          Case #men_export
            DisableMenuItem(#men_export, #men_export_pngFile_map_screen, Bool(mapTab <> #tab_map))
            DisableMenuItem(#men_export, #men_export_pngClip_map_screen, Bool(mapTab <> #tab_map))
            DisplayPopupMenu(#men_export, WindowID(win))
            
          Case #men_copy
            DisableMenuItem(#men_copy, #men_export_pngClip_map_screen, Bool(mapTab <> #tab_map))
            DisplayPopupMenu(#men_copy, WindowID(win))
                        
          Case #men_export_pngFile_fullGFX, #men_export_pngFile_logGFX, #men_export_pngFile_hiGFX, #men_export_pngFile_fullMAP, #men_export_pngFile_loMAP, 
               #men_export_pngFile_hiMAP, #men_export_pngFile_label, #men_export_pngFile_map_screen, #men_export_pngFile_selection
            export_pngFile(EventMenu())
            
          Case #men_export_pngClip_fullGFX, #men_export_pngClip_logGFX, #men_export_pngClip_hiGFX, #men_export_pngClip_fullMAP, #men_export_pngClip_loMAP, 
               #men_export_pngClip_hiMAP, #men_export_pngClip_label, #men_export_pngClip_map_screen, #men_export_pngClip_selection
            export_pngClip(EventMenu())
            
            
          Case #men_export_luaClip_full, #men_export_luaClip_sprite_lo, #men_export_luaClip_map_lo, #men_export_luaClip_shared, #men_export_luaClip_gff, 
               #men_export_luaClip_label, #men_export_luaClip_fullGFX
            export_luaClip(EventMenu())     
            
          Case #men_export_luaFile_full, #men_export_luaFile_sprite_lo, #men_export_luaFile_map_lo, #men_export_luaFile_shared, #men_export_luaFile_gff,
               #men_export_luaFile_label, #men_export_luaFile_fullGFX
            export_luaFile(EventMenu())     
            
          Case #men_import
            DisableMenuItem(#men_import, #men_import_pngFile_map_screen, Bool(mapTab <> #tab_map))
            DisableMenuItem(#men_import, #men_import_pngClip_map_screen, Bool(mapTab <> #tab_map))
            DisplayPopupMenu(#men_import, WindowID(win))
            
          Case #men_paste
            If Len(GetClipboardText())>0
              DisplayPopupMenu(#men_pasteText,WindowID(win))
            Else
              img = GetClipboardImage(#PB_Any)
              If img
                FreeImage(img)
                DisableMenuItem(#men_pasteImage, #men_import_pngClip_map_screen, Bool(mapTab <> #tab_map))
                DisplayPopupMenu(#men_pasteImage, WindowID(win))
              EndIf
            EndIf
            
          Case #men_import_pngClip_fullGFX, #men_import_pngClip_loGFX, #men_import_pngClip_hiGFX, #men_import_pngClip_label, #men_import_pngClip_map_screen,
               #men_import_pngClip_selection
            import_pngClip(EventMenu())
            
          Case #men_import_pngFile_fullGFX, #men_import_pngFile_loGFX, #men_import_pngFile_hiGFX, #men_import_pngFile_label, #men_import_pngFile_map_screen,
               #men_import_pngFile_selection
            import_pngFile(EventMenu())
            
          Case #men_import_luaClip_full, #men_import_luaClip_sprite_lo, #men_import_luaClip_map_lo, #men_import_luaClip_shared, #men_import_luaClip_gff,
               #men_import_luaClip_label, #men_import_luaClip_fullGFX
            import_luaClip(EventMenu())     
            
          Case #men_import_luaFile_full, #men_import_luaFile_sprite_lo, #men_import_luaFile_map_lo, #men_import_luaFile_shared, #men_import_luaFile_gff,
               #men_import_luaFile_label, #men_import_luaFile_FullGFX
            import_luaFile(EventMenu())     
          
        EndSelect
        
        
    EndSelect
  Until event = 0
  
  If DoResize
    Window_Resize()
    mbutton = 0
    mclick = 0
  EndIf
  
  ClearScreen(RGB(80,80,80))
  
  If UpdateGFX And mbutton = 0
    GFX_Create()
    GFX_CountUsed()
    UpdateGFX = #False
    UpdateMap = #False
  ElseIf UpdateMap And mbutton = 0
    GFX_CountUsed()
    UpdateMap = #False    
  EndIf
  
  Map_Draw()
  GFX_Draw()  
  
  
  Define.l x,y
  x=WindowMouseX(win)
  y=WindowMouseY(win)
  
  If x<0 Or y<0
    mbutton = 0
  EndIf
  
  Menu_Draw(x, y, mclick)
    
  Map_HandleMouse(x,y,mbutton)
  GFX_HandleMouse(x,y,mbutton,SpecialKey)
  
  ; don't click-move from outside
  If mbutton
    Mouse_Grab(#GrabMouse_Outside)
  Else
    Mouse_Release(#GrabMouse_Outside)
  EndIf
    
  Delay(1)
  FlipBuffers()
ForEver

pico_clear()

CloseScreen()
CloseWindow(win)




; IDE Options = PureBasic 5.73 LTS (Windows - x86)
; CursorPosition = 2808
; FirstLine = 2766
; Folding = -------------
; EnableXP
; UseIcon = GFXedit-pixel.ico
; Executable = GFXedit  (x86).exe
; SubSystem = opengl