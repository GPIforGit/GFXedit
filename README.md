GFXedit for Pico8
-----------------

![picture alt](https://github.com/GPIforGit/GFXedit/blob/main/GFXedit.jpg "Gfx editor")

Short
-----
GFXedit is a small tool to handle the sprite, map und label data from a p8-file with many
features, like export and import as png or lua-data, copy&paste, display the usage of sprite
and many more.

Sprite-Overview (left side)
---------------------------
You can simple select an sprite with a left click. If you hold down the mouse button, you
can select a group of sprites.
With a right click you can Copy the current selected sprite to the "red border" place.
When you have selected only one sprite, shift + right click will replace every appearance
in the map.
Over/Under the Sprite overviews are Tabs. "Low" to show the sprites <= 127, "High" for
sprites >=128 and "Minimap" to activate the minimap.
Under the Sprite-overview you can find the coordinates in the world (if the cursor is in
the Worldmap, the ID of the sprite under the cursor and the flags of the ID under the cursor.
You can also sets flags of the current selected sprite here.
Below that you find some views:

"Flags" activate a small bar under every sprite with small indicators which flag is activ.

"ID" show the HEX-Id over every Sprite

"Count" show of often a sprite is used.

"Grid" activate a small grid


Editor-Overview (right side)
----------------------------
You can select between "Map" - the world editor, "Sprite" - the sprite editor and "Label" a 
label-viewer of the p8-file.
Map and Sprite can be edit, labels only displayed (but in- and exported). 
With left click you draw in the map/sprite, with right-click you select a current object under 
the cursor. You can select multiply objects with the rubber band to copy complete structures.
You can even select multiply objects in the map and switch to the sprite-mode to edit this 
object.
Under the editor field you find some options:

"Stamp" - simple draw in the map / sprite 

"Line" - draw a line

"Box" - draw a box

"Ellipse" - draw a ellipse

"Fill" - fill (on map it is clipped by the current visible screen)

"Filled Box" - a filled box

"SmartBox" - a variant of box, when you select an 3x3 pattern in the sprite sheet, it will
then draw a box in the editor, it will more "stretch" the selection to the draw box.

"ID" - display the id over every tile in the editor.

"Grid" - display a grid over the editor

"Copy 00" - when active (default) sprite-id 00 and color 0 is draw with stamp/box. Otherwise
it will be ignored / transparent.

"Find Sel." - the current objects blinks now in the editor and minimap.

"Hi as Hex" - A special and experimental mode. Since "Sprite High" and "Map High" use the 
same memory, many prefer the map data. Now the high bit is completed unused in the map data.
The idea here is, that you can use the useless High-Sprites as indicators in the world.
For example place a sign the world (from the lower sprites), activate the "Hi as Hex"-mode,
now select a high-sprite (for example "80") and place it over the sign in the map.
The sign-ID is now copied to the Sprite-flag of "80" and the editor shows a sign with an 80
over it.
Of course PICO8 can't handle this, you must write a code that scan the map-data for sprites
over 128, store the places in a table and replace the map-data with the sprite-flag of the
high-byte-sprite.

"Colorfield" - in map mode you can select a background color, in sprite mode the current color.

"1" to "10" - a zoom mode.

"Load Cart" - load data from an p8-file. Only graphics, sound and lua data are ignored. 

"Merge Cart" - select an p8-file and it will replace the graphic-data in this file.


Export
------
you have here multiply options to export any kind of data.
You can export as image:

"Sprite complete" - export the complete sprite-sheet (128x128 pixels)

"Sprites low" - export the sprites 0-127 (128x64 pixels)

"Sprites high" - export the sprites 128-255 in the shared memory (128x64 pixels)

"Map complete" - export the complete world map (1024x512 pixels)

"Map low" - export the "upper" part of the map (1024x256 pixels)

"Map high" - export the "lower" part of the map in shared memory (1024x256 pixels)

"Label" - export the label used for cartridge-export of pico8

"Map screen" - the middle 16x16 tile big screen in the map-editor as image (128x128 pixels)

"Sprite selection" - the current selected sprite (vary in size)

You can also export as lua-data. You can then copy this data in the pico8 code editor and
switch dynamical between diffrent sprite oder mapdata. You can also use this to exchange
maps between p8-files.

"complete" - contains all map, sprite and spriteflags.

"sprites complete" - contains low and high sprites

"sprites low " - contains sprites with id <= 127

"Map low " - the upper part of the map

"Shared" - the shared part the sprite/map data

"Sprites-flags" - the flag data of the spritesheet

"label" - the cart-label - it use address 0x6000 (Screen data), when you want for example 
title-screen.

To load the data you need some additional code:

	function str2mem(data)
		local t,a,i,c,d,str,m = split(data)
		for a = 1,#t,2 do  
			m,str,i=t[a],t[a+1],1
			while i <= #str do
				c,d= ord(str,i,2)
				i+=c==255 and 2 or 1
				if (c>16) poke(m, c==255 and d or c^^0x80) m+=1
			end
		end
	end
	
	data = [[
	--some funny chars from the export
	]]
	
	str2mem(data)

	
Import
------
Almost the same as the export. You can import any image. Colours are automatic translated
to the pico8 colour palette. When a image is too big, it can be cropped or resized.
Something special is "Map screen (center)" for images. It will split the image in 8x8 tiles
and try to find this tiles in the Sprite sheet. If it not exist, it will replace the first
free tile (complete black ones) with this tile. 
When you import text/lua, the exported destination is ignored. You can for example import a 
label as sprite sheet.


Keyboard
--------
Mouse wheel - change selection of sprite (map) or color (sprite)

ctrl + wheel - change zoom

0-8/ shift + 0-8 - change current/background color

Num0 - Num9 - change zoom level

Cursor keys / asdw - change selected sprite (map) or color ( sprite)

shift + cursor keys / asdw - move world map

ctrl + cursor keys / asdw - move world map screen wide

ctrl + z - undo

ctrl + y - redo

ctrl + c - copy/export menu

ctrl + v - pate/import menu

ctrl + o - open

ctrl + s - merge/save

alt + cursor - Sprite-editor: shift sprite

alt+shift + cursor - Sprite-editor: flip sprite

R - Sprite-editor: rotate sprite



About the string format
-----------------------
Graphic data are too big for a string in "", but enclose it with [[]] has the disadvantage 
that escape-sequenzes are not possible. Also chars lower 16 are not printable.

Chars lower than code 16 must be encode in a special form. Also some special characters like 
"[]," must be encoded to prevent conflicts.

Because chars lower than code 16 are very common (especially code zero), I first flip the 
high-bit of the char (m = char ^^ 0x80). If m is now lower 16 or one of the special characters, 
I store the in the string a sequenz of "chr(0xff)..chr(m ^^ 0x80)" otherwise a simple "chr(m)".


Infos
-----
Icon made by https://www.freepik.com from https://www.flaticon.com/
