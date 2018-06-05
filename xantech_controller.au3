;#AutoIt3Wrapper_au3check_parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#include <GuiImageList.au3>
#include <GuiButton.au3>

#Include <GDIPlus.au3>
#include <CommMG.au3>




Opt("TrayIconHide", 1) ;0=show, 1=hide tray icon
Opt("TrayAutoPause", 0) ;0=no pause, 1=Pause
_GDIPlus_Startup ()

OnAutoItExitRegister("alldone")
HotKeySet("{ESC}", "alldone")


Const $exitTimer = 5 ; unit in minutes
Const $formWidth = 500
Const $formHeight = 720
Const $nZone = 4
Const $minVol = 20;
Const $maxVol = 80;
Const $stepVol = 10;
Const $ZoneButtonHeight = 50
Const $Group_Border = 40 ;From form1's edge to groups border
const $Group_inBorder = 30 ;From groups edge to internal element
Const $preview_Height = 197;Height of the preview zone90
Const $volBar_Height = 20;
Const $nSource = 4
Const $sourceButtonHeight = 25;
Const $imagePath  = @WorkingDir & "\images\"


Local $time_begin = TimerInit()


Dim $SourceName[$nSource+1] = ["Apple","Family","Dock","Theater","Local"]

Const $n_feature = 4
Dim $extraFeature[$n_feature] = ["Whole House On", "Whole House Off", "All Power On", "All Power Off"]
;                                       0             1                      2              3
Const $CONST_ALLOFF=3
Const $CONST_ALLON=2
Const $CONST_WHOFF=1
Const $CONST_WHON=0


Global $currentZone = 0; base select default to 1

$Form1_1 = GUICreate("Form1", $formWidth, $formHeight, 200, 0)

;===========COMS
$list_ports = _CommlistPorts()
GUICtrlCreateLabel("COM: ", 10, 50, 70, 20)
$available_port = GuiCtrlCreatecombo("",80, 50, 60,20)
GUICtrlSetData(-1,""&$list_ports)


Local $sportSetError
            
_CommSetPort(3,$sportSetError,9600,8,"none",1,2)
			
if $sportSetError = '' Then
			MsgBox(262144, 'Connected ','to COM' & 3)
			Else
			MsgBox(262144, 'Setport error = ', $sportSetError)
EndIf
            

;============================================================


$Group1 = GUICtrlCreateGroup("Controlling Zone 1", $Group_Border, $Group_Border + $ZoneButtonHeight , $formWidth-2*$Group_Border,$formHeight-2*$Group_Border-2*$ZoneButtonHeight )

$zoneviewer = GUICtrlCreatePic($imagePath & "preview_zone1.jpg", $Group_Border+$Group_inBorder,$Group_Border+$Group_inBorder+$ZoneButtonHeight, $formWidth-2*$Group_Border-2*$Group_inBorder  , $preview_Height)
ConsoleWrite("preview width" & $formWidth-2*$Group_Border-2*$Group_inBorder & @CRLF )

Const $totalvolume = int(($maxVol-$minVol)/$stepVol)+1
Const $progress_width = int(($formWidth-2*$Group_Border-2*$Group_inBorder)/$totalvolume)
ConsoleWrite("progress_width" & $progress_width & @CRLF)

Local $volumeSelect[$totalvolume]
ConsoleWrite("volumeselect + 1 = " & $totalvolume & @CRLF)

global $VOLCOLOR1 = 0xA0A0A0
For $i = 0 to $totalvolume-1
   $volumeSelect[$i] = GUICtrlCreateButton("",2+$Group_Border+$Group_inBorder+$i*$progress_width, $Group_Border+$Group_inBorder + $preview_Height + $ZoneButtonHeight, $progress_width,$volBar_Height)
   GUICtrlSetBkColor(-1, $VOLCOLOR1)
Next

$Top_Source_Gap = 15;
$temp_38 =  $ZoneButtonHeight+$Group_Border+$Group_inBorder + $preview_Height + $volBar_Height + $Top_Source_Gap

$bSource = $nSource+1;
Local $sourceSelect[$bSource]
For $i = 0 to $bSource-1
$sourceSelect[$i] = GUICtrlCreateButton($sourceName[$i]	 , $Group_Border+$Group_inBorder + $i*int(($formWidth-2*$Group_Border-2*$Group_inBorder)/$bSource) _
														 , $temp_38, int(($formWidth-2*$Group_Border-2*$Group_inBorder)/$bSource) _
														 , $SourceButtonHeight)
Next

$Top_Source_Gap = 5;
$temp_39 =  $temp_38 + $sourceButtonHeight + $Top_Source_Gap

Const $source_button_w=150
Const $source_button_h=64
;========== <Source Left Button ==========

$sJPGImage1 = $imagePath & "button_left.png"
$hImage1 = _GDIPlus_ImageLoadFromFile($sJPGImage1)
$hBitmap1 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage1)

$source_left = GUICtrlCreateButton("", $Group_Border+$Group_inBorder, $temp_39, $source_button_w, $source_button_h)
GUICtrlSetTip(-1, "Change to previous source")

; get image W/H dimensions to set imagelist to size of image
$iW1 =   _GDIPlus_ImageGetWidth($hImage1)
$iH1 = _GDIPlus_ImageGetHeight($hImage1)
	
$hImagebtn1 = _GUIImageList_Create($iW1, $iH1, 5, 3)
_GUIImageList_Add($hImagebtn1,$hBitmap1)
_GUICtrlButton_SetImageList($source_left, $hImagebtn1, 4) ; last parameter sets centering of image on button


;========== Source Label ==========
$labelspace=$formWidth-2*$Group_Border-2*$Group_inBorder-2*$source_button_w
$textSize=10;
GUICtrlCreateLabel("Source",$Group_Border+$Group_inBorder+$source_button_w , $temp_39+$source_button_h/2-$textSize, $labelspace, $source_button_h,$SS_CENTER)
;GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
;GUICtrlSetColor(-1, 0xFFFFFF)

;========== Source Right Button ==========
$sJPGImage1 = $imagePath & "button_right.png"
$hImage1 = _GDIPlus_ImageLoadFromFile($sJPGImage1)
$hBitmap1 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage1)

$source_right = GUICtrlCreateButton("", $formWidth-$Group_Border-$Group_inBorder-$source_button_w, $temp_39, $source_button_w, $source_button_h)
GUICtrlSetTip(-1, "Change to next source")

$iW1 =   _GDIPlus_ImageGetWidth($hImage1)
$iH1 = _GDIPlus_ImageGetHeight($hImage1)
	
$hImagebtn1 = _GUIImageList_Create($iW1, $iH1, 5, 3)
_GUIImageList_Add($hImagebtn1,$hBitmap1)
_GUICtrlButton_SetImageList($source_right, $hImagebtn1, 4) ; last parameter sets centering of image on button

;========== source end > ==========

; ...

;========== Volume Left Button ==========
$Top_Source_Gap = 15;
$temp_40 =  $temp_39 + $Top_Source_Gap + $source_button_h;



$sJPGImage1 = $imagePath & "button_left.png"
$hImage1 = _GDIPlus_ImageLoadFromFile($sJPGImage1)
$hBitmap1 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage1)

$volume_left = GUICtrlCreateButton("", $Group_Border+$Group_inBorder, $temp_40, $source_button_w, $source_button_h)
; get image W/H dimensions to set imagelist to size of image
$iW1 =   _GDIPlus_ImageGetWidth($hImage1)
$iH1 = _GDIPlus_ImageGetHeight($hImage1)
$hImagebtn1 = _GUIImageList_Create($iW1, $iH1, 5, 3)
_GUIImageList_Add($hImagebtn1,$hBitmap1)
_GUICtrlButton_SetImageList($volume_left, $hImagebtn1, 4) ; last parameter sets centering of image on button
;========== Volume Label ==========
$labelspace=$formWidth-2*$Group_Border-2*$Group_inBorder-2*$source_button_w
$textSize=10;
GUICtrlCreateLabel("Volume",$Group_Border+$Group_inBorder+$source_button_w , $temp_40+$source_button_h/2-$textSize, $labelspace, $source_button_h,$SS_CENTER)

;========== Volume Right Button ==========
$sJPGImage1 = $imagePath & "button_right.png"
$hImage1 = _GDIPlus_ImageLoadFromFile($sJPGImage1)
$hBitmap1 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage1)

$volume_right = GUICtrlCreateButton("", $formWidth-$Group_Border-$Group_inBorder-$source_button_w, $temp_40, $source_button_w, $source_button_h)
$iW1 =   _GDIPlus_ImageGetWidth($hImage1)
$iH1 = _GDIPlus_ImageGetHeight($hImage1)
$hImagebtn1 = _GUIImageList_Create($iW1, $iH1, 5, 3)
_GUIImageList_Add($hImagebtn1,$hBitmap1)
_GUICtrlButton_SetImageList($volume_right, $hImagebtn1, 4) ; last parameter sets centering of image on button




$Top_Source_Gap = 15;
;$Bottom_button_h = 64;
$Bottom_button_w = $source_button_w/2 - 5;
ConsoleWrite("bottom button w =" & $Bottom_button_w &@CRLF)

$Bottom_button_h = $Bottom_button_w

$temp_41 =  $temp_40 + $Top_Source_Gap + $Bottom_button_h;



$sJPGImage1 = $imagePath & "button_mute.png"
$hImage1 = _GDIPlus_ImageLoadFromFile($sJPGImage1)
$hBitmap1 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage1)
$mute_toggle = GUICtrlCreateButton("", $Group_Border+$Group_inBorder, $temp_41, $Bottom_button_w, $Bottom_button_h)
$iW1 =   _GDIPlus_ImageGetWidth($hImage1)
$iH1 = _GDIPlus_ImageGetHeight($hImage1)
$hImagebtn1 = _GUIImageList_Create($iW1, $iH1, 5, 3)
_GUIImageList_Add($hImagebtn1,$hBitmap1)
_GUICtrlButton_SetImageList($mute_toggle, $hImagebtn1, 4) ; last parameter sets centering of image on button

$mute_active = GUICtrlCreateButton("Mute",   $Group_Border+$Group_inBorder+$Bottom_button_w + 10, $temp_41,$Bottom_button_w,$Bottom_button_h/2)
$mute_inactive=GUICtrlCreateButton("Un-Mute",  $Group_Border+$Group_inBorder+$Bottom_button_w + 10, $temp_41+$Bottom_button_h/2, $source_button_w/2 - 5,$Bottom_button_h/2)

$sJPGImage1 = $imagePath & "button_power.png"
$hImage1 = _GDIPlus_ImageLoadFromFile($sJPGImage1)
$hBitmap1 = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage1)

$power_toggle = GUICtrlCreateButton("", $formWidth-$Group_Border-$Group_inBorder-$Bottom_button_w,$temp_41,$Bottom_button_w,$Bottom_button_h)
$iW1 =   _GDIPlus_ImageGetWidth($hImage1)
$iH1 = _GDIPlus_ImageGetHeight($hImage1)
$hImagebtn1 = _GUIImageList_Create($iW1, $iH1, 5, 3)
_GUIImageList_Add($hImagebtn1,$hBitmap1)
_GUICtrlButton_SetImageList($power_toggle, $hImagebtn1, 4) ; last parameter sets centering of image on button


$power_active = GUICtrlCreateButton("Power On",    $formWidth-$Group_Border-$Group_inBorder-$Bottom_button_w-$source_button_w/2-5,$temp_41,$Bottom_button_w - 5,$Bottom_button_h/2)
$power_inactive=GUICtrlCreateButton("Power Off",   $formWidth-$Group_Border-$Group_inBorder-$Bottom_button_w-$source_button_w/2-5,$temp_41+$Bottom_button_h/2,$Bottom_button_w - 5,$Bottom_button_h/2)


;GUICtrlCreateLabel("Please select zone to control..",$Group_Border+$Group_inBorder,$temp_41+$Bottom_button_h+$Top_Source_Gap,$formWidth-2*$Group_Border-2*$Group_inborder,16)
;GUICtrlSetBkColor(-1, 0x000000)
;GUICtrlSetColor(-1, 0xFFFFFF)
;GUICtrlSetFont(-1, 11, 800, -1, "Courier New")


#cs
Local $extraFeatureButton[$n_feature]
for $i = 0 to $n_feature-1

$extraFeatureButton[$i] =  GUICtrlCreateButton($extraFeature[$i], _
						   $Group_Border+$Group_inBorder + $i*int(($formWidth-2*$Group_Border-2*$Group_inBorder)/$n_feature), _
						   $temp_41+$Bottom_button_h+$Top_Source_Gap/3, _
						   int(($formWidth-2*$Group_Border-2*$Group_inBorder)/$n_feature), _
						   $SourceButtonHeight)
;GUICtrlSetBkColor(-1, 0xFFFFFF)
;GUICtrlSetColor(-1,0x0059bb)
						   
Next
#Ce


GUICtrlCreateGroup("", -99, -99, 1, 1)

Local $zoneselect[$nZone+1];
For $i = 0 to $nZone-1
$zoneselect[$i] = GUICtrlCreateButton("Zone" & $i+1, 0 + $i*int($formWidth/$nZone), 0, int($formWidth/$nZone), $ZoneButtonHeight)
Next

Local $extraFeatureButton[$n_feature]
for $i = 0 to $n_feature-1
$extraFeatureButton[$i] =  GUICtrlCreateButton($extraFeature[$i], _
						   $i*int($formWidth/$n_feature), _
						   $formHeight-$ZoneButtonHeight, _
						  int($formWidth/$n_feature), _
						   $ZoneButtonHeight)
;GUICtrlSetBkColor(-1, 0xFFFFFF)
;GUICtrlSetColor(-1,0x0059bb)
						   
Next




   ; Clean up resources after adding bitmaps to button imagelists
    _GDIPlus_ImageDispose($hImage1)

    _WinAPI_DeleteObject($hBitmap1)


    ; Shut down GDI+ library
    _GDIPlus_ShutDown ()


GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

;--------------------------------------------------------------------------- ACTION START HERE ---------------------------------------------------------------

While 1
   
   if TimerDiff($time_begin) >= $exitTimer*1000*60 then 
	  ConsoleWrite($time_begin & " " & TimerDiff($time_begin)  & @CRLF )
	  alldone();
	  Exit
   EndIf
   
	$nMsg = GUIGetMsg()
	For $i = 0 to $nZone - 1
		 Switch $nMsg
		 Case $zoneselect[$i]
			;Update picture of current zone select
			$currentZone = $i
			;ConsoleWrite("currentZone = " & $currentZone & @CRLF )
			$newFileName = $imagePath & "preview_zone" & $currentZone+1 & ".jpg"
			ConsoleWrite("filename = " & $newFileName & @CRLF )
			GUICtrlSetImage($zoneviewer,$newFileName)
			GUICtrlSetPos($zoneviewer,$Group_Border+$Group_inBorder,$Group_Border+$Group_inBorder+$ZoneButtonHeight, $formWidth-2*$Group_Border-2*$Group_inBorder  , $preview_Height)
			;Update Group Title
			GUICtrlSetData($Group1,"Controlling Zone " & $i+1)
			; refer select zone by $i + 1
			
			
			for $k = 0 to $totalvolume-1
			   GUICtrlSetBkColor($volumeSelect[$k],$VOLCOLOR1)
			Next
		 EndSwitch
	   
    Next
	
	Switch $nMsg
		 case $power_toggle
			ConsoleWrite("power toggle on currentZone = " & $currentZone & @CRLF )
			$com_message="!"&$currentZone+1&"PT+"
			ConsoleWrite($com_message & @CRLF)
			_CommSendstring($com_message & @CR)
			;=========== SEND POWER TOGGLE TO currentZone base 0
		 case $power_active
			ConsoleWrite("power turn ON on currentZone = " & $currentZone & @CRLF )
			$com_message="!"&$currentZone+1&"PR1+"
			ConsoleWrite($com_message & @CRLF)
			_CommSendstring($com_message & @CR)
		 case $power_inactive
			ConsoleWrite("power turn OFF currentZone = " & $currentZone & @CRLF )
			$com_message="!"&$currentZone+1&"PR0+"
			ConsoleWrite($com_message & @CRLF)
			_CommSendstring($com_message & @CR)
		 case $mute_toggle
			ConsoleWrite("mute toggle on currentZone = " & $currentZone & @CRLF )
			$com_message="!"&$currentZone+1&"MT+"
			ConsoleWrite($com_message & @CRLF)
			_CommSendstring($com_message & @CR)
		 case $mute_active
			ConsoleWrite("mute enable on currentZone = " & $currentZone & @CRLF )
			$com_message="!"&$currentZone+1&"MU1+"
			ConsoleWrite($com_message & @CRLF)
			_CommSendstring($com_message & @CR)
		 case $mute_inactive
			ConsoleWrite("mute disable on currentZone = " & $currentZone & @CRLF )
			$com_message="!"&$currentZone+1&"MU0+"
			ConsoleWrite($com_message & @CRLF)
			_CommSendstring($com_message & @CR)
			
		 case $source_left
			ConsoleWrite("previous source" & $currentZone & @CRLF )
			$com_message="!"&$currentZone+1&"SD+"
			ConsoleWrite($com_message & @CRLF)
			_CommSendstring($com_message & @CR)
						
		 case $source_right
			ConsoleWrite("next source" & $currentZone & @CRLF )
			$com_message="!"&$currentZone+1&"SI+"
			ConsoleWrite($com_message & @CRLF)
			_CommSendstring($com_message & @CR)
			
		 case $volume_left
			ConsoleWrite("volume decrease" & $currentZone & @CRLF )
			$com_message="!"&$currentZone+1&"VD+"
			ConsoleWrite($com_message & @CRLF)
			_CommSendstring($com_message & @CR)
			
			
		 case $volume_right
			ConsoleWrite("volume increase" & $currentZone & @CRLF )
			$com_message="!"&$currentZone+1&"VI+"
			ConsoleWrite($com_message & @CRLF)
			_CommSendstring($com_message & @CR)
			
			
		 case $extraFeatureButton[$CONST_ALLOFF]
			ConsoleWrite("all off" & $currentZone & @CRLF )
			$com_message="!"&$currentZone+1&"AO+"
			ConsoleWrite($com_message & @CRLF)
			_CommSendstring($com_message & @CR)
			
		 case $extraFeatureButton[$CONST_ALLON]
			ConsoleWrite("All on" & @CRLF)
			for $j = 0 to $nZone-1
			   $com_message="!"&$j+1&"PR1+"
			   ConsoleWrite($com_message & @CRLF)
			   _CommSendstring($com_message & @CR)
			   sleep(200)
			Next
		 case $extraFeatureButton[$CONST_WHON]
			ConsoleWrite("whole house one" & @CRLF)
			 $com_message="!"&$currentZone+1&"WH1+"
			 ConsoleWrite($com_message & @CRLF)
			_CommSendstring($com_message & @CR)
			

		 case $extraFeatureButton[$CONST_WHOFF]
			ConsoleWrite("whole house off" & @CRLF)
			 $com_message="!"&$currentZone+1&"WH0+"
			 ConsoleWrite($com_message & @CRLF)
			_CommSendstring($com_message & @CR)
			
	EndSwitch
	
	
	
	
   For $i = 0 to $nSource
	     Switch $nMsg
			case $sourceSelect[$i]
			ConsoleWrite("set zone number "& $currentZone & " to source = " & $i & @CRLF)
			$com_message="!"&$currentZone+1&"SS" & $i+1 & "+"
			ConsoleWrite($com_message & @CRLF)
			_CommSendstring($com_message & @CR)
		 EndSwitch
   Next

   



	For $i = 0 to $totalvolume-1
		 Switch $nMsg
		 Case $volumeSelect[$i]
			;msgbox(0,"Event","Volume " & $minVol+$i*$stepVol & "select")
			ConsoleWrite("set volume of zone "& $currentZone+1 & " to " & $minVol+$i*$stepVol & @CRLF)

			for $k = 0 to $totalvolume-1
				  ; set color here
				  if $k <= $i Then
				  GUICtrlSetBkColor($volumeSelect[$k],0x0059bb)
			   Else
				  
				  GUICtrlSetBkColor($volumeSelect[$k],$VOLCOLOR1)
				  EndIf
			Next
		 EndSwitch
    Next
	Switch $nMsg
			
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd


Func AllDone()
   _Commcloseport()
   msgbox(0,"Exiting","COM port now closed",60*5)
   
	  
EndFunc
