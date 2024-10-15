#SingleInstance force
#NoEnv ;Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn ;Enable warnings to assist with detecting common errors.
#Persistent
#MaxThreadsPerHotkey 2

SetTitleMatchMode 1
SendMode Input ;Recommended for new scripts due to its superior speed and reliability.

if not A_IsAdmin
{
	Run *RunAs "%A_ScriptFullPath%" ; Requires v1.0.92.01+
	ExitApp
}

#Include %A_ScriptDir%\lib\
#include ImagePut.ahk

global Title:="Path of Exile"
global GuiX=-5
global GuiY=1000

global StackSize=9

global ClipEnabled=0

Gui, Color, 0X130F13
Gui +LastFound +AlwaysOnTop +ToolWindow
WinSet, TransColor, 0X130F13
Gui -Caption
Gui, Font, bold cFFFFFF S10, Trebuchet MS
Gui, Add, Text, y+0.5 BackgroundTrans vT1, ClipParser: OFF
Gui, Show, x%GuiX% y%GuiY%
GuiUpdate()

Menu, Tray, Add, Calculate item amount, ItemAmount ;Creates a new menu item.

OnClipboardChange("OnChange")

$!Numpad6::reload

$NumpadMult::WhisperOffer()
$^Numpad7::FindUsername()

$^Numpad1::ClipToggle()

OnChange() {
	If !ClipEnabled {
		return false
	}
	WhisperOffer()
}

WhisperOffer() {
	If ClipEnabled {
		ClipToggle()
	}

	if !RegExMatch(Clipboard, "i)wts") {
		ToolTip No offer found
		Sleep 1500
		ToolTip
		return false
	}

	username := FindUsername()
	if (username = False OR !WinExist(Title))
		return false

	WinActivate
	Sleep 250

	message := "@" . username . " wtb all essences"

	;SendInput {Esc}
	;Sleep 50
	SendInput {Enter}^{a}
	Sleep 200
	SendInput %message%
	; Clipboard := ""

	ToolTip % username
	Sleep 200
	ToolTip

	return
}

FindUsername() {
	ClipSaved := Clipboard

	Loop, Parse, ClipSaved, `n, `r ;parse clipboard line by line
	{

		if RegExMatch(A_LoopField, "i)IGN") { ;detect if line contains ign
			usernameLine := RegExReplace(A_LoopField, "[``]")
			ToolTip % usernameLine
			Sleep 200
			ToolTip
			if RegExMatch(usernameLine, "i)IGN:?\s*(\S*)") { ;get username from line
				username := RegExReplace(usernameLine, "i).*IGN:?\s*(\S*)", "$1")
			}
			else {
				InputBox, username, Format not detected,,,200, 100,,,,, %usernameLine%
				if (username = usernameLine OR ErrorLevel)
					username := ""
			}
		}
	}

	if RegExMatch(ClipSaved, "ims).*(?<=""url0"":"")(.*)(?="").*") { ;check if clipboard has link
		url := RegExReplace(ClipSaved, "ims).*(?<=""url0"":"")(.*)(?="").*", "$1")
		;Run, firefox.exe -new-window %url%
		UrlDownloadToFile, %url%, discord.png
		Run discord.png
		hwd := ImageShow(url)
		Sleep 200
	} else {
		ToolTip No link found
		Sleep 500
		ToolTip
	}

	if username {
		return username
	}
	else {
		Clipboard := "wtb essences. IGN: username" ; replace with ur username
		ToolTip Name not found
		Sleep 500
		ToolTip
		return false
	}
}

ItemAmount() {
	CoordMode, ToolTip, Screen
	field := StackSize
	InputBox, amount, Enter amount desired,,,200, 100,,,,, %field%
	InputBox, StackSize, Stack size of item,,,175, 100,,,,,%StackSize%

	stacks := floor(amount / StackSize)
	rest := mod(amount, StackSize)

	message := stacks " stacks " rest " items"
	ToolTip, %message%, 1375, 935
	Sleep 15000
	ToolTip
	CoordMode, ToolTip, Relative
}

ClipToggle() {
	ClipEnabled := !ClipEnabled
	GuiUpdate()
	return
}

GuiUpdate() {
	if ClipEnabled{
		clipState := "ON"
	} else {
		clipState := "OFF"
	}

	GuiControl, Hide, Moving
	GuiControl,, T1, ClipParser: %clipState%
	return
}
