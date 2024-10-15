#SingleInstance force
#NoEnv ;Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn ;Enable warnings to assist with detecting common errors.
#Persistent
#MaxThreadsPerHotkey 2

SendMode Input ;Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ;Ensures a consistent starting directory.
CoordMode, Mouse, Screen
CoordMode, ToolTip, Screen
CoordMode, Pixel, Screen

if not A_IsAdmin
{
	Run *RunAs "%A_ScriptFullPath%" ; Requires v1.0.92.01+
	ExitApp
}

#Include, %A_ScriptDir%\lib\FindClick.ahk
#Include, %A_ScriptDir%\lib\RandomBezier.ahk

#Include, %A_ScriptDir%\lib\Config.ahk
#Include, %A_ScriptDir%\lib\SettingsGUI.ahk
#Include, %A_ScriptDir%\lib\Hotkeys.ahk

#Include, %A_ScriptDir%\lib\ExternalFunctions.ahk
#Include, %A_ScriptDir%\lib\MoveWholeInventory.ahk

global PoEWindowGrp
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_KG.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_EGS.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExileEGS.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExileSteam.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64_KG.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64EGS.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExilex64EGS.exe
GroupAdd, PoEWindowGrp, Path of Exile ahk_class POEWindowClass ahk_exe PathOfExile_x64Steam.exe

global PoEWindowHwnd := ""
WinGet, PoEWindowHwnd, ID, ahk_group PoEWindowGrp

; General
global Speed=3 ; Pixels/ms

; Coordinates
global CellWith=53

; Slot above surveyor's compasses
global AwakenedSextantX:=506
global AwakenedSextantY:=605

global CompassX:=506
global CompassY:=665

global LastCompassX:=443
global LastCompassY:=611

global VoidstoneX:=928
global VoidstoneY:=805

; Currency stash tab (Use the first on the tab list)
global StashTabCurrencyX:=700
global StashTabCurrencyY:=100

; Dump stash tab (The following will be used too)
global StashTabDumpX:=700
global StashTabDumpY:=135

global GuiX:=-5
global GuiY:=950

global TopLeftX:=1271
global TopLeftY:=589

; Toggles
global RunningToggle=1

global SextantsUsed:=0
;To do a small break
global TimesCleared:=0

global StartTime:=0

; Image Detection
global EmptySlotParams:=", 50, 265"" n0 o10 Center1"

; Other - not in INI
global EmptySlotLocation:="img/emptySlot"

global sextantsfile
fileread, sextantsfile, SextantModsSelector/sextants_selected.txt
ShowTooltip(sextantsfile, 2000)

; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
; Gui (default bottom left)
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Gui, Color, 0X130F13
Gui +LastFound +AlwaysOnTop +ToolWindow
WinSet, TransColor, 0X130F13
Gui -Caption
Gui, Font, bold cFFFFFF S10, Trebuchet MS
Gui, Add, Text, y+0.5 BackgroundTrans vT1, ChangeRunning (. HParse_rev(KeyRunningToggle) .): OFF
Gui, Add, Text, y+0.5 BackgroundTrans vStoring, Storing...
Gui, Add, Text, y+0.5 BackgroundTrans vRolling, Rolling...
Gui, Show, x%GuiX% y%GuiY%
GuiUpdate()
; -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

StartBot() {
	StartTime:=A_TickCount
	OldClip := Clipboard
	LogDebug("starting")
	Loop {
		if !IsRunning() {
			StopBot()
		}

		Sleep 300
		LogDebug("trying to copy")
		SendInput ^{c}
		Sleep 200
		LogDebug(Clipboard)
		if !ParseClipboard(Clipboard) {
			StopBot()
		}
		Clipboard := OldClip
		LogDebug("-----")
	}
}

StopBot() {
	Clipboard := OldClip
	StopRolling()
	return false
}

ParseClipboard(ClipSaved) {
	if (RegExMatch(ClipSaved, "Decayed Voidstone")) { ; if clipboard has voidstone info
		LogDebug("voidstone detected")
		if RegExMatch(ClipSaved, "4 uses remaining") { ; if voidstone is charged
			LogDebug("voidstone detected as charged")
			if IsSextantModValid(ClipSaved) {
				LogDebug("voidstone mod passed test")
				return StoreSextant()
			} else {
				LogDebug("voidstone mod didn't pass test")
				Roll()
				return true
			}
		} else {
			LogDebug("voidstone detected as empty")
			StartRolling()
			Roll()
			return true
		}
	} else {
		LogDebug("no voidstone detected")
		ShowTooltip("No voidstone detected in clipboard", 2000)
		return false
	}
}

IsSextantModValid(mod) {
	mods := RegExReplace(ClipSaved, "ims).*(?<=Item Level: 84..-{8}..)(.*)(?=..4 uses).*", "$1")
	LogDebug(mods)
	LogDebug("parsing mod")
	Loop, parse, sextantsfile, `n, `r
	{
		; if RegExMatch(mods, A_LoopField) {
		IfInString, mods, %A_LoopField%
		{
			; message := mods . "`n-----PASSED-----"
			LogDebug("---PASSED---")
			return true
		}
	}
	LogDebug("---NOT PASSED---")
	return false
}

StartRolling() {
	GuiControl, Show, Rolling
	MoveMouseHuman(AwakenedSextantX, AwakenedSextantY)
	SendInput {RButton}
	SendInput {Shift down}
}

Roll() {
	MoveMouseHuman(VoidstoneX, VoidstoneY)
	if !IsRunning() {
		return
	}
	Sleep 100
	SendInput {LButton}
	SextantsUsed += 1
}

StopRolling() {
	GuiControl, Hide, Rolling
	SendInput {Shift up}
}

StoreSextant() {
	StopRolling()
	if !IsRunning() {
		LogDebug("program stopped before storing1")
		return false
	}

	GuiControl, Show, Storing

	x := TopLeftX
	y := TopLeftY
	delta := CellWith

	MoveMouseHuman(CompassX, CompassY)
	; SendInput ^{c}
	; if !(RegExMatch(Clipboard, "i)Surveyor's Compass")) {
	; 	tooltip ran out of compasses
	; 	Sleep 1000
	; 	tooltip
	; 	return false
	; }

	SendInput {RButton}

	MoveMouseHuman(VoidstoneX, VoidstoneY)

	if !IsRunning() {
		LogDebug("program stopped before storing2")
		return false
	}

	SendInput {LButton}

	full := True
	Loop, 12 {
		params := "a""" . x . ", " . y . EmptySlotParams
		if FindClick(EmptySlotLocation, params, eX, eY) {
			MoveMouseHuman(eX, eY)
			SendInput {LButton}
			full := False
			break
		} else {
			full := True
		}
		x += delta
	}
	if full {
		tooltip no empty slots found
		MoveMouseHuman(LastCompassX, LastCompassY)
		SendInput {LButton}
		tooltip
		GuiControl, Hide, Storing

		CleanInventory()
		; return false
	}

	GuiControl, Hide, Storing
	StartRolling()
	Roll()

	LogDebug("stored successfully")
	Sleep 200
	return true
}

CleanInventory() {
	MoveMouseHuman(StashTabDumpX, StashTabDumpY)
	SendInput {LButton}

	message:="Clearing inventory. Sextants used: " . SextantsUsed . "."
	LogInfo(message)
	SextantsUsed:=0

	MoveWholeInventory()

	ElapsedTime:= (A_TickCount - StartTime)/1000
	message:="Inventory cleared. Cycle time: " . ElapsedTime
	LogInfo(message)
	ShowTooltip(message, 5000)
	MoveMouseHuman(StashTabCurrencyX, StashTabCurrencyY)
	SendInput {LButton}
	MoveMouseHuman(LastCompassX, LastCompassY)
	SendInput ^{LButton}

	Random, R, 1, 4
	TimesClearedCap:=floor(R)
	TimesCleared += 1
	if (TimesCleared > TimesClearedCap) {
		TimesCleared:=0
		LogInfo("Taking a break.")
		RandomSleep(44312,124413)
		LogInfo("Break done.")
	}
	StartTime:=A_TickCount
}

MoveMouseHuman(x, y) {
	RandomSleep(100, 250)
	MouseGetPos, posX, posY

	distance := sqrt((posX-x)**2+(posY-y)**2)
	if (distance < 5) {
		return
	}
	delay := floor(distance/Speed)
	Random, rand, 0.0, 0.2
	delay := delay + delay*rand

	params := "T" . delay . "RO"
	RandomBezier(0, 0, x, y, params)
	Sleep 50
	MouseMove, 0, 0, 50, R
	RandomSleep(100, 250)
	return
}

RandomSleep(min, max) {
	if (min > max) {
		temp := max
		max := min
		min := temp
	}
	Random, R, %min%, %max%
	r := floor(r)
	Sleep %r%
	return
}

Random(min, max) {
	Random, r, %min%, %max%
	return r
}

ShowTooltip(message, delay) {
	ToolTip
	ToolTip, %message%, 1375, 935
	SetTimer, RemoveToolTip, -%delay%
	return

	RemoveToolTip:
	ToolTip
	return
}

LogInfo(message) {
	FormatTime, date,, yyyy/MM/dd HH:mm:ss ; 2023/01/04 14:00:20
	log:="[" . date . "] INFO: " . message . "`n"
	FileAppend, %log%, log.txt
}

LogDebug(message) {
	if DebugMessages {
		FormatTime, date,, yyyy/MM/dd HH:mm:ss ; 2023/01/04 14:00:20
		log:="[" . date . "] DEBUG: " . message . "`n"
		; log := message . "`n"
		FileAppend, %log%, log.txt
	}
}

IsRunning() {
	if !RunningToggle {
		ShowTooltip("ChangeRunning not enabled", 2000)
		return false
	}
	if !(GetKeyState("NumLock", "T")){
		ShowTooltip("Numlock is off", 2000)
		return false
	}
	if !(WinActive("ahk_group PoEWindowGrp")){
		ShowTooltip("Window not active", 2000)
		return false
	}
	return true
}

ChangeRunning() {
	RunningToggle := !RunningToggle
	GuiUpdate()
	return
}

GuiUpdate() {
	RunningState := RunningToggle ? "ON" : "OFF"

	GuiControl, Hide, Storing
	GuiControl, Hide, Rolling
	T1Text := "ChangeRunning (" . HParse_rev(KeyRunningToggle) . "): " . RunningState
	GuiControl,, T1, %T1Text%
	return
}

Reload() {
	Reload
}