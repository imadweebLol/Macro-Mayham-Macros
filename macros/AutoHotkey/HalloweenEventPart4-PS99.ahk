; <COMPILER: v1.1.37.02>
#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook
InstallKeybdHook
InstallMouseHook
Persistent
CoordMode "Pixel", "Screen"
CoordMode "Mouse", "Client"
SendMode "Input"
DllCall("winmm\timeBeginPeriod", "UInt", 1)
try TraySetIcon(A_ScriptDir "\mayham.ico")
; falls back to default if mayham.ico missing
A_IconTip := "Macro Mayham – Halloween Event Part 4"
A_TrayMenu.Delete()
A_TrayMenu.Add("Macro Mayham | Open menu (F2)", (*) => Welcome())
A_TrayMenu.Add("Start (F1)", (*) => StartMacro())
A_TrayMenu.Add("Diagnostics (F4)", (*) => ToggleDiag())
A_TrayMenu.Add("Open log", (*) => OpenLog())
A_TrayMenu.Add()
A_TrayMenu.Add("Stop and exit (F3)", (*) => (ReleaseAll(), ExitApp()))
A_TrayMenu.Default := "Macro Mayham | Open menu (F2)"
A_TrayMenu.ClickCount := 1
LogFile := A_ScriptDir "\" RegExReplace(A_ScriptName, "\.\w+$") ".log"
try {
if FileGetSize(LogFile) > 1000000
FileDelete LogFile
}
TurnL := "Left", TurnR := "Right"
ResetAfterBridge := false
BackMaxMs := 20000
BackDownMs := 500
BackDiagMs := 1600
BackJumpMs := 200
RobloxW := 800, RobloxH := 600
HouseDots := Map("roof", "53,2 68,5 80,11 59,14 90,19 46,20 99,28 55,29 38,30 108,37 47,39 30,40 39,49"
, "door", "81,43 69,46 76,51 83,56 70,57 26,59 76,63 69,68 82,69 75,74"
, "wall", "43,8 76,17 36,21 86,27 67,29 96,37 58,40 49,51 90,51 102,59 60,60 42,64 92,69 53,73"
, "edge", "22,2 77,2 89,10 18,18 99,20 10,30 109,30 115,44 14,46 108,57 15,65 105,74 24,76 89,78 65,82 35,85")
LightMin := 1000
InMin := 250
RecheckMs := 20000
JoinWaitMs := 60000
StuckMs := 40000
CyanMin := 20
WhiteMin := 12
WhiteRatio := 0.2
GapCols := 10
ConfirmFrames := 3
SearchTurnMs := 220
InFrac := 0.6
LobbyZoomMs := 2000
BlockSig := 0.12
NudgeMs := 2500
GCharXr := 0.5, GCharYr := 0.508
GParkYr := 0.30
PoleStepMs := 400
FlashMs := 5000
GravesVoidPct := 12
ZoomHoldMs := 700, ZoomTaps := 4
DragPx := 500, DragSteps := 10
YawTol := 0.02
GBot := 0.72, GStep := 4
LitPct := 25, GreenPct := 35, GreenStrong := 70, GoneWhite := 12, OccOther := 8, OccWhite := 20, TileWhite := 35
OccCrowd := 40
OccSafeMs := 1000
OccGapMs := 500
GWalk := 1.07
JumpMsStraight := 200
JumpMsDiag := 430
AirMs := 620
HopMaxMs := 1000, DiagMaxMs := 1400
CenterTol := 0.06, CenterTolDiag := 0.05
BoostDots := Map("Lucky Charm", "17,6,041510 24,6,010F08 40,6,0A1D07 42,11,8BFFF8 29,13,F9E039 46,14,89FFF8 23,16,EDAB1D 37,16,DC7F08 50,17,88FFF7 14,18,D67904 33,19,C9450E 44,19,88FEF0 19,20,E57601 25,21,DA3D11 39,21,ED9C04 11,22,218A85 48,22,88FDF4 21,25,B41D00 31,25,AE1C00 52,25,8AF8EA 44,26,AFCC95 34,29,C83D0D 48,29,8EF1DE 23,30,CE3C05 42,31,9BDDBE 15,32,16120C 30,32,EEB28B 19,35,F7B487 26,35,EFD6C3 45,35,BAC88D 37,36,C0BB9F 13,38,7DAF8E 32,38,DD9152 22,39,F0DDC6 41,39,A8CA9D 8,40,ADC08E 28,41,E1BF94 16,42,DCA77E 55,43,1C2C2A 11,44,A1CEA6 33,44,F7D7B9 24,46,C3956C 38,46,EBCEB8 18,47,D98962 50,47,FBD4B8 29,48,211515 43,48,E1C19F 34,50,F6ECE2 22,51,CF9A71 39,52,F0DAC6 52,52,101D1E 27,53,E3B56F 45,53,C29776 56,55,81EFE8 31,56,D59967"
, "Treat Magnet", "30,11,8BFFF8 46,11,AC76ED 17,13,A37FED 35,14,8BF9F6 23,16,BD70EC 50,16,CC4FF8 31,17,88FFF9 39,17,9374EA 45,18,8600E8 9,20,A504E3 15,21,9100D6 28,21,86E4F5 35,21,82EEF3 41,22,AC00F5 48,22,E56C7C 31,25,84FDF9 57,25,311807 12,26,CB28FF 37,26,80F7F1 44,26,C400F1 18,27,F49281 25,27,CF616B 52,27,493C37 7,29,1D7D7B 33,30,83FCF8 47,30,4A0460 39,31,7BF1F0 58,31,44006B 10,33,150C17 19,33,714500 28,33,89EFE2 53,33,7B4103 44,34,360148 35,35,7FF9FA 24,36,D4C43F 49,36,623071 56,37,BA8526 30,38,7CF6F9 41,38,1F0368 14,39,5C0079 8,40,7E6343 20,40,813181 36,41,9378FC 53,41,2E1A11 27,43,7A3E00 44,43,140400 12,44,3A004F 57,44,461600 39,45,070108 17,46,44164B 50,47,211A1A 23,48,2C2226 35,49,0F0A0C 42,49,1D1619 55,49,340F00 13,50,EC8E20 27,51,1A1517 47,51,23110E 8,52,C9D1A8 17,53,2B1F15 31,54,121011 37,55,170F17 44,55,140F11")
BoostSmall := Map("Lucky Charm", "9,3,2E7C06 12,3,68FD14 21,3,69F619 22,6,000808 15,7,27312B 24,7,0B1514 12,8,545337 19,8,58654B 26,9,3D6D68 7,9,376360 17,10,A54100 23,10,89FFF7 10,10,CD7203 13,11,A15D17 20,11,E58A0A 6,11,6F9F9D 25,11,89FFF6 11,13,D84D05 16,13,B54B00 27,13,86F9F1 23,14,A3D09F 18,15,930E00 25,15,90F5E4 12,16,CA4C0C 22,16,AAD2A7 8,17,309185 16,17,CB9D81 10,18,AD8163 14,18,EDD3BE 23,18,A3D4AA 19,19,A0BF96 7,20,AAC8A4 17,20,DB9F6B 11,20,EACCAA 21,20,A2C9A1 4,21,386260 15,21,D1AA8C 8,22,6E9369 29,22,7CCCCC 6,23,9FD7BB 17,23,E5C0A6 12,24,C38662 20,24,E2CBB6 9,24,614C32 26,24,A4714D 15,25,3F2721 22,25,ECC8A7 18,26,F9DEC9 11,27,7B5B45 20,27,BFA58E 27,27,287370 14,28,B9B293 23,28,010000 29,29,000508 16,29,5C4126"
, "Treat Magnet", "16,6,184F00 24,6,58DA0F 9,7,191A1F 18,7,102312 12,8,382C3B 26,8,7BA265 16,9,2C7276 20,9,9B5CCE 23,9,8F0AD0 5,10,81768B 8,11,AF39E2 15,11,82D7EF 18,11,6EC2D9 21,11,8E00DC 25,11,DB639D 16,13,9BE7FF 30,13,25596B 6,14,8458B1 19,14,817BBD 23,14,C71CD3 9,14,CE46D6 13,14,9F5DB8 27,14,8A6A5D 4,15,3A6360 17,16,81FBF6 24,16,8E23A1 20,16,22757E 30,16,455A93 5,17,4B657B 10,17,AF6C8C 15,17,89DAC8 28,17,7D4B46 23,18,3F0250 18,18,84F7F3 12,19,845B75 25,19,703345 29,19,6091A3 16,20,83EEF0 21,20,3D0158 7,20,1B0C1A 4,21,376161 10,21,A1529D 19,21,9F77F9 28,21,5C3C1A 14,22,7A5838 23,22,360B33 6,23,366B99 30,23,26716E 20,23,1C0433 9,24,6A335D 26,24,4C2819 12,25,612F1E 18,25,280C02 22,25,31100E 29,25,77D5DF 7,26,E09746 14,27,351100 24,27,3E3935 4,27,355F62 9,28,5A5648 16,28,1C1114 19,29,000000 23,29,0F0F10"
, "Flashlight", "13,8,557B75 17,10,C66228 19,11,E69809 22,11,F99E11 24,12,D66E03 26,13,94714A 16,14,874E26 20,14,71421B 23,14,CC4C11 28,14,A5CEA1 13,17,A4B1A5 21,17,8C2F14 17,18,723F40 15,19,945E1E 19,19,80381A 9,21,A8D6B5 12,21,9B895F 16,21,CA7C13 7,23,9DD8B8 10,23,CC9963 15,23,A26411 12,24,8B330E 17,24,744604 9,25,C1A57F 14,25,72372E 11,26,9E4216 16,26,7C4024 13,27,A97136 15,28,A16C2A 7,6,000300 15,6,000A00 30,6,030106 22,7,3B3416 11,10,87FDF7 3,11,3C5D59 27,11,8BECD9 17,13,5C2D11 7,15,7EF9F8 31,15,325654 25,17,77CEC9 12,18,7FE4EA 3,19,285153 18,21,632F04 28,22,77F2F9 6,24,7CE7EB 11,27,6C4821 3,29,244D52 17,29,77D3CE 7,33,204A53 14,34,214B53")
ModeTimeout := 8000
RefocusIdleMs := 5000
EggStep := 6, EggCell := 3, EggBannerPct := 4
EggFlashKey := "", EggFlashMs := 9000
EggFlashMax := 1, EggMagnetMax := 3
BarsKeyJump := "Space", BarsKeyDive := "t", BarsMin := 1300, BarsDelayMs := 0
EggRankBonus := 0.12
EggTolPct := 6, EggTolMin := 8, EggFeetPx := 30, EggPulseMin := 20, EggPulseMax := 150, EggSatMargin := 5, EggBoostMs := 700
global Running := false, WDown := false, Diag := false, Frames := [], Paused := false, Clipped := false
global Joined := false, JoinSeen := 0, JoinedAt := 0, OutHits := 0, Mode := "", StuckN := 0, JoinT0 := 0
global GPhase := "", GCamAt := 0, GViewAt := 0, GRun := false, GBase := 0, GPrev := "", GPrevAt := 0, GPrevP := 0, GMe := 0, GVoidN := 0
global GSafe := Map(), GEv := Map(), GRowSince := 0, GOnRow := -1, GNoAhead := 0, GSteerAt := 0, GBoosted := false, GLastOk := "", GOnBridge := false
global GSlope := 0.0, GCamN := 0, GDoneAt := 0, GRewAt := 0, GAcross := 0, GBackAt := 0, GPlusAt := 0, GCentered := false, GPoleAt := 0, GCount := false, GHop1 := false, GClockAt := 0
global GFlashAt := 0, GBackKey := "", GKillKey := "", GJumpAt := 0, GSafeAt := Map(), GHopTo := 0, GHopCol := "", GHopMsg := false, GHopAt := 0, GHopEnd := 0, GTopRow := 0, GTopAt := 0
global GWin := "", GLastScan := "", GScanMs := 80, LLast := "", GAligned := false, GMagnet := false, GLucky := false, GBoostAt := 0, GBoostN := 0
global KeyH := "", KeyV := "", ModeSeen := 0, ModeCheck := 0, LightN := 0
global LobbyScore := ""
global Approached := false
global GameNo := -1
global WS := 1, UF := 1, LF := 1, Light := "", LobbyBtn := "", LobbyClick := "", LobbyMin := 0, VoidScan := "", VoidStep := 8
global TimerBox := "", TimerSum := 15, TimerGap := 14, LScan := "", Chat := "", LStep := 4, HouseSc := 1, BoostSc := 1
global GTop := 70, GEvTop := 105, GHalfW := 330
global DiagG := "", DiagBody := "", DiagLast := ""
global EggN := 0, EggFlashAt := 0, EggSet := false, EggGs := 0, EggGsum := 0, EggLast := "", EggBoostAt := 0, EggClickAt := Map()
global BarsLast := "", BarsNoneAt := 0
global GameMagnetUsed := false, GameMagnetAttemptAt := 0
global EggUsed := Map(), EggNoneAt := 0, EggPrev := "", EggSpdX := 0, EggSpdY := 0, EggLoopMs := 130, EggTickAt := 0, EggHXat := 0, EggHYat := 0, EggGrabAt := 0
Fit(1920, 1008)
OnExit ReleaseAll
Welcome()
$*F1:: StartMacro()
$*F2:: Welcome()
StartMacro() {
global Running
if Running
return
Running := true
A_IconTip := "Macro Mayham – running"
Log("---- Halloween Event Part 4 - PS99 started (" (A_IsCompiled ? "compiled .exe" : ".ahk") ", admin " (A_IsAdmin ? "yes" : "no") ", AutoHotkey " A_AhkVersion " " A_PtrSize * 8 "-bit, screen " A_ScreenWidth "x" A_ScreenHeight " at " A_ScreenDPI " dpi)")
FocusRoblox() && SizeRoblox()
Status("Started")
SetTimer MainLoop, -1
}
Welcome() {
static g := 0
if g {
    try g.Destroy()
    g := 0
}
; Macro Mayham panel UI (hub-style card, original purple — not Halloween orange)
BG      := "0D0B12"
CARD    := "16121C"
ACCENT  := "7657FF"
TEXT    := "F3F4F8"
MUTED   := "9A93A8"
OK      := "35D07F"
WARN    := "F5A524"

WW := 380, HH := 420
g := Gui("+AlwaysOnTop -MaximizeBox", "Macro Mayham · Halloween Event Part 4")
g.BackColor := BG
g.MarginX := 0, g.MarginY := 0
g.SetFont("s10", "Segoe UI")
try DllCall("dwmapi\DwmSetWindowAttribute", "Ptr", g.Hwnd, "Int", 20, "Int*", 2, "Int", 4)

; Title block
g.SetFont("s16 bold c" TEXT)
g.Add("Text", "x20 y18 w340 h28 BackgroundTrans", "Halloween Event Part 4")
g.SetFont("s9 c" ACCENT)
g.Add("Text", "x20 y48 w340 h18 BackgroundTrans", "PS99 Halloween · Brooms / minigames")

; Info card
g.Add("Text", "x20 y78 w340 h100 Background" CARD, "")
g.SetFont("s9 c" MUTED)
g.Add("Text", "x34 y90 w312 h72 BackgroundTrans",
    "Hands-free helper for the Halloween lobby.`n"
    . "Keep Roblox focused and the camera still.`n`n"
    . "Credit to MrFlyingPies for the macro")

; Status card
g.Add("Text", "x20 y190 w340 h64 Background" CARD, "")
found := !!RobloxHwnd()
g.SetFont("s9 bold c" (found ? OK : WARN))
g.Add("Text", "x34 y202 w312 h20 BackgroundTrans", found ? "●  Roblox detected" : "●  Waiting for Roblox")
g.SetFont("s9 c" MUTED)
g.Add("Text", "x34 y226 w312 h20 BackgroundTrans", "Status:  Stopped")

; Primary actions (hub-style solid buttons)
g.SetFont("s10 bold cFFFFFF")
btnStart := g.Add("Button", "x20 y274 w165 h40", "▶  Start (F1)")
btnMenu  := g.Add("Button", "x195 y274 w165 h40", "Menu (F2)")
btnStart.OnEvent("Click", (*) => (g.Hide(), StartMacro()))
btnMenu.OnEvent("Click", (*) => 0)  ; already open

g.SetFont("s9 c" MUTED)
btnStop := g.Add("Button", "x20 y328 w340 h36", "■  Stop and exit (F3)")
btnStop.OnEvent("Click", (*) => (ReleaseAll(), ExitApp()))

g.SetFont("s8 c" MUTED)
g.Add("Text", "x20 y378 w340 h28 BackgroundTrans",
    "F1 start · F2 menu · F3 stop · F4 diagnostics`nMacro Mayham")

g.OnEvent("Close", (*) => g.Hide())
g.Show("w" WW " h" HH)
}

Hud(t) {
static g := 0, bar := 0, txt := 0, last := "", placeAt := 0, col := "", HW := 340, HH := 56
BG := "0D0B12", ACCENT := "7657FF", MUTED := "9A93A8", TEXT := "F3F4F8"
if !g {
    g := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 +E0x08000000")
    g.BackColor := BG
    g.MarginX := 0, g.MarginY := 0
    bar := g.Add("Text", "x0 y0 w4 h" HH " Background" ACCENT)
    g.SetFont("s8 bold c" MUTED, "Segoe UI")
    g.Add("Text", "x14 y6 w" (HW - 24) " BackgroundTrans", "MACRO MAYHAM · PART 4")
    g.SetFont("s9 norm c" TEXT, "Segoe UI")
    txt := g.Add("Text", "x14 y24 w" (HW - 24) " h26 BackgroundTrans", "")
    g.Show("NA x10 y10 w" HW " h" HH)
    try DllCall("dwmapi\DwmSetWindowAttribute", "ptr", g.Hwnd, "int", 33, "int*", 2, "int", 4)
    placeAt := 0
}
if A_TickCount - placeAt > 1500 {
    placeAt := A_TickCount
    if Client(&ox, &oy, &cw, &ch) {
        if ox + cw + 10 + HW <= A_ScreenWidth
            hx := ox + cw + 10, hy := oy
        else if ox - 10 - HW >= 0
            hx := ox - 10 - HW, hy := oy
        else
            hx := 10, hy := 10
        try g.Move(hx, hy)
    }
}
if t = last
    return
last := t
c := RegExMatch(t, "^(Paused|Roblox lost)") ? "F5A524" : RegExMatch(t, "^Eliminated") ? "FF5364" : RegExMatch(t, "^(RLGL|Brooms)") ? "35D07F" : "7657FF"
if c != col {
    col := c
    bar.Opt("Background" c)
    bar.Redraw()
}
try txt.Text := t
}


DiagShow(t) {
    global DiagG, DiagBody, DiagLast
    if !IsObject(DiagG) {
        g := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20 +E0x08000000")
        g.BackColor := "0B1217"
        g.MarginX := 0, g.MarginY := 0
        g.Add("Text", "x0 y0 w720 h3 Background8B5CF6")
        g.SetFont("s8 bold c8B5CF6", "Segoe UI")
        g.Add("Text", "x16 y12 w360 h16 Background0B1217", "Macro Mayham  /  Diagnostics")
        g.SetFont("s8 norm c5C7C88", "Segoe UI")
        g.Add("Text", "x420 y12 w284 h16 Right Background0B1217", "F4 closes")
        g.SetFont("s9 norm cC9E7EF", "Consolas")
        DiagBody := g.Add("Text", "x16 y34 w688 h40 Background0B1217", "")
        g.Show("x10 y84 w720 h90 NA")
        try WinSetTransparent(235, "ahk_id " g.Hwnd)
        DiagG := g
    }
    if t = DiagLast
        return
    DiagLast := t
    lines := 0
    for l in StrSplit(t, "`n")
        lines += Max(1, Ceil(StrLen(l) / 96))
    h := lines * 16 + 6
    DiagBody.Move(, , , h)
    DiagBody.Value := t
    DiagG.Show("NA w720 h" (h + 46))
}
HideDiag() {
    global DiagG, DiagLast
    DiagLast := ""
    if IsObject(DiagG)
        DiagG.Hide()
}
ToggleDiag() {
    global Diag := !Diag
    SetTimer ShowDiag, Diag ? 500 : 0
    Diag ? ShowFrames() : HideFrames()
    if !Diag
        HideDiag()
}
OpenLog() {
    try Run('notepad.exe "' LogFile '"')
}
$*F3:: {
ReleaseAll()
ExitApp
}
$*F4:: ToggleDiag()
$*F5:: SaveBoostPanel()
$*F8:: TestHop("")
$*F9:: TestHop("a")
$*F10:: TestHop("d")
$*F11:: {
if !Running && FocusRoblox()
SetCamera()
}
TestHop(side) {
if Running || !FocusRoblox()
return
Sleep 150
gs := Scan()
if gs.ok
HopRow(side, gs.me + 1, side = "" ? MyCol(gs) : side = "a" ? "L" : "R", gs)
}
SaveBoostPanel() {
if Running || !FocusRoblox() || !Client(&ox, &oy, &cw, &ch)
return
Sleep 150
x0 := cw - UI(92, 53) - 2
Grab([ox + x0, oy, ox + cw, oy + Min(ch, UI(680, 420) + 60)], &buf, &w, &h)
hdr := Buffer(54, 0)
NumPut("ushort", 0x4D42, hdr, 0), NumPut("uint", 54 + w * h * 4, hdr, 2), NumPut("uint", 54, hdr, 10)
NumPut("uint", 40, hdr, 14), NumPut("int", w, hdr, 18), NumPut("int", -h, hdr, 22)
NumPut("ushort", 1, hdr, 26), NumPut("ushort", 32, hdr, 28)
f := FileOpen(A_ScriptDir "\boost_panel.bmp", "w")
f.RawWrite(hdr, 54), f.RawWrite(buf, w * h * 4), f.Close()
Log("Boost panel saved: window " cw "x" ch ", BoostSc " Round(BoostSc, 3) ", UF " Round(UF, 3) ", panel " w "x" h " px")
ToolTip "Saved boost_panel.bmp", 10, 10
SetTimer () => ToolTip(), -2000
}
RobloxHwnd() {
static hw0 := 0, at := 0
if (a := WinExist("A")) && IsRoblox(a)
return a
if hw0 && A_TickCount - at < 2000 && WinExist(hw0)
return hw0
best := 0, ba := -1
for t in ["ahk_exe RobloxPlayerBeta.exe", "ahk_exe Windows10Universal.exe", "Roblox ahk_exe ApplicationFrameHost.exe"]
try {
for hw in WinGetList(t)
if IsRoblox(hw) {
WinGetClientPos(, , &w, &h, hw)
if w * h > ba
best := hw, ba := w * h
}
}
hw0 := best, at := A_TickCount
return best
}
IsRoblox(hw) {
try {
p := WinGetProcessName(hw)
return p = "RobloxPlayerBeta.exe" || p = "Windows10Universal.exe" || p = "ApplicationFrameHost.exe" && WinGetTitle(hw) = "Roblox"
}
return false
}
RobloxActive() {
try return (hw := WinExist("A")) && IsRoblox(hw) && WinGetMinMax(hw) != -1
return false
}
RobloxAt(x, y) {
if !Client(&ox, &oy, &cw, &ch) || x < 0 || y < 0 || x >= cw || y >= ch
return false
x := Round(ox + x), y := Round(oy + y)
hw := DllCall("WindowFromPoint", "Int64", (y << 32) | (x & 0xFFFFFFFF), "Ptr")
return hw && IsRoblox(DllCall("GetAncestor", "Ptr", hw, "UInt", 2, "Ptr"))
}
InBox(x, y, b) => x >= b[1] && y >= b[2] && x < b[3] && y < b[4]
FocusRoblox() {
if !(hw := RobloxHwnd())
return false
try {
WinActivate hw
WinWaitActive hw, , 1
}
return RobloxActive()
}
RobloxReady() {
global Paused
if RobloxActive() {
Paused := false
return true
}
if !Paused
ReleaseKeys(), Paused := true
hw := RobloxHwnd()
if hw && A_TimeIdlePhysical >= RefocusIdleMs {
Status("Roblox lost focus while you were away: bringing it back")
try WinActivate hw
Sleep 500
} else
Status(hw ? "Paused: Roblox isn't the active window. Click into Roblox to resume (F3 stops)" : "Paused: Roblox window not found")
return false
}
Client(&x, &y, &w, &h) {
static lw := 0, lh := 0
x := 0, y := 0, w := A_ScreenWidth, h := A_ScreenHeight
if !(hw := RobloxHwnd())
return false
try WinGetClientPos &x, &y, &w, &h, hw
catch
return false
if (w != lw || h != lh) && w >= 200 && h >= 150
lw := w, lh := h, Fit(w, h), Log("Roblox window: " w "x" h)
return true
}
Win(rg) {
Client(&ox, &oy, &cw, &ch)
return [ox + rg[1], oy + rg[2], ox + rg[3], oy + rg[4]]
}
SizeRoblox() {
static at := 0, last := "", n := 0
if !RobloxW || A_TickCount - at < 1000 || !(hw := RobloxHwnd()) || !RobloxActive()
return
at := A_TickCount
try {
WinGetClientPos(, , &cw, &ch, hw)
if Abs(cw - RobloxW) <= 1 && Abs(ch - RobloxH) <= 1 && WinGetMinMax(hw) = 0
return n := 0
k := hw " " cw "x" ch, n := k = last ? n + 1 : 1, last := k
if n > 3
return n = 4 && Log("Roblox window stays " cw "x" ch " inside (asked for " RobloxW "x" RobloxH ")")
WinGetPos(&x, &y, &w, &h, hw)
if !(WinGetStyle(hw) & 0xC00000) && w >= A_ScreenWidth && h >= A_ScreenHeight
Tap("F11", 50), Sleep(1500)
if WinGetMinMax(hw) != 0
WinRestore(hw), Sleep(400)
WinGetPos(&x, &y, &w, &h, hw), WinGetClientPos(, , &cw, &ch, hw)
w += RobloxW - cw, h += RobloxH - ch, m := 1
Loop MonitorGetCount()
if MonitorGet(A_Index, &l, &t, &r, &b) && x + w // 2 >= l && x + w // 2 < r && y + h // 2 >= t && y + h // 2 < b
m := A_Index
MonitorGetWorkArea(m, &l, &t, &r, &b)
x := Max(l, Min(x, r - w)), y := Max(t, Min(y, b - h))
Loop 3 {
WinMove(x, y, w, h, hw), Sleep(250)
WinGetClientPos(, , &cw, &ch, hw)
if Abs(cw - RobloxW) <= 1 && Abs(ch - RobloxH) <= 1
break
w += RobloxW - cw, h += RobloxH - ch
}
Log("Roblox window set to " cw "x" ch " inside" (Abs(cw - RobloxW) <= 1 && Abs(ch - RobloxH) <= 1 ? "" : " (asked for " RobloxW "x" RobloxH ")"))
}
}
Fit(cw, ch) {
global WS, UF, LF, Light, LobbyBtn, LobbyClick, LobbyMin, VoidScan, VoidStep, TimerBox, TimerSum, TimerGap
global LScan, Chat, LStep, HouseSc, BoostSc, GTop, GEvTop, GHalfW
hx := cw // 2, WS := ch / 1008, UF := (ch - 592) / 416
Light := [hx - 160, UI(100, 50), hx + 160, UI(260, 170)]
LobbyBtn := [hx - UI(360, 150), ch - UI(113, 87), hx + UI(360, 150), ch - UI(33, 34)], LobbyMin := UI(1200, 500)
LobbyClick := [hx + UI(100, 40), ch - UI(73, 61)]
VoidScan := [hx - Round(510 * WS), ch // 2 - Round(354 * WS), hx + Round(510 * WS), ch // 2 + Round(396 * WS)], VoidStep := Max(4, Round(8 * WS))
TimerBox := [hx - UI(100, 45), UI(35, 12), hx + UI(100, 45), UI(125, 45)], TimerSum := UI(15, 4), TimerGap := UI(14, 6)
LScan := [0, UI(25, 15), cw, ch - UI(108, 80)], Chat := [0, 0, UI(430, 250), UI(350, 200)]
LStep := Max(2, Round(4 * WS)), LF := (4 * WS / LStep) ** 2
HouseSc := 0.675 + 0.325 * UF, BoostSc := 0.52 + 0.48 * UF
GTop := UI(70, 30), GHalfW := Round(330 * WS)
GEvTop := UI(105, 45)
}
UI(a, b) => Round(b + (a - b) * UF)
ShowDiag() {
t := "Roblox active: " (RobloxActive() ? "yes" : "NO (macro waits)") "   mode: " (Mode = "" ? "-" : Mode) "   last game: " GameName(GameNo) "   in lobby: " InLobby() " (house " LobbyScore ", need 32)   Lobby button px: " Count(Win(LobbyBtn), 4, "lobby") " / " LobbyMin
if Mode = "graves" && IsObject(GLastScan) {
gs := GLastScan
t .= "`nGraves: " GPhase "   bridge " (gs.ok ? "OK" : "no (" gs.why ")") "   scan " Round(GScanMs) " ms   grave " gs.cw "px  column gap " gs.colsp "  row gap " gs.pitch "  lean " Round(gs.k, 3)
. "`nYou: row " GMe "   safe ahead: " SafeTxt(GMe + 1) " " SafeTxt(GMe + 2) " " SafeTxt(GMe + 3) " " SafeTxt(GMe + 4)
. RowsTxt(gs)
} else if Mode = "rlgl" || Mode = "" && GameNo <= 1 && !InLobby()
t .= "`nLight green: " Count(Win(Light), 2, "green") "  red: " Count(Win(Light), 2, "red") "  (min " LightMin ")"
else if IsObject(LLast) {
s := LLast
t .= "`nRing: orange " s.on "  green " s.inN " (in: " Round(InMin * LF) "+ and 4x the orange)   " (s.rr ? "middle " Round(s.rx) "," Round(s.ry) " px from you, size " Round(s.rr) : "not made out")
. "`nSign: " (s.ok ? "FOUND" : "no") "  x " s.x "  w " s.w "  cyan " s.n "  white " s.wa "   latched in: " Joined
}
try {
    DiagShow(t "`nW held: " WDown)
} catch {
    ToolTip t "`nW held: " WDown, 10, 60, 2
}
}
SafeTxt(row) => GSafe.Has(row) ? GSafe[row] : "?"
RowsTxt(gs) {
t := ""
for r in gs.rows
if r.HasOwnProp("a") && r.a != ""
t .= "`n  row " r.a ": L " r.L.st " (w" r.L.w " o" r.L.o ")  R " r.R.st " (w" r.R.w " o" r.R.o ")"
return t
}
MainLoop() {
global Joined, JoinSeen, JoinedAt, OutHits, Mode, ModeSeen, ModeCheck, GVoidN, LightN, GameNo, Approached, JoinT0
while Running {
if !RobloxReady() {
Sleep 250
continue
}
SizeRoblox()
if LobbyButton() {
W(false), Move("", "")
Joined := false, Mode := "", GameNo := 0, Approached := false, JoinT0 := 0
ResetGraves()
Status(ClickAt(LobbyClick[1], LobbyClick[2]) ? "Eliminated: clicked Lobby" : "Eliminated: Lobby button seen, but that spot isn't Roblox, so not clicking")
Sleep 1500
} else if InLobby() {
if GameNo != 0 || Mode != ""
ResetGraves(), Mode := "", GameNo := 0, Approached := false, JoinT0 := 0, Log("Lobby")
W(false), Move("", ""), GVoidN := 0, LightN := 0
s := LobbyScan(), now := A_TickCount
if Joined && now - JoinedAt >= JoinWaitMs {
Log("Lobby | no game " JoinWaitMs // 1000 " s after getting in: looking for the circle again")
Joined := false, JoinT0 := 0
}
if Joined && LobbyIn(s) {
JoinSeen := now, OutHits := 0
Status("Lobby: IN circle, waiting")
} else if Joined {
OutHits += s.on >= InMin * LF
if OutHits >= ConfirmFrames {
Joined := false, JoinT0 := now - JoinedAt >= 10000 ? 0 : JoinT0
Log("Lobby | the circle's ring is orange again: not in it")
} else if now - JoinSeen > RecheckMs {
Status("Lobby: holding still, re-checking circle")
Tap(TurnR, SearchTurnMs)
Sleep 80
} else
Status("Lobby: in circle, holding still")
} else {
r := JoinCircle(!Approached)
Approached := true
if r = "in"
Joined := true, JoinSeen := JoinedAt := A_TickCount, OutHits := 0
}
} else {
Joined := false, now := A_TickCount
if Mode = "" {
; ===== OLD MINIGAMES DISABLED (RLGL, bridge/graves, eggs): start detection commented out =====
; s := GameNo <= 1 ? LightState() : "", LightN := s != "" ? LightN + 1 : 0
; GVoidN := GameNo <= 2 && Graves() ? GVoidN + 1 : 0
; if LightN >= (GameNo < 0 ? 2 : 1)
; StartGame("rlgl", 1, (s = "green" ? "WALK" : "FREEZE") " on screen")
; else if GVoidN >= 2
; StartGame("graves", GameNo, "its lavender void on screen")
; else if GameNo = 3 && EggReady()
; StartGame("eggs", 3, "its 'Stand in a shadow' text on screen")
; else {
; W(false), Move("", "")
; Status(GameNo < 0 ? "Game: waiting / loading" : GameNo < 2 ? "Game: waiting for " GameName(GameNo + 1) : GameNo = 3 ? "Game: waiting for the eggs" : "Game: not one the macro plays, waiting")
; }
; ===== SUPPORTED MINIGAME: brooms =====
if now - ModeCheck >= 200 {
ModeCheck := now
if BarsPrompt() != ""
StartGame("bars", 5, "its JUMP / DIVE text on screen")
else {
W(false), Move("", "")
Status("Game: waiting for Brooms")
}
}
}
if Mode = "graves" {
if GViewAt && GameNo < 2
GameNo := 2, Log("Mode: graves: its graves read, so it's the bridge")
if now - GViewAt < 1000
ModeSeen := now
else if now - ModeCheck >= 1000 {
ModeCheck := now
if GameNo < 2 && (s := LightState()) != ""
StartGame("rlgl", 1, (s = "green" ? "WALK" : "FREEZE") " on screen (no graves read, so not the bridge)")
else if Graves()
ModeSeen := now
}
if Mode = "graves" && now - ModeSeen < 3000
PlayGraves()
else if Mode = "graves"
W(false), Move("", ""), Status("Graves | bridge gone, waiting for the next game")
} else if Mode = "rlgl" {
s := LightState()
if s != ""
ModeSeen := now
W(s = "green")
Status(s = "green" ? "RLGL: GO" : s = "red" ? "RLGL: FREEZE" : "RLGL: waiting")
if s = "" && now - ModeCheck >= 500 {
ModeCheck := now
GVoidN := Graves() ? GVoidN + 1 : 0
if GVoidN >= 2
StartGame("graves", GameNo, "its lavender void on screen")
}
} else if Mode = "eggs" {
PlayEggs()
if now - ModeCheck >= 500 {
ModeCheck := now
if EggBanner()
ModeSeen := now
}
} else if Mode = "bars" {
PlayBars()
}
if Mode != "" && A_TickCount - ModeSeen > ModeTimeout {
W(false), Move("", "")
ResetGraves()
Log("Mode: " Mode " over")
GameNo := Mode = "graves" && GameNo = 2 ? 3 : Mode = "eggs" ? 4 : GameNo, Mode := "", GVoidN := 0, LightN := 0
}
}
Sleep 15
}
}
GameName(n) => n = 0 ? "lobby" : n = 1 ? "RLGL" : n = 2 ? "the bridge" : n = 3 ? "the eggs" : n = 4 ? "past the eggs" : n = 5 ? "the brooms" : "?"
StartGame(m, n, why) {
global Mode := m, GameNo := n, ModeSeen := A_TickCount, ModeCheck := A_TickCount, GVoidN := 0, LightN := 0, GameMagnetUsed, GameMagnetAttemptAt
W(false), ResetGraves()
GameMagnetUsed := false, GameMagnetAttemptAt := 0
if m = "eggs"
EggReset()
if m = "bars"
BarsReset()
Log("Mode: " m " (" GameName(m = "rlgl" ? 1 : m = "eggs" ? 3 : m = "bars" ? 5 : 2) "): " why)
}
LobbyButton() => Count(Win(LobbyBtn), 4, "lobby") >= LobbyMin
ClickAt(x, y) {
if !RobloxActive() || !Client(&ox, &oy, &cw, &ch) || !InBox(x, y, [10, 10, cw - 10, ch - 10]) || !RobloxAt(x, y)
return false
MouseMove x + 1, y, 0
Sleep 30
MouseMove x, y, 0
Sleep 30
MouseGetPos &mx, &my
if Abs(mx - x) > 2 || Abs(my - y) > 2 || !RobloxActive() || !RobloxAt(mx, my)
return false
Click "Down"
Sleep 40
Click "Up"
return true
}
KeyDown(k) {
if !RobloxActive()
return false
Send "{" k " down}"
return true
}
KeyUp(k) => Send("{" k " up}")
Tap(key, ms) {
Critical "On"
if KeyDown(key) {
Sleep ms
KeyUp(key)
}
Critical "Off"
}
LobbyScan() {
Client(&ox, &oy, &cw, &ch)
x0 := LScan[1], y0 := LScan[2], hx := cw // 2, hy := ch // 2
Grab([ox + x0, oy + y0, ox + Min(cw, LScan[3]), oy + Min(ch, LScan[4])], &buf, &w, &h)
cols := w // LStep, rows := h // LStep
cn := [], ct := [], cb := []
cn.Length := ct.Length := cb.Length := cols
Loop cols
cn[A_Index] := 0, ct[A_Index] := 99999, cb[A_Index] := -1
inN := 0, on := 0, rp := [], ry := 0
while ry < rows {
base := ry * LStep * w, inChat := y0 + ry * LStep < Chat[4]
cx := 0
while cx < cols {
p := NumGet(buf, (base + cx * LStep) * 4, "uint")
r := (p >> 16) & 255, g := (p >> 8) & 255, b := p & 255
if !(inChat && x0 + cx * LStep < Chat[3]) {
if r >= 220 && g >= 140 && g <= 205 && b >= 40 && b <= 125
on++, rp.Push([x0 + cx * LStep - hx, y0 + ry * LStep - hy])
else if g >= 225 && r >= 185 && r <= 245 && b >= 140 && b <= 215 && g - b >= 30 && g - r >= 5
inN++, rp.Push([x0 + cx * LStep - hx, y0 + ry * LStep - hy])
else if g >= 170 && b > 140 && r < 170 && g - r > 60 && Abs(g - b) < 70 {
i := cx + 1
cn[i]++
if ry < ct[i]
ct[i] := ry
if ry > cb[i]
cb[i] := ry
}
}
cx++
}
ry++
}
res := {inN: inN, on: on, ok: false, x: 0, y: 0, w: 0, n: 0, wa: 0, mx: hx, my: hy, rx: 0, ry: 0, rr: 0}
global LLast := res
if IsObject(c := RingFit(rp)) && c.r >= 100 * WS && c.r <= 600 * WS
res.rx := c.x, res.ry := c.y, res.rr := c.r
best := BestRun(cn, cols, Round(GapCols * 4 * WS / LStep))
if best = ""
return res
top := 99999, bot := -1
Loop best.r - best.l + 1 {
i := best.l + A_Index - 1
if cn[i]
top := Min(top, ct[i]), bot := Max(bot, cb[i])
}
hh := Max(bot - top + 1, 3), ry := Max(0, top - Round(hh * 1.6)), wa := 0
while ry < top {
base := ry * LStep * w
cx := best.l - 1
while cx < best.r {
p := NumGet(buf, (base + cx * LStep) * 4, "uint")
if ((p >> 16) & 255) > 225 && ((p >> 8) & 255) > 225 && (p & 255) > 215
wa++
cx++
}
ry++
}
res.n := best.n, res.wa := wa, res.w := (best.r - best.l + 1) * LStep
res.x := x0 + ((best.l + best.r) // 2 - 1) * LStep, res.y := y0 + ((top + bot) // 2) * LStep
res.ok := best.n >= CyanMin * LF && wa >= WhiteMin * LF && wa >= best.n * WhiteRatio
return res
}
BestRun(arr, cols, gapMax) {
best := "", cur := "", gap := 0
Loop cols {
i := A_Index
if arr[i] {
if cur = ""
cur := {l: i, r: i, n: 0}
cur.r := i, cur.n += arr[i], gap := 0
} else if cur != "" && ++gap > gapMax {
if best = "" || cur.n > best.n
best := cur
cur := "", gap := 0
}
}
if cur != "" && (best = "" || cur.n > best.n)
best := cur
return best
}
LobbyIn(s) => s.inN >= InMin * LF && s.on * 4 < s.inN
JoinCircle(first) {
global JoinT0
leg := 0, legAt := 0, camAt := 0, ins := 0, ref := "", refAt := 0, slow := 0, blocked := 0, side := 1, waitAt := 0
lx := 100, ly := 0, far := 0, last := A_TickCount, t0 := JoinT0 := JoinT0 ? JoinT0 : A_TickCount
while Running {
if !RobloxActive() || LobbyButton() || !InLobby() {
Move("", ""), JoinT0 := RobloxActive() ? JoinT0 : 0
return "abort"
}
if first {
first := false, camAt := A_TickCount
Status("Lobby: camera straight down and zoomed out"), Move("", ""), SetCamera(), Tap("o", LobbyZoomMs)
continue
}
s := LobbyScan(), now := A_TickCount
if !LobbyIn(s)
ins := 0
else if ++ins >= ConfirmFrames {
Move("", "")
Log("Lobby | in the circle (its ring went green)")
return "in"
} else {
Move("", "")
Sleep 100
continue
}
tx := s.rr ? s.rx : s.ok ? s.x - s.mx : "", ty := s.rr ? s.ry : s.y - s.my
d := tx = "" ? 0 : Sqrt(tx ** 2 + ty ** 2), mid := s.rr && d < InFrac * s.rr
far += mid ? 0 : now - last, last := now
if far > StuckMs || now - t0 > 120000 {
Unstick(lx, ly)
far := 0, slow := 0, ref := "", leg := 0, last := t0 := JoinT0 := A_TickCount
continue
}
if tx = "" {
ref := "", slow := 0
if now - camAt > 6000 {
Move("", ""), camAt := now
Status("Lobby: circle not in view, setting the camera again"), SetCamera(), Tap("o", LobbyZoomMs)
continue
}
if now - legAt > 1500 * ((leg + 1) // 2) {
leg++, legAt := now, k := Mod(leg - 1, 4), lx := k = 0 ? 100 : k = 2 ? -100 : 0, ly := k = 1 ? -100 : k = 3 ? 100 : 0
Toward(lx, ly), Status("Lobby: circle not in view, walking " (["right", "up", "left", "down"][k + 1]))
}
Sleep 100
continue
}
leg := 0
if mid {
Move("", ""), ref := "", slow := 0
if s.rr && now - waitAt >= NudgeMs {
waitAt := now, Toward(tx, ty)
Sleep 250
Move("", "")
}
Status("Lobby: well inside the circle, waiting to be let in (it may be full)")
Sleep 150
continue
}
k := s.rr ? 1 - InFrac * 0.5 * s.rr / d : 1, lx := tx * k, ly := ty * k
Toward(lx, ly)
g := ScreenSig()
if !IsObject(ref)
ref := g, refAt := now
else if now - refAt >= 300
slow := SigDiff(g, ref) < BlockSig ? slow + 1 : 0, ref := g, refAt := now
if slow >= 2 {
slow := 0, ref := "", side := -side, blocked++
Status("Lobby: held up (" blocked "), going round")
if !Mod(blocked, 3) {
Toward(-lx, -ly)
Sleep 400
}
Toward(lx * 0.3 - ly * side, ly * 0.3 + lx * side)
Tap("Space", 60)
Sleep 250 + 80 * Min(blocked, 5)
} else
Status("Lobby: walking to the circle (" (s.rr ? "ring" : "sign") ", " Round(d) " px)")
}
Move("", "")
return "abort"
}
Toward(x, y) => Move(Abs(x) > Max(25 * WS, 0.4 * Abs(y)) ? (x > 0 ? "d" : "a") : "", Abs(y) > Max(25 * WS, 0.4 * Abs(x)) ? (y > 0 ? "s" : "w") : "")
Unstick(x, y) {
global StuckN
sd := Mod(StuckN++, 2) ? 1 : -1
Log("Lobby | not in after a while: backing away to come at the circle again from somewhere else")
Status("Lobby: stuck, backing away")
Toward(-x, -y)
Sleep 1500
Toward(-y * sd, x * sd)
Sleep 1200
Move("", "")
}
ScreenSig() {
Grab(Win(LScan), &buf, &w, &h)
g := Max(10, Round(40 * WS)), sig := Buffer(Ceil(w / g) * Ceil(h / g) * 4), k := 0, yy := 0
while yy < h {
xx := 0
while xx < w
NumPut("UInt", NumGet(buf, (yy * w + xx) * 4, "UInt"), sig, k), k += 4, xx += g
yy += g
}
return sig
}
SigDiff(a, b) {
n := Min(a.Size, b.Size) // 4, c := 0
Loop n {
p := NumGet(a, (A_Index - 1) * 4, "UInt"), q := NumGet(b, (A_Index - 1) * 4, "UInt")
c += Abs(((p >> 16) & 255) - ((q >> 16) & 255)) + Abs(((p >> 8) & 255) - ((q >> 8) & 255)) + Abs((p & 255) - (q & 255)) > 60
}
return n ? c / n : 0
}
RingFit(pts) {
n := pts.Length, tol := 10 * WS, c := "", bn := 0
if n < 60 * LF
return ""
Loop 40 {
k := A_Index - 1, i := k * n // 40
t := Circle3(pts[i + 1], pts[Mod(i + n // 3, n) + 1], pts[Mod(i + 2 * n // 3 + k, n) + 1])
if !IsObject(t) || t.r < 100 * WS || t.r > 600 * WS
continue
m := 0
for p in pts
m += Abs(Sqrt((p[1] - t.x) ** 2 + (p[2] - t.y) ** 2) - t.r) <= tol
if m > bn
bn := m, c := t
}
if !IsObject(c)
return ""
Loop 2 {
n := 0, sx := sy := sxx := syy := sxy := sz := sxz := syz := 0.0
for p in pts {
x := p[1], y := p[2]
if Abs(Sqrt((x - c.x) ** 2 + (y - c.y) ** 2) - c.r) > tol
continue
z := x * x + y * y, n++, sx += x, sy += y, sxx += x * x, syy += y * y, sxy += x * y, sz += z, sxz += x * z, syz += y * z
}
if n < 60 * LF || !(dt := Det3(sxx, sxy, sx, sxy, syy, sy, sx, sy, n))
return ""
dd := Det3(-sxz, sxy, sx, -syz, syy, sy, -sz, sy, n) / dt, ee := Det3(sxx, -sxz, sx, sxy, -syz, sy, sx, -sz, n) / dt
ff := Det3(sxx, sxy, -sxz, sxy, syy, -syz, sx, sy, -sz) / dt
c := {x: -dd / 2, y: -ee / 2, n: n}, c.r := Sqrt(Max(0, c.x ** 2 + c.y ** 2 - ff))
}
return c
}
Circle3(p, q, r) {
if !(d := 2 * (p[1] * (q[2] - r[2]) + q[1] * (r[2] - p[2]) + r[1] * (p[2] - q[2])))
return ""
a := p[1] ** 2 + p[2] ** 2, b := q[1] ** 2 + q[2] ** 2, e := r[1] ** 2 + r[2] ** 2
x := (a * (q[2] - r[2]) + b * (r[2] - p[2]) + e * (p[2] - q[2])) / d, y := (a * (r[1] - q[1]) + b * (p[1] - r[1]) + e * (q[1] - p[1])) / d
return {x: x, y: y, r: Sqrt((p[1] - x) ** 2 + (p[2] - y) ** 2)}
}
Det3(a, b, c, d, e, f, g, h, i) => a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)
Graves() => Pct(Win(VoidScan), VoidStep, "void") >= GravesVoidPct
ResetGraves() {
global GPhase := "", GCamAt := 0, GViewAt := 0, GRun := false, GBase := 0, GPrev := "", GPrevAt := 0, GPrevP := 0, GMe := 0
global GSafe := Map(), GEv := Map(), GRowSince := 0, GOnRow := -1, GNoAhead := 0, GWin := "", GBoosted := false, GLastOk := "", GOnBridge := false
global GSlope := 0.0, GCamN := 0, GCentered := false, GPoleAt := 0, GCount := false, GHop1 := false, GAcross := 0, GClockAt := 0
global GFlashAt := 0, GBackKey := "", GKillKey := "", GSafeAt := Map(), GHopTo := 0, GAligned := false, GMagnet := false, GLucky := false, GBoostAt := 0, GBoostN := 0
}
PlayGraves() {
global GPhase, GRun, GRowSince, GOnRow, GNoAhead, GMe, GCount, GKillKey, GFlashAt, GTopRow, GTopAt
if GPhase = ""
W(false), GPhase := "camera"
if !GRun
BoostTry()
if GPhase = "kill"
return (Move(GKillKey, ""), Status("Graves | last seconds: off the side to be eliminated"))
if ResetAfterBridge && GRun && LastSeconds() && !Steering() {
GKillKey := IsObject(GLastOk) && MyCol(GLastOk) = "L" ? "a" : "d"
W(false), Move(GKillKey, ""), GPhase := "kill"
return Log("Graves | 0:03 or less on the timer: holding " (GKillKey = "a" ? "left (A)" : "right (D)") " off the side till eliminated")
}
if GPhase = "camera"
return CamStep()
if GPhase = "done"
return BridgeDone()
if GPhase = "back"
return RunBack()
if GPhase = "over"
return Status("Graves | across the bridge")
gs := Scan()
if !gs.ok && GRun && IsObject(GLastOk) && GLastOk.me >= 1 && A_TickCount - GLastOk.at < 4000 && EndAhead(GLastOk) {
Status("Graves | finish ahead (bridge view cut off): stepping onto it")
return ToFinish(GLastOk)
}
if !gs.ok {
if A_TickCount - GViewAt > 800
GPhase := "camera"
return Status("Graves | bridge not in view (" gs.why ")")
}
GMe := me := gs.me
if !GRun {
if TimerState() = "countdown"
return (GCount := true, Status("Graves | countdown: camera set, waiting for the start"))
GRun := true, GTopRow := 0, GTopAt := A_TickCount
}
if me != GOnRow
GOnRow := me, GRowSince := A_TickCount
if Steering()
return Status("Graves | you're steering: macro waits")
if me > GTopRow
GTopRow := me, GTopAt := A_TickCount
if A_TickCount - Max(GTopAt, GFlashAt) >= FlashMs && !GSafe.Has(me + 1) {
GFlashAt := A_TickCount
Boosts(["Flashlight"], "Graves | " (A_TickCount - GTopAt) // 1000 " s without getting further or proof for row " (me + 1))
}
if me = 0
return FromPlatform(gs)
if !gs.on
return Status("Graves | between rows")
nxt := RowA(gs, me + 1)
if !IsObject(nxt) {
GNoAhead := EndAhead(gs) ? GNoAhead + 1 : 0
if GNoAhead < 2
return Status("Graves | no row ahead of row " me)
Status("Graves | last row: stepping onto the finish")
return ToFinish(gs)
}
GNoAhead := 0
my := MyCol(gs), tgt := GSafe.Has(me + 1) ? GSafe[me + 1] : ""
if tgt = ""
return Status("Graves | on row " me ", waiting for proof on row " (me + 1) " (" (A_TickCount - GRowSince) // 1000 "s)")
Status("Graves | row " me " -> " . (me + 1) . (tgt = my ? " straight" : " diagonal") . " to " tgt)
if tgt = my && Abs(NearColX(gs) - gs.charX) <= 0.15 * gs.colsp && Abs(gs.own.cy - gs.charY) <= 0.15 * gs.pitch
return HopRow("", me + 1, tgt, gs)
if CenterOwn(tgt != my, gs)
HopRow(tgt = my ? "" : tgt = "L" ? "a" : "d", me + 1, tgt, GLastScan)
}
ToFinish(gs) {
global GPhase, GDoneAt, GRewAt, GPlusAt, GAcross
Reward(true), GPlusAt := 0, GAcross := 0
HopRow("", gs.me + 1, MyCol(gs), gs, Across)
if !GAcross && KeyDown("w") {
t0 := A_TickCount
while A_TickCount - t0 < 500 && !Across()
Sleep 10
KeyUp("w")
}
GPhase := "done", GDoneAt := A_TickCount, GRewAt := 0
BridgeDone()
}
Across() {
global GAcross
if !GAcross && (PlusSeen() || FinishMsg())
GAcross := A_TickCount
return GAcross != 0
}
PlusSeen() {
global GPlusAt
Client(&ox, &oy, &cw, &ch)
y := Round(ch * GCharYr), hw := Round(220 * WS)
if Count([ox + cw // 2 - hw, oy + Max(0, y - Round(260 * WS)), ox + cw // 2 + hw, oy + y - Round(20 * WS)], 2, "plus") >= 120 * WS * WS
GPlusAt := A_TickCount
return GPlusAt != 0
}
BridgeDone() {
global GPhase, GRewAt, GBackAt, GBackKey
if !ResetAfterBridge
return Status("Graves | across the bridge")
now := A_TickCount
if !Across() && Reward()
GRewAt := now
if GAcross || GRewAt && now - GRewAt >= 500 {
h := IsObject(GLastOk) && MyCol(GLastOk) = "L" ? "a" : "d"
GBackKey := h = "a" ? "d" : "a"
Log("Graves | across" (GPlusAt ? " (+points popped up)" : GAcross ? " ('Safe across the bridge!' is up)" : " (points counted)") ": on its " (h = "a" ? "left" : "right") " side, running off that edge (S " BackDownMs " ms, then S+" (h = "a" ? "A" : "D") " " BackDiagMs " ms, then S+" (GBackKey = "a" ? "A" : "D") " and jumping) to start over")
Critical "On"
Move("", "s"), Sleep(BackDownMs), Move(h, "s"), Sleep(BackDiagMs), Move(GBackKey, "s")
Critical "Off"
GPhase := "back", GBackAt := A_TickCount
} else if !GRewAt && now - GDoneAt >= 6000
GPhase := "play", Log("Graves | no sign of being across: reading the bridge again")
else
Status("Graves | across, waiting for the points")
}
RunBack() {
global GPhase, GJumpAt
if A_TickCount - GBackAt < BackMaxMs {
Move(GBackKey, "s")
if A_TickCount - GJumpAt >= BackJumpMs
GJumpAt := A_TickCount, Tap("Space", 40)
return Status("Graves | under the bridge: S+" (GBackKey = "a" ? "A" : "D") " and jumping till eliminated")
}
Move("", ""), GPhase := "over"
Log("Graves | not eliminated " BackMaxMs // 1000 " s after running off the bridge: waiting for the next game")
}
CamStep() {
global GPhase, GCamAt, GViewAt, GAligned, GCamN, GPoleAt
if GridScan().ok {
GPhase := "play", GViewAt := A_TickCount, GCamN := 0
if !GAligned
GAligned := true, AlignYaw()
return Status("Graves | camera ready")
}
if GCamN && A_TickCount - GPoleAt >= 600 && (side := PoleSide()) && TimerState() != "countdown" {
GPoleAt := A_TickCount, GCamAt := 0
Log("Graves | a pole right beside you on the " (side > 0 ? "right" : "left") " keeps the camera in close: stepping " (side > 0 ? "left" : "right") " away from it")
Tap(side > 0 ? "a" : "d", PoleStepMs)
}
if A_TickCount - GCamAt < (GRun && GCamN >= 3 ? 4000 : 400)
return Status("Graves | waiting for the bridge to be readable (" GLastScan.why ")")
Status("Graves | zooming out + tilting the camera")
SetCamera()
GCamAt := A_TickCount, GCamN++
}
BoostTry() {
global GMagnet, GLucky, GBoostAt, GBoostN
if GMagnet || GBoostN >= 8 || A_TickCount - GBoostAt < 1500
return
GBoostAt := A_TickCount, GBoostN++
if !GMagnet
GMagnet := Boosts(["Treat Magnet"], "Graves (try " GBoostN ")") > 0
}
BoostPts(pat, name, sc) {
pts := []
for d in StrSplit(pat[name], " ")
q := StrSplit(d, ","), pts.Push([Round(q[1] * sc) + 2, Round(q[2] * sc), Integer("0x" q[3])])
return pts
}
BoostScore(buf, w, h, pts, y, dx, quick := false) {
n := 0, miss := 0
for q in pts {
xx := q[1] + dx, yy := y + q[2]
if xx < 0 || xx >= w || yy >= h {
miss++
continue
}
v := NumGet(buf, (yy * w + xx) * 4, "uint")
if Abs(((v >> 16) & 255) - (q[3] >> 16)) <= 40 && Abs(((v >> 8) & 255) - ((q[3] >> 8) & 255)) <= 40 && Abs((v & 255) - (q[3] & 255)) <= 40
n++
else if quick && ++miss > pts.Length * 0.4
return 0
}
return n / pts.Length
}
BoostFind(buf, w, h, pts, bh, minF, y1 := 0, y2 := -1) {
by := Max(0, y1), bx := 0, best := 0
y2 := y2 < 0 ? h - bh - 1 : Min(y2, h - 1)
y := by
while y <= y2 {
for dx in [0, -1, 1, -2, 2] {
f := BoostScore(buf, w, h, pts, y, dx, minF >= 0.6)
if f > best
best := f, by := y, bx := dx
}
y++
}
return best >= minF ? [by, bx, best] : ""
}
Boosts(names, tag) {
if !Client(&ox, &oy, &cw, &ch)
return
sm := BoostSc < 0.76, sc := sm ? BoostSc / 0.52 : BoostSc, bh := Round(60 * BoostSc)
x0 := cw - UI(92, 53), y0 := UI(100, 60)
pat := sm ? BoostSmall : BoostDots, used := 0, r := 0
for name in names {
if A_Index > 1
Sleep 300
Grab([ox + x0 - 2, oy + y0, ox + x0 + Round(70 * BoostSc) + 2, oy + Min(ch, UI(680, 420))], &buf, &w, &h)
if !pat.Has(name) {
Log(tag " | " name " button: not known at this window size")
continue
}
pts := BoostPts(pat, name, sc)
hit := BoostFind(buf, w, h, pts, bh, 0.6), how := "pattern"
if name = "Treat Magnet" {
anc := BoostFind(buf, w, h, BoostPts(pat, "Lucky Charm", sc), bh, 0.4)
if IsObject(anc) {
ey := anc[1] + Round(119 * BoostSc)
t := BoostFind(buf, w, h, pts, bh, 0, ey - 5, ey + 5)
if IsObject(t)
hit := t, how := "one slot below Lucky Charm"
}
}
if IsObject(hit) {
by := hit[1], bx := hit[2]
Loop name = "Flashlight" ? 1 : 3 {
k := A_Index, r := 0
ClickAt(x0 + bx + Round(34 * BoostSc), y0 + by + Round(40 * BoostSc))
if name = "Flashlight"
break
Sleep 600
if !(r := Ready(x0 + bx, y0 + by))
break
}
used += !r
Log(tag " | clicked " name " at y " by " (" how ", match " Round(hit[3] * 100) "%)" (k > 1 ? " (" k " goes)" : "") (r ? ", but it still says Ready!" : ""))
} else
Log(tag " | " name " button not found")
}
ParkCursor()
return used
}
Ready(x, y) {
Client(&ox, &oy, &cw, &ch)
return Count([ox + x, oy + y, ox + x + Round(66 * BoostSc), oy + y + Round(14 * BoostSc)], 1, "ready") >= 15 * BoostSc / 0.52
}
AlignYaw() {
global GWin
static gain := 0.004
k0 := "", px := 0
Loop 3 {
GWin := "", gs := GridScan()
if !gs.ok
Sleep(60), GWin := "", gs := GridScan()
if !gs.ok
break
if k0 != "" && Abs(gs.kf - k0) >= 0.004 && Abs(g := (gs.kf - k0) / px) >= 0.0005 && Abs(g) <= 0.03
gain := g
if Abs(gs.kf) <= YawTol
return (Log("Camera | bridge straight on screen" (k0 = "" ? "" : " after turning (lean " Round(gs.kf, 3) ")")), true)
if A_Index = 3
break
k0 := gs.kf, px := Round(-k0 / gain), px := Max(-150, Min(150, px ? px : k0 / gain > 0 ? -1 : 1))
if !RightDrag(px, 0)
break
Sleep 80
}
Log("Camera | bridge still leans " (gs.ok ? Round(gs.kf, 3) : "?") " on screen")
return false
}
PoleSide() {
if !Client(&ox, &oy, &cw, &ch)
return 0
Grab([ox, oy + ch // 10, ox + cw, oy + ch * 8 // 10], &buf, &w, &h)
n := 0, p := 0, sx := 0, gr := 0, yy := 0
while yy < h {
xx := 0
while xx < w {
q := NumGet(buf, (yy * w + xx) * 4, "UInt"), r := (q >> 16) & 255, g := (q >> 8) & 255, b := q & 255, n++
if b >= 40 && b <= 120 && r <= 50 && g <= 60 && b - r >= 25
p++, sx += xx
else if g > r + 35 && g > b
gr++
xx += 4
}
yy += 4
}
if p < 0.03 * n || gr < 0.3 * n || Abs(c := sx / p / w - 0.5) < 0.15
return 0
return c > 0 ? 1 : -1
}
SetCamera() {
if !KeyDown("o")
return
t0 := A_TickCount
RightDrag()
Sleep Max(0, ZoomHoldMs - (A_TickCount - t0))
KeyUp("o")
Loop ZoomTaps {
Tap("o", 40)
Sleep 30
}
}
LastSeconds() {
global GClockAt
t := TimerState(true)
if t = "running" && !GClockAt
GClockAt := A_TickCount
return t = "last3" && GClockAt && A_TickCount - GClockAt >= 5000
}
TimerState(ones := false) {
Grab(Win(TimerBox), &buf, &w, &h)
m := Buffer(w * h, 0), colN := []
colN.Length := w
Loop w
colN[A_Index] := 0
yy := 0
while yy < h {
xx := 0
while xx < w {
p := NumGet(buf, (yy * w + xx) * 4, "uint")
r := (p >> 16) & 255, g := (p >> 8) & 255, b := p & 255
if r >= 244 && g >= 244 && b >= 244 && Max(r, g, b) - Min(r, g, b) <= 6 {
NumPut("uchar", 1, m, yy * w + xx)
colN[xx + 1]++
}
xx++
}
yy++
}
best := [], cur := [], bs := 0, cs := 0
for x in Runs(colN, 1, 1, 2) {
if x.sum < TimerSum
continue
if cur.Length && x.l - cur[cur.Length].r > TimerGap {
if cs > bs
best := cur, bs := cs
cur := [], cs := 0
}
cur.Push(x), cs += x.sum
}
if cs > bs
best := cur
if best.Length < 4
return "none"
ci := 1, mw := 0
for i, x in best {
if x.sum < best[ci].sum
ci := i
mw := Max(mw, x.r - x.l + 1)
}
if ci = 1 || ci = best.Length
return "none"
if !ZeroGlyph(m, w, h, best[ci - 1], mw) || !ZeroGlyph(m, w, h, best[ci + 1], mw)
return "running"
return ones && ci + 2 <= best.Length && Under4(m, w, h, best[ci + 2], mw) ? "last3" : "countdown"
}
Under4(m, w, h, d, mw) {
x1 := d.l - 1, dw := d.r - d.l + 1
if dw <= mw * 0.6
return true
rows := []
Loop h {
y := A_Index - 1, n := 0
Loop dw
n += NumGet(m, y * w + x1 + A_Index - 1, "uchar")
rows.Push(n)
}
b := ""
for x in Runs(rows, 1, 1, 2)
if !IsObject(b) || x.r - x.l > b.r - b.l
b := x
if !IsObject(b)
return false
hh := b.r - b.l + 1, lw := Ceil(dw / 3), rx := 2 * dw // 3, mid := tl := bl := br := false
Loop hh {
i := A_Index - 1, y := b.l - 1 + i, lt := rt := false
Loop dw
if NumGet(m, y * w + x1 + A_Index - 1, "uchar")
lt := lt || A_Index <= lw, rt := rt || A_Index > rx
mid := mid || lt && i >= 0.3 * hh && i <= 0.6 * hh
tl := tl || lt && i <= 0.25 * hh
bl := bl || lt && i >= 0.75 * hh
br := br || rt && i >= 0.75 * hh
}
return !mid && tl && bl && br
}
ZeroGlyph(m, w, h, d, mw) {
if d.r - d.l + 1 <= mw * 0.6
return false
x1 := d.l - 1, x2 := d.r - 1, c := Max(1, (x1 + x2) // 2), t := -1, bt := -1
Loop h {
y := A_Index - 1, x := x1
while x <= x2 {
if NumGet(m, y * w + x, "uchar") {
t := t < 0 ? y : t, bt := y
break
}
x++
}
}
if t < 0
return false
hh := bt - t + 1, top := false, bot := false, mid := false
y := t
while y <= bt {
if NumGet(m, y * w + c - 1, "uchar") || NumGet(m, y * w + c, "uchar") || NumGet(m, y * w + c + 1, "uchar") {
if y <= t + hh * 0.25
top := true
else if y >= bt - hh * 0.12
bot := true
else if y >= t + hh * 0.35 && y <= t + hh * 0.65
mid := true
}
y++
}
return top && bot && !mid
}
ParkCursor() {
if !RobloxActive() || !Client(&ox, &oy, &cw, &ch)
return false
for p in [[GCharXr, GParkYr], [0.5, 0.45], [0.3, 0.35], [0.7, 0.35]]
if RobloxAt(x := Round(cw * p[1]), y := Round(ch * p[2])) {
MouseMove x, y, 0
Sleep 200
return true
}
Log("Camera | no spot on Roblox's view to start the drag from (something on top of it?)")
return false
}
RightDrag(dx := 0, dy := DragPx) {
if !FocusRoblox() || !Client(&ox, &oy, &cw, &ch)
return false
box := [60, 60, cw - 60, Round(ch * 0.75)]
Loop dy ? 2 : 1 {
go := A_Index
MouseGetPos &mx, &my
if !InBox(mx, my, box) || !RobloxAt(mx, my) {
if !ParkCursor()
return false
Sleep 300
MouseGetPos &mx, &my
if !InBox(mx, my, box) || !RobloxAt(mx, my)
return (Log("Camera | the cursor didn't stay on Roblox's view: no drag"), false)
}
if !RobloxActive() || !ClipCursorTo([ox + box[1], oy + box[2], ox + box[3], oy + box[4]])
return false
ref := ScreenSig()
Click "Right Down"
Sleep 60
Loop DragSteps {
if !RobloxActive()
break
i := A_Index, DllCall("mouse_event", "UInt", 0x0001, "Int", Round(dx * i / DragSteps) - Round(dx * (i - 1) / DragSteps)
, "Int", Round(dy * i / DragSteps) - Round(dy * (i - 1) / DragSteps), "UInt", 0, "UPtr", 0)
Sleep 12
}
Sleep 40
Click "Right Up"
Sleep 60
ClipCursorTo("")
MouseGetPos &ex, &ey
if Abs(ex - mx) > 30 || Abs(ey - my) > 30
MouseMove mx, my, 0
if !dy || SigDiff(ScreenSig(), ref) >= 0.15
return true
Log("Camera | the drag didn't move the view (go " go "): again")
Sleep 100
}
return false
}
ClipCursorTo(rect) {
static old := Buffer(16, 0)
global Clipped
if IsObject(rect) {
if !Clipped
DllCall("GetClipCursor", "Ptr", old)
r := Buffer(16)
NumPut("Int", rect[1], "Int", rect[2], "Int", rect[3], "Int", rect[4], r)
Clipped := DllCall("ClipCursor", "Ptr", r)
} else if Clipped {
DllCall("ClipCursor", "Ptr", old)
Clipped := false
}
return Clipped
}
Steering() {
global GSteerAt
for k in ["w", "a", "s", "d", "Space"]
if GetKeyState(k, "P")
GSteerAt := A_TickCount
return A_TickCount - GSteerAt < 700
}
FromPlatform(gs) {
global GCentered, GHop1
if !GCentered {
GCentered := true
return CenterBridge()
}
if OnRowOne(gs) {
Log("Graves | walked onto row 1 before its hop (rows ahead would be counted one off): back off it")
return (Tap("s", MoveMs(0.7 * gs.pitch, gs.pitch)), Sleep(150))
}
r1 := RowA(gs, 1)
if !IsObject(r1)
return Status("Graves | can't see row 1 yet")
if (gs.charY - r1.cy) / gs.pitch > 1.12 {
Status("Graves | walking up to row 1")
return WalkUp()
}
tgt := GSafe.Has(1) ? GSafe[1] : ""
if tgt = ""
return Status("Graves | at row 1, waiting for proof (" (A_TickCount - GRowSince) // 1000 "s)")
Status("Graves | row 1: lining up on " tgt)
if AlignPlatform(tgt)
GHop1 := true, HopRow("", 1, tgt, GLastScan)
}
OnRowOne(gs) {
for r in gs.rows
if r.full && Abs(r.cy - gs.charY) <= 0.35 * gs.pitch && Abs(NearColX(gs) - gs.charX) <= 0.35 * gs.colsp
return true
return false
}
WalkUp() {
Critical "On"
if KeyDown("w") {
t0 := A_TickCount
while A_TickCount - t0 < 3000 && RobloxActive() {
gs := Scan()
if !gs.ok
break
r1 := RowA(gs, 1)
if !IsObject(r1) || (gs.charY - r1.cy) / gs.pitch <= 1.02 + GScanMs / 1000 * GWalk
break
}
KeyUp("w")
}
Sleep 60
Critical "Off"
}
CenterBridge() {
Status("Graves | centering on the bridge")
Critical "On"
k := "", dx0 := "", dx := 0, t0 := A_TickCount
while A_TickCount - t0 < 3000 && RobloxActive() {
gs := Scan()
if !gs.ok
break
dx := (gs.cols[1] + gs.cols[2]) / 2 - gs.charX, dx0 := dx0 = "" ? dx : dx0
if Abs(dx) <= (k = "" ? CenterTol * gs.colsp : (1.5 * GScanMs + 30) / 1000 * GWalk * gs.pitch)
break
if (n := dx > 0 ? "d" : "a") != k {
if k != ""
KeyUp(k)
if !(k := KeyDown(n) ? n : "")
break
}
}
if k != ""
KeyUp(k)
Sleep 60
Critical "Off"
if dx0 != ""
Log("Graves | centering on the bridge: started " Round(Abs(dx0)) " px " (dx0 > 0 ? "left" : "right") " of its middle, stopped " Round(Abs(dx)) " px from it")
}
AlignPlatform(col) {
Loop 8 {
gs := Scan()
if !gs.ok || !RobloxActive()
return false
r1 := RowA(gs, 1)
if !IsObject(r1)
return false
if OnRowOne(gs)
return false
dx := gs.cols[col = "L" ? 1 : 2] - gs.charX
dr := (gs.charY - r1.cy) / gs.pitch - 1.0
okx := Abs(dx) <= CenterTol * gs.colsp, oky := dr >= -CenterTol && dr <= 0.25
if okx && oky
return true
if !oky
Tap(dr > 0 ? "w" : "s", MoveMs((dr > 0 ? dr - 0.1 : 0.1 - dr) * gs.pitch, gs.pitch))
else
Tap(dx > 0 ? "d" : "a", MoveMs(Abs(dx), gs.pitch))
Sleep 60
}
return false
}
CenterOwn(tight, gs) {
tol := tight ? CenterTolDiag : CenterTol, dx := dy := 99
Loop 6 {
if A_Index > 1
gs := Scan()
if !gs.ok || !RobloxActive()
return false
r := NearRow(gs)
if !IsObject(r)
return false
dx := NearColX(gs) - gs.charX, dy := gs.charY - r.cy
if Abs(dx) <= tol * gs.colsp && Abs(dy) <= tol * gs.pitch
return true
if Abs(dx) > tol * gs.colsp
Tap(dx > 0 ? "d" : "a", MoveMs(Abs(dx), gs.pitch))
if Abs(dy) > tol * gs.pitch
Tap(dy > 0 ? "w" : "s", MoveMs(Abs(dy), gs.pitch))
Sleep 50
}
k := tight ? 1.5 : 2
return Abs(dx) <= k * tol * gs.colsp && Abs(dy) <= k * tol * gs.pitch
}
MoveMs(px, pitch) => Max(20, Min(300, Round(px / (GWalk * pitch / 1000))))
HopRow(side, row, col, gs0 := "", stop := "") {
global GHopTo, GHopCol, GHopMsg, GHopAt, GHopEnd
Critical "On"
GHopTo := 0, GHopMsg := FinishMsg(true), GHopAt := A_TickCount
diag := side != "", ci := col = "L" ? 1 : 2, dir := side = "a" ? -1 : 1
jumpAt := JumpTime(diag, ci, gs0), maxMs := diag ? DiagMaxMs : HopMaxMs
if KeyDown("w") {
sHeld := diag && KeyDown(side)
t0 := A_TickCount, jumped := false, wHeld := true
Loop {
el := A_TickCount - t0
if el >= maxMs || !RobloxActive() || jumped && stop && stop()
break
if !jumped && el >= jumpAt {
if !KeyDown("Space")
break
Sleep 40
KeyUp("Space"), jumped := true
continue
}
if !jumped && jumpAt - el < GScanMs + 20 {
Sleep 2
continue
}
if stop {
Sleep 10
continue
}
gs := Scan()
if !gs.ok || !jumped || A_TickCount - t0 < jumpAt + AirMs - 200
continue
r := RowA(gs, row), lead := (1.5 * GScanMs + 30) / 1000
if wHeld && IsObject(r) && gs.charY - r.cy <= lead * (diag ? 0.8 : GWalk) * gs.pitch
KeyUp("w"), wHeld := false
if sHeld && dir * (gs.cols[ci] - gs.charX) <= lead * 0.75 * gs.colsp
KeyUp(side), sHeld := false
if !wHeld && !sHeld
break
}
}
Send "{w up}{a up}{d up}"
GHopTo := row, GHopCol := col, GHopEnd := A_TickCount
Sleep 60
Critical "Off"
}
JumpTime(diag, ci, gs) {
if !diag && IsObject(gs) && gs.ok && gs.HasOwnProp("own") && !IsObject(gs.own) && IsObject(r1 := RowA(gs, 1)) && GMe = 0
return Max(0, Round(((gs.charY - r1.cy) / gs.pitch - 0.79) / GWalk * 1000))
if !IsObject(gs) || !gs.ok || !gs.HasOwnProp("own") || !IsObject(gs.own)
return diag ? JumpMsDiag : JumpMsStraight
f := (gs.own.cy - gs.charY) / gs.pitch, c := NearColX(gs)
if !diag
return Max(0, Round((0.21 - f) / GWalk * 1000))
l := (gs.charX - c) * (gs.cols[ci] > c ? 1 : -1) / gs.colsp
return Max(0, Round(Min((0.36 - l) / 0.75, (0.36 - f) / 0.8) * 1000) - 20)
}
Learn(gs) {
global GSafe
now := A_TickCount
for r in gs.rows {
if r.a = "" || r.n < 1 || r.n > 6 || GSafe.Has(r.a) || r.cy - r.h / 2 < GEvTop
continue
for side, g in Map("L", r.L, "R", r.R) {
e := Ev(r.a side, g.st, now), o := side = "L" ? r.R : r.L
if g.st = "lit" && g.lt >= 40 || e.litAt && now - e.litAt >= 80 || e.occ >= OccSafeMs || e.greenN >= 2 || g.st = "green" && g.hn >= GreenStrong
GSafe[r.a] := side
else if e.goneAt && now - e.goneAt >= 400 && (o.st = "tile" || o.st = "occupied")
GSafe[r.a] := side = "L" ? "R" : "L"
if GSafe.Has(r.a) {
GSafeAt[r.a] := now
Log("Graves | proof: row " r.a " = " GSafe[r.a] . (e.goneAt ? " (" side " broke)" : e.greenN || g.st = "green" ? " (glowed green)" : e.litAt ? " (lit)" : " (people stood on it)"))
break
}
}
}
}
Ev(key, st, now) {
global GEv
if !GEv.Has(key)
GEv[key] := {at: now, litAt: 0, goneAt: 0, occ: 0, occAt: 0, greenAt: 0, greenN: 0}
e := GEv[key], dt := Min(now - e.at, 200), e.at := now
e.litAt := st = "lit" ? e.litAt || now : 0
if st = "green"
e.greenN := e.greenAt && now - e.greenAt <= 600 ? e.greenN + 1 : 1, e.greenAt := e.greenN = 1 ? now : e.greenAt
e.goneAt := st = "gone" ? e.goneAt || now : 0
if st = "gone" || e.occAt && now - e.occAt > OccGapMs
e.occ := 0, e.occAt := 0
if st = "occupied"
e.occ += e.occAt ? dt : 0, e.occAt := now
return e
}
Scan() {
global GViewAt, GLastOk
gs := GridScan()
if gs.ok {
gs.me := Track(gs), GViewAt := A_TickCount, gs.at := A_TickCount, GLastOk := gs
if GRun
Learn(gs)
}
return gs
}
Track(gs) {
global GBase, GPrev, GPrevAt, GPrevP, GOnBridge
own := IndexRows(gs, GOnBridge || GHop1 || !GCount), cur := [], lo := ""
for r in gs.rows
if r.full && r.n != ""
cur.Push([r.cy, r.n])
if !GOnBridge {
GBase := IsObject(own) ? 1 : 0
GOnBridge := IsObject(own) && GRun
} else if IsObject(GPrev) && A_TickCount - GPrevAt < 800 && Abs(gs.pitch - GPrevP) < 0.15 * GPrevP {
votes := Map(), best := 0, bv := 0
for c in cur
for p in GPrev
if Abs(c[1] - p[1]) < 0.4 * gs.pitch
k := p[2] - c[2], votes[k] := (votes.Has(k) ? votes[k] : 0) + 1
for k, v in votes
if v > bv
best := k, bv := v
GBase := Max(1, GBase + best)
}
GPrev := cur, GPrevAt := A_TickCount, GPrevP := gs.pitch
for r in gs.rows {
r.a := r.full && r.n != "" ? GBase + r.n : ""
if r.a != "" && (!IsObject(lo) || r.cy > lo.cy)
lo := r
}
gs.own := own
if (gs.on := IsObject(own)) {
if GHopTo && GOnBridge && (d := HopCheck(own, gs))
for r in gs.rows
if r.a != ""
r.a += d
return own.a
}
return IsObject(lo) ? Max(0, lo.a - Max(1, Round((gs.charY - lo.cy) / gs.pitch))) : 0
}
HopCheck(own, gs) {
global GBase, GHopTo, GEv
if A_TickCount - GHopEnd > 1500
return GHopTo := 0
if Abs(own.cy - gs.charY) > 0.25 * gs.pitch
return 0
caught := !GHopMsg && FinishMsg(true), want := caught ? GHopTo - 1 : GHopTo, d := want - own.a
if d {
GBase += d, GEv := Map(), drop := []
for a, t in GSafeAt
if t >= GHopAt
drop.Push(a)
for a in drop
GSafeAt.Delete(a), GSafe.Has(a) && GSafe.Delete(a)
Log("Graves | row count put right after the hop: read as row " own.a ", you're on row " want (caught ? " (caught at the ledge)" : ""))
}
if caught && GSafe.Has(GHopTo) {
GSafe.Delete(GHopTo), GSafeAt.Delete(GHopTo), GEv := Map()
Log("Graves | caught at the ledge: row " GHopTo "'s proof dropped, to be seen again")
}
return d
}
IndexRows(gs, mine := true) {
rows := gs.rows, P := gs.pitch, cy := gs.charY, own := "", anchor := 0
for i, r in rows {
r.n := ""
if mine && r.full && Abs(r.cy - cy) <= 0.45 * P && (!IsObject(own) || Abs(r.cy - cy) < Abs(own.cy - cy))
own := r, anchor := i
}
if IsObject(own)
own.n := 0
else {
i := rows.Length
while i >= 1 {
if rows[i].full && rows[i].cy < cy - 0.45 * P {
anchor := i, rows[i].n := 1
break
}
i--
}
if !anchor
return ""
}
prev := rows[anchor], lp := P, i := anchor - 1
while i >= 1 {
r := rows[i], i--
if !r.full
continue
stp := prev.cy - r.cy, k := Max(1, Round(stp / lp))
r.n := prev.n + k, lp := stp / k, prev := r
}
return own
}
RowA(gs, a) {
for r in gs.rows
if r.HasOwnProp("a") && r.a != "" && r.a = a
return r
return ""
}
NearRow(gs) {
best := ""
for r in gs.rows
if r.full && (!IsObject(best) || Abs(r.cy - gs.charY) < Abs(best.cy - gs.charY))
best := r
return best
}
NearColX(gs) => Abs(gs.cols[1] - gs.charX) <= Abs(gs.cols[2] - gs.charX) ? gs.cols[1] : gs.cols[2]
MyCol(gs) => Abs(gs.cols[1] - gs.charX) <= Abs(gs.cols[2] - gs.charX) ? "L" : "R"
EndAhead(gs) {
x := gs.ox + gs.charX, y := gs.oy + gs.charY, p := gs.pitch
return Pct([Round(x - 1.2 * p), Round(y - 2.2 * p), Round(x + 1.2 * p), Round(y - 0.6 * p)], 3, "grass") >= 25
}
Banner() {
static at := 0, bot := 0
if A_TickCount - at < 1000
return bot
at := A_TickCount, bot := 0, n := 0
Client(&ox, &oy, &cw, &ch)
Grab([ox + Round(cw * 0.3), oy, ox + Round(cw * 0.7), oy + Round(ch * 0.4)], &buf, &w, &h)
y := 0
while y < h {
k := 0, x := 0
while x < w {
p := NumGet(buf, (y * w + x) * 4, "UInt"), r := (p >> 16) & 255, g := (p >> 8) & 255, b := p & 255
k += Max(r, g, b) - Min(r, g, b) <= 10 && Max(r, g, b) >= 45 && Max(r, g, b) <= 115, x += 2
}
if k * 2 >= 0.15 * cw
n++, bot := y + Round(10 * WS)
y += 2
}
return bot := n >= 3 ? bot : 0
}
GridScan() {
global GWin, GLastScan, GScanMs
t0 := A_TickCount
narrow := IsObject(GWin) && t0 - GWin.at < 1500
gs := GridRead(narrow ? Round(GWin.x) : "", narrow ? Round(GWin.sp * 1.8) : GHalfW, !narrow)
GWin := gs.ok ? {x: (gs.cols[1] + gs.cols[2]) / 2, sp: gs.colsp, at: A_TickCount} : ""
GScanMs := (GScanMs * 3 + A_TickCount - t0) / 4, GLastScan := gs
return gs
}
GridRead(mid, half, search) {
global GSlope
Client(&ox, &oy, &cw, &ch)
cx0 := Round(cw * GCharXr), cy0 := Round(ch * GCharYr), mid := mid = "" ? cx0 : mid
x1 := Max(0, mid - half), x2 := Min(cw, mid + half), y1 := GTop, y2 := Round(ch * GBot)
if (bb := Banner()) > y1 && bb < cy0 - 100 * WS
y1 := bb
res := {ok: false, why: "", cw: 0, colsp: 0, pitch: 0, cols: [], rows: [], charX: cx0, charY: cy0, ox: ox, oy: oy, k: GSlope, kf: GSlope}
if x2 - x1 < 120 * WS || y2 - y1 < 200 * WS {
res.why := "window too small"
return res
}
Grab([ox + x1, oy + y1, ox + x2, oy + y2], &buf, &w, &h)
s := GStep, nc := w // s, nr := h // s
cls := Buffer(nc * nr, 0), seg := []
ry := 0
while ry < nr {
base := ry * s * w * 4, rb := ry * nc, cx := 0, sl := -1, sr := -1
while cx < nc {
p := NumGet(buf, base + cx * s * 4, "UInt")
pr := (p >> 16) & 255, pg := (p >> 8) & 255, pb := p & 255
if pb >= 240 && pg >= 225 && pr >= 212 && pg - pr >= 5 && pb - pg <= 32
k := 1
else if pr >= 225 && pg >= 205 && pg <= 235 && pb >= 120 && pb <= 185 && pr - pb >= 55 && pr - pg <= 40
k := 3
else if pg >= 225 && pr >= 150 && pr <= 215 && pb >= 140 && pb <= 215 && pg - pr >= 30 && pg - pb >= 30 && Abs(pr - pb) <= 30
k := 6
else if pg > pr + 35 && pg > pb
k := 5
else if (pb >= 200 && pb - pr >= 14) || (pb >= 150 && pb - pr >= 70 && pr <= 120) || (Abs(pr - pg) < 14 && Abs(pg - pb) < 14 && pr > 190) || (pr > 200 && pg > 170 && pb < 110)
k := 0
else
k := 4
NumPut("UChar", k, cls, rb + cx)
if k = 1 || k = 3 || k = 6 {
if sl < 0
sl := cx
sr := cx
} else if sl >= 0 && cx - sr > 1 {
if sr - sl >= 2
seg.Push(ry, sl, sr)
sl := -1
}
cx++
}
if sl >= 0 && sr - sl >= 2
seg.Push(ry, sl, sr)
ry++
}
if seg.Length < 18 {
res.why := "no graves in view"
return res
}
k := search ? LeanBest(seg, s, y1, cy0, GSlope) : GSlope
if !IsObject(cols := LeanCols(seg, s, y1, cy0, nc, k)) {
res.why := "columns"
return res
}
res.kf := k2 := LeanFit(seg, s, y1, cy0, k, cols)
if Abs(k2 - k) > 0.01 && IsObject(c2 := LeanCols(seg, s, y1, cy0, nc, k2))
k := k2, cols := c2
lL := cols[1], rL := cols[2], lR := cols[3], rR := cols[4]
wL := (rL - lL + 1) * s, wR := (rR - lR + 1) * s, gw := (wL + wR) / 2
cxL := x1 + (lL + rL) / 2 * s, cxR := x1 + (lR + rR) / 2 * s
res.cw := Round(gw), res.colsp := Round(cxR - cxL), res.cols := [cxL, cxR], res.k := k
aligned := Buffer(nc * nr, 0)
Loop nr {
ay := A_Index - 1
Loop nc {
ax := A_Index - 1
sy := ay - Round(k * (x1 + ax * s - cx0) / s)
if sy >= 0 && sy < nr
NumPut("UChar", NumGet(cls, sy * nc + ax, "UChar"), aligned, ay * nc + ax)
}
}
cls := aligned
yp := [], yp.Length := nr
Loop nr {
ry := A_Index - 1, sh := Round(k * (y1 + ry * s - cy0) / s), rb := ry * nc, n := 0
cx := Max(0, lL + sh), ce := Min(nc - 1, rR + sh)
while cx <= ce {
kk := NumGet(cls, rb + cx, "UChar")
n += (kk = 1 || kk = 3 || kk = 6)
cx++
}
yp[A_Index] := n
}
bands := []
for bd in Runs(yp, 2, 1, 3)
if bands.Length && bd.l - bands[bands.Length].r <= 1
bands[bands.Length].r := bd.r
else
bands.Push({l: bd.l, r: bd.r})
full := []
for bd in bands {
row := {cy: y1 + ((bd.l + bd.r) / 2 - 1) * s, h: (bd.r - bd.l + 1) * s, a: ""}
cut := (bd.r - bd.l + 1) // 5, i1 := bd.l - 1 + cut, i2 := bd.r - 1 - cut
for side, c in Map("L", [lL, rL], "R", [lR, rR]) {
t := 0, lt := 0, o := 0, gr := 0, hn := 0, n := 0, ni := 0, yy := bd.l - 1
while yy < bd.r {
sh := Round(k * (y1 + yy * s - cy0) / s), rb := yy * nc, inner := yy >= i1 && yy <= i2
xx := Max(0, c[1] + sh), xe := Min(nc - 1, c[2] + sh)
while xx <= xe {
kk := NumGet(cls, rb + xx, "UChar")
t += (kk = 1), lt += (kk = 3), gr += (kk = 5), hn += (kk = 6), n++
if inner
o += (kk = 4), ni++
xx++
}
yy++
}
n := Max(1, n), t := t * 100 // n, lt := lt * 100 // n, o := o * 100 // Max(1, ni), gr := gr * 100 // n, hn := hn * 100 // n
if lt >= LitPct
st := "lit"
else if hn >= GreenPct
st := "green"
else if t < GoneWhite && gr < 2 && hn < 5 && o < 25
st := "gone"
else if o >= OccOther && (t >= OccWhite || o >= OccCrowd)
st := "occupied"
else if t >= TileWhite
st := "tile"
else
st := "unclear"
row.%side% := {st: st, w: t, o: o, hn: hn, lt: lt}
}
if row.L.st = "green" && row.R.st = "green"
row.L.st := row.R.st := "unclear"
row.full := row.h >= gw * 0.5
res.rows.Push(row)
if row.full
full.Push(row)
}
if full.Length < 3 && !(full.Length = 2 && IsObject(GLastOk) && A_TickCount - GLastOk.at < 3000
&& Abs(full[2].cy - full[1].cy - GLastOk.pitch) <= 0.2 * GLastOk.pitch)
&& !(full.Length = 2 && y1 > GTop && Abs(full[2].cy - full[1].cy) >= 0.75 * (cxR - cxL) && Abs(full[2].cy - full[1].cy) <= 1.3 * (cxR - cxL)) {
res.why := "rows"
return res
}
d := [], hs := [], mean := 0, vsum := 0
Loop full.Length - 1
d.Push(full[A_Index + 1].cy - full[A_Index].cy)
pitch := Median(d), colsp := cxR - cxL
for i, v in d
d[i] := v >= 1.7 * pitch ? v / Max(1, Round(v / pitch)) : v, mean += d[i]
mean /= d.Length
for v in d
vsum += (v - mean) ** 2
for row in full
hs.Push(row.h)
hw := Median(hs) / gw
res.pitch := Round(pitch)
res.ok := gw >= 36 * WS && gw <= 210 * WS && Abs(wL - wR) <= 0.35 * gw && colsp >= 1.1 * gw && colsp <= 2.0 * gw
&& pitch >= 0.75 * colsp && pitch <= 1.3 * colsp && hw >= 0.55 && hw <= 1.3 && Sqrt(vsum / d.Length) / Max(1, mean) < 0.3
if !res.ok
res.why := "not top-down"
else
GSlope := k
return res
}
LeanBest(seg, s, y1, cy0, k0) {
best := k0, bs := -1
for d in [0, -0.02, 0.02, -0.04, 0.04, -0.08, 0.08, -0.12, 0.12, -0.16, 0.16] {
kk := k0 + d, hist := Map(), sc := 0, i := 1
while i < seg.Length {
xm := Floor(Round((seg[i + 1] + seg[i + 2]) / 2 - kk * (y1 + seg[i] * s - cy0) / s) / 2)
hist[xm] := (hist.Has(xm) ? hist[xm] : 0) + seg[i + 2] - seg[i + 1] + 1
i += 3
}
for x, v in hist
sc += v * v
if sc > bs
bs := sc, best := kk
}
return best
}
LeanCols(seg, s, y1, cy0, nc, k) {
off := nc, xp := [], xp.Length := 3 * nc
Loop 3 * nc
xp[A_Index] := 0
i := 1
while i < seg.Length {
sh := Round(k * (y1 + seg[i] * s - cy0) / s), a := seg[i + 1] - sh + off, b := seg[i + 2] - sh + off
if a >= 0 && b < 3 * nc
Loop b - a + 1
xp[a + A_Index]++
i += 3
}
mx := 0
for v in xp
mx := Max(mx, v)
if mx < 4
return ""
cr := Runs(xp, Max(3, mx * 0.25), 2, 5)
if cr.Length < 2
return ""
ia := 0, ib := 0
for i, c in cr
if !ia || c.sum > cr[ia].sum
ib := ia, ia := i
else if !ib || c.sum > cr[ib].sum
ib := i
cL := cr[Min(ia, ib)], cR := cr[Max(ia, ib)]
return [cL.l - 1 - off, cL.r - 1 - off, cR.l - 1 - off, cR.r - 1 - off]
}
LeanFit(seg, s, y1, cy0, k, cols) {
tot := 0, acc := 0
for c in [[cols[1], cols[2]], [cols[3], cols[4]]] {
n := 0, sy := 0, sx := 0, syy := 0, sxy := 0, ymin := 9999, ymax := -1, i := 1
while i < seg.Length {
xm := (seg[i + 1] + seg[i + 2]) / 2, ry := seg[i], xq := xm - k * (y1 + ry * s - cy0) / s
if xq >= c[1] - 1 && xq <= c[2] + 1
n++, sy += ry, sx += xm, syy += ry * ry, sxy += ry * xm, ymin := Min(ymin, ry), ymax := Max(ymax, ry)
i += 3
}
if n >= 4 && ymax - ymin >= 25 && (den := n * syy - sy * sy)
acc += n * (n * sxy - sy * sx) / den, tot += n
}
return tot ? acc / tot : k
}
Runs(arr, th, gapMax, minLen) {
out := [], cur := "", gap := 0
Loop arr.Length {
i := A_Index
if arr[i] >= th {
if cur = ""
cur := {l: i, r: i, sum: 0}
cur.r := i, cur.sum += arr[i], gap := 0
} else if cur != "" && ++gap > gapMax {
if cur.r - cur.l + 1 >= minLen
out.Push(cur)
cur := "", gap := 0
}
}
if cur != "" && cur.r - cur.l + 1 >= minLen
out.Push(cur)
return out
}
Median(a) {
b := a.Clone(), n := b.Length
Loop n - 1 {
i := A_Index + 1, v := b[i], j := i - 1
while j >= 1 && b[j] > v
b[j + 1] := b[j], j--
b[j + 1] := v
}
return n & 1 ? b[(n + 1) // 2] : (b[n // 2] + b[n // 2 + 1]) / 2
}
Move(h, v) {
global KeyH, KeyV
if h != KeyH {
if KeyH != ""
KeyUp(KeyH)
KeyH := h != "" && KeyDown(h) ? h : ""
}
if v != KeyV {
if KeyV != ""
KeyUp(KeyV)
KeyV := v != "" && KeyDown(v) ? v : ""
}
}
Reward(start := false) {
static sig := "", cand := "", n := 0
Client(&ox, &oy, &cw, &ch)
st := Max(1, UI(2, 1)), p1 := UI(2, 1), p2 := UI(3, 2), wh := UI(235, 200), dk := UI(150, 220)
probe := [[p1, 0], [-p1, 0], [p2, 0], [-p2, 0], [0, p1], [0, -p1], [0, p2], [0, -p2]]
Grab([ox + cw // 2 - UI(225, 102), oy + UI(96, 52), ox + cw // 2 - UI(159, 68), oy + UI(140, 66)], &buf, &w, &h)
nc := (w + st - 1) // st, nr := (h + st - 1) // st, m := Buffer(nc * nr, 0), on := 0
Loop nr {
y := (A_Index - 1) * st, rb := (A_Index - 1) * nc
Loop nc {
x := (A_Index - 1) * st, i := rb + A_Index - 1, p := NumGet(buf, (y * w + x) * 4, "UInt")
if ((p >> 16) & 255) < wh || ((p >> 8) & 255) < wh || (p & 255) < wh
continue
for o in probe {
xx := x + o[1], yy := y + o[2]
if xx < 0 || yy < 0 || xx >= w || yy >= h
continue
q := NumGet(buf, (yy * w + xx) * 4, "UInt")
if ((q >> 16) & 255) + ((q >> 8) & 255) + (q & 255) < dk {
NumPut("UChar", 1, m, i), on++
break
}
}
}
}
if start || !IsObject(sig) || sig.Size != m.Size {
sig := m, cand := "", n := 0
return false
}
if MaskDiff(m, sig) > 6 && on >= 4 {
n := IsObject(cand) && MaskDiff(m, cand) <= UI(3, 2) ? n + 1 : 1, cand := m
if n >= 2 {
sig := m, cand := "", n := 0
return true
}
} else
cand := "", n := 0
return false
}
MaskDiff(a, b) {
d := 0
Loop a.Size
d += NumGet(a, A_Index - 1, "UChar") != NumGet(b, A_Index - 1, "UChar")
return d
}
FinishMsg(loose := false) {
Client(&ox, &oy, &cw, &ch)
Grab([ox + cw // 2 - UI(403, 190), oy + ch - UI(328, 200), ox + cw // 2 + UI(403, 190), oy + ch - UI(227, 144)], &buf, &w, &h)
n := 0, t := -1, bt := -1, y := 0, xl := w, xr := -1
while y < h {
k := 0, x := 0, l := -1, rx := -1
while x < w {
p := NumGet(buf, (y * w + x) * 4, "UInt"), r := (p >> 16) & 255, g := (p >> 8) & 255, b := p & 255
if r >= 225 && g >= 185 && g <= 225 && b >= 45 && b <= 120 && r - b >= 120
k++, l := l < 0 ? x : l, rx := x
x += 2
}
n += k, y += 2
if k >= 3
t := t < 0 ? y : t, bt := y, xl := Min(xl, l), xr := Max(xr, rx)
}
return n >= UI(200, 120) && (loose || bt - t + 2 <= UI(40, 28) && xr - xl <= UI(380, 250))
}
InLobby() {
global LobbyScore
if !Client(&ox, &oy, &cw, &ch)
return false
sc := HouseSc, st := Max(2, Round(4 * sc)), x0 := ox + cw // 2 - UI(60, 40) - 4 * st, y0 := oy + ch - UI(151, 106) - 4 * st
Grab([x0, y0, x0 + Round(116 * sc) + 8 * st, y0 + Round(86 * sc) + 8 * st], &buf, &w, &h)
best := 0
for dy in [0, -1, 1, -2, 2, -3, 3, -4, 4]
for dx in [0, -1, 1, -2, 2, -3, 3, -4, 4] {
n := 0, c := 0, miss := 0
for k in ["roof", "door", "wall", "edge"]
for p in StrSplit(HouseDots[k], " ") {
xy := StrSplit(p, ","), v := NumGet(buf, ((Round(xy[2] * sc) + (4 + dy) * st) * w + Round(xy[1] * sc) + (4 + dx) * st) * 4, "uint")
if IsKind(k, (v >> 16) & 255, (v >> 8) & 255, v & 255)
n++, c += (k = "roof" || k = "door")
else if (k = "roof" || k = "door") && ++miss > 11
break 2
}
if n > best
best := n
if n >= 32 && c >= 12 {
LobbyScore := n "/53"
return true
}
}
LobbyScore := best "/53"
return false
}
LightState() {
if Count(Win(Light), 2, "red") >= LightMin
return "red"
if Count(Win(Light), 2, "green") >= LightMin
return "green"
return ""
}
IsKind(kind, r, g, b) {
switch kind {
case "green": return g >= 200 && r <= 150 && b <= 170 && g - r >= 80
case "red":   return r >= 190 && g <= 100 && b <= 100 && Abs(g - b) <= 35
case "white": return r >= 235 && g >= 235 && b >= 235
case "roof":  return r >= 160 && g <= 90 && b <= 90
case "door":  return r >= 200 && g >= 100 && g <= 220 && b <= 100
case "wall":  return Min(r, g, b) >= 150 && Max(r, g, b) - Min(r, g, b) <= 60
case "edge":  return Max(r, g, b) <= 90
case "lobby": return r >= 220 && g <= 80 && b >= 60 && b <= 150
case "void":  return b >= 200 && b - r >= 50
case "grass": return g > r + 35 && g > b
case "ready": return g >= 190 && r <= 140 && b <= 90 && g - r >= 80
case "plus":  return r >= 235 && g >= 195 && g <= 230 && b >= 70 && b <= 125 && r - b >= 120
case "pink":  return r >= 130 && g >= 45 && b >= 100 && r > g * 1.25 && b > g * 1.15
case "gold":  return r >= 150 && g >= 90 && b <= 90 && r - g >= 20
case "orange": return r >= 200 && g >= 65 && g <= 195 && b <= 110 && r - g >= 40
}
return false
}
Pct(rg, step, kind) {
n := 0, k := 0
Grab(rg, &buf, &w, &h)
yy := 0
while yy < h {
xx := 0
while xx < w {
p := NumGet(buf, (yy * w + xx) * 4, "uint")
k += IsKind(kind, (p >> 16) & 255, (p >> 8) & 255, p & 255), n++
xx += step
}
yy += step
}
return n ? k * 100 // n : 0
}
Count(rg, step, kind) {
n := 0
Grab(rg, &buf, &w, &h)
yy := 0
while yy < h {
xx := 0
while xx < w {
p := NumGet(buf, (yy * w + xx) * 4, "uint")
if IsKind(kind, (p >> 16) & 255, (p >> 8) & 255, p & 255)
n++
xx += step
}
yy += step
}
return n
}
Grab(rg, &buf, &w, &h) {
x0 := rg[1], y0 := rg[2], w := rg[3] - x0, h := rg[4] - y0
hdcS := DllCall("GetDC", "ptr", 0, "ptr")
hdcM := DllCall("CreateCompatibleDC", "ptr", hdcS, "ptr")
bi := Buffer(40, 0)
NumPut("uint", 40, bi, 0), NumPut("int", w, bi, 4), NumPut("int", -h, bi, 8)
NumPut("ushort", 1, bi, 12), NumPut("ushort", 32, bi, 14)
pBits := 0
hbm := DllCall("CreateDIBSection", "ptr", hdcM, "ptr", bi, "uint", 0, "ptr*", &pBits, "ptr", 0, "uint", 0, "ptr")
obm := DllCall("SelectObject", "ptr", hdcM, "ptr", hbm, "ptr")
DllCall("BitBlt", "ptr", hdcM, "int", 0, "int", 0, "int", w, "int", h, "ptr", hdcS, "int", x0, "int", y0, "uint", 0x00CC0020)
buf := Buffer(w * h * 4)
DllCall("RtlMoveMemory", "ptr", buf, "ptr", pBits, "uptr", w * h * 4)
DllCall("SelectObject", "ptr", hdcM, "ptr", obm)
DllCall("DeleteObject", "ptr", hbm)
DllCall("DeleteDC", "ptr", hdcM)
DllCall("ReleaseDC", "ptr", 0, "ptr", hdcS)
}
ShowFrames() {
HideFrames()
if !Client(&ox, &oy, &cw, &ch)
return
for f in [[Chat, "Gray"], [TimerBox, "White"], [Light, "Red"], [LobbyBtn, "Blue"]]
Frame(Win(f[1]), f[2])
cx := ox + Round(cw * GCharXr), cy := oy + Round(ch * GCharYr), py := oy + Round(ch * GParkYr)
Frame([cx - GHalfW, oy + GTop, cx + GHalfW, oy + Round(ch * GBot)], "Lime")
Frame([cx - 10, cy - 10, cx + 10, cy + 10], "Fuchsia")
Frame([cx - 6, py - 6, cx + 6, py + 6], "Yellow")
}
Frame(r, color) {
for e in [[r[1], r[2], r[3] - r[1], 2], [r[1], r[4] - 2, r[3] - r[1], 2]
, [r[1], r[2], 2, r[4] - r[2]], [r[3] - 2, r[2], 2, r[4] - r[2]]] {
g := Gui("-Caption +AlwaysOnTop +ToolWindow +E0x20")
g.BackColor := color
g.Show("x" e[1] " y" e[2] " w" e[3] " h" e[4] " NA")
Frames.Push(g)
}
}
HideFrames() {
global Frames
for g in Frames
g.Destroy()
Frames := []
}
W(on) {
global WDown
if on = WDown || on && !KeyDown("w")
return
if !on
KeyUp("w")
WDown := on
}
ReleaseKeys() {
global WDown, KeyH, KeyV
WDown := false, KeyH := "", KeyV := ""
for k in ["w", "a", "s", "d", "o", "i", "Space", TurnL, TurnR]
if GetKeyState(k)
KeyUp(k)
}
ReleaseAll(*) {
global Running := false
if GetKeyState("RButton")
Click "Right Up"
ClipCursorTo("")
ReleaseKeys()
}
Status(t) {
try {
    Hud(t)
} catch {
    ToolTip t, 10, 10
}
if RegExMatch(t, "^(Graves|Eliminated|Paused|Roblox)")
Log(t)
}
Log(t) {
static last := ""
if t = last
return
last := t
try FileAppend FormatTime(, "HH:mm:ss") "." Format("{:03}", A_MSec) "  " t "`n", LogFile
}
EggBanner() {
    if !Client(&ox, &oy, &cw, &ch)
        return false
    hw := Round(0.45 * ch)
    return Pct([ox + cw // 2 - hw, oy + Round(ch * 0.17), ox + cw // 2 + hw, oy + Round(ch * 0.31)], 3, "white") >= EggBannerPct
}
EggReady() {
    global EggN
    EggN := EggBanner() ? EggN + 1 : 0
    return EggN >= 2
}
EggKind(r, g, b) {
    global EggGs, EggGsum
    if EggGsum {
        t := r + g + b
        if r > g && g > b && t * 100 <= EggGsum * 87 && t * 100 >= EggGsum * 50 && g * 100 <= r * 86 && (r - b) * 100 >= (EggGs + EggSatMargin) * r
            return 4
    } else if g <= 125 && b <= 25 && r >= 100 && r <= 232 && g * 100 <= r * 60 && g * 100 >= r * 38
        return 4
    if g < 190
        return 0
    if r >= 195 && r <= 240 && g <= 225 && Abs(r - g) <= 25 && b <= 60
        return 3
    if g >= 215 && r >= 140 && r <= 190 && b <= 70
        return 2
    if r >= 240 && g >= 222 && b >= 150 && b <= 205
        return 1
    return 0
}
EggGround(buf, w, h, step) {
    cnt := Map(), acc := Map(), gs := step * 3, yy := 0
    while yy < h {
        xx := 0
        while xx < w {
            p := NumGet(buf, (yy * w + xx) * 4, "uint")
            q := ((p >> 20) & 15) * 256 + ((p >> 12) & 15) * 16 + ((p >> 4) & 15)
            cnt[q] := cnt.Get(q, 0) + 1
            if !acc.Has(q)
                acc[q] := [0, 0, 0]
            a := acc[q], a[1] += (p >> 16) & 255, a[2] += (p >> 8) & 255, a[3] += p & 255
            xx += gs
        }
        yy += gs
    }
    best := "", bn := 0
    for q, n in cnt
        if n > bn
            best := q, bn := n
    if !bn
        return ""
    a := acc[best]
    return [a[1] // bn, a[2] // bn, a[3] // bn]
}
EggScan() {
    global EggGs, EggGsum, EggGrabAt
    if !Client(&ox, &oy, &cw, &ch)
        return []
    step := Max(3, Round(EggStep * WS)), cell := step * EggCell
    x0 := Round(cw * 0.04), x1 := Round(cw * 0.92), y0 := Round(ch * 0.37), y1 := Round(ch * 0.92)
    Grab([ox + x0, oy + y0, ox + x1, oy + y1], &buf, &w, &h)
    EggGrabAt := A_TickCount
    EggGs := 0, EggGsum := 0
    gc := EggGround(buf, w, h, step)
    if IsObject(gc) && gc[1] >= 150 && gc[1] > gc[2] && gc[2] > gc[3]
        EggGs := (gc[1] - gc[3]) * 100 // gc[1], EggGsum := gc[1] + gc[2] + gc[3]
    cols := w // cell + 1, rows := h // cell + 1
    cnt := Map()
    yy := 0
    while yy < h {
        xx := 0, rr := yy // cell
        while xx < w {
            p := NumGet(buf, (yy * w + xx) * 4, "uint")
            k := EggKind((p >> 16) & 255, (p >> 8) & 255, p & 255)
            if k {
                i := (rr * cols + xx // cell) * 8 + k
                cnt[i] := cnt.Get(i, 0) + 1
            }
            xx += step
        }
        yy += step
    }
    kinds := Map(), per := EggCell * EggCell
    for i, n in cnt {
        if n * 100 >= per * 45 {
            key := i // 8
            kinds[key] := i - key * 8
        }
    }
    blobs := [], seen := Map()
    for key, k in kinds {
        if seen.Has(key)
            continue
        seen[key] := 1
        stack := [key], cells := []
        while stack.Length {
            c := stack.Pop(), cells.Push(c)
            c0 := Mod(c, cols)
            for d in [-cols, cols, -1, 1] {
                if d = -1 && c0 = 0 || d = 1 && c0 = cols - 1
                    continue
                q := c + d
                if kinds.Has(q) && kinds[q] = k && !seen.Has(q) {
                    seen[q] := 1
                    stack.Push(q)
                }
            }
        }
        minc := cols, maxc := -1, minr := rows, maxr := -1
        for c in cells {
            c0 := Mod(c, cols), r0 := c // cols
            minc := Min(minc, c0), maxc := Max(maxc, c0), minr := Min(minr, r0), maxr := Max(maxr, r0)
        }
        bw := maxc - minc + 1, bh := maxr - minr + 1, n := cells.Length, pad := 0
        if bw >= 5 || bh >= 5 {
            minc := cols, maxc := -1, minr := rows, maxr := -1, n := 0
            for c in cells {
                c0 := Mod(c, cols)
                if c0 = 0 || c0 = cols - 1 || kinds.Get(c - 1, 0) != k || kinds.Get(c + 1, 0) != k || kinds.Get(c - cols, 0) != k || kinds.Get(c + cols, 0) != k
                    continue
                r0 := c // cols, n++
                minc := Min(minc, c0), maxc := Max(maxc, c0), minr := Min(minr, r0), maxr := Max(maxr, r0)
            }
            if !n
                continue
            bw := maxc - minc + 1, bh := maxr - minr + 1, pad := 1
        }
        if n >= (k = 4 ? 3 : 4) && n * 100 >= bw * bh * 55 && bw <= 3.3 * bh && bh <= 3.3 * bw
            blobs.Push({k: k, n: n, x: ox + x0 + (minc + maxc + 1) * cell // 2, y: oy + y0 + (minr + maxr + 1) * cell // 2, w: (bw + 2 * pad) * cell, h: (bh + 2 * pad) * cell})
    }
    return blobs
}
EggReset() {
    global EggUsed := Map(), EggClickAt := Map(), EggBoostAt := 0, EggSet := false, EggLast := "", EggNoneAt := 0, EggPrev := "", EggTickAt := 0, EggFlashAt := 0
}
EggBoosts() {
    global EggBoostAt, EggClickAt, EggUsed
    static want := [["Flashlight", 0.2965], ["Treat Magnet", 0.3985]]
    if EggUsed.Get("Flashlight", 0) >= EggFlashMax && EggUsed.Get("Treat Magnet", 0) >= EggMagnetMax
        return
    if A_TickCount - EggBoostAt < EggBoostMs
        return
    EggBoostAt := A_TickCount
    if !Client(&ox, &oy, &cw, &ch)
        return
    x0 := Round(cw * 0.86), y0 := Round(ch * 0.12)
    Grab([ox + x0, oy + y0, ox + cw, oy + Round(ch * 0.80)], &buf, &w, &h)
    rows := h // 2 + 1, cnt := [], sx := []
    cnt.Length := sx.Length := rows
    Loop rows
        cnt[A_Index] := 0, sx[A_Index] := 0
    yy := 0
    while yy < h {
        xx := 0, i := yy // 2 + 1
        while xx < w {
            p := NumGet(buf, (yy * w + xx) * 4, "uint")
            if ((p >> 8) & 255) >= 185 {
                r := (p >> 16) & 255, g := (p >> 8) & 255, b := p & 255
                if r <= 165 && b <= 115 && g - r >= 55
                    cnt[i]++, sx[i] += xx
            }
            xx += 2
        }
        yy += 2
    }
    labels := [], i := 1
    while i <= rows {
        if cnt[i] < 2 {
            i++
            continue
        }
        a := i, last := i, n := 0, xs := 0, j := i
        while j <= rows && j - last <= 3 {
            if cnt[j] >= 2
                last := j
            n += cnt[j], xs += sx[j], j++
        }
        ht := (last - a + 1) * 2
        if n >= 12 && ht >= ch * 0.006 && ht <= ch * 0.05
            labels.Push({y: y0 + (a - 1) * 2, x: x0 + xs / n})
        i := j
    }
    if !labels.Length
        return
    picks := []
    if labels.Length >= 2
        picks := [[want[1][1], labels[1]], [want[2][1], labels[2]]]
    else {
        d1 := Abs(labels[1].y - ch * want[1][2]), d2 := Abs(labels[1].y - ch * want[2][2])
        if Min(d1, d2) <= ch * 0.10
            picks := [d1 <= d2 ? [want[1][1], labels[1]] : [want[2][1], labels[1]]]
    }
    clicked := false
    for pk in picks {
        name := pk[1], lb := pk[2]
        if A_TickCount - EggClickAt.Get(name, 0) < 2500
            continue
        if EggUsed.Get(name, 0) >= (name = "Flashlight" ? EggFlashMax : EggMagnetMax)
            continue
        EggClickAt[name] := A_TickCount
        Move("", "")
        ok := ClickAt(Round(lb.x), Round(lb.y + ch * 0.040))
        if ok
            EggUsed[name] := EggUsed.Get(name, 0) + 1
        uses := EggUsed.Get(name, 0)
        clicked := true
        Log("Eggs | " (ok ? "used " : "couldn't click ") name " (" uses " this round, its Ready! label was at " Round(lb.x / cw * 100) "% across, " Round(lb.y / ch * 100) "% down)")
        Sleep 150
    }
    if clicked
        ParkCursor()
}
EggCal(old, step, since, prevG, g, f) {
    t := g - Max(prevG, since)
    if t < 60 || step < 8 * WS
        return old
    v := step * 1000 / t / f
    if v < 120 * WS || v > 1500 * WS
        return old
    return 0.5 * old + 0.5 * v
}
PlayEggs() {
    global EggFlashAt, ModeSeen, EggSet, EggLast, EggNoneAt, EggPrev, EggSpdX, EggSpdY, EggLoopMs, EggTickAt, EggHXat, EggHYat
    static names := ["white", "green", "gold", "brown"]
    now := A_TickCount
    if EggTickAt
        EggLoopMs := 0.7 * EggLoopMs + 0.3 * Min(400, now - EggTickAt)
    EggTickAt := now
    if !EggSpdX
        EggSpdX := 800 * WS, EggSpdY := 600 * WS
    if EggFlashKey != "" && now - EggFlashAt >= EggFlashMs {
        EggFlashAt := now
        Tap(EggFlashKey, 40)
    }
    blobs := EggScan()
    gAt := EggGrabAt
    if !Client(&ox, &oy, &cw, &ch)
        return
    cx := ox + Round(cw * GCharXr), cy := oy + Round(ch * GCharYr) + Round(EggFeetPx * WS)
    best := "", bs := -999999
    if EggSet {
        sd := 999999
        for b in blobs {
            d := Sqrt((b.x - cx) ** 2 + (b.y - cy) ** 2)
            if d <= 0.5 * Max(b.w, b.h) && d < sd
                best := b, sd := d
        }
    }
    if !IsObject(best) {
        for b in blobs {
            dx := b.x - cx, dy := b.y - cy
            s := (b.k = 4 ? 0 : b.k) * Round(ch * EggRankBonus) - Sqrt(dx * dx + dy * dy)
            if IsObject(EggLast) && Sqrt((b.x - EggLast.x) ** 2 + (b.y - EggLast.y) ** 2) < ch * 0.07
                s += Round(ch * 0.06)
            if s > bs
                best := b, bs := s
        }
    }
    if !IsObject(best) {
        Move("", "")
        EggLast := "", EggSet := false, EggPrev := ""
        if !EggNoneAt
            EggNoneAt := now
        else if now - EggNoneAt >= 1000
            EggBoosts()
        return Status("Eggs | no shadow in sight")
    }
    EggNoneAt := 0
    EggLast := best
    ModeSeen := now
    dx := best.x - cx, dy := best.y - cy
    if IsObject(EggPrev) && best.k = EggPrev.k && Abs(best.w - EggPrev.w) <= 0.4 * EggPrev.w && Sqrt((best.x - EggPrev.x) ** 2 + (best.y - EggPrev.y) ** 2) <= ch * 0.2 {
        fd := KeyH != "" && KeyV != "" ? 0.7071 : 1
        if KeyH != ""
            EggSpdX := EggCal(EggSpdX, KeyH = "d" ? EggPrev.dx - dx : dx - EggPrev.dx, EggHXat, EggPrev.g, gAt, fd)
        if KeyV != ""
            EggSpdY := EggCal(EggSpdY, KeyV = "s" ? EggPrev.dy - dy : dy - EggPrev.dy, EggHYat, EggPrev.g, gAt, fd)
    }
    lag := A_TickCount - gAt
    ex := dx, ey := dy
    if KeyH != ""
        ex -= (KeyH = "d" ? 1 : -1) * EggSpdX * lag / 1000
    if KeyV != ""
        ey -= (KeyV = "s" ? 1 : -1) * EggSpdY * lag / 1000
    f := EggSet ? 2 : 1
    tx := Max(EggTolMin * WS, best.w * EggTolPct / 100) * f, ty := Max(EggTolMin * WS, best.h * EggTolPct / 100) * f
    h := "", v := "", hk := "", vk := "", hp := 0, vp := 0
    if Abs(ex) > tx {
        k := ex > 0 ? "d" : "a"
        if Abs(ex) > tx + EggSpdX * EggLoopMs / 1000
            h := k
        else
            hk := k, hp := Max(EggPulseMin, Min(EggPulseMax, Round(Abs(ex) / EggSpdX * 850)))
    }
    if Abs(ey) > ty {
        k := ey > 0 ? "s" : "w"
        if Abs(ey) > ty + EggSpdY * EggLoopMs / 1000
            v := k
        else
            vk := k, vp := Max(EggPulseMin, Min(EggPulseMax, Round(Abs(ey) / EggSpdY * 850)))
    }
    EggSet := h = "" && v = "" && hk = "" && vk = ""
    Status("Eggs | " (EggSet ? "standing in the middle of a " : "heading to the middle of a ") names[best.k] " shadow (off by " Round(dx) "," Round(dy) " px)")
    EggPrev := {dx: dx, dy: dy, g: gAt, x: best.x, y: best.y, k: best.k, w: best.w}
    if h != KeyH
        EggHXat := A_TickCount
    if v != KeyV
        EggHYat := A_TickCount
    Move(h, v)
    if hp
        Tap(hk, hp)
    if vp
        Tap(vk, vp)
    if EggSet
        EggBoosts()
}
BarsReset() {
    global BarsLast := "", BarsNoneAt := 0
}
BarsPrompt() {
    if !Client(&ox, &oy, &cw, &ch)
        return ""
    Grab([ox + Round(cw * 0.30), oy + Round(ch * 0.20), ox + Round(cw * 0.70), oy + Round(ch * 0.50)], &buf, &w, &h)
    nj := 0, nd := 0, yy := 0
    while yy < h {
        xx := 0
        while xx < w {
            p := NumGet(buf, (yy * w + xx) * 4, "uint")
            r := (p >> 16) & 255, g := (p >> 8) & 255, b := p & 255
            if r >= 245 && g >= 128 && g <= 148 && b >= 18 && b <= 50
                nj++
            else if b >= 232 && r >= 165 && r <= 200 && g >= 118 && g <= 140
                nd++
            xx += 2
        }
        yy += 2
    }
    need := Max(60, Round(BarsMin * (ch / 1056) ** 2 / 4))
    if nj < need && nd < need
        return ""
    return nj >= nd ? "jump" : "dive"
}
PlayBars() {
    global BarsLast, BarsNoneAt, ModeSeen
    now := A_TickCount
    want := BarsPrompt()
    if want = "" {
        if !BarsNoneAt
            BarsNoneAt := now
        else if now - BarsNoneAt >= 150
            BarsLast := ""
        return Status("Brooms | waiting for JUMP / DIVE")
    }
    BarsNoneAt := 0
    ModeSeen := now
    if want = BarsLast {
        UseGameMagnet("Brooms")
        return Status("Brooms | " want " (already pressed)")
    }
    BarsLast := want
    if BarsDelayMs > 0
        Sleep BarsDelayMs
    if want = "jump"
        Tap(BarsKeyJump, 60)
    else
        Tap(BarsKeyDive, 60)
    UseGameMagnet("Brooms")
    Status("Brooms | pressed " (want = "jump" ? "JUMP" : "DIVE"))
}
UseGameMagnet(tag) {
    global GameMagnetUsed, GameMagnetAttemptAt
    if GameMagnetUsed || A_TickCount - GameMagnetAttemptAt < 3000
        return
    GameMagnetAttemptAt := A_TickCount
    if Boosts(["Treat Magnet"], tag) > 0
        GameMagnetUsed := true
}
