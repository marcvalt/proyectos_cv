; #IfWinActive Path of Exile
#SingleInstance force
#NoEnv ;Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn ;Enable warnings to assist with detecting common errors.
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

; $Numpad0::PrepareShipment()
$Numpad1::DoAllShipments()

global barsAmount=55
global cropsAmount=1000
global dustAmount=2000

DoAllShipments() {
  ShipmentIcon:="|<ShipmentIcon>*113$20.zjzzvzySzz3708UU0080U20Dzzw0000000000000zzzs0040000000000000U"
  found:=FindText(X, Y, 0, 0, 1918, 1078, 0, 0, ShipmentIcon)

  InputBox, barsAmount, Amount of bars,,,200, 100,,,,, %barsAmount%
  InputBox, cropsAmount, Amount of crops ,,,175, 100,,,,, %cropsAmount%
  InputBox, dustAmount, Amount of dust ,,,175, 100,,,,, %dustAmount%

  for i in found {
    MoveMouseHuman(found[i].x, found[i].y, 3)
    SendInput {LButton}
    RandomSleep(100, 250)

    PrepareShipment()
  }

  SelectPortButton:="|<SelectPortButton>*99$37.szzzzlk00w3U3tazAbXznza7tztznHwzwzsNyDyTwwz7rDyTDc3Xz7k7DlzXyC"
  SetSailButton:="|<SetSailButton>*99$21.03s9bSBwzlzbz7wzsTbzlwzz7bywwznD3y3zzxw"
  found:=FindText(X, Y, 0, 0, 1918, 1078, 0, 0, SelectPortButton)

  for i in found {
    MoveMouseHuman(found[i].x, found[i].y, 2)
    SendInput {LButton}
    RandomSleep(100, 250)

    MoveMouseHuman(1149, 412, 2)
    SendInput {LButton}

    RandomSleep(100, 250)

    ; if (FindText(X, Y, 0, 0, 1918, 1078, 0, 0, SetSailButton)) {
    ;   MoveMouseHuman(X, Y, 2)
    ;   SendInput {LButton}
    ; }
    ; RandomSleep(100, 250)
  }

}

PrepareShipment() {
  PrepareShipmentScreenCheck:="|<PrepareShipmentScreenCheck>*117$18.00S00WQ0Uq0kn0Qz0CU07U03l0WS0yU"
  CrimsonBarIcon:="|<CrimsonBarIcon>*97$20.00Q00Dk07y03zE1zg0zr0TnUDRk7ys3z01z80zk0Tv0/xk3Ts0Lw03D00NU02k00M02"
  DoneButton:="|<DoneButton>*89$45.zzyDzzzs0z0STW0XVXllyMoTAz67n7Xs7wkSMoTVzaFn0Xw7wH2MYTUzaQ37XsbwnkMwSCTCT36U3s3VyE7bznzzzzU"

  if not (FindText(X, Y, 0, 0, 1918, 1078, 0, 0, PrepareShipmentScreenCheck))
  {
    ShowTooltip("Prepare Shipment screen not found", 1500)
    return
  }

  if not (FindText(X, Y, 0, 0, 1918, 1078, 0, 0, CrimsonBarIcon))
  {
    ShowTooltip("Crimson Iron Bar icon not found", 1500)
    return
  }

  if barsAmount is not integer
    return
  if cropsAmount is not integer
    return
  if dustAmount is not integer
    return

  MoveMouseHuman(X+188, Y, 2)
  SendInput {LButton}

  Loop, 5 {
    SendInput %barsAmount%
    RandomSleep(50, 100)
    SendInput {Tab}
  }

  Loop, 5 {
    SendInput %cropsAmount%
    RandomSleep(50, 100)
    SendInput {Tab}
  }

  SendInput %dustAmount%
  RandomSleep(50, 100)
  SendInput {Tab}

  if (FindText(X, Y, 0, 0, 1918, 1078, 0, 0, DoneButton))
  {
    MoveMouseHuman(X, Y, 2)
    SendInput {LButton}
    return
  }

}

MoveMouseHuman(x, y, speed) {
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

ShowTooltip(message, delay) {
  ToolTip
  ToolTip, %message% ;, 1725, 966
  SetTimer, RemoveToolTip, -%delay%
  return

  RemoveToolTip:
  ToolTip
  return
}

$^Numpad5::reload
