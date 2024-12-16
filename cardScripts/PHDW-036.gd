extends Node2D
#Pinfencer's Pixtea Prayer
#done for 0.00


func isInSkillRange(myZone, originZone):
	return true


func costForOpenMe():
	get_parent().chooseATargetAtCost("openedAGate")


func resoForOpenMe(source, targetArray):
	var _targetRow
	var _targetColumn
	var _targetedCardNode
	for target in targetArray:
		_targetRow = get_parent().rowConvert[target["zoneID"].left(1)]
		_targetColumn = int(target["zoneID"].right(2))-1
		_targetedCardNode = Global.getCardNodeInZone(target["zoneID"])
		if _targetedCardNode != null:
			_targetedCardNode.get_node("Card/cardScript").myDefense += int(_targetedCardNode.get_node("Card").dataLookup("atk")) - int(_targetedCardNode.get_node("Card").dataLookup("def"))
			_targetedCardNode.get_node("Card/cardScript").myAttack += int(_targetedCardNode.get_node("Card").dataLookup("def")) - int(_targetedCardNode.get_node("Card").dataLookup("atk"))
			_targetedCardNode.get_node("Card").updateInfo()
	get_parent().emitStartNextSequence()
