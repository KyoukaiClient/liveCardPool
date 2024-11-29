extends Node2D
var cardNode = get_parent().get_parent()
var skillChosenZone = ""
#First Form - Punch

func isInSpecialSkillRange(myZone, originZone):
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
	var snapZoneNode
	snapZoneNode = get_node(Global.pathStrings["cursorMouseCatch"]+"/"+get_parent().get_parent().inZoneID)
	RulesEngine.toggleZoneMarkers(true, snapZoneNode, get_parent().get_parent(), RulesEngine.MARKERTYPES.OPENCOST)
	RulesEngine.requestSpSkillChoice(get_parent().get_parent())
	
	await RulesEngine.spSkillChoiceReceived
	RulesEngine.addTargetedGate(RulesEngine.spSkillChoiceZoneID, get_parent().get_parent())
	RulesEngine.spSkillChoiceZoneID = ""
	RulesEngine.rangePurpose = RulesEngine.RANGETYPE.BLANK
	RulesEngine.selRangePurpose = RulesEngine.RANGETYPE.BLANK
	RulesEngine.selRangeSource = ""
	RulesEngine.selRangeSourceScript = null
	RulesEngine.waitingToSpSkillNode = null
	RulesEngine.requestResponse(get_parent().get_parent(), "openedAGate")
	await get_tree().create_timer(.1).timeout
	RulesEngine.waitingForSpSkillChoice = false
	RulesEngine.spSkillModeFocused = false

func resoForOpenMe(source, targetArray):
	var targetRow
	var targetColumn
	var myMatrix
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
			myMatrix = get_node(Global.pathStrings["P1Snaps"]).zoneHas
			entrantZoneID = RulesEngine.currentP1EntrantNode.get_node("Card").inZoneID
		else:
			myMatrix = get_node(Global.pathStrings["P2Snaps"]).zoneHas
			entrantZoneID = RulesEngine.currentP2EntrantNode.get_node("Card").inZoneID
		entrantRow = get_parent().rowConvert[entrantZoneID.left(1)]
		entrantColumn = int(entrantZoneID.right(2))-1
		
		
		if targetRow-1 == entrantRow or targetRow+1 == entrantRow:
			if targetColumn == entrantColumn:
				damageAmount += 6
		elif targetRow == entrantRow:
			if targetColumn-1 == entrantColumn or targetColumn+1 == entrantColumn:
				damageAmount += 6
		RulesEngine.dealDamageToZone(target["zoneID"], source, damageAmount)

	get_parent().emitStartNextSequence()
