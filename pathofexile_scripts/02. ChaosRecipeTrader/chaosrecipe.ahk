#SingleInstance force
#NoEnv ;Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn ;Enable warnings to assist with detecting common errors.
#Persistent
#MaxThreadsPerHotkey 2

SetTitleMatchMode 1
SendMode Input ;Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ;Ensures a consistent starting directory.
CoordMode, Mouse, Screen
CoordMode, ToolTip, Screen
CoordMode, Pixel, Screen

#Include %A_ScriptDir%\lib\
#Include RandomBezier.ahk
#Include FindText.ahk

;global Speed=5 ; Pixels/ms
global tab:=0

; LEFT MONITOR
global GuiX:=-5
global GuiY:=950
global TopLeftX:=1271
global TopLeftY:=589
global CellWith=53

global ClipLatency := 0
global Clip_Contents := ""

global SlotsOcuppied := 0

global Items := JSON.Load(FileOpen("ItemSizes.json","r").Read())

$Numpad0::ClickHighlighted()
; $Numpad3::TradeFullInventory()
$Numpad4::ClickLillyAndTradeFullInventory()
$Numpad5::FullCycle()

; goes through all inventory slots to stash them
TradeFullInventory() {
  Sleep 500
  x := TopLeftX
  y := TopLeftY
  delta := CellWith
  SendInput {LCtrl Down}
  swap := true
  Loop, 5 {
    Loop, 12 {
      RandomSleep(25, 100)
      MoveMouseHuman(x+27, y+26, 2)
      SendInput {LButton}
      RandomSleep(20, 50)
      if swap {
        x += delta
      } else {
        x -= delta
      }
    }
    swap := !swap
    if swap {
      x := TopLeftX
    } else {
      x := TopLeftX + 11*delta
    }
    y += delta
  }
  SendInput {LCtrl Up}
}

FullCycle() {
  if not OpenStash() {
    return
  }
  if not TransferFullInventorySets() {
    return
  }
  if not ClickLillyAndTradeFullInventory() {
    return
  }
}

OpenStash() {
  Stash:="|<Stash>*91$46.Uzzzzzzw1zzzzzznbzTTntwDk1sw37kTMr3nCT0TXwDDtwUyDYQTbnVsyFkS0D7Xs7ks0yCD0DXbntswwz6T37XbnQtw0yCT43bnDzzzwzzs"

  if (FindText(eX, eY, 0, 0, 1918, 1078, 0, 0, Stash))
  {
    MoveMouseHuman(eX, eY, 3)
    SendInput {LButton}
    RandomSleep(250, 500)
    return True
  }

  return False
}

ClickLillyAndTradeFullInventory() {
  Lilly:="|<Lilly>*102$38.DzzzzznzzzzzwzjbtxxDllwSC3ySTbnYzbbtwHDttyTYnySTbwQzbbtz7DttyTlnySTbwQtbbNr70Ns61ls"
  Accept:="|<AcceptTrade>*101$57.yztzbzzjzzXw1k41U80sT6AMnANMr3lv7iTn77mCTtznyMsyFnzDy3nD7kCTtzkS1sw0lz7yTkz7baDsznyTstwstXaTXz7DXUS1kATszzzDwzzzzzU"

  if (FindText(eX, eY, 0, 0, 1918, 1078, 0, 0, Lilly))
  {
    CtrlClick(eX, eY)
    RandomSleep(250, 500)
    TradeFullInventory()
    if (FindText(eX, eY, 0, 0, 1918, 1078, 0, 0, Accept))
    {
      MoveMouseHuman(eX, eY, 3)
      SendInput {LButton}
    } else {
      return False
    }
  } else {
    return False
  }
  return True
}

TransferFullInventorySets() {
  Loop, 2 {
    TransferSet()
  }
  return True
}

TransferSet() {
  SlotsOcuppied := 0
  While (SlotsOcuppied < 28) {
    ClickHighlighted()
  }
  SlotsOcuppied := 0
}

AddItemSpace() {
  ItemSpace := ItemSpace()
  SlotsOcuppied += ItemSpace
  ShowTooltip(ItemSpace . " tot: " . SlotsOcuppied, 1000)
}

; Click highlighted stash slot from "Chaos Recipe Enhancer"
ClickHighlighted() {
  ItemHighlight1:="|<ItemHighlightedSlot>0xF0F0F0@1.00$16.000000000803k0TU1z0Dw0Tk1y03k02000000000U"
  ItemHighlight2:="|<ItemHighlightSlot>0xF0F0F0@1.00$8.43lyzjzyTXkEU"
  TabHighlight:="|<TabHighliighted>0xDCDCDC@1.00$10.zy080U2080U2080U2"

  if (FindText(eX, eY, 7, 89, 656, 773, 0, 0, ItemHighlight1))
  {
    ClipItem(eX+5, eY+5)
    if AddItemSpace() {

    }
    CtrlClick(eX+5, eY+5, True)
  } else if (FindText(eX, eY, 7, 89, 656, 773, 0, 0, ItemHighlight2)) {
    ClipItem(eX+5, eY+5)
    AddItemSpace()
    CtrlClick(eX+5, eY+5, True)
  } else if (FindText(eX, eY, 7, 89, 656, 773, 0, 0, TabHighlight)) {
    MoveMouseHuman(eX+25, eY+25, 3)
    RandomSleep(20, 50)
    SendInput {LButton}
    RandomSleep(20, 50)
  } else {
    return False
  }
  return True
}

ItemSpace() {
  If RegExMatch(Clip_Contents, "`amO)Item Class: (.+)", RxMatch)
    ItemClass := RxMatch[1]

  For k, v in Items
  {
    If (v.ItemClass = ItemClass)
    {
      return v.Count
    }
  }
}

; ClipItem - Capture Clip at Coord
ClipItem(x, y) {
  BlockInput, MouseMove
  Backup := Clipboard
  Clipboard := ""
  MoveMouseHuman(x, y, 3)
  ; Sleep, 75+(ClipLatency*15)
  RandomSleep(75, 100)
  Send ^!c
  ClipWait, 0.1
  If ErrorLevel
  {
    Sleep, 60
    Send ^!c
    ClipWait, 0.1
    If (ErrorLevel)
      Clipboard := Backup
  }
  Clip_Contents := Clipboard
  Clipboard := Backup
  BlockInput, MouseMoveOff
  Return
}

; CtrlClick - Ctrl Click ^Click at Coord
CtrlClick(x, y, IsItem=False){
  BlockInput, MouseMove
  MoveMouseHuman(x, y, 3)
  ; Sleep, 90+(ClickLatency*15)
  RandomSleep(90, 120)
  Send ^{Click}
  ; Sleep, 90+(ClickLatency*15)
  RandomSleep(90, 120)
  if (IsItemTransfered() AND IsItem = True) {
    CtrlClick(x, y, True)
  }
  BlockInput, MouseMoveOff
  return
}

IsItemTransfered() {
  Send {Click}
  RandomSleep(40, 80)
  ClipItem(x, y)
  if (Clip_Contents = "") {
    return true
  } else {
    return false
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
  ToolTip, %message%, 1725, 966
  SetTimer, RemoveToolTip, -%delay%
  return

  RemoveToolTip:
  ToolTip
  return
}

$^Numpad5::reload
