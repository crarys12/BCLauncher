; Author: Shawn Crary
;
; Purpose: enable cleaning of the Compare and Search history written to the BCState.xml file.
;
; Install: Once compiled, the launcher is to be placed in the Beyond Compare install directory
;          and the launcher should be run instead of the BCompare.exe henceforth.

#include <File.au3>
$file = "BCState.xml"

RunWait("BCompare.exe")
Sleep(1000)

$array = FileReadToArray($file)

If Not (@error) Then
	$arrLen = UBound($array) - 1

	For $i = 0 To $arrLen
		If StringInStr($array[$i], "<FindItems>") Then
			Do
				$i += 1
				$array[$i] = cleanMruLine($array[$i])
			Until StringInStr($array[$i], "</FindItems>")
		Else
			$array[$i] = cleanPathLine($array[$i])
		EndIf
	Next

	_FileWriteFromArray($file, $array)
EndIf

Func cleanPathLine($line)
	If isPathLine($line) Then
		$line = cleanMruLine($line)
	EndIf
	Return $line
EndFunc   ;==>cleanPathLine

Func isPathLine($line)
	$returnValue = False
	If (StringInStr($line, ":\")) Or ((StringInStr($line, "Value=")) And (StringInStr($line, ':"/>'))) Then
		$returnValue = True
	EndIf
	Return $returnValue
EndFunc   ;==>isPathLine

Func cleanMruLine($line)
	$posValue = StringInStr($line, "Value")
	If $posValue > 0 Then
		$line = StringLeft($line, $posValue - 2) & "/>"
	EndIf
	Return $line
EndFunc   ;==>cleanMruLine
