; #IfWinActive Path of Exile
#SingleInstance force
#NoEnv ;Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn ;Enable warnings to assist with detecting common errors.
SetWorkingDir %A_ScriptDir% ;Ensures a consistent starting directory.
#Persistent
#MaxThreadsPerHotkey 2

#Include %A_ScriptDir%\lib\
#Include RandomBezier.ahk

global TopLeftX=1271
global TopLeftY=589
global CellWithin=53
global Position=1
global Speed=4 ; Pixels/ms

If FileExist("config.ini") {
    IniRead, Position, config.ini, General, Position
} else {
    IniWrite, %Position%, config.ini, General, Position
}

Menu, Tray, Add, Change position, SetPosition ;Creates a new menu item.

OnExit, exit

$NumpadAdd::Add()
$NumpadSub::Sub()
$XButton2::PlaceMap()

UpdatePosition()

Add() {
    Position++
    UpdatePosition()
    return
}

Sub() {
    Position--
    UpdatePosition()
    return
}

UpdatePosition() {
    Rectangle(getInvX(Position), getInvY(Position), CellWithin, CellWithin)
    return
}

Rectangle(x, y, w, h) {
    Gui WinBorder:New,+AlwaysOnTop -Caption +ToolWindow +E0x20
    Gui Color,FFFFFF
    Gui Show,NoActivate x%x% y%y% w%w% h%h%,WinBorder
    WinSet Region,% "0-0 " w "-0 " w "-" h " 0-" h " 0-0 2-2 " w-2 "-2 " w-2 "-" h-2 " 2-" h-2 " 2-2",WinBorder
    return
}

getInvX(pos) {
    result := TopLeftX + CellWithin * (Floor(pos/5))
    return result
}

getInvY(pos) {
    result := TopLeftY + CellWithin * (Mod(pos, 5))
    return result
}

SetPosition() {
    message := "Actual position: " . Position
    InputBox, column, Enter column,,,200, 100,,,,, %message%
    InputBox, row, Enter row,,,175, 100,,,,, %message%
    if not (var column is number and var row is number) {
        return
    }
    Position := (column-1)*5 + row
    ToolTip % Position
    Sleep 500
    ToolTip
    UpdatePosition()
    return
}

PlaceMap() {
    x := getInvX(Position)+25
    y := getInvY(Position)+25
    BlockInput On
    MoveMouseHuman(958, 359) ; goto map device
    SendInput {LButton}
    MoveMouseHuman(x, y) ; goto map
    SendInput {LButton}
    MoveMouseHuman(564, 703) ; goto empty slot in map device
    SendInput {LButton}
    MoveMouseHuman(625, 888) ; goto activate
    SendInput {LButton}
    MoveMouseHuman(858, 397) ; goto stash
    SendInput {LButton}
    BlockInput Off
    Sleep 250
    Loop, 3 { ; stash 3 first items after maps
        xx := getInvX(Position+A_Index)+25
        yy := getInvY(Position+A_Index)+25
        MoveMouseHuman(xx, yy)
        Sleep 100
        SendInput ^{LButton}
        Sleep 100
    }
    Sleep 100
    Position--
    UpdatePosition()
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

MoveMouseHuman(x, y) {
    RandomSleep(25, 50)
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
    RandomSleep(25, 50)
    return
}

exit:
IniWrite, %Position%, config.ini, General, Position
ExitApp