; #IfWinActive Path of Exile
#SingleInstance force
#NoEnv ;Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn ;Enable warnings to assist with detecting common errors.
#Persistent
#MaxThreadsPerHotkey 2
;#IfWinActive Path of Exile ; WARNING: DO NOT USE THIS SCRIPT IF YOU HAVE AN "UNLOCKED" MOUSE WHEEL (THAT CAN SCROLL WHILE YOUR FINGER IS NOT TOUCHING IT). USE AT YOUR OWN RISK DEPENDING ON YOUR MOUSEWHEEL SCROLL SPEED/DIFFICULTY, AND NOTE THAT GGG MAY AT ANY TIME DEEM USE OF THIS SCRIPT TO BE BANNABLE.

SetTitleMatchMode 1
SendMode Input ;Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ;Ensures a consistent starting directory.
CoordMode, Mouse, Screen
CoordMode, ToolTip, Screen
CoordMode, Pixel, Screen

#Include %A_ScriptDir%\lib\
#Include RandomBezier.ahk
#Include FindText.ahk

global TopLeftX:=1271
global TopLeftY:=589
global CellWidth=53

global Clip_Contents := ""
global RandomClickToggle := False

$F19::CorruptEssenceOnMouseWithFixedCoords()
$F18::OpenEssence(3)
$^F18::OpenEssence(6)
$F17::LootStackedEssences()

$Numpad5::Reload

LootStackedEssences() {
  EssenceItemHeight:=37
  ; PixelGetColor colors ; Window Spy colors; Window Spy hovering colors
  ; Screaming 009FD5     ; Screaming D59F00 ; Screaming FECA22
  ; Shrieking 0D96F8     ; Shrieking F8960D ; Shrieking FEC140
  ; Deafening 1C58EF     ; Deafening 272822 ; Deafening FE844B

  MouseGetPos, mX, mY
  X:=mX
  Y:=mY+EssenceItemHeight
  SendInput {LButton}
  ; ShowTooltip("Click", 1000)
  RandomSleep(100, 200)

  Loop {
    PixelSearch,,, X, Y, X+5, Y+5, 0x009FD5, 3, Fast
    if ErrorLevel
      PixelSearch,,, X, Y, X+5, Y+5, 0x0D96F8, 3, Fast
    if ErrorLevel
      PixelSearch,,, X, Y, X+5, Y+5, 0x1C58EF, 3, Fast
    if ErrorLevel
      PixelSearch,,, X, Y, X+5, Y+5, 0xFE00B4, 3, Fast
    if ErrorLevel {
      ShowTooltip("Done", 250)
      MoveMouseHuman(X, Y+EssenceItemHeight, 4)
      break
    }

    ; MsgBox, xd

    MoveMouseHuman(X, Y, 4)
    SendInput {Click}
    RandomSleep(53, 95)
    Y += EssenceItemHeight
    ; ShowTooltip("Click", 1000)
  }
  ; MouseGetPos, mX, mY
}

OpenEssence(times) {
  Loop, %times% {
    SendInput {LButton}
    RandomSleep(100, 250)
  }
}

CorruptEssenceOnMouseWithFixedCoords() {
  MouseGetPos, mX, mY

  Slot1 := {"X": 1295, "Y": 769, "Count": 0}
  Slot2 := {"X": 1295, "Y": 824, "Count": 0}

  Slots := [Slot1, Slot2]

  SendInput i
  RandomSleep(50, 100)

  for i in Slots {
    ClipItem(Slots[i].X, Slots[i].Y)
    if (RegExMatch(Clip_Contents, "O)Stack Size: (\d)", Found)) {
      Slots[i].Count:=Found[1]
      ; ShowTooltip(Slots[i].Count, 250)
    }
    else {
      MsgBox % "Remnants aren't on their allocated slots"
      return
    }
  }

  ; MsgBox % Slots[1].Count . " - " Slots[2].Count
  ; MsgBox % Slot1.Count . " - " Slot2.Count

  RandomClickToggle:=True
  if (Slot1.Count > Slot2.Count)
    MoveMouseHuman(Slot1.X, Slot1.Y, 4)
  else
    MoveMouseHuman(Slot2.X, Slot2.Y, 4)
  SendInput {RButton}

  SendInput i
  RandomSleep(50, 100)
  MoveMouseHuman(mX, mY, 2)
  RandomSleep(50, 150)
  SendInput {LButton}
  RandomSleep(25, 50)
}

CorruptEssenceOnMouseWithFindText() {
  MouseGetPos, mX, mY

  RemnantIcon:="|<RemnantIcon>*47$8.nskMA73VswD7vs|<R2>*49$8.DrBVkwC73VmSU|<R3>*40$7.XV111Vkkk|<R4>*40$10.laAFV45ky3sP3iSty"

  SendInput i
  SendInput	{Tab}
  RandomSleep(100, 200)
  if (FindText(X, Y, 1263, 579, 1378, 857, 0, 0, RemnantIcon))
  {
    MoveMouseHuman(X, Y, 4)
    SendInput {RButton}
  } else {
    SendInput {Tab}
    return
  }

  SendInput i
  SendInput	{Tab}
  RandomSleep(50, 100)
  MoveMouseHuman(mX, mY, 3)
  RandomSleep(50, 150)
  SendInput {LButton}
  RandomSleep(25, 50)
}

; ClipItem - Capture Clip at Coord
ClipItem(x, y) {
  BlockInput, MouseMove
  Backup := Clipboard
  Clipboard := ""
  MoveMouseHuman(x, y, 3)
  ; Sleep, 75+(ClipLatency*15)
  ; RandomSleep(25, 50)
  Send ^!c
  ClipWait, 0.1
  If ErrorLevel
  {
    Sleep, 60
    Send ^!c
    ClipWait, 0.1
  }
  Clip_Contents := Clipboard
  Clipboard := Backup
  BlockInput, MouseMoveOff
  Return
}

MoveMouseHuman(x, y, speed) {
  ; BlockInput, MouseMove

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

  if (RandomClickToggle = True) {
    o := RandClick(x, y)
    MouseMove, o.X, o.Y, 50
  }
  MouseMove, 0, 0, 50, R

  randomClick = False

  ; BlockInput, MouseMoveOff
  return
}

; RandClick - Randomize Click area around middle of cell using lower left Coord
RandClick(x, y){
  Random, Rx, x+5, x+15
  Random, Ry, y-15, y-5
  return {"X": Rx, "Y": Ry}
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

ShowTooltip(message, delay) {
  ToolTip
  ToolTip, %message% ;, 1725, 966
  SetTimer, RemoveToolTip, -%delay%
  return

  RemoveToolTip:
  ToolTip
  return
}