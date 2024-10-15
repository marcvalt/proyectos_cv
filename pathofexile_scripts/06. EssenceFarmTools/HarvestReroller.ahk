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
global CellWidth:=53

global Clip_Contents := ""

global LastEssence := ""

global essencesfile
fileread, essencesfile, essences_reroll_to.txt ;get the text from the file into a variable

; $F18::RerollEssenceOnMouse()
$F18::TradeInventory()

$Numpad5::Reload

TradeInventory() {
  x := TopLeftX
  y := TopLeftY
  delta := CellWidth

  InputBox, InputSlot,, Introduce the slot where you wanna start,,300, 125
  if ErrorLevel
    InputSlot := 1
  Sleep 500

  SlotNum := 0

  WinActivate, ahk_class POEWindowClass

  swap := true
  Loop, 12 {
    Loop, 5 {
      SlotNum += 1
      if (SlotNum >= InputSlot) {
        if RerollEssence(x+26, y+26)
          return
      }

      y += delta
    }
    y := TopLeftY
    x += delta
  }
}

RerollEssence(mX, mY) {
  ; Ultra wide values coords
  ; HarvestSlot := {"X": 965, "Y": 339}
  ; CraftButton := {"X": 962, "Y": 448}

  ; Normal 1080p
  HarvestSlot := {"X": 968, "Y": 452}
  CraftButton := {"X": 965, "Y": 607}

  ClipItem(mX, mY)

  if not (RegExMatch(Clip_Contents, "O)Essence"))
  {
    txt := "Mouse isn't over an essence"
    ShowTooltip(txt, 1000)
    LogDebug(txt)
    return true
  }

  HarvestScreen.="|<HarvestScreen>*76$49.T3k00000L0s000003UQD3w001kCTsz7zAs7MCNmA7TzA3AM63jzg1qQ31b0q0Pw1UnUP0By0kNkAkAnUMAs6ACMsA6Q33yTDD3D1k00100E"
  HarvestScreen.="|<HarvestScreen>*66$46.00000000000000000000000000000000000000DUz00000s0s00003U3U7000C0C3z3zUs0sQD3j7U3X0QCQC0CM0ssszztU1XX3U3a07CQC0Cs0QzUs0tU1ny3U3a07CQC0CQ0Msss0ss33VXU3VksC7i0C1y1w7w1w0000000000000000000000000002"
  if not FindText(X, Y, 0, 0, 1918, 1078, 0, 0, HarvestScreen) {
    txt := "Harvest interface isn't open"
    ShowTooltip(txt, 1000)
    LogDebug(txt)
    return true
  }

  if IsEssenceValid() {
    txt := "Essence already rerolled"
    ShowTooltip(txt, 1000)
    LogDebug(txt)
    return false
  }

  SendInput ^{Click}

  Loop {
    MoveMouseHuman(CraftButton.X, CraftButton.Y,,True)
    SendInput {Click}
    RandomSleep(50, 100)

    ClipItem(HarvestSlot.X, HarvestSlot.Y)

    ; Check if the essence changed
    if (LastEssence = Clip_Contents) {
      LastEssence := ""
      txt := "Ran out of juice"
      ShowTooltip(txt, 1000)
      LogDebug(txt)
      return true
    }
    LastEssence := Clip_Contents

    RandomSleep(400, 800)

    if IsEssenceValid() {
      ; MsgBox % "Good..."
      break
    }

    ; MsgBox % "Rerolling..."
  }

  MoveMouseHuman(HarvestSlot.X, HarvestSlot.Y,,True)
  RandomSleep(25, 50)
  SendInput ^{Click}

  ; MoveMouseHuman(mX, mY)

  return false
}

; Check if essence is already valid
IsEssenceValid() {
  Loop, parse, essencesfile, `n, `r
  {
    IfInString, Clip_Contents, %A_LoopField%
    {
      return true
    }
  }
}

; ClipItem - Capture Clip at Coord
ClipItem(x, y) {
  BlockInput, MouseMove
  Backup := Clipboard
  Clipboard := ""
  MoveMouseHuman(x, y, 3, True)
  ; Sleep, 75+(ClipLatency*15)
  ; RandomSleep(25, 50)
  Send ^!c
  ClipWait, 0.1
  If ErrorLevel {
    Sleep, 60
    Send ^!c
    ClipWait, 0.1
  }
  Clip_Contents := Clipboard
  Clipboard := Backup
  BlockInput, MouseMoveOff
  Return
}

MoveMouseHuman(x, y, speed:=2, randomizeMouse:=False) {
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

  if (randomizeMouse) {
    o := RandClick(x, y)
    MouseMove, o.X, o.Y, 50
  }
  MouseMove, 0, 0, 50, R

  ; BlockInput, MouseMoveOff
  return
}

; RandClick - Randomize Click area around middle of cell using lower left Coord
RandClick(x, y){
  Random, Rx, x+10, x-10
  Random, Ry, y+5, y-5
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

LogDebug(message) {
  FormatTime, date,, yyyy/MM/dd HH:mm:ss ; 2023/01/04 14:00:20
  log:="[" . date . "] DEBUG: " . message . "`n"
  ; log := message . "`n"
  FileAppend, %log%, log.txt
}