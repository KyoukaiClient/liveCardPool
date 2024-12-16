extends Node2D
#Wanderer's Will
#done for 0.00

func isInSkillRange(myZone, originZone):
	var checkNode = Global.getCardNodeInZone(myZone)
	if checkNode != null:
		if Structure.isItMyTurn:
			if checkNode.get_node("Card").cardOwnerIndex == 1:
				if checkNode.get_node("Card/cardScript").timesMovedByEffectThisTurn > 1:
					if not checkNode.get_node("Card").cardReady:
						return true
		else:
			if checkNode.get_node("Card").cardOwnerIndex == 2:
				if checkNode.get_node("Card/cardScript").timesMovedByEffectThisTurn > 1:
					if not checkNode.get_node("Card").cardReady:
						return true
	return false

func resoForOpenMe(source = null, targetArray = []):
	RulesEngine.requestSkillChoice(get_parent().get_parent())
	
	await RulesEngine.skillChoiceReceived
	if RulesEngine.skillChoiceZoneID != "FIZZLE":
		var chosenNode = Global.getCardNodeInZone(RulesEngine.skillChoiceZoneID)
		chosenNode.get_node("Card").readyMe()
	RulesEngine.skillChoiceZoneID = ""
	RulesEngine.skillModeFocused = false
	RulesEngine.waitingForSkillChoice = false
	RulesEngine.rangePurpose = RulesEngine.RANGETYPE.BLANK
	RulesEngine.selRangePurpose = RulesEngine.RANGETYPE.BLANK
	RulesEngine.selRangeSource = ""
	RulesEngine.selRangeSourceScript = null
	RulesEngine.waitingToSkillNode = null
	get_parent().emitStartNextSequence()
