/************************************************************************
 * @description On-Screen Keypress - Show the key pressed on the screen as a tooltip  
 * @file OSKP.ahk
 * @author TrueCrimeAudit
 * @link https://github.com/TrueCrimeAudit/AHK
 * @date 2024/12/18
 * @dependencies TooltipEx.ahk by @nperovic https://github.com/nperovic/ToolTipEx
 * @version 1.0.0
 ***********************************************************************/

#Requires AutoHotkey v2.1-alpha.14
#SingleInstance Force
#Include <TooltipEx>

ListLines(false)
KeypressTooltip()

class KeypressTooltip {
    __New() {
        this.SetupHotkeys()
        this.lastKeyPress := ""
        this.previousKeys := ""
        this.counter := 1
        this.tooltipHandle := 0
    }

    SetupHotkeys() {
        Loop 95 {
            try {
                key := Chr(A_Index + 31)
                if RegExMatch(key, "[a-zA-Z0-9]")
                    Hotkey("~*" key, this.OnKeyPress.Bind(this))
            }
        }
        Loop 24
            Hotkey("~*F" A_Index, this.OnKeyPress.Bind(this))
        Loop 10
            Hotkey("~*Numpad" A_Index - 1, this.OnKeyPress.Bind(this))
        otherKeys := "NumpadDiv|NumpadMult|NumpadAdd|NumpadSub|Tab|Enter|Esc|BackSpace|Del|Insert|Home|End|PgUp|PgDn|Up|Down|Left|Right|ScrollLock|CapsLock|NumLock|Pause|Space|NumpadDot|NumpadEnter|Media_Play_Pause|Volume_Mute|Volume_Up|Volume_Down|Browser_Home|AppsKey|PrintScreen|Sleep"
        Loop Parse, otherKeys, "|"
            Hotkey("~*" A_LoopField, this.OnKeyPress.Bind(this))
    }

    OnKeyPress(hotkeyInfo) {
        actualKey := SubStr(hotkeyInfo, 3)
        
        if (StrLen(this.previousKeys) > 60) {
            this.previousKeys := this.lastKeyPressf
            this.counter := 1
        }
        
        prefix := this.GetModifierPrefix()
        actualKey := StrReplace(StrReplace(actualKey, "Numpad", "Num"), "&", "&&")
        
        if (this.lastKeyPress = prefix actualKey) {
            this.counter++
            displayPrefix := keyDown := ""
        } else {
            displayPrefix := (prefix = "" && StrLen(actualKey) = 1 && StrLen(this.lastKeyPress) = 1) || this.previousKeys = "" ? prefix : " " prefix
            keyDown := StrLen(actualKey) = 1 ? (GetKeyState("CapsLock", "T") ? Format("{:U}", actualKey) : Format("{:L}", actualKey)) : actualKey
            this.counter := 1
        }
        
        counterDisplay := this.counter > 1 ? "×" this.counter : ""
        displayText := " " this.previousKeys displayPrefix keyDown counterDisplay " "
        
        MouseGetPos(&mouseX, &mouseY)
        this.tooltipHandle := ToolTipEx(displayText, 2, 1)
    }

    GetModifierPrefix() {
        prefix := ""
        for mod in ["Ctrl", "Shift", "Alt", "LWin", "RWin"]
            if GetKeyState(mod)
                prefix .= mod "+"
        return prefix
    }
}
