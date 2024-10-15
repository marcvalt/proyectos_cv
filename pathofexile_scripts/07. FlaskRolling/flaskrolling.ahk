#IfWinActive Path of Exile
#SingleInstance force
#NoEnv ;Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn ;Enable warnings to assist with detecting common errors.
#Persistent
#MaxThreadsPerHotkey 2
;#IfWinActive Path of Exile ; WARNING: DO NOT USE THIS SCRIPT IF YOU HAVE AN "UNLOCKED" MOUSE WHEEL (THAT CAN SCROLL WHILE YOUR FINGER IS NOT TOUCHING IT). USE AT YOUR OWN RISK DEPENDING ON YOUR MOUSEWHEEL SCROLL SPEED/DIFFICULTY, AND NOTE THAT GGG MAY AT ANY TIME DEEM USE OF THIS SCRIPT TO BE BANNABLE.

SetTitleMatchMode 1
SendMode Input ;Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ;Ensures a consistent starting directory.

#Include %A_ScriptDir%\lib\
#Include RandomBezier.ahk

if not A_IsAdmin
{
	Run *RunAs "%A_ScriptFullPath%" ; Requires v1.0.92.01+
	ExitApp
}

;General
global Title:="Path of Exile"
global Speed=3 ; Pixels/ms

; LEFT MONITOR
global AlterationX:=108
global AlterationY:=271
global AugmentX:=222
global AugmentY:=324
global ItemSlotX:=325
global ItemSlotY:=456

V::Alteration()
B::Augment()

Alteration() {
	MoveMouseHuman(AlterationX, AlterationY)
	SendInput {RButton}
	MoveMouseHuman(ItemSlotX, ItemSlotY)
	SendInput {LButton}
}

Augment() {
	MoveMouseHuman(AugmentX, AugmentY)
	SendInput {RButton}
	MoveMouseHuman(ItemSlotX, ItemSlotY)
	SendInput {LButton}
}

MoveMouseHuman(x, y) {
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
	RandomSleep(50, 150)
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
