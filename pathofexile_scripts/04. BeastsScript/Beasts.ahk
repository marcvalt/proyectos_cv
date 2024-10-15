; #IfWinActive Path of Exile
#SingleInstance force
#NoEnv ;Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn ;Enable warnings to assist with detecting common errors.
#Persistent
#MaxThreadsPerHotkey 2

SetTitleMatchMode 1
SendMode Input ;Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ;Ensures a consistent starting directory.
CoordMode, Mouse, Screen
CoordMode, ToolTip, Screen
CoordMode, Pixel, Screen

#Include %A_ScriptDir%\lib\
#Include FindClick.ahk
#Include RandomBezier.ahk
#Include FindText.ahk

global TopLeftX:=1271
global TopLeftY:=589
global CellWidth=53

global Toggle := False

global EmptySlotParams:=", 50, 265"" n0 o10 Center1"
global EmptySlotLocation:="img/emptySlot"

$F4::StartReleasing()
$F6::StopReleasing()

$Numpad1::StoreBeasts()

$Numpad5::Reload

StoreBeasts() {
  Toggle := True
  While (Toggle = True) {
    BestiaryOrbIcon:="|<BestiaryOrbIcon>*78$19.w07y03z13zRVyckyCMTTw/bu/dxXyzHrjdrvgvwQzzCPzZDznbzsrz|<>*60$17.0UywVTw0ns37kCboRb0raXD6Ay8HyEzwGzsZztDy|<>*96$16.kUTa1ySDzszbVziDzsjzXrz7jxzzbhyTttzrjzSzzvzzTs"
    CapturedBeastsWindow:="|<CapturedBeastsWindow>*128$35.zy00t1nw00k3Xk01kbH001Vwa0011zA003/zs007Vzk00DbzU00TbyQ0STzxw1yyz7w3yByDsDQvzDsTnnzDkzD7z31UuDzU07HTjU0S6rbWEs1qD0XW3yS/DA7AwGQ8DsMYtXTsF1X6zUk3o1"

    if (!FindText(X, Y, 0, 0, 1920, 1080, 0, 0, CapturedBeastsWindow))
    {
      return
    }

    if (FindText(X, Y, 0, 0, 1920, 1080, 0, 0, BestiaryOrbIcon))
    {
      MoveMouseHuman(X, Y, 2)
      SendInput {RButton}
      RandomSleep(50, 100)
    } else {
      return
    }

    MoveMouseHuman(143, 294, 2)
    SendInput {LButton}
    RandomSleep(50, 100)

    x := TopLeftX
    y := TopLeftY
    delta := CellWidth

    full := True
    Loop, 12 {
      params := "a""" . x . ", " . y . EmptySlotParams
      if FindClick(EmptySlotLocation, params, eX, eY) {
        MoveMouseHuman(eX, eY, 2)
        SendInput {LButton}
        full := False
        break
      } else {
        full := True
      }
      x += delta
    }
    if full {
      return
    }

    RandomSleep(50, 100)
    MoveMouseHuman(1910, 856, 6)
    RandomSleep(50, 100)
  }
}

StartReleasing() {
  Toggle := True
  While (Toggle = true AND WinActive("Path of Exile") AND !GetKeyState("Esc")) {

    CapturedBeastsWindow:="|<CapturedBeastsWindow>*128$35.zy00t1nw00k3Xk01kbH001Vwa0011zA003/zs007Vzk00DbzU00TbyQ0STzxw1yyz7w3yByDsDQvzDsTnnzDkzD7z31UuDzU07HTjU0S6rbWEs1qD0XW3yS/DA7AwGQ8DsMYtXTsF1X6zUk3o1"
    if (!FindText(X, Y, 0, 0, 1918, 1078, 0, 0, CapturedBeastsWindow))
    {
      break
    }
    MoveMouseHuman(86, 241, 2)
    RandomSleep(50, 100)
    SendInput {LButton}
    RandomSleep(150, 300)
    SendInput {Enter}
    RandomSleep(583, 953)
  }
}

StopReleasing() {
  Toggle := !Toggle
  return
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
  MouseMove, 0, 0, 50, R

  ; BlockInput, MouseMoveOff
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