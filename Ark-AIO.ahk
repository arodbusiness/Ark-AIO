#Persistent
#SingleInstance Force
#Include TransSplashText.ahk
#Include Gdip_All.ahk

GuiX := 0
GuiY := 30

If !pToken := Gdip_Startup(){
	MsgBox, No Gdiplus 
	ExitApp
}


Debug := 0

DefaultWaterDelay := 10000
DefaultFoodDelay := DefaultWaterDelay*2
DefaultWaterKey := "8"
DefaultFoodKey := "9"
DefaultQTHotkey := "F8"



FileSettings := A_ScriptDir . "\Ark-AIO.ini"
if (!FileExist(FileSettings)){
	file := FileOpen(FileSettings, "w")
	file.Write("[Main]`r`ncrosshair=1`r`nd=7`r`nR=0`r`nG=200`r`nB=255`r`nautofoodwater=0`r`nwaterdelay=" DefaultWaterDelay "`r`nfooddelay=" DefaultFoodDelay "`r`nwaterkey=" DefaultWaterKey "`r`nfoodkey=" DefaultFoodKey "`r`nqton=1`r`nqthotkey=" DefaultQTHotkey "`r`nqtdrop=0`r`nqtfromyou=0`r`nqtsearch=i`r`nalertsdelay=15`r`nalerts=1`r`nenemyspotted=1`r`ndisconnected=1`r`nhotkeyradio=1`r`ntogglehotkey=F12`r`nspindir=0`r`nspinamount=220`r`nautoclickkey=LButton`r`nautoclickspamdelay=1000`r`nautoclickholddelay=50")
	file.close
}





IniRead, HotkeyRadioInput, %FileSettings%, Main, hotkeyradio
IniRead, ToggleHotkeyInput, %FileSettings%, Main, togglehotkey
IniRead, SpinDirInput, %FileSettings%, Main, spindir
IniRead, SpinAmountInput, %FileSettings%, Main, spinamount
IniRead, AutoClickKeyInput, %FileSettings%, Main, autoclickkey
IniRead, AutoClickSpamDelayInput, %FileSettings%, Main, autoclickspamdelay
IniRead, AutoClickHoldDelayInput, %FileSettings%, Main, autoclickholddelay


if (HotkeyRadioInput){
	AutoClickInput := 1
	FeedBabiesInput := 0
}else{
	AutoClickInput := 0
	FeedBabiesInput := 1
}

if (SpinDirInput){
	SpinRadio1 := 1
	SpinRadio2 := 0
}else{
	SpinRadio1 := 0
	SpinRadio2 := 1
}



IniRead, AlertsDelayInput, %FileSettings%, Main, alertsdelay
IniRead, AlertsInput, %FileSettings%, Main, alerts
IniRead, EnemySpottedInput, %FileSettings%, Main, enemyspotted
IniRead, DisconnectedInput, %FileSettings%, Main, disconnected


IniRead, AutoFWInput, %FileSettings%, Main, autofoodwater
IniRead, WaterDelayInput, %FileSettings%, Main, waterdelay
IniRead, FoodDelayInput, %FileSettings%, Main, fooddelay
IniRead, WaterKey, %FileSettings%, Main, waterkey
IniRead, FoodKey, %FileSettings%, Main, foodkey

IniRead, crosshair, %FileSettings%, Main, crosshair
IniRead, DVal, %FileSettings%, Main, d
IniRead, RVal, %FileSettings%, Main, R
IniRead, GVal, %FileSettings%, Main, G
IniRead, BVal, %FileSettings%, Main, B

IniRead, QTonInput, %FileSettings%, Main, qton
IniRead, QTHotkeyInput, %FileSettings%, Main, qthotkey
IniRead, QTdropInput, %FileSettings%, Main, qtdrop
IniRead, QTfromyouInput, %FileSettings%, Main, qtfromyou
IniRead, QTSearchInput, %FileSettings%, Main, qtsearch

if (QTdropInput){
	DropRadio := 1 
	TransferRadio := 0
}else{
	DropRadio := 0 
	TransferRadio := 1
}

if (QTfromyouInput){
	FromYouRadio := 1
	FromThemRadio := 0
}else{
	FromYouRadio := 0
	FromThemRadio := 1
}


Hotkey, %ToggleHotkeyInput%, HotkeyButton
Hotkey, %QTHotkeyInput%, QTHotkeyFunction


Width := 350
Height := A_ScreenHeight-60

Width2 := 350
Height2 := A_ScreenHeight-20



GoSub, ChooseServer



Gui, 2:+AlwaysOnTop +LastFound +ToolWindow -Caption +E0x20
Gui, 2:Color, EEAA99
Gui, 2:Add, ActiveX, x0 y0 w%Width% h%Height% vWB, Shell.Explorer2
WB.silent := true
WB.Document.Body.Style.Overflow := "Hidden"
Display(WB,ServerLog)
WinSet, TransColor, EEAA99


















Enabled := 0

AlertsDelayMS := AlertsDelayInput*1000

LastDrink := A_Now
LastEat := A_Now
LastTest := A_Now

DrinkTime := LastDrink
EatTime := LastEat







if (crosshair=1){
	GoSub, drawReticle
	ReticleDrawn := 1
	CHchecked := 1
}else{
	ReticleDrawn := 0
	CHchecked := 0
}
	
LSC1 := 1
LSC2 := 0
LSC3 := 0


R1Checked := 1
R2Checked := 0



X1 := 5
X125 := X1 + 6
X15 := X1 + 12

X2 := X1 + 190
X225 := X2 + 6
X25 := X2 + 12

TextYOffset := "+7"
EditYOffset := "-3"

xOffset1 := "+85"

GroupBoxH1A := 110
GroupBoxH2A := 100

GroupBoxH1B := 62
GroupBoxH2B := 117
GroupBoxH3B := 138
GroupBoxH4B := 125


GroupBoxY1 := 5
GroupBoxY2A := GroupBoxY1 + GroupBoxH1A 
GroupBoxY3A := GroupBoxY2A + GroupBoxH2A + 5

GroupBoxY2B := GroupBoxY1 + GroupBoxH1B + 5
GroupBoxY3B := GroupBoxY2B + GroupBoxH2B + 5
GroupBoxY4B := GroupBoxY3B + GroupBoxH3B + 5





GroupBoxWA := 185
GroupBoxWB := 200

EditW := "80"
x := X1+5

Gui, Add, GroupBox, x%X1% y%GroupBoxY1% h%GroupBoxH1A% w%GroupBoxWA%
Gui, Add, GroupBox, x%X1% y%GroupBoxY2A% h%GroupBoxH2A% w%GroupBoxWA%



Gui, Add, Radio, x%x% y%GroupBoxY1% vRadio1 gAutoClickFunction Checked%AutoClickInput%, Auto Click
;;Radio1_TT := "Test1"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

y := GroupBoxY2A
Gui, Add, Radio, Checked%FeedBabiesInput% x%x% y%y% gAutoClickFunction, Feed Babies


Gui, Add, Text, x%X15% yp+20, Spin Pixels:
Gui, Add, Edit, vSpinPixels xp%xOffset1% yp%EditYOffset% w%EditW% gUpdateSpinAmount, %SpinAmountInput%





Gui, Add, Text, x%X15% yp+28, Spin Direction:
Gui, Add, Radio, Checked%SpinRadio1% xp+75 yp+0 vRadioSpin gUpdateSpinDir, Left
Gui, Add, Radio, Checked%SpinRadio2% xp+45 yp+0 gUpdateSpinDir, Right












;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

y := GroupBoxY1 + 90

;Gui, Add, Radio, Checked%LSC1% x%X15% y%y% vRadio2, Local
;Gui, Add, Radio, Checked%LSC2% xp+55 yp+0, Client
;Gui, Add, Radio, Checked%LSC3% xp+55 yp+0, Server


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

y := GroupBoxY3A

Gui, Add, Text, x%X125% y%y%, Toggle Hotkey:
Gui, Add, Edit, vToggleHotkey gToggleHotkeyFunction xp+80 yp%EditYOffset% w95, %ToggleHotkeyInput%

Gui, Add, Text, x%X125% , Overlay:
Gui, Add, CheckBox, vOverlay1 xp+80 yp+0 checked%AlertsInput%

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

y := GroupBoxY1 +18
Gui, Add, Text, x%X15% y%y%, Spam Key:
Gui, Add, Edit, vAutoClickKey gUpdateAutoClickKey w%EditW% xp%xOffset1% yp%EditYOffset%, %AutoClickKeyInput%

Gui, Add, Text, x%X15% y%TextYOffset%, Spam Delay (ms):
Gui, Add, Edit, r1 vAutoClickSpamDelay gUpdateAutoClickSpamDelay w%EditW% xp%xOffset1% yp%EditYOffset%, %AutoClickSpamDelayInput%

Gui, Add, Text, x%X15% y%TextYOffset%, Hold Delay (ms):
Gui, Add, Edit, r1 vAutoClickHoldDelay gUpdateAutoClickHoldDelay w%EditW% xp%xOffset1% yp%EditYOffset%, %AutoClickHoldDelayInput%







;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
xOffset2 := "+55"
Gui, Add, GroupBox, x%X2% y%GroupBoxY1% h%GroupBoxH1B% w%GroupBoxWB%
Gui, Add, CheckBox, vAlerts gAlertsFunction xp+5 yp+ checked%AlertsInput%, Alerts

Gui, Add, Text, x%X25% yp+20, Repeat Delay (s):
Gui, Add, Edit, vAlertsDelay gAlertsDelayFunction w%EditW% xp%xOffset1% yp%EditYOffset%, %AlertsDelayInput%

Gui, Add, CheckBox, vEnemySpotted gEnemySpottedFunction x%X225% yp+26 checked%EnemySpottedInput%, Enemy Spotted
Gui, Add, CheckBox, vDisconnected gDisconnectedFunction xp+100 yp+0 checked%DisconnectedInput%, Disconnected











;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
xOffset2 := "+55"

Gui, Add, GroupBox, x%X2% y%GroupBoxY2B% h%GroupBoxH2B% w%GroupBoxWB%
Gui, Add, CheckBox, vFoodWaterCheckBox gToggleFoodWater xp+5 yp+0 checked%AutoFWInput%, Auto Food Water


Values := "1|2|3|4|5|6|7|8|9|0"
Values := RegexReplace(Values, FoodKey, FoodKey "|")

Gui, Add, Text, x%X25% yp+20, Food Key:
Gui, Add, ComboBox, r10 vFoodCombo gSetFoodKey w30 xp%xOffset2% yp%EditYOffset% center, %Values%
Gui, Add, Text, xp+35 yp+2, Time (s):
Gui, Add, Edit, r1 vFoodDelay gSetFoodDelay w50 xp+40 yp%EditYOffset% center, %FoodDelayInput%


Values := "1|2|3|4|5|6|7|8|9|0"
Values := RegexReplace(Values, WaterKey, WaterKey "|")

Gui, Add, Text, x%X25% y%TextYOffset%, Water Key:
Gui, Add, ComboBox, r10 vWaterCombo gSetWaterKey w30 xp%xOffset2% yp%EditYOffset% center, %Values%
Gui, Add, Text, xp+35 yp+2, Time (s):
Gui, Add, Edit, r1 vWaterDelay gSetWaterDelay w50 xp+40 yp%EditYOffset% center, %WaterDelayInput%


Gui, Add, Button, x230 yp+26 gResetFWCounters, Reset Timers
Gui, Add, Button, x310 yp+0 gSetDefaultCounters, Default Timers

X := X2+5
Gui, Add, Edit, r1 vFoodWaterStatus w190 x%X% yp+26 disabled, Food: 0m 0s`tWater: 0m 0s


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






Gui, Add, GroupBox, x%X2% y%GroupBoxY3B% h%GroupBoxH3B% w%GroupBoxWB%

Gui, Add, CheckBox, vCrosshairToggle xp+5 yp+0 Checked%CHchecked% gToggleCrosshair, Crosshair

xOffset3 := "+80"


x := "+44"
x275 := "+105"
y := "-4"
y2 := "+1"
y3 := "+32"
SliderW := 105


Gui, Add, Text, x%X25% yp+20, Red:
Gui, Add, Slider, xp%x% yp%y% vRSlider w%SliderW% Range0-255 gSetRSlider, %RVal%
Gui, Add, Edit, vRed r1 w30 xp%x275% yp%y2% center Number gSetREdit, %RVal%


Gui, Add, Text, x%X25% yp%y3%, Green:
Gui, Add, Slider, xp%x% yp%y% vGSlider w%SliderW% Range0-255 gSetGSlider, %GVal%
Gui, Add, Edit, vGreen r1 w30 xp%x275% yp%y2% center Number gSetGEdit, %GVal%


Gui, Add, Text, x%X25% yp%y3%, Blue:
Gui, Add, Slider, xp%x% yp%y% vBSlider w%SliderW% Range0-255 gSetBSlider, %BVal%
Gui, Add, Edit, vBlue r1 w30 xp%x275% yp%y2% center Number gSetBEdit, %BVal%




Gui, Add, Text, x%X25% yp%y3%, Diameter:
Gui, Add, Slider, xp%x% yp%y% vDSlider w%SliderW% Range2-25 gSetDSlider, %DVal%
Gui, Add, Edit, vDiameter r1 w30 xp%x275% yp%y2% center Number gSetDEdit, %DVal%



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




Gui, Add, GroupBox, x%X2% y%GroupBoxY4B% h%GroupBoxH4B% w%GroupBoxWB%

Gui, Add, CheckBox, vQTToggle gSetTransferToggle xp+5 yp+0 Checked%QTonInput%, Quick Transfer



Gui, Add, Text, x%X25% yp+20, Function Hotkey:
Gui, Add, Hotkey, vQTHotkey gUpdateQTHotkey xp+85 yp%EditYOffset% w90, %QTHotkeyInput%




Gui, Add, Radio, Checked%DropRadio% gSetDrop x%X25% yp+30 vQT1, Drop
Gui, Add, Radio, Checked%TransferRadio% gSetTransfer xp+80 yp+0, Transfer


Gui, Add, Text, x%X25% yp+50, Search String(s):
Gui, Add, Edit, vSearchString gUpdateTransferString w%EditW% xp%xOffset1% yp%EditYOffset%, %QTSearchInput%


Gui, Add, Radio, Checked%FromYouRadio% gSetFromYou x%X25% yp-25 vQT2, From You
Gui, Add, Radio, Checked%FromThemRadio% gSetFromThem xp+80 yp+0, From Them















;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

















Gui, Add, StatusBar
SB_SetText("Important Info down here")


Gui, Show, AutoSize x0 y-600


OnMessage(0x20, "WM_MOUSEMOVE")



Loop{

	if (AlertsInput){
		if (CheckDC() && DisconnectedInput){
			;;EventInfo = Disconnected
			;;GoSub, UpdateGUI
			SoundPlay, Disconnected.mp3
			Sleep, %AlertsDelayMS%
		}
		if (EnemySpottedInput){
			GoSub, CheckEnemy
			if (Hits>=5)
			{
				;;EventInfo := "Enemy Detected"
				;;GoSub, UpdateGUI
				SoundPlay, EnemySpotted.mp3
				Sleep, %AlertsDelayMS%
			}
		}
	}

	if (FeedBabiesInput){
		if (Enabled && WinActive("ahk_class UnrealWindow")){
			EventInfo = Rotating
			GoSub, UpdateGUI
			;BlockInput, MouseMove
						
			ActualSpin := RadioSpinInput ? -SpinAmountInput : SpinAmountInput
			
			DllCall("mouse_event", "UInt", 0x01, "UInt", ActualSpin, "UInt", 0)
			;BlockInput, MouseMoveOff
			Sleep 250
			Send {f}
			EventInfo = Looking For Inventory
			GoSub, UpdateGUI
			Sleep 1000
		}
		if (Enabled && CheckInv() && WinActive("ahk_class UnrealWindow")){
			EventInfo = Found Inventory
			GoSub, UpdateGUI
			Sleep 500
			X := 0.5*A_ScreenWidth
			if (A_ScreenWidth>=1920)			;;;;;;1920x1080
				Y := 0.44*A_ScreenHeight
			else													;;;;;;1680x1050
				Y := 0.47*A_ScreenHeight
			
			PixelGetColor, Color, %X%, %Y%
			B := Color >> 16 & 0xFF, G := Color >> 8 & 0xFF, R := Color & 0xFF
			if (Enabled &&WinActive("ahk_class UnrealWindow")){
				;BlockInput, MouseMove
				if (R<20 && G>65 && B>100){	;;;;;;IN Food Supply
					
					EventInfo = Food Supply
					GoSub, UpdateGUI
					Sleep 1000
					X := 0.18*A_ScreenWidth
					if (A_ScreenWidth>=1920)	;;;;;;1920x1080
						Y := 0.18*A_ScreenHeight
					else												;;;;;;1680x1050
						Y := 0.22*A_ScreenHeight
					
					MouseClick, Left, X, Y, 5
					
					Sleep 500
					X := 0.67*A_ScreenWidth
					if (A_ScreenWidth>=1920)	;;;;;;1920x1080
						Y := 0.26*A_ScreenHeight
					else												;;;;;;1680x1050
						Y := 0.29*A_ScreenHeight
				}
				else{												;;;;;;IN Baby
					
					EventInfo = Feed Baby
					GoSub, UpdateGUI
					Sleep 1500
					
					X := 0.19*A_ScreenWidth
					if (A_ScreenWidth>=1920)	;;;;;;1920x1080
						Y := 0.27*A_ScreenHeight
					else 											;;;;;;1680x1050
						Y := 0.30*A_ScreenHeight
				}
				
			}
			if (Enabled && CheckInv() && WinActive("ahk_class UnrealWindow")){
				EventInfo = Transfering Food
				GoSub, UpdateGUI
				MouseMove, X, Y, 5
				Sleep 100
				Loop, 5{
					Send {t}
					Sleep 500
				}
			}
			;BlockInput, MouseMoveOff
			Send {f}
			EventInfo = Exit Inventory
			GoSub, UpdateGUI
			Sleep 1000
		}
		else{
			if (Enabled &&WinActive("ahk_class UnrealWindow"))
			{
				EventInfo = No Inventory Found
				GoSub, UpdateGUI
			}
		}
	}





	if (DrinkTime<=0)
	{	
		if (AutoFWInput && WinActive("ahk_class UnrealWindow"))
			GoSub, Drink
	}
	else
	{
		DrinkTime := LastDrink
		EnvSub, DrinkTime, %A_Now%, seconds 
		DrinkTime := WaterDelayInput + DrinkTime

		DrinkTimeM := DrinkTime/60
		DrinkTimeS := round("0" substr(DrinkTimeM, InStr(DrinkTimeM, "."))*60,0)
		DrinkTimeM := substr(DrinkTimeM, 1, InStr(DrinkTimeM, ".")-1)

		DrinkTimeDisp := DrinkTimeM "m " DrinkTimeS "s"
	}

	if (EatTime<=0)
	{	
		if (AutoFWInput && WinActive("ahk_class UnrealWindow"))
			GoSub, Eat
	}
	else
	{
		EatTime := LastEat
		EnvSub, EatTime, %A_Now%, seconds
		EatTime := FoodDelayInput + EatTime

		EatTimeM := EatTime/60
		EatTimeS := round("0" substr(EatTimeM, InStr(EatTimeM, "."))*60,0)
		EatTimeM := substr(EatTimeM, 1, InStr(EatTimeM, ".")-1)

		EatTimeDisp := EatTimeM "m " EatTimeS "s"
	}
	
	
	if (Debug){
		TestTime := LastTest
		EnvSub, TestTime, %A_Now%, seconds
		
		TestTimeM := TestTime/60
		TestTimeS := round("0" substr(TestTimeM, InStr(TestTimeM, "."))*60,0)
		TestTimeM := substr(TestTimeM, 2, InStr(TestTimeM, ".")-2)
		
		TestTimeDisp := " (" TestTimeM "m " TestTimeS "s)"
	}
	GuiControl, , FoodWaterStatus, Food: %EatTimeDisp%`tWater: %DrinkTimeDisp%

	;;;GoSub, UpdateGUI
	
	
	
	
	
	
	
	
	
	Sleep 1000
}

Return








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;










GuiClose:
GuiEscape:
{
    ExitApp
}




WM_MOUSEMOVE()
{
    static CurrControl, PrevControl, _TT  ; _TT is kept blank for use by the ToolTip command below.
    CurrControl := RegexReplace(A_GuiControl, " ")
    If (CurrControl <> PrevControl and not InStr(CurrControl, " "))
    {
        ToolTip  ; Turn off any previous tooltip.
        SetTimer, DisplayToolTip, 1000
        PrevControl := CurrControl
    }
    return

    DisplayToolTip:
    SetTimer, DisplayToolTip, Off
    ToolTip % %CurrControl%_TT  ; The leading percent sign tell it to use an expression.
    ;;SetTimer, RemoveToolTip, 3000
    return

    RemoveToolTip:
    SetTimer, RemoveToolTip, Off
    ToolTip
    return
}

CheckInv(){

	if (A_ScreenWidth>=1920){
		;;;;;;1920x1080
		X := 0.438*A_ScreenWidth
		Y := 0.026*A_ScreenHeight
	}else{
		;;;;;;1680x1050
		X := 0.440*A_ScreenWidth
		Y := 0.08*A_ScreenHeight
	}
	
	PixelGetColor, Color, %X%, %Y%
	B := Color >> 16 & 0xFF, G := Color >> 8 & 0xFF, R := Color & 0xFF

	if (R<165 && G>220 && B>240 && WinActive("ahk_class UnrealWindow"))
		RetVal := true
	else
		RetVal := false
		
	return RetVal
}


SetRSlider:
	GuiControlGet, RVal, , RSlider
	GuiControl, , Red, %RVal%
	if (crosshair=1){
		GoSub, drawReticle
		ReticleDrawn := 1
	}
return
SetREdit:
	GuiControlGet, RVal, , Red
	GuiControl, , RSlider, %RVal%
	if (crosshair=1){
		GoSub, drawReticle
		ReticleDrawn := 1
	}
return

SetGSlider:
	GuiControlGet, GVal, , GSlider
	GuiControl, , Green, %GVal%
return
SetGEdit:
	GuiControlGet, GVal, , Green
	GuiControl, , GSlider, %GVal%
	if (crosshair=1){
		GoSub, drawReticle
		ReticleDrawn := 1
	}
return

SetBSlider:
	GuiControlGet, BVal, , BSlider
	GuiControl, , Blue, %BVal%
	if (crosshair=1){
		GoSub, drawReticle
		ReticleDrawn := 1
	}
return
SetBEdit:
	GuiControlGet, BVal, , Blue
	GuiControl, , BSlider, %BVal%
	if (crosshair=1){
		GoSub, drawReticle
		ReticleDrawn := 1
	}
return

SetDSlider:
	GuiControlGet, DVal, , DSlider
	GuiControl, , Diameter, %DVal%
	if (crosshair=1){
		GoSub, drawReticle
		ReticleDrawn := 1
	}
return
SetDEdit:
	GuiControlGet, DVal, , Diameter
	GuiControl, , DSlider, %DVal%
	if (crosshair=1){
		GoSub, drawReticle
		ReticleDrawn := 1
	}
return

ToggleCrosshair:
	GuiControlGet, crosshair, , CrosshairToggle
	if (crosshair=1){
		GoSub, drawReticle
		ReticleDrawn := 1
	}else{
		Gui, 6:Destroy
		ReticleDrawn := 0
	}


return



drawReticle:
	HexR := substr(FHex(RVal, 2),3)
	HexG:= substr(FHex(GVal, 2),3)
	HexB := substr(FHex(BVal, 2),3)
	
	IniWrite, %DVal%, %FileSettings%, Main, d
	IniWrite, %RVal%, %FileSettings%, Main, R
	IniWrite, %GVal%, %FileSettings%, Main, G
	IniWrite, %BVal%, %FileSettings%, Main, B
	
	
	
	
	
	Color := HexR HexG HexB
	
	
	Gui, 6:Destroy
	Sleep 10
	Gui, 6:+LastFound -Caption +AlwaysOnTop +ToolWindow +E0x20
	Gui, 6:Color, EEAA99
	WinSet, TransColor, EEAA99

	DVal2 := DVal+1
	Gui, 6:Add, Picture, x-1 y-1 w%DVal2% h%DVal2% BackgroundTrans 0xE HwndXHairHwnd,	
	
	

	pBitmap := Gdip_CreateBitmap(DVal2, DVal2)
	Graphics := Gdip_GraphicsFromImage(pBitmap)

	Gdip_SetSmoothingMode(Graphics, 3)
	Gdip_SetInterpolationMode(Graphics, 7)



	Brush := Gdip_BrushCreateSolid("0xFF" Color)
	Gdip_FillEllipse(Graphics, Brush, 1, 1, DVal, DVal)

	;;pPen := Gdip_CreatePen("0xFF" Color2, 2)
	;;Gdip_DrawEllipse(Graphics, pPen, 1, 1, DVal, DVal)

	;FilePath := A_ScriptDir . "\CrossHair.jpg"
	;Gdip_SaveBitmapToFile(pBitmap, Filepath)
	


	hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
	SetImage(XHairHwnd, hBitmap)
	Gui, 6:Show, w%DVal2% h%DVal2% NA
return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





Display(WB,html_str) {
	Count:=0
	while % FileExist(f:=A_Temp "\" A_TickCount A_NowUTC "-tmp" Count ".DELETEME.html")
		Count+=1
	FileAppend,%html_str%,%f%
	WB.Navigate("file://" . f)
}

FHex( int, pad=0 ) { ; Function by [VxE]. Formats an integer (decimals are truncated) as hex.

; "Pad" may be the minimum number of digits that should appear on the right of the "0x".

	Static hx := "0123456789ABCDEF"

	If !( 0 <= int |= 0 )

		Return !int ? "0x0" : "-" FHex( -int, pad )

	s := 1 + Floor( Ln( int ) / Ln( 16 ) )

	h := SubStr( "0x0000000000000000", 1, pad := pad < s ? s + 2 : pad < 16 ? pad + 2 : 18 )

	u := A_IsUnicode = 1

	Loop % s

		NumPut( *( &hx + ( ( int & 15 ) << u ) ), h, pad - A_Index << u, "UChar" ), int >>= 4

	Return h

}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



CheckDC(){
	Y := 0.572*A_ScreenHeight ;;;;.551-.574
	X1 := 0.390*A_ScreenWidth ;;;;.368
	X2 := 0.450*A_ScreenWidth ;;;;;.470
	X3 := 0.550*A_ScreenWidth ;;;;;.528
	X4 := 0.600*A_ScreenWidth ;;;;;.629
	Test1 := Test2 := Test3 := Test4 := 0	
	Loop, 4
	{
		if (WinActive("ahk_class UnrealWindow")){
			X := X%A_Index%
			PixelGetColor, Color, %X%, %Y%
			B%A_Index% := Color >> 16 & 0xFF
			G%A_Index% := Color >> 8 & 0xFF
			R%A_Index% := Color & 0xFF
			if (R%A_Index%>0 && R%A_Index%<20 && G%A_Index%>20 && G%A_Index%<100 && B%A_Index%>40 && B%A_Index%<120)
				Test%A_Index% := 1
			else
				Test%A_Index% := 0
		}
	}
	
	;Tooltip, R1:%R1% G1:%G1% B1:%B1%`nR2:%R2% G2:%G2% B2:%B2%`nR3:%R3% G3:%G3% B3:%B3%`nR4:%R4% G4:%G4% B4:%B4% 
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	if (Test1=1 && Test2=1 && Test3=1 && Test4=1)
		RetVal := true
	else if (WinExist("The UE4-ShooterGame Game has crashed and will close"))
		RetVal := true
	else if (!WinExist("ahk_exe ShooterGame.exe"))
		RetVal := true
	else
		RetVal := false
			
			
	return RetVal
}


CheckEnemy:
	Hits := 0
	Y := 0.038*A_ScreenHeight
	X := 0.5*A_ScreenWidth
	While (X<0.75*A_ScreenWidth && WinActive("ahk_class UnrealWindow"))
	{
		PixelGetColor, Color, %X%, %Y%
		B := Color >> 16 & 0xFF, G := Color >> 8 & 0xFF, R := Color & 0xFF
		;Tooltip, R:%R% G:%G% B:%B%
		;Sleep 1000
		
		if (R<10 && G>240 && B>220)
			Hits++
		
		X := X+20
	}
return



ToggleFoodWater:
	GuiControlGet, AutoFWInput,, FoodWaterCheckBox
	IniWrite, %AutoFWInput%, %FileSettings%, Main, autofoodwater
return


Eat:
	Send {%FoodKey%}
	LastEat := A_Now
	EatTime := 1
return

Drink:
	Send {%WaterKey%}
	LastDrink := A_Now
	DrinkTime := 1
return

ResetFWCounters:
	LastEat := A_Now
	LastDrink := A_Now
	LastTest := A_Now
	DrinkTime := 1
	EatTime := 1
return

SetDefaultCounters:
	GuiControl, , FoodDelay, %DefaultFoodDelay%
	GuiControl, , WaterDelay, %DefaultWaterDelay%

	IniWrite, %DefaultFoodDelay%, %FileSettings%, Main, fooddelay
	IniWrite, %DefaultWaterDelay%, %FileSettings%, Main, waterdelay
return

SetFoodDelay:
	GuiControlGet, FoodDelayInput, , FoodDelay
	IniWrite, %FoodDelayInput%, %FileSettings%, Main, fooddelay
return

SetWaterDelay:
	GuiControlGet, WaterDelayInput, , WaterDelay
	IniWrite, %WaterDelayInput%, %FileSettings%, Main, waterdelay
return

SetFoodKey:
	GuiControlGet, FoodKey, , FoodCombo
	IniWrite, %FoodKey%, %FileSettings%, Main, foodkey
return

SetWaterKey:
	GuiControlGet, WaterKey, , WaterCombo
	IniWrite, %WaterKey%, %FileSettings%, Main, waterkey
return

AlertsDelayFunction:
	GuiControlGet, AlertsDelayInput, , AlertsDelay
	IniWrite, %AlertsDelayInput%, %FileSettings%, Main, alertsdelay
	AlertsDelayMS := AlertsDelayInput*1000
return

AlertsFunction: 
	GuiControlGet, AlertsInput, , Alerts
	IniWrite, %AlertsInput%, %FileSettings%, Main, alerts
return

EnemySpottedFunction: 
	GuiControlGet, EnemySpottedInput, , EnemySpotted
	IniWrite, %EnemySpottedInput%, %FileSettings%, Main, enemyspotted
return

DisconnectedFunction:
	GuiControlGet, DisconnectedInput, , Disconnected
	IniWrite, %DisconnectedInput%, %FileSettings%, Main, disconnected
return

AutoClickFunction:
	GuiControlGet, HotkeyRadioInput, , Radio1
	if (HotkeyRadioInput){
		AutoClickInput := 1
		FeedBabiesInput := 0
	}else{
		AutoClickInput := 0
		FeedBabiesInput := 1
	}
	IniWrite, %HotkeyRadioInput%, %FileSettings%, Main, hotkeyradio
	
	GoSub, UpdateGUI
return

ToggleHotkeyFunction:
	Hotkey, %ToggleHotkeyInput%, HotkeyButton, Off
	GuiControlGet, ToggleHotkeyInput, , ToggleHotkey
	IniWrite, %ToggleHotkeyInput%, %FileSettings%, Main, togglehotkey
	Hotkey, %ToggleHotkeyInput%, HotkeyButton, On
return

HotkeyButton:
	if (Enabled){
		Enabled := 0
		SB_SetText("Disabled")
		if(AutoClickInput)
			SetTimer, SpamKeyFunction, Off
		
		
		
	}else{
		Enabled := 1
		SB_SetText("Enabled")
		if(AutoClickInput)
			SetTimer, SpamKeyFunction, %AutoClickSpamDelayInput%
		
		
	}
	GoSub, UpdateGUI
return

SpamKeyFunction:
	if (WinActive("ahk_class UnrealWindow")){
		if ((AutoClickKeyInput="t" && CheckInv()) || AutoClickKeyInput!="t"){
			if (AutoClickHoldDelayInput="0")
				Send {%AutoClickKeyInput%}
			else {
				Send {%AutoClickKeyInput% down}
				Sleep AutoClickHoldDelayInput
				Send {%AutoClickKeyInput% up}
			}
		}
	}
return



SetTransferToggle:
	GuiControlGet, QTonInput, , QTToggle
	IniWrite, %QTonInput%, %FileSettings%, Main, qton
return

QTHotkeyFunction:
	if (QTonInput && WinActive("ahk_class UnrealWindow")){
		
		if (!CheckInv())
			Send {f}
		While (!CheckInv() && i<1000)
		{
			i++
			Sleep 10
		}
		
		
		if (CheckInv()){
			Y := A_ScreenWidth>=1920 ? 0.167*A_ScreenHeight : 0.213*A_ScreenHeight
			if (QTfromyouInput){
				X1 := 0.1*A_ScreenWidth
				X2 := QTdropInput ? 0.212*A_ScreenWidth : 0.185*A_ScreenWidth
			}else{
				X1 := 0.7*A_ScreenWidth
				X2 := QTdropInput ? 0.80*A_ScreenWidth : 0.77*A_ScreenWidth
			}
			
			
			if (InStr(QTSearchInput,",")){
				QTSearchArr := StrSplit(QTSearchInput, ",")
				Loop %	QTSearchArr.MaxIndex(){
					QTSearchStr := QTSearchArr[A_Index]
					if (StrLen(QTSearchStr)>0){
						MouseClick, Left, X1, Y, 1, 3
						Sleep 50
						Send %QTSearchStr%
						Sleep 50
						MouseClick, Left, X2, Y, 1, 3
					}
					Sleep 50
				}
				
				
			}else{
				MouseClick, Left, X1, Y, 1, 3
				Sleep 50
				Send %QTSearchInput%
				Sleep 50
				MouseClick, Left, X2, Y, 1, 3
			}
			Sleep 50
			Send {f}
		}
	}
return


UpdateQTHotkey:
	Hotkey, %QTHotkeyInput%, QTHotkeyFunction, Off 
	GuiControlGet, QTHotkeyInput, , QTHotkey
	IniWrite, %QTHotkeyInput%, %FileSettings%, Main, QTHotkey
	Hotkey, %QTHotkeyInput%, QTHotkeyFunction, On
	QTHotkeyInputOld := QTHotkeyInput
return



SetDrop:
	IniWrite, 1, %FileSettings%, Main, qtdrop
	QTdropInput := 1
return
SetTransfer:
	IniWrite, 0, %FileSettings%, Main, qtdrop
	QTdropInput := 0
return
	
	
	
SetFromYou:
	IniWrite, 1, %FileSettings%, Main, qtfromyou
	QTfromyouInput := 1
return
SetFromThem:
	IniWrite, 0, %FileSettings%, Main, qtfromyou
	QTfromyouInput := 1
return


UpdateTransferString:
	GuiControlGet, QTSearchInput, , SearchString
	IniWrite, %QTSearchInput%, %FileSettings%, Main, qtsearch
return

UpdateSpinDir:
	GuiControlGet, RadioSpinInput, , RadioSpin
	IniWrite, %RadioSpinInput%, %FileSettings%, Main, spindir
return

UpdateSpinAmount:
	GuiControlGet, SpinAmountInput, , SpinPixels
	IniWrite, %SpinAmountInput%, %FileSettings%, Main, spinamount
return

UpdateAutoClickKey:
	GuiControlGet, AutoClickKeyInput, , AutoClickKey
	IniWrite, %AutoClickKeyInput%, %FileSettings%, Main, autoclickkey
	if Enabled
		GoSub, UpdateGUI
return

UpdateAutoClickSpamDelay:
	GuiControlGet, AutoClickSpamDelayInput, , AutoClickSpamDelay
	IniWrite, %AutoClickSpamDelayInput%, %FileSettings%, Main, autoclickspamdelay
	if Enabled
		GoSub, UpdateGUI
return

UpdateAutoClickHoldDelay:
	GuiControlGet, AutoClickHoldDelayInput, , AutoClickHoldDelay
	IniWrite, %AutoClickHoldDelayInput%, %FileSettings%, Main, autoclickholddelay
	if Enabled
		GoSub, UpdateGUI
return






UpdateGUI:
	Gui, 43:Destroy
	
	if Enabled 
		EnabledText := "ON"
	else
		EnabledText := "OFF"
	
	
	if (AutoClickInput)
		TransSplashText_On(43,ToggleHotkeyInput ":", EnabledText, "Spam Key: " AutoClickKeyInput "  Spam Delay: " AutoClickSpamDelayInput " ms  Hold Delay: " AutoClickHoldDelayInput " ms", hwndText, hwndTextS,,"White","Black",,GuiX,GuiY, 800)
	else
		TransSplashText_On(43,ToggleHotkeyInput ":", EnabledText, EventInfo, hwndText, hwndTextS,,"White","Black",,GuiX,GuiY)
return



ChooseServer:
	PlayerCount := ServerLog := hObject := ""
	ServerSearch := "443"
	URL := "https://www.battlemetrics.com/servers/search?q=" ServerSearch "&game=ark&sort=score&features%5B2e079b9a-d6f7-11e7-8461-83e84cedb373%5D=true"
	
	
	;;hObject := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	;;hObject.Open("GET",URL)
	;;hObject.Send()
	;;ServerHTML := hObject.ResponseText
	
	Loop{
		Process, Close, iexplore.exe
		Process, Exist, iexplore.exe
	}	Until	!ErrorLevel
	
	hObject := ComObjCreate("InternetExplorer.Application")
	hObject.Visible := False
	hObject.Navigate(URL)

	while hObject.readyState!=4 || hObject.document.readyState != "complete" || hObject.busy
		sleep 10
	
	Links := hObject.Document.getElementsbyTagName("a")
	Loop % Links.Length
	{	
		FoundPos := RegexMatch(Links[A_Index-1].outerHTML, "href=""/servers/ark/([0-9]{1,8})""", Match)
		if (FoundPos>0){
			URL := "https://www.battlemetrics.com/servers/ark/" Match1
			break
		}
	}
	
	
	;;FoundPos := RegexMatch(ServerHTML, "href=""/servers/ark/([0-9]{1,8})""", Match)
	;;if (FoundPos>0)
	;;	URL := "https://www.battlemetrics.com/servers/ark/" Match1
	
	
	hObject.Navigate(URL)
	while hObject.readyState!=4 || hObject.document.readyState != "complete" || hObject.busy
		sleep 10
	GoSub, UpdateServerInfo
return

UpdateServerInfo:
	;;hObject.Open("GET",URL)
	;;hObject.Send()
	;;ServerHTML := hObject.ResponseText
	
	
	;hObject.Navigate(URL)
	;hObject.refresh()
	
	while hObject.readyState!=4 || hObject.document.readyState != "complete" || hObject.busy
		sleep 10
		
		
	ServerHTML := hObject.Document.All.Tags("body")[0].OuterHTML
	
	FoundPos := RegexMatch(ServerHTML, "<dt>Player count</dt><dd>([0-9/]{1,7})</dd>", Match)
	if (FoundPos>0)
		PlayerCount := Match1
	


	FoundPos := RegexMatch(ServerHTML, "<div class=""collapse"">(.+?)</div></div>", Match)
	if (FoundPos>0){
		ServerLog := Match1
		ServerLog := RegexReplace(ServerLog, "<div.+?>|</div>", "")
		ServerLog := RegexReplace(ServerLog, "<span.+?>", "`r`n`r`n<tr>`r`n<td>`r`n")
		ServerLog := RegexReplace(ServerLog, "</span>", "`r`n</td>")
		ServerLog := RegexReplace(ServerLog, "<time.+?>", "`r`n<td>`r`n")
		ServerLog := RegexReplace(ServerLog, "</time>", "`r`n</td>`r`n</tr>")
		ServerLog := "<style>`r`n`tbody {`r`n`t`tbackground-color: #EEAA99;`r`n`t`tcolor: white;`r`n`t`ttext-shadow: 0px 0px 5px #000000;`r`n`t}`r`n</style>`r`n`r`n<body>`r`n<table>" ServerLog "`r`n`r`n</table>`r`n</body>"
		;;Clipboard := ServerLog
	}
	ServerHTML := ""
	
	;;SoundBeep
return

CheckPauseMenu:


	X0 := 0.41*A_ScreenWidth
	X1 := 0.45*A_ScreenWidth
	X2 := 0.55*A_ScreenWidth
	X3 := 0.59*A_ScreenWidth
	
	Y1 := 0.25*A_ScreenHeight
	Y2 := 0.30*A_ScreenHeight
	Y3 := 0.35*A_ScreenHeight
	

	l := 0
	MaxCD := 8
	
	MaxOutPix := 12

			
	X := Round(X0)
	Y := Round(Y1)
	
	OutofInv := 0
	Loop, 3{
		Y := Round(Y%A_Index%)
		X := Round(X0)
		
		PixelGetColor, Color, %X%, %Y%
		B1 := Color >> 16 & 0xFF, G1 := Color >> 8 & 0xFF, R1 := Color & 0xFF
		if (R1>0 && R1<26 && G1>20 && G1<110 && B1>100 && B1<134){

		
			While (X<X1){
				PixelGetColor, Color, %X%, %Y%
				B := Color >> 16 & 0xFF, G := Color >> 8 & 0xFF, R := Color & 0xFF
				TestR := abs(R-R1),TestG := abs(G-G1),TestB := abs(B-B1)
				
				if (TestR>MaxCD || TestG>MaxCD || TestB>MaxCD){
					;Tooltip, %X% %Y%`n%TestR%`n%TestG%`n%TestB%
					OutofInv++
				}
				X := X+3
			}
			X := Round(X2)
			While (X<X3){
				PixelGetColor, Color, %X%, %Y%
				B := Color >> 16 & 0xFF, G := Color >> 8 & 0xFF, R := Color & 0xFF
				TestR := abs(R-R1),TestG := abs(G-G1),TestB := abs(B-B1)
				if (TestR>MaxCD || TestG>MaxCD || TestB>MaxCD){
					;Tooltip, %TestR%`n%TestG%`n%TestB%
					OutofInv++
				}
				X := X+3
			}
		}
	}
	l := l + 1 
	Sleep 10
	;;Tooltip, %l%
	
	
	
	
	if (OutofInv<=MaxOutPix){
		GoSub, UpdateServerInfo
		SetTimer, CheckPauseMenu, 500
		SetTimer, UpdateServerInfo, 15000
		Gui, 2:Show, X0 Y0 w%Width2% h%Height2% NA
	}
	else{
		Gui, 2:Hide
		SetTimer, UpdateServerInfo, Off
		SetTimer, CheckPauseMenu, Off
		
	}
	l := 0
	
	
return

~Esc::
	Gui, 2:Hide
	SetTimer, UpdateServerInfo, Off
	SetTimer, CheckPauseMenu, Off
	if (0)
		GoSub, CheckPauseMenu
return