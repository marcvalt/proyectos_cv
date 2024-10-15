MoveWholeInventory() {
  Sleep 1000
  x := TopLeftX
  y := TopLeftY
  delta := CellWith
  SendInput {LCtrl Down}
  swap := true
  Loop, 5 {
    Loop, 12 {
      if (GetKeyState("RButton") OR GetKeyState("LButton") OR IsRunning()) {
        Sleep 10
        SendInput {Ctrl up}
        break 2
      }

      RandomSleep(25, 50)
      MouseMove, x+27, y+26, 60
      RandomSleep(25, 50)
      SendInput {LButton}

      Loop {
        OldClip := Clipboard
        Sleep 100
        SendInput ^{c}
        Sleep 100

        if (Clipboard = OldClip) {
          break
        } else {
          if (GetKeyState("RButton") OR GetKeyState("LButton")) {
            Sleep 10
            SendInput {Ctrl up}
            break 3
          }
          SendInput {Right}
          RandomSleep(50, 100)
          SendInput {LButton}
        }

        Clipboard := OldClip
      }

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
  return
}