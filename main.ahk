#Requires AutoHotkey v2.0
#SingleInstance Force

; ====== Includes (use absolute script dir to avoid include-dir issues) ======
#Include "%A_ScriptDir%\web_gui\Neutron.ahk"

; ====== Config ======
APP_TITLE := "Keyboard Dock"
UI_W_EXPANDED := 149        ; panel width (kbd + close buttons)
UI_W_COLLAPSED := 33        ; only toggle tab width
UI_H := 45

; Gap to taskbar / screen edges
MARGIN_RIGHT := 0
MARGIN_BOTTOM := 0

; ====== State ======
global neutron := 0
global gCollapsed := false
global gKbdBlocked := false
global gDragging := false
global gDragStartX := 0
global gDragStartY := 0

; Emergency hotkey (always available): Ctrl+Alt+Backspace
^!BS::EmergencyUnblock()

; ====== Start ======
try {
    InitUI()
} catch as e {
    MsgBox "Startup failed: " e.Message "`n`n" e.What "`nLine: " e.Line, "Error", 16
    ExitApp
}

return


; =====================================================================
; UI bootstrap
; =====================================================================
InitUI() {
    global neutron, UI_W_EXPANDED, UI_H

    htmlPath := A_ScriptDir "\html\index.html"
    if !FileExist(htmlPath)
        throw Error("Cannot find html/index.html: " htmlPath)

    ; Change working directory to script directory so Neutron can find html files
    SetWorkingDir(A_ScriptDir)

    ; Create window
    neutron := NeutronWindow()
        .Load("html/index.html")
        .Opt("-Resize -MaximizeBox -MinimizeBox")   ; fixed-size tool window
        .OnEvent("Close", (*) => ExitProc())
        .Show("x" GetDockX(UI_W_EXPANDED) " y" GetDockY(UI_H) " w" UI_W_EXPANDED " h" UI_H, APP_TITLE)

    ; AHK object is automatically exposed to JS via Neutron._Dispatch
    ; In your html/app.js, call: ahk.Clicked('kbd'|'toggle'|'exit')
    ; and: ahk.SyncFromUi({ collapsed:true, blocked:false }) if you want.

    ; Optional: start always-on-top (depends on Neutron implementation)
    ; If Neutron exposes hWnd: WinSetAlwaysOnTop(true, "ahk_id " neutron.hWnd)
    try {
        WinSetAlwaysOnTop true, "ahk_id " neutron.hWnd
    } catch {
        ; ignore if not available
    }


    ; Ask UI to reflect initial state (optional)
    PushStateToUI()
}

; =====================================================================
; Bridge: called from JS
; =====================================================================
Clicked(neutron, which) {
    global gCollapsed, gKbdBlocked

    switch which {
        case "toggle":
            ToggleCollapsed()
        case "kbd":
            ToggleKeyboardBlock()
        case "exit":
            ExitProc()
        default:
            ; Unknown events are ignored for stability
            return
    }
}
; =====================================================================
; Drag logic: free drag -> release detection -> snap to bounds if needed
; =====================================================================
Drag(neutron) {
    ; 1. Let system handle dragging for smooth tracking experience
    PostMessage 0xA1, 2, 0, , "ahk_id " neutron.hWnd

    ; 2. Wait for left mouse button release (drag ends)
    KeyWait "LButton"

    ; 3. After drag ends, detect position and snap to bounds if needed
    CheckAndSnap(neutron)
}

CheckAndSnap(neutron) {
    try {
        ; Get current window position and size
        WinGetPos &x, &y, &w, &h, "ahk_id " neutron.hWnd
        
        ; Get work area of primary monitor (automatically excludes taskbar height)
        ; WALeft, WATop, WARight, WABottom are left, top, right, bottom boundaries of work area
        MonitorGetWorkArea 1, &WALeft, &WATop, &WARight, &WABottom

        ; Record target coordinates, default to keeping current position
        targetX := x
        targetY := y
        needsFix := false

        ; --- 1. Horizontal boundary check ---
        ; Logic: if window's right edge (x + w) exceeds screen's right edge (WARight)
        ; it means window is partially off the right side of screen
        if (x + w > WARight) {
            ; Fix: snap window to right edge
            targetX := WARight - w
            needsFix := true
        }

        ; --- 2. Vertical boundary check ---
        ; Logic: if window's bottom edge (y + h) exceeds taskbar top edge (WABottom)
        ; it means window is partially below the taskbar or off-screen
        if (y + h > WABottom) {
            ; Fix: snap window to above taskbar
            targetY := WABottom - h
            needsFix := true
        }

        ; --- Apply fix ---
        if (needsFix) {
            ; Use WinMove to reposition window to corrected coordinates
            WinMove targetX, targetY, , , "ahk_id " neutron.hWnd
        }

    } catch {
        ; Ignore potential handle errors
    }
}

; Optional: JS can call this to sync its own state back to AHK.
; Example payload: {collapsed:true, blocked:false}
SyncFromUi(neutron, payload) {
    ; You can keep this empty for MVP.
    ; It exists so your front-end can evolve without breaking.
}

; =====================================================================
; Actions
; =====================================================================
ToggleCollapsed() {
    global gCollapsed, UI_W_EXPANDED, UI_W_COLLAPSED, UI_H, neutron

    gCollapsed := !gCollapsed

    ; Option A: Only let the front-end animate/hide panel, keep window same.
    ; Just update state and inform UI.
    PushStateToUI()

    ; Option B (recommended): actually resize window so only arrow remains.
    ; This makes it feel like ToDesk: only one arrow left when collapsed.
    w := gCollapsed ? UI_W_COLLAPSED : UI_W_EXPANDED

    WinGetPos &currX, &currY, &currW, &currH, "ahk_id " neutron.hWnd
    currentRightEdge := currX + currW
    x := currentRightEdge - W

    try {
        WinMove x, currY, w, UI_H, "ahk_id " neutron.hWnd
    } catch {
        ; ignore if hWnd not available
    }
}

ToggleKeyboardBlock() {
    global gKbdBlocked
    gKbdBlocked := !gKbdBlocked

    if gKbdBlocked
        EnableKeyboardBlock()
    else
        DisableKeyboardBlock()

    PushStateToUI()
}

EmergencyUnblock() {
    global gKbdBlocked
    if gKbdBlocked {
        gKbdBlocked := false
        DisableKeyboardBlock()
        PushStateToUI()
        SoundBeep 880, 80
    } else {
        ; If already unblocked, you can choose to exit quickly:
        ; ExitProc()
        SoundBeep 660, 60
    }
}

ExitProc() {
    global gKbdBlocked
    if gKbdBlocked {
        gKbdBlocked := false
        DisableKeyboardBlock()
    }
    ExitApp
}

; =====================================================================
; Keyboard block implementation (mouse unaffected)
; Strategy: swallow most keys via Hotkeys, keep emergency hotkey alive.
; =====================================================================
EnableKeyboardBlock() {
    ; Swallow most keyboard input.
    ; We intentionally do NOT block mouse.
    ; Keep Ctrl+Alt+Backspace active as emergency - don't block it.

    for key in GetBlockKeyList() {
        ; Skip Backspace - we need Ctrl+Alt+Backspace to work
        if (key = "Backspace")
            continue
        try Hotkey "*" key, Swallow, "On"
    }
    ; Block Backspace without * modifier so Ctrl+Alt+BS still works
    try Hotkey "Backspace", Swallow, "On"
}

DisableKeyboardBlock() {
    for key in GetBlockKeyList() {
        if (key = "Backspace") {
            try Hotkey "Backspace", "Off"
        } else {
            try Hotkey "*" key, "Off"
        }
    }
}

Swallow(*) {
    ; Do nothing; hotkey fires and prevents the key from reaching apps.
    return
}

GetBlockKeyList() {
    ; Covers letters, digits, function keys, arrows, editing keys, etc.
    ; You can adjust as needed.
    static keys := []

    if keys.Length
        return keys

    ; Letters
    Loop 26 {
        keys.Push(Chr(Ord("A") + A_Index - 1))
    }

    ; Digits
    Loop 10 {
        keys.Push("" (A_Index - 1))
    }

    ; Function keys
    Loop 24 {
        keys.Push("F" A_Index)
    }

    ; Editing/navigation
    for k in [
        "Tab","Enter","Space","Backspace","Delete","Insert",
        "Home","End","PgUp","PgDn",
        "Up","Down","Left","Right",
        "Esc",
        "CapsLock","NumLock","ScrollLock",
        "PrintScreen","Pause"
    ]
        keys.Push(k)

    ; Numpad
    for k in [
        "Numpad0","Numpad1","Numpad2","Numpad3","Numpad4",
        "Numpad5","Numpad6","Numpad7","Numpad8","Numpad9",
        "NumpadDot","NumpadDiv","NumpadMult","NumpadAdd","NumpadSub","NumpadEnter"
    ]
        keys.Push(k)

    ; Punctuation / symbols (US layout, still safe to include)
    for k in [
        "`-","`=","`[","`]", "`\","`;","`'","`,","`.","`/",
        "AppsKey"
    ]
        keys.Push(k)

    ; Modifiers: we generally DO swallow them too to prevent any accidental shortcuts,
    ; but leaving them enabled can be useful. Choose your preference.
    ; If you swallow modifiers, mouse-only still works, but hotkeys won't.
    ; for k in ["LShift","RShift","LControl","RControl","LAlt","RAlt","LWin","RWin"]
    ;    keys.Push(k)

    return keys
}

; =====================================================================
; Position helpers: bottom-right above taskbar
; =====================================================================
GetDockX(w) {
    global MARGIN_RIGHT
    ; Use the work area so it sits above the taskbar automatically
    MonitorGetWorkArea 1, &l, &t, &r, &b
    return r - w - MARGIN_RIGHT
}

GetDockY(h) {
    global MARGIN_BOTTOM
    MonitorGetWorkArea 1, &l, &t, &r, &b
    return b - h - MARGIN_BOTTOM
}

; =====================================================================
; Push state to UI (optional but nice)
; Your HTML can implement window.setState({collapsed, blocked})
; =====================================================================
PushStateToUI() {
    global neutron, gCollapsed, gKbdBlocked

    if !neutron
        return

    ; Use neutron.wnd to access the JavaScript window object directly
    try {
        neutron.wnd.setState(ComObject(0x400B, ComObjArray(0xC, 2, gCollapsed, gKbdBlocked)))
    } catch {
        ; Alternative: call execScript to run JS code
        try {
            js := "if(window.setState){window.setState({collapsed:" (gCollapsed ? "true" : "false") ",blocked:" (gKbdBlocked ? "true" : "false") "});}"
            neutron.wnd.execScript(js, "javascript")
        } catch {
            ; ignore if not supported
        }
    }
}

