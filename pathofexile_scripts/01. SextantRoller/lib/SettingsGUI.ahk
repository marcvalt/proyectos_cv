global nameWidth := 110
global optionWidth := 70
global offsetWidth := 40
global optionHeight := 21
global dropDownHeight := 100
global toolTimeout := 0

; #Include, %A_ScriptDir%\lib\build.ahk

LaunchSettings() {
  global
  Critical

  Gui, Settings:New, -E0x20 -E0x80 +AlwaysOnTop -SysMenu +hwndSettingsWindow, Bot Roller Settings

  ;HotKeys
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% x10 y10, Hotkeys ;Static19

  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% x10 y40, Show Settings ;Static20
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Toggle Bot ;Static21
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Start Bot ;Static22
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Stash All Inventory ;Static23
  Gui, Settings:Add, Text, w%nameWidth% h%optionHeight% y+5, Reload script ;Static24

  Gui, Settings:Add, Hotkey, vKeySettings w%nameWidth% h%optionHeight% x140 y36, %KeySettings%
  Gui, Settings:Add, Hotkey, vKeyRunningToggle w%nameWidth% h%optionHeight% y+5, %KeyRunningToggle%
  Gui, Settings:Add, Hotkey, vKeyStartBot w%nameWidth% h%optionHeight% y+5, %KeyStartBot%
  Gui, Settings:Add, Hotkey, vKeyMoveWholeInventory w%nameWidth% h%optionHeight% y+5, %KeyMoveWholeInventory%
  Gui, Settings:Add, Hotkey, vKeyReload w%nameWidth% h%optionHeight% y+5, %KeyReload%

  Gui, Settings:Add, Button, gSaveAndClose w%nameWidth% x10 y177, &Save
  Gui, Settings:Add, Button, gCancelAndClose w%nameWidth% x140 y177, &Cancel

  Gui, Settings:Show, w260 h210 NA
  WinSet, AlwaysOnTop, Off, ahk_id %SettingsWindow% ;Turn off always on top, I only set it to bring it to the front in the first place
}

SaveAndClose() {
  global
  Gui, Settings:Submit, NoHide

  WriteAll()

  Gui, Settings:Cancel
  ;   SetTimer, ToolTip, Off
  ;   WinActivate, ahk_id %PoEWindowHwnd%
  Reload
}

CancelAndClose() {
  global
  Gui, Settings:Cancel
  WinActivate, ahk_id %PoEWindowHwnd%
}