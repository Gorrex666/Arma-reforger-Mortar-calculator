;;; // CALCULATOR //
#MaxThreadsPerHotkey 2
Process, Priority,, A

; Calculate position for bottom-right corner
SysGet, ScreenWidth, 78
SysGet, ScreenHeight, 79
GuiWidth := 104
GuiHeight := 40
GuiX := ScreenWidth - GuiWidth - 0  ; Adjust relative to edge
GuiY := ScreenHeight - GuiHeight - 110

; Main GUI
Gui, Color, afaca9
Gui, Font, s11, Bold
Gui -sysmenu -caption
Gui, Show, x%GuiX% y%GuiY% w%GuiWidth% h%GuiHeight%, Comp
Gui, Add, DropDownList, vRings gUpdateresult x35 y-10 w33 h110, 4|3|2|1|0
Gui, Add, DropDownList, vShellType gUpdateresult x58 y-10 w33 h110, HE|SMK|FLR
Gui, Add, DropDownList, vMortarType gUpdateresult x81 y-10 w33 h110, M252|2B14
Gui, Color,, afaca9
Gui, Add, Edit, vDistanceInput gUpdateresult x0 y0 w35 h20 center
Gui, Color,, afaca9
Gui, Add, Edit, vMultiplierInput gUpdateresult x0 y20 w35 h20 center
Gui, Font, s20, Bold
Gui, Add, Text, vTotalResult x36 y11 w130 h30

; Piecewise data for 1st calculation (distance in mils)
piecewiseData := {}

;M252_HE
piecewiseData["M252_HE_0"] := { "distances": [50, 100, 150, 200, 250, 300, 350, 400], "mils": [1540, 1479, 1416, 1350, 1279, 1201, 1106, 955]},
piecewiseData["M252_HE_1"] := { "distances": [100, 200, 300, 400, 500, 600, 700, 800, 900], "mils": [1547, 1492, 1437, 1378, 1317, 1249, 1174, 1085, 954]},
piecewiseData["M252_HE_2"] := { "distances": [200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600], "mils": [1538, 1507, 1475, 1443, 1410, 1376, 1341, 1305, 1266, 1225, 1180, 1132, 1076, 1009, 912]},
piecewiseData["M252_HE_3"] := { "distances": [300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300], "mils": [1534, 1511, 1489, 1466, 1442, 1419, 1395, 1370, 1344, 1318, 1291, 1263, 1233, 1202, 1169, 1133, 1094, 1051, 999, 931, 801]},
piecewiseData["M252_HE_4"] := { "distances": [400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300, 2400, 2500, 2600, 2700, 2800, 2900], "mils": [1531, 1514, 1496, 1478, 1460, 1442, 1424, 1405, 1385, 1366, 1346, 1326, 1305, 1283, 1261, 1238, 1214, 1188, 1162, 1134, 1104, 1070, 1034, 993, 942, 870]},

;M252_SMK
piecewiseData["M252_SMK_1"] := { "distances": [200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750], "mils": [1463, 1427, 1391, 1352, 1314, 1271, 1227, 1178, 1124, 1060, 982, 882]},
piecewiseData["M252_SMK_2"] := { "distances": [200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400], "mils": [1528, 1491, 1453, 1414, 1374, 1333, 1289, 1242, 1191, 1133, 1067, 980, 818]},
piecewiseData["M252_SMK_3"] := { "distances": [300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900], "mils": [1522, 1495, 1468, 1440, 1412, 1383, 1354, 1323, 1291, 1257, 1221, 1183, 1142, 1096, 1044, 980, 892]},
piecewiseData["M252_SMK_4"] := { "distances": [400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300, 2400], "mils": [1517, 1495, 1474, 1452, 1429, 1407, 1383, 1360, 1335, 1310, 1284, 1257, 1228, 1199, 1166, 1132, 1096, 1055, 1008, 952, 871]},

;M252_FLR
piecewiseData["M252_FLR_1"] := { "distances": [200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750], "mils": [1463, 1428, 1391, 1352, 1312, 1269, 1224, 1175, 1120, 1055, 974, 823]},
piecewiseData["M252_FLR_2"] := { "distances": [200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400], "mils": [1529, 1493, 1457, 1419, 1379, 1338, 1295, 1249, 1199, 1144, 1081, 1005, 900]},
piecewiseData["M252_FLR_3"] := { "distances": [300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900], "mils": [1521, 1494, 1466, 1438, 1409, 1380, 1349, 1317, 1284, 1240, 1212, 1172, 1128, 1081, 1027, 962, 875]},
piecewiseData["M252_FLR_4"] := { "distances": [400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300, 2400], "mils": [1515, 1493, 1471, 1448, 1426, 1402, 1378, 1353, 1328, 1301, 1274, 1245, 1215, 1184, 1151, 1115, 1076, 1033, 985, 928, 855]},
 
;2B14_HE
piecewiseData["2B14_HE_0"] := { "distances": [50, 100, 150, 200, 250, 300, 350, 400, 450, 500], "mils": [1455, 1411, 1365, 1318, 1268, 1217, 1159, 1095, 1023, 922]},
piecewiseData["2B14_HE_1"] := { "distances": [100, 200, 300, 400, 500, 600, 700, 800], "mils": [1446, 1392, 1335, 1275, 1212, 1141, 1058, 952]},
piecewiseData["2B14_HE_2"] := { "distances": [200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400], "mils": [1432, 1397, 1362, 1325, 1288, 1248, 1207, 1162, 1114, 1060, 997, 914, 755]},
piecewiseData["2B14_HE_3"] := { "distances": [300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800], "mils": [1423, 1397, 1370, 1343, 1315, 1286, 1257, 1226, 1193, 1159, 1123, 1084, 1040, 991, 932, 851]},
piecewiseData["2B14_HE_4"] := { "distances": [400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300], "mils": [1418, 1398, 1376, 1355, 1333, 1311, 1288, 1264, 1240, 1215, 1189, 1161, 1133, 1102, 1069, 1034, 995, 950, 896, 820]},
 
;2B14_SMK
piecewiseData["2B14_SMK_1"] := { "distances": [50, 100, 150, 200, 250, 300, 350, 400, 450], "mils": [1450, 1399, 1347, 1292, 1235, 1172, 1102, 1020, 898]},
piecewiseData["2B14_SMK_2"] := { "distances": [200, 300, 400, 500, 600, 700, 800], "mils": [1381, 1319, 1252, 1179, 1097, 993, 805]},
piecewiseData["2B14_SMK_3"] := { "distances": [300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200], "mils": [1387, 1348, 1308, 1266, 1222, 1175, 1123, 1065, 994, 902]},
piecewiseData["2B14_SMK_4"] := { "distances": [400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700], "mils": [1387, 1357, 1327, 1286, 1264, 1231, 1196, 1159, 1119, 1075, 1026, 969, 896, 753]},
 
;2B14_FLR
piecewiseData["2B14_FLR_1"] := { "distances": [100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600], "mils": [1421, 1381, 1339, 1296, 1251, 1203, 1151, 1093, 1028, 945, 799]},
piecewiseData["2B14_FLR_2"] := { "distances": [200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100], "mils": [1417, 1374, 1330, 1284, 1234, 1182, 1124, 1057, 979, 870]},
piecewiseData["2B14_FLR_3"] := { "distances": [300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600], "mils": [1411, 1380, 1348, 1315, 1281, 1246, 1209, 1170, 1128, 1082, 1031, 973, 903, 807]},
piecewiseData["2B14_FLR_4"] := { "distances": [400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200], "mils": [1411, 1388, 1364, 1341, 1316, 1291, 1265, 1238, 1210, 1181, 1150, 1119, 1085, 1048, 1009, 965, 917, 860, 787]},
 
; Data table for 2nd calculation (elevation difference in mils)
newCalculationData := {}

;M252_HE
newCalculationData["M252_HE_0"] := { "distances": [50, 100, 150, 200, 250, 300, 350, 400], "multipliers": [61, 63, 66, 71, 78, 95, 151, 0]},
newCalculationData["M252_HE_1"] := { "distances": [100, 200, 300, 400, 500, 600, 700, 800, 900], "multipliers": [28, 27, 29, 31, 33, 35, 42, 57, 148]},
newCalculationData["M252_HE_2"] := { "distances": [200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600], "multipliers": [15, 16, 16, 16, 16, 17, 18, 20, 20, 22, 23, 27, 31, 43, 109]},
newCalculationData["M252_HE_3"] := { "distances": [300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300], "multipliers": [12, 11, 12, 12, 12, 12, 13, 13, 13, 13, 14, 15, 7, 16, 17, 19, 21, 26, 31, 46, 0]},
newCalculationData["M252_HE_4"] := { "distances": [400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300, 2400, 2500, 2600, 2700, 2800, 2900], "multipliers": [9, 9, 9, 9, 9, 9, 10, 10, 9, 10, 10, 11, 11, 11, 11, 12, 12, 13, 14, 15, 17, 17, 20, 25, 31, 64]},
 
;M252_SMK
newCalculationData["M252_SMK_1"] := { "distances": [200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750], "multipliers": [36, 36, 39, 38, 43, 44, 49, 54, 64, 78, 160, 0]},
newCalculationData["M252_SMK_2"] := { "distances": [200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400], "multipliers": [19, 19, 19, 19, 20, 22, 23, 25, 28, 31, 39, 58, 0]},
newCalculationData["M252_SMK_3"] := { "distances": [300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900], "multipliers": [14, 14, 14, 14, 14, 14, 16, 16, 17, 18, 18, 20, 23, 25, 30, 38, 84]},
newCalculationData["M252_SMK_4"] := { "distances": [400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300, 2400], "multipliers": [11, 10, 11, 11, 11, 12, 11, 12, 12, 13, 14, 14, 15, 17, 16, 18, 21, 23, 28, 36, 67]},
 
;M252_FLR
newCalculationData["M252_FLR_1"] := { "distances": [200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750], "multipliers": [35, 37, 39, 40, 43, 45, 49, 55, 65, 81, 151, 0]},
newCalculationData["M252_FLR_2"] := { "distances": [200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400], "multipliers": [17, 18, 19, 19, 20, 21, 23, 25, 27, 30, 335, 47, 98]},
newCalculationData["M252_FLR_3"] := { "distances": [300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900], "multipliers": [14, 14, 14, 14, 14, 16, 16, 16, 18, 19, 20, 21, 22, 26, 30, 39, 67]},
newCalculationData["M252_FLR_4"] := { "distances": [400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300, 2400], "multipliers": [11, 11, 11, 11, 12, 12, 12, 133, 13, 14, 14, 15, 15, 17, 18, 19, 21, 23, 27, 33, 52]},
  
;2B14_HE
newCalculationData["2B14_HE_0"] := { "distances": [50, 100, 150, 200, 250, 300, 350, 400, 450, 500], "multipliers": [23, 18, 15, 10, 6, 3, 12, 24, 57, 0]},
newCalculationData["2B14_HE_1"] := { "distances": [100, 200, 300, 400, 500, 600, 700, 800], "multipliers": [40, 36, 32, 28, 20, 12, 1, 40]},
newCalculationData["2B14_HE_2"] := { "distances": [200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400], "multipliers": [49, 48, 45, 43, 40, 38, 34, 31, 25, 19, 8, 15, 0]},
newCalculationData["2B14_HE_3"] := { "distances": [300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800], "multipliers": [54, 52, 51, 49, 47, 46, 43, 41, 39, 36, 33, 29, 24, 17, 6, 31]},
newCalculationData["2B14_HE_4"] := { "distances": [400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300], "multipliers": [57, 55, 54, 52, 51, 50, 48, 47, 45, 43, 42, 40, 337, 35, 33, 29, 24, 18, 6, 29]},

;2B14_SMK
newCalculationData["2B14_SMK_1"] := { "distances": [50, 100, 150, 200, 250, 300, 350, 400, 450], "multipliers": [51, 52, 55, 57, 63, 70, 82, 122, 0]},
newCalculationData["2B14_SMK_2"] := { "distances": [200, 300, 400, 500, 600, 700, 800], "multipliers": [31, 33, 34, 38, 57, 67, 0]},
newCalculationData["2B14_SMK_3"] := { "distances": [300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200], "multipliers": [18, 20, 21, 22, 24, 26. 28, 32, 40, 64]},
newCalculationData["2B14_SMK_4"] := { "distances": [400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700], "multipliers": [15, 15, 15, 16, 16, 17, 18, 20, 22, 24, 27, 33, 50, 0]},
  
;2B14_FLR
newCalculationData["2B14_FLR_1"] := { "distances": [100, 150, 200, 250, 300, 350, 400, 450, 500, 550, 600], "multipliers": [40, 42, 43, 45, 48, 52, 58, 65, 83, 146, 0]},
newCalculationData["2B14_FLR_2"] := { "distances": [200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100], "multipliers": [21, 22, 23, 24, 25, 29, 32, 36, 48, 89]},
newCalculationData["2B14_FLR_3"] := { "distances": [300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600], "multipliers": [16, 16, 16, 16, 17, 18, 19, 21, 23, 25, 28, 33, 43, 0]},
newCalculationData["2B14_FLR_4"] := { "distances": [400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2100, 2200], "multipliers": [12, 12, 11, 13, 13, 13, 13, 14, 14, 15, 15, 17, 18, 19, 21, 23, 27, 34, 0]},
 
 
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

    ; Calculate altitude difference in mils
        newCalcResult := (mils * MultiplierInput) / 100  ; New calculation using newCalculationData

   ; Calculate the total result
        totalResult := round(result + newCalcResult)

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
    } 
}

;//HOTKEYS
end::Reload
~up::WinSet, AlwaysOnTop, Toggle, Comp
~f12::ExitApp
~`:: ; Trigger on the backtick key
WinActivate, Comp ; Activate the "Comp" window
GuiControl, Focus, DistanceInput
SendInput ^a{Backspace} ; Select all text and delete it
