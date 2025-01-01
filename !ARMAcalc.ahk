;;; // CALCULATOR //
#MaxThreadsPerHotkey 2
Process, Priority,, A


; Calculate position for bottom-right corner
SysGet, ScreenWidth, 78
SysGet, ScreenHeight, 79
GuiWidth := 136
GuiHeight := 80
GuiX := ScreenWidth - GuiWidth - 0  ; Adjust relative to edge
GuiY := ScreenHeight - GuiHeight - 110

; Main GUI
Gui, Color, afaca9
Gui, Font, s11, Bold
Gui -sysmenu -caption
Gui, Show, x%GuiX% y%GuiY% w%GuiWidth% h%GuiHeight%, Comp
Gui, Add, DropDownList, vMortarType gUpdateresult x45 y0 w39 h110, M252|2B14
Gui, Add, DropDownList, vShellType gUpdateresult x75 y0 w39 h110, HE|SMK|FLR
Gui, Add, DropDownList, vRings gUpdateresult x105 y0 w39 h110, 0|1|2|3|4
Gui, Add, Edit, vDistanceInput gUpdateresult x6 y0 w35 h20 center
;Gui, Add, Text, vResultText x0 y80 w266 h26 center
;Gui, Add, Text, vMilsResult x0 y100 w266 h26 center

; Additional input for the new calculation
Gui, Add, Edit, vMultiplierInput gUpdateresult x6 y30 w35 h20 center
;Gui, Add, Text, vNewCalcResult x0 y180 w266 h26 center
Gui, Font, s24, Bold
Gui, Add, Text, vTotalResult x0 y48 w136 h30 center

WinActivate, Hell Let Loose

; Piecewise data for original calculation
piecewiseData := {}
piecewiseData["M252_HE_0"] := { "distances": [50, 100, 150, 200, 250, 300, 350, 400], "mils": [1540, 1479, 1416, 1350, 1279, 1201, 1106, 955]},
piecewiseData["M252_HE_1"] := { "distances": [100, 200, 300, 400, 500, 600, 700, 800, 900], "mils": [1547, 1492, 1437, 1378, 1317, 1249, 1174, 1085, 954]},
piecewiseData["M252_HE_2"] := { "distances": [200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600], "mils": [1538, 1507, 1475, 1443, 1410, 1376, 1341, 1305, 1266, 1225, 1180, 1132, 1076, 1009, 912]},
piecewiseData["M252_HE_3"] := { "distances": [300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300], "mils": [1534, 1511, 1489, 1466, 1442, 1419, 1395, 1370, 1344, 1318, 1291, 1263, 1233, 1202, 1169, 1133, 1094, 1051, 999, 931, 801]},
piecewiseData["M252_HE_4"] := { "distances": [400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300, 2400, 2500, 2600, 2700, 2800, 2900], "mils": [1531, 1514, 1496, 1478, 1460, 1442, 1424, 1405, 1385, 1366, 1346, 1326, 1305, 1283, 1261, 1238, 1214, 1188, 1162, 1134, 1104, 1070, 1034, 993, 942, 870]},
 


; New data table for the new calculation (e.g., elevation difference calculations)
newCalculationData := {}
newCalculationData["M252_HE_0"] := { "distances": [50, 100, 150, 200, 250, 300, 350, 400], "multipliers": [61, 63, 66, 71, 78, 95, 151, 0]},
newCalculationData["M252_HE_1"] := { "distances": [100, 200, 300, 400, 500, 600, 700, 800, 900], "multipliers": [28, 27, 29, 31, 33, 35, 42, 57, 148]},
newCalculationData["M252_HE_2"] := { "distances": [200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600], "multipliers": [15, 16, 16, 16, 16, 17, 18, 20, 20, 22, 23, 27, 31, 43, 109]},
newCalculationData["M252_HE_3"] := { "distances": [300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300], "multipliers": [12, 11, 12, 12, 12, 12, 13, 13, 13, 13, 14, 15, 7, 16, 17, 19, 21, 26, 31, 46, 0]},
newCalculationData["M252_HE_4"] := { "distances": [400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300, 2400, 2500, 2600, 2700, 2800, 2900], "multipliers": [9, 9, 9, 9, 9, 9, 10, 10, 9, 10, 10, 11, 11, 11, 11, 12, 12, 13, 14, 15, 17, 17, 20, 25, 31, 64]},
 


; Update result based on selections
Updateresult:
    Gui, Submit, NoHide
    ; Get inputs using GuiControlGet for dropdown lists and Edit field
    GuiControlGet, mortarType, , MortarType
    GuiControlGet, shellType, , ShellType
    GuiControlGet, rings, , Rings
    GuiControlGet, distance, , DistanceInput
    GuiControlGet, multiplier, , MultiplierInput

    key := mortarType "_" shellType "_" rings
    result := calculate(distance, key) ; Original calculation (using piecewiseData)
    mils := calculateMilsFromTable(distance, key) ; Mils calculation using newCalculationData

    ; Perform the new calculation using the new table
    if (mils != "Out of Range" && mils != "") {
        newCalcResult := (mils * MultiplierInput) / 100  ; New calculation using newCalculationData
    } else {
        newCalcResult := ""
    }

    ; Calculate the total result
    if (result != "" && newCalcResult != "") {
        totalResult := round(result + newCalcResult)
    } else {
        totalResult := ""
    }

    ; Update the GUI
    GuiControl,, ResultText, % (result != "") ? result : ""
    GuiControl,, MilsResult, % (mils != "") ? "Mi: " mils : ""
    GuiControl,, NewCalcResult, % (newCalcResult != "") ? "elev diff: " newCalcResult : ""
    GuiControl,, TotalResult, % (totalResult != "") ? "" totalResult : ""
return

; Calculation function for original Mils
calculate(x, key) {
    global piecewiseData

    data := piecewiseData[key]
    distances := data["distances"]
    mils := data["mils"]

    ; Perform linear interpolation
    for index, value in distances {
        if (x < value) {
            lowerIndex := index - 1
            upperIndex := index
            break
        }
    }

    if (x >= distances[1] && x <= distances[distances.MaxIndex()]) {
        lowerDistance := distances[lowerIndex]
        upperDistance := distances[upperIndex]
        lowerMils := mils[lowerIndex]
        upperMils := mils[upperIndex]

        result := lowerMils + ((x - lowerDistance) / (upperDistance - lowerDistance)) * (upperMils - lowerMils)
        return Round(result)
    } else {
        return "Out of Range"
    }
}

; New Calculation: Multiplier based on the new table
calculateNewMultiplier(distance, key, multiplier) {
    global newCalculationData

    data := newCalculationData[key]
    distances := data["distances"]
    multipliers := data["multipliers"]

    ; Perform linear interpolation for multiplier
    for index, value in distances {
        if (distance < value) {
            lowerIndex := index - 1
            upperIndex := index
            break
        }
    }

    if (distance >= distances[1] && distance <= distances[distances.MaxIndex()]) {
        lowerDistance := distances[lowerIndex]
        upperDistance := distances[upperIndex]
        lowerMultiplier := multipliers[lowerIndex]
        upperMultiplier := multipliers[upperIndex]

        interpolatedMultiplier := lowerMultiplier + ((distance - lowerDistance) / (upperDistance - lowerDistance)) * (upperMultiplier - lowerMultiplier)
        return Round(interpolatedMultiplier * multiplier) ; Apply the multiplier to the result
    } else {
        return "Out of Range"
    }
}

; Calculation function for mils (corrected to use newCalculationData)
calculateMilsFromTable(distance, key) {
    global newCalculationData

    data := newCalculationData[key]
    distances := data["distances"]
    multipliers := data["multipliers"]

    ; Perform linear interpolation for mils
    for index, value in distances {
        if (distance < value) {
            lowerIndex := index - 1
            upperIndex := index
            break
        }
    }

    if (distance >= distances[1] && distance <= distances[distances.MaxIndex()]) {
        lowerDistance := distances[lowerIndex]
        upperDistance := distances[upperIndex]
        lowerMultiplier := multipliers[lowerIndex]
        upperMultiplier := multipliers[upperIndex]

        interpolatedMils := lowerMultiplier + ((distance - lowerDistance) / (upperDistance - lowerDistance)) * (upperMultiplier - lowerMultiplier)
        return Round(interpolatedMils)
    } else {
        return "Out of Range"
    }
}




;HOTKEYS
end::Reload ;Recarga el script
~up::WinSet, AlwaysOnTop, Toggle, Comp
~`:: ; Trigger on the backtick key
WinActivate, Comp ; Activate the "Comp" window
GuiControl, Focus, DistanceInput
SendInput ^a{Backspace} ; Select all text and delete it