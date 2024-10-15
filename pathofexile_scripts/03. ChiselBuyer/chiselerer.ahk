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
#Include FindClick.ahk
#Include RandomBezier.ahk
#Include FindText.ahk
global TopLeftX:=308
global TopLeftY:=259
global CellWidth=53

global Clip_Contents := ""

global scarabsfile
fileread, scarabsfile, scarabs.txt ;get the text from the file into a variable

global uniquemapsfile
fileread, uniquemapsfile, uniquemaps.txt ;get the text from the file into a variable

$Numpad0::BuyAndRefresh()
;$F18::BloodAltarKirac()
$NumpadEnter::reload
; $Numpad0::IsInventoryFull()

; Maps:="|<AugSynthMap>*86$30.TU9TjcCYMT7wAjbTUQDNm00zxU013S02HjzU7nojq/nbzC/nbyQ3nzzA01zkM47zrU8UzB4004MP043no004yTE04JT80ezCM0ByD001uU"
; Text.="|<TwistSynthMap>*82$25.7maDXtvoPwzzby8zzy0zzzEzzz8PzzyBzzy7zzzrzzzvzzzxzzzxztzzzzzzzzzzzzzzzzzzzzzTzzy7zDss0Hjwvviz1CqylOqzCCQzk"
; Text.="|<RewritSynthMap>*87$25.DBfRzrtLxzRzyz9pznzxSjzxzKTtjtzxqRzzvzzzxzzzzzzzzzzzzzzzzzzzzzxzzzhzzvCItlzYHDjsBhjq/yDvnXDyR1jqVEA7nwTzk"

; Text:="|<VeritaniaMap>*110$25.zHnzyFs7ycwHzkS2yMD1iY7Ubk3k7o0k3m+NFcYA818604m7U2wbk4T7y60Hz87lzUt0zk4DTs2Ejt377yjPDzljzzzzzzzzTzzrzzzrk"
; Text.="|<BaranMap>*69$25.zzzzzzzzzzzwSzvz6TszkTyTwTzDyDzbzjzFzzA96TowtjuySLxzDfyjbpzLnuzdtsTqQvjvaPrxx7zzzbzzznzzztzzzzzzzzzzzzzzk"
; Text.="|<AlHezMap>*96$25.VoFEztzDzwTvzyDzTzbzbztzxTww0tz00MTtzy7zzxlwDyyQ1zTYQ0jszUKTsTw7s0y0Mk7zZzlztyDvzw1jzw0rz0zrwDzvyTznzzznk"

; Text.="|<PutridMap>*109$25.ztsjryPGv7glf3qQnnXj9zkzzzsTzxyDzDznrrwttPvA4Vwa0Ey3s8CZzU10zk0UQM006A00360k1y0Q0v0D0QUTUCMzs74zs2XzlU1zk"

BloodAltarKirac() {
  Loop {
    BloodAltarTag:="|<BloodAltarNametag>*104$17.1zy1zwtvtnXnbbUTD0SSQQwstttnnnbbDC0y1zzy"
    if (FindText(X, Y, 0, 0, 1918, 1078, 0, 0, BloodAltarTag))
    {
      MoveMouseHuman(X, Y, 2)
      SendInput {LButton}
    } else {
      return
    }

    BloodAltarScreen:="|<BloodAltarScreen>*87$22.zk01lU07700QQS1lkk7630RsA1zUk7T30QCA1ksk71n0Q7A1kMkL1XXSQTvz008"

    While, !FindText(X, Y, 0, 0, 1918, 1078, 0, 0, BloodAltarScreen)
    {
    }

    SendInput {Numpad5}
    RandomSleep(200, 400)
    MouseMove, 480, 154
    RandomSleep(100, 200)
    SendInput {LButton}

    RandomSleep(100, 200)
    MouseMove, 618, 917
    RandomSleep(200, 400)
    SendInput {LButton}
    RandomSleep(200, 400)

    MouseMove, 551, 565

    RandomSleep(200, 400)

    While, !FindText(X, Y, 0, 0, 1918, 1078, 0, 0, BloodAltarTag)
    {
      SendInput {Q Down}
    }
    SendInput {Q Up}
  }
}

BuyAndRefresh() {
  Loop {
    OpenKiracAndBuy()
    ; KeyWait, F18, D
    RandomSleep(50, 100)
    SendInput {Esc}
    RandomSleep(200, 400)
    SendInput {Esc}
    RandomSleep(50, 100)
    OpenMapDevice()
    RandomSleep(250, 500)
    RefreshKirac()
    RandomSleep(2500, 3000)
  }
}

RefreshKirac() {
  KiracIcon:="|<KiracIcon>*86$36.zzurzzzzvvzzszU7zzwzU5zzwzk1zwyzVnzczzVXy/zzkWzDzjlfTzzqkmTvvTs7jzwzwDzzmyzvzzdQ3tzrhM0zzzfw1zzx1a3zzzy71zztU"
  if (FindText(X, Y, 0, 0, 1918, 1078, 0, 0, KiracIcon))
  {
    MoveMouseHuman(X, Y, 2)
    SendInput {LButton}
  } else {
    return
  }

  ; KeyWait, F18, D
  RandomSleep(50, 100)
  MoveMouseHuman(879, 413, 2) ; First map slot
  RandomSleep(50, 100)
  SendInput {LButton}
  RandomSleep(50, 100)

  ActivateButton:="|<ActivateButton>*97$70.ty00067XC003bnsNowyQtbFgCTbbnltVyT7klzyTDbC7twSFDztwyAmDbk84zzbnwr0yT4UFzyTDmQ3twQsXxtwz3b7blnm7bbnyCSST6D20wD7xlsEs2"
  if (FindText(X, Y, 0, 0, 1918, 1078, 0, 0, ActivateButton))
  {
    MoveMouseHuman(X, Y, 2)
    SendInput {LButton}
  } else {
    return
  }

}

ParsePurchaseTab() {
  x:=TopLeftX
  y:=TopLeftY
  delta := CellWidth
  Loop, 2 {
    Loop, 11 {
      if (GetKeyState("RButton") OR GetKeyState("LButton")) {
        Sleep 10
        SendInput {Ctrl up}
        break 2
      }

      ClipItem(x+26, y+26)

      if (Clip_Contents = "") {
        return
      }

      if IsItemBuyable() {
        IsInventoryFull()
        SendInput {CtrlDown}{LButton}{CtrlUp}
        RandomSleep(50, 100)
        ClipItem(x+26, y+26)
        if (Clip_Contents != "") {
          Msgbox NO C
          Reload
        }
        ShowTooltip(StrSplit(Clip_Contents,"`n","`r").3, 250)
        ; LogDebug(Clip_Contents)
      }

      y += delta

    }
    y := TopLeftY
    x += delta
  }
  ; SendInput {LCtrl Up}
  return
}

IsInventoryFull() {
  emptyslot:="|<EmptySlot>*6$40.000zU0000/w00000jk000EWy0000RDmEU03wzzy007v3zs00zyzTU07rzxz00TDrlw00xyDkU0Tr033UFyM0Cy7lzUETSzzw3Vxzzzkz77tDz1wATxzw6klwDzk477zzzV0yTzzz03xvnLM07lUCRk0rE01vsCQ0kDnvny00TnyT801ztzy007zzzs00LzzyU00gzzk000Xzs0002Dz0000Mzs0001UzU00007y00000Ts00U"

  if (FindText(X, Y, 1840, 578, 1905, 643, 0, 0, emptyslot))
  {
    return false
  }
  MsgBox Full
  Reload
  return true
}

IsItemBuyable() {
  If RegExMatch(Clip_Contents, "Cartographer's Chisel") {
    return true
  }

  If RegExMatch(Clip_Contents, "Synthesised Map") {
    return true
  }

  If RegExMatch(Clip_Contents, "Citadel") {
    return true
  }

  If RegExMatch(Clip_Contents, "Rarity: Unique") {
    Loop, parse, uniquemapsfile, `n, `r
    {
      ; if RegExMatch(mods, A_LoopField) {
      IfInString, Clip_Contents, %A_LoopField%
      {
        return true
      }
    }
  }

  If RegExMatch(Clip_Contents, "Scarab") {
    Loop, parse, scarabsfile, `n, `r
    {
      ; if RegExMatch(mods, A_LoopField) {
      IfInString, Clip_Contents, %A_LoopField%
      {
        return true
      }
    }
  }

  return false
}

OpenMapDevice() {
  MapDevice:="|<MapDeviceNametag>*103$34.7yTzzwTlzzzlz7xzj3sTbk4DVwD6ESbkyM1mSFtUb9tbaG9bUS3AaQ0swktnnbn3WTATCS9wFzxzzzzs"

  if (FindText(X, Y, 0, 0, 1918, 1078, 0, 0, MapDevice))
  {
    MoveMouseHuman(X, Y, 2)
    SendInput {LButton}
  } else {
    return
  }
}

OpenKiracAndBuy() {
  KiracTag:="|<KiracNametag>*94$46.7XzzzzzySTzzzzztlnzzvzbaCC0z7s2FwsnsT68DnX7VsxVzCAQXby3wsnmCTt7nUD0tzaDC1s1XyMwsXbaDtlnX4yQQbXCC3ss7zzzzzzts"

  ; SendInput {Esc}
  ; RandomSleep(50, 100)

  if (FindText(X, Y, 0, 0, 1918, 1078, 0, 0, KiracTag))
  {
    MoveMouseHuman(X, Y, 2)
    SendInput {LControl down}{LButton}{LControl up}
  } else {
    return
  }

  RandomSleep(250, 500)

  ; ChiselIcon:="|<ChiselIcon>*86$11.z1w7sDUz3wDszVy7wDszXz7z"
  ; if (FindText(X, Y, 0, 0, 1258, 1078, 0, 0, ChiselIcon))
  ; {
  ;   MoveMouseHuman(X, Y, 2)
  ;   SendInput {LControl down}{LButton}{LControl up}
  ; }
  ParsePurchaseTab()
}

; ClipItem - Capture Clip at Coord
ClipItem(x, y) {
  BlockInput, MouseMove
  Backup := Clipboard
  Clipboard := ""
  MoveMouseHuman(x, y, 3)
  ; Sleep, 75+(ClipLatency*15)
  RandomSleep(25, 50)
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
  BlockInput, MouseMove

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

  BlockInput, MouseMoveOff
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

LogDebug(message) {
  FormatTime, date,, yyyy/MM/dd HH:mm:ss ; 2023/01/04 14:00:20
  log:="[" . date . "] DEBUG: " . message . "`n"
  ; log := message . "`n"
  FileAppend, %log%, log.txt
}