extends Node2D
#Into The Gate
#done for 0.00

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
	var myBorderingEmpty = 0
	if snapMatrix1[myRow][myColumn] != 0 or snapMatrix2[myRow][myColumn] != 0:
		return false
	if myRow-1 >= 0:
		if myMatrix[myRow-1][myColumn] != 0:
			myBorderingCount += 1
			if get_node("/root/Main/playField/Field/CardP" + str(myOwner) + " - " + str(myMatrix[myRow-1][myColumn])).get_node("Card").cardReady:
				myBorderingReady += 1
		else:
			myBorderingEmpty += 1
	if myColumn-1 >= 0:
		if myMatrix[myRow][myColumn-1] != 0:
			myBorderingCount += 1
			if get_node("/root/Main/playField/Field/CardP" + str(myOwner) + " - " + str(myMatrix[myRow][myColumn-1])).get_node("Card").cardReady:
				myBorderingReady += 1
		else:
			myBorderingEmpty += 1
	if myRow+1 <=4:
		if myMatrix[myRow+1][myColumn] != 0:
			myBorderingCount += 1
			if get_node("/root/Main/playField/Field/CardP" + str(myOwner) + " - " + str(myMatrix[myRow+1][myColumn])).get_node("Card").cardReady:
				myBorderingReady += 1
		else:
			myBorderingEmpty += 1
	if myColumn+1 <= 4:
		if myMatrix[myRow][myColumn+1] != 0:
			myBorderingCount += 1
			if get_node("/root/Main/playField/Field/CardP" + str(myOwner) + " - " + str(myMatrix[myRow][myColumn+1])).get_node("Card").cardReady:
				myBorderingReady += 1
		else:
			myBorderingEmpty += 1
	if myBorderingCount >= 2:
		if myBorderingReady >= 1 and myBorderingEmpty >= 1:
			return true
		else:
			return false
	else:
		return false


func isInSkillRange(myZone, originZone):
	return get_parent().isEmptyBorderingZone(myZone, originZone)


func costForOpenMe():
	get_parent().chooseATargetAtCost("openedAGate")


func isInSpecialSkillRange(myZone, originZone):
	var targetRow = get_parent().rowConvert[myZone.left(1)]
	var targetColumn = int(myZone.right(2))-1
	var myRow = get_parent().rowConvert[originZone.left(1)]
	var myColumn = int(originZone.right(2))-1
	var myMatrix
	var myOwner = get_parent().get_parent().cardOwnerIndex
	if myOwner == 1:
		myMatrix = get_node(Global.pathStrings["P1Snaps"]).zoneHas
	else:
		myMatrix = get_node(Global.pathStrings["P2Snaps"]).zoneHas
	
	if myMatrix[targetRow][targetColumn] != 0:
		if myRow == targetRow:
			if myColumn == targetColumn:
				return false
			elif myColumn - targetColumn == 1 or targetColumn - myColumn == 1:
				return false
		elif myColumn == targetColumn:
			if myRow - targetRow == 1 or targetRow - myRow == 1:
				return false
		return true
	return false


func resoForOpenMe(source,targetArray):
	for target in targetArray:
		if target["contents"] == null:
			RulesEngine.requestSpSkillChoice(get_parent().get_parent())
			
			await RulesEngine.spSkillChoiceReceived
	
			if RulesEngine.spSkillChoiceZoneID != "FIZZLE":
				Global.getCardNodeInZone(RulesEngine.spSkillChoiceZoneID).get_node("Card").moveMeFromZoneToZone(target["zoneID"])
	
	get_parent().emitStartNextSequence()
