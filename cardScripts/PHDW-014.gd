extends Node2D
#First Form - Block
#done for 0.02


func isInSkillRange(myZone, originZone):
	return get_parent().isMyGate(myZone, originZone)
	


func costForOpenMe():
	get_parent().chooseATargetAtCost("openedAGate")

func resoForOpenMe(source, targetArray):
	var targetRow
	var targetColumn
	var myOwner
	var entrantZoneID
	var targetedCardNode
	var entrantRow
	var entrantColumn
	var blockAmount = 3
	for target in targetArray:
		targetRow = get_parent().rowConvert[target["zoneID"].left(1)]
		targetColumn = int(target["zoneID"].right(2))-1
		myOwner = get_parent().get_parent().cardOwnerIndex
		targetedCardNode = Global.getCardNodeInZone(target["zoneID"])
		
		if myOwner == 1:
			entrantZoneID = RulesEngine.currentP1EntrantNode.get_node("Card").inZoneID
		else:
			entrantZoneID = RulesEngine.currentP2EntrantNode.get_node("Card").inZoneID
		entrantRow = get_parent().rowConvert[entrantZoneID.left(1)]
		entrantColumn = int(entrantZoneID.right(2))-1
		
		if targetRow-1 == entrantRow or targetRow+1 == entrantRow:
			if targetColumn == entrantColumn:
				blockAmount += 6
		elif targetRow == entrantRow:
			if targetColumn-1 == entrantColumn or targetColumn+1 == entrantColumn:
				blockAmount += 6
			elif targetColumn == entrantColumn:
				blockAmount += 6
		targetedCardNode.get_node("Card/cardScript").myDefense += blockAmount
		targetedCardNode.get_node("Card").updateInfo()
		blockAmount = 3
	get_parent().emitStartNextSequence()
