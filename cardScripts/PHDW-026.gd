extends Node2D
#Feng, Emerging Flame

func canIOpenHere(myZone):
	var myRow = Global.rowConvert[myZone.left(1)]
	var myColumn = int(myZone.right(2))-1
	var myOwner = get_parent().get_parent().cardOwnerIndex
	var snapMatrix1 = get_node(Global.pathStrings["P1Snaps"]).zoneHas
	var snapMatrix2 = get_node(Global.pathStrings["P2Snaps"]).zoneHas
	var myMatrix
	if myOwner == 1:
		myMatrix = snapMatrix1
	else:
		myMatrix = snapMatrix2
	
	var myBorderingCount = 0
	var myBorderingReady = 0
	
	if snapMatrix1[myRow][myColumn] != 0 or snapMatrix2[myRow][myColumn] != 0:
		return false
	if myRow-1 >= 0:
		if myMatrix[myRow-1][myColumn] != 0:
			myBorderingCount += 1
			if get_node("/root/Main/playField/Field/CardP" + str(myOwner) + " - " + str(myMatrix[myRow-1][myColumn])).get_node("Card").cardReady:
				myBorderingReady += 1
	if myColumn-1 >= 0:
		if myMatrix[myRow][myColumn-1] != 0:
			myBorderingCount += 1
			if get_node("/root/Main/playField/Field/CardP" + str(myOwner) + " - " + str(myMatrix[myRow][myColumn-1])).get_node("Card").cardReady:
				myBorderingReady += 1
	if myRow+1 <=4:
		if myMatrix[myRow+1][myColumn] != 0:
			myBorderingCount += 1
			if get_node("/root/Main/playField/Field/CardP" + str(myOwner) + " - " + str(myMatrix[myRow+1][myColumn])).get_node("Card").cardReady:
				myBorderingReady += 1
	if myColumn+1 <= 4:
		if myMatrix[myRow][myColumn+1] != 0:
			myBorderingCount += 1
			if get_node("/root/Main/playField/Field/CardP" + str(myOwner) + " - " + str(myMatrix[myRow][myColumn+1])).get_node("Card").cardReady:
				myBorderingReady += 1
	
	if myBorderingCount >= 3:
		if myBorderingReady >= 1:
			return true
		else:
			return false
	else:
		return false

func resoForOpenMe(source, targetArray):
	get_parent().get_parent().readyMe()
	var _snapZoneNode
	_snapZoneNode = get_node(Global.pathStrings["cursorMouseCatch"]+"/"+get_parent().get_parent().inZoneID)
	get_parent().emitStartNextSequence()
