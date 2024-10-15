global DebugMessages := False

global KeySettings := "F10"
global KeyRunningToggle := "!X"
global KeyStartBot := "Numpad0"
global KeyMoveWholeInventory := "Numpad2"
global KeyReload := "^Numpad5"

;*** Create INI if not exist
ININame=%A_scriptdir%\config.ini
ifnotexist,%ININame%
{
  WriteAll()
}

;*** Load
;IniRead, OutputVar, Filename, Section, Key , Default
IniRead, DebugMessages, %ININame%, General, DebugMessages, %DebugMessages%

IniRead, KeySettings, %ININame%, ToggleKey, KeySettings, %KeySettings%
IniRead, KeyRunningToggle, %ININame%, ToggleKey, KeyRunningToggle, %KeyRunningToggle%
IniRead, KeyStartBot, %ININame%, ToggleKey, KeyStartBot, %KeyStartBot%
IniRead, KeyMoveWholeInventory, %ININame%, ToggleKey, KeyMoveWholeInventory, %KeyMoveWholeInventory%
IniRead, KeyReload, %ININame%, ToggleKey, KeyReload, %KeyReload%

WriteAll() {
  global
  ;IniWrite, Value, Filename, Section, Key
  IniWrite, %DebugMessages%, %ININame%, General, DebugMessages

  IniWrite, %KeySettings%, %ININame%, ToggleKey, KeySettings
  IniWrite, %KeyRunningToggle%, %ININame%, ToggleKey, KeyRunningToggle
  IniWrite, %KeyStartBot%, %ININame%, ToggleKey, KeyStartBot
  IniWrite, %KeyMoveWholeInventory%, %ININame%, ToggleKey, KeyMoveWholeInventory
  IniWrite, %KeyReload%, %ININame%, ToggleKey, KeyReload
}