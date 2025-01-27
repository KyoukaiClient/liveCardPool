extends Node2D
var cardNode = get_parent().get_parent()
var skillChosenZone = ""
#First Form - Punch
#done for 0.02

func isInSkillRange(myZone, originZone):
	var targetRow = get_parent().rowConvert[myZone.left(1)]
	var targetColumn = int(myZone.right(2))-1
	var myMatrix
	var myOwner = get_parent().get_parent().cardOwnerIndex
	if myOwner == 1:
		myMatrix = get_node(Global.pathStrings["P1Snaps"]).zoneHas
	else:
		myMatrix = get_node(Global.pathStrings["P2Snaps"]).zoneHas
	
	if targetRow-1 >= 0:
		if myMatrix[targetRow-1][targetColumn] != 0:
			return true
	if targetColumn-1 >= 0:
		if myMatrix[targetRow][targetColumn-1] != 0:
			return true
	if targetRow+1 <=4:
		if myMatrix[targetRow+1][targetColumn] != 0:
			return true
	if targetColumn+1 <= 4:
		if myMatrix[targetRow][targetColumn+1] != 0:
			return true
	return false


func costForOpenMe():
	get_parent().chooseATargetAtCost("openedAGate")

func resoForOpenMe(source, targetArray):
	var targetRow
	var targetColumn
	var myOwner
	var entrantZoneID
	var entrantRow
	var entrantColumn
	var damageAmount = 3
	for target in targetArray:
		targetRow = get_parent().rowConvert[target["zoneID"].left(1)]
		targetColumn = int(target["zoneID"].right(2))-1
		myOwner = get_parent().get_parent().cardOwnerIndex
		
		if myOwner == 1:
			entrantZoneID = RulesEngine.currentP1EntrantNode.get_node("Card").inZoneID
		else:
			entrantZoneID = RulesEngine.currentP2EntrantNode.get_node("Card").inZoneID
		entrantRow = get_parent().rowConvert[entrantZoneID.left(1)]
		entrantColumn = int(entrantZoneID.right(2))-1
		if targetRow-1 == entrantRow or targetRow+1 == entrantRow:
			if targetColumn == entrantColumn:
				damageAmount += 6
		elif targetRow == entrantRow:
			if targetColumn-1 == entrantColumn or targetColumn+1 == entrantColumn:
				damageAmount += 6
		await RulesEngine.dealDamageToZone(target["zoneID"], source, damageAmount)
		damageAmount = 3

	get_parent().emitStartNextSequence()
