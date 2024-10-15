;###########################################################################################
;Hparse_rev(Keycombo)
;	Returns the user displayable format of Ahk Hotkey
;###########################################################################################

HParse_rev(Keycombo){

    if Instr(Keycombo, "&")
    {
        loop,parse,Keycombo,&,%A_space%%A_tab%
            toreturn .= A_LoopField " + "
        return Substr(toreturn, 1, -3)
    }
    Else
    {
        StringReplace, Keycombo, Keycombo,^,Ctrl&
        StringReplace, Keycombo, Keycombo,#,Win&
        StringReplace, Keycombo, Keycombo,+,Shift&
        StringReplace, Keycombo, Keycombo,!,Alt&
        loop,parse,Keycombo,&,%A_space%%A_tab%
            toreturn .= ( Strlen(A_LoopField)=1 ? Hparse_StringUpper(A_LoopField) : A_LoopField ) " + "
        return Substr(toreturn, 1, -3)
    }
}

Hparse_StringUpper(str){
    StringUpper, o, str
    return o
}