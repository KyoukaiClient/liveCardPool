extends Node2D
#Cloudfaring Dragon
#done for 0.02

func canIUseASkill():
	return true

func canIPayMyOpenCost():
	var playerDiscard
	var checkCardsNode
	var discardShatterableCount = []
	var sameNameHit = false
	
	if Global.whichPlayerAmI == 1:
		playerDiscard = GameManager.P1CurrentDiscard
		checkCardsNode = get_node(Global.pathStrings["pileList1/SearchBG"])
	elif Global.whichPlayerAmI == 2:
		playerDiscard = GameManager.P2CurrentDiscard
		checkCardsNode = get_node(Global.pathStrings["pileList2/SearchBG"])
	if playerDiscard.size() >= 3:
		for card in playerDiscard:
			if checkCardsNode.get_node("CardP" + str(Global.whichPlayerAmI) + " - " + str(card) + "/Card/cardScript").canIBeShattered():
				if discardShatterableCount.size() > 0:
					sameNameHit = false
					for cardname in discardShatterableCount:
						if cardname == checkCardsNode.get_node("CardP" + str(Global.whichPlayerAmI) + " - " + str(card) + "/Card").dataLookup("name"):
							sameNameHit = true
					if sameNameHit == false:
						discardShatterableCount.append(checkCardsNode.get_node("CardP" + str(Global.whichPlayerAmI) + " - " + str(card) + "/Card").dataLookup("name"))
				else:
					discardShatterableCount.append(checkCardsNode.get_node("CardP" + str(Global.whichPlayerAmI) + " - " + str(card) + "/Card").dataLookup("name"))
		if discardShatterableCount.size() >= 3:
			return true
		else:
			return false

func costForOpenMe():
	RulesEngine.requestPileChoice(get_parent(), RulesEngine.PILES.DISCARD,1,3,3,"noDupe", "Choose [3] differently named [gate] to Shatter:", RulesEngine.DESTINATIONS.SHATTER)
		
	await RulesEngine.pileChoiceReceived
	RulesEngine.requestResponse(get_parent().get_parent(), "openedAGate")

func resoForOpenMe(source, targetArray):
	get_parent().get_parent().readyMe()
	get_parent().emitStartNextSequence()


func isInSkillRange(myZone, originZone):
	var originRow = get_parent().rowConvert[originZone.left(1)]
	var originColumn = int(originZone.right(2))-1
	var targetRow = get_parent().rowConvert[myZone.left(1)]
	var targetColumn = int(myZone.right(2))-1
	var pathLength = get_node("/root/Main").pathGrid.get_id_path(Vector2i(originRow,originColumn),Vector2i(targetRow,targetColumn)).size()-1
	if (pathLength) == 1 or pathLength == 0:
		return true
	else:
		return false


func isInSpecialSkillRange(myZone, originZone):
	var originRow = get_parent().rowConvert[originZone.left(1)]
	var originColumn = int(originZone.right(2))-1
	var targetRow = get_parent().rowConvert[myZone.left(1)]
	var targetColumn = int(myZone.right(2))-1
	var targetSolid = get_node("/root/Main").pathGrid.is_point_solid(Vector2i(targetRow,targetColumn))
	var targetCardNode = Global.getCardNodeInZone(myZone)
	if targetSolid == true:
		get_node("/root/Main").pathGrid.set_point_solid(Vector2i(targetRow,targetColumn),false)
	var pathLength = get_node("/root/Main").pathGrid.get_id_path(Vector2i(originRow,originColumn),Vector2i(targetRow,targetColumn)).size()-1
	if targetSolid == true:
		get_node("/root/Main").pathGrid.set_point_solid(Vector2i(targetRow,targetColumn),true)
	
	if (pathLength) == 1:
		return true
	else:
		return false

func costForSkill():
	get_parent().get_parent().restMe()
	RulesEngine.requestResponse(get_parent().get_parent(), "costForMySkill")


func resoForSkill(source,targetArray):
	RulesEngine.requestSkillChoice(get_parent().get_parent())
	await RulesEngine.skillChoiceReceived
	if RulesEngine.skillChoiceZoneID != "FIZZLE":
		if RulesEngine.skillChoiceZoneID == "":
			get_parent().emitStartNextSequence()
		else:
			get_parent().get_parent().moveMeFromZoneToZone(RulesEngine.skillChoiceZoneID)
			await get_tree().create_timer(.1).timeout
			RulesEngine.skillChoiceZoneID = ""
			RulesEngine.waitingForSkillChoice = false
			RulesEngine.waitingToSkillNode = null
			RulesEngine.rangePurpose = RulesEngine.RANGETYPE.BLANK
			RulesEngine.selRangePurpose = RulesEngine.RANGETYPE.BLANK
	
	RulesEngine.requestSpSkillChoice(get_parent().get_parent())
	await RulesEngine.spSkillChoiceReceived
	var damageResult
	if RulesEngine.spSkillChoiceZoneID != "FIZZLE":
		if RulesEngine.spSkillChoiceZoneID == "":
			get_parent().emitStartNextSequence()
		else:
			damageResult = await RulesEngine.dealDamageToZone(RulesEngine.spSkillChoiceZoneID,get_parent().get_parent(),get_parent().myAttack)
			await get_tree().create_timer(.1).timeout
			RulesEngine.spSkillChoiceZoneID = ""
			RulesEngine.waitingForSpSkillChoice = false
			RulesEngine.waitingToSpSkillNode = null
			RulesEngine.rangePurpose = RulesEngine.RANGETYPE.BLANK
			RulesEngine.selRangePurpose = RulesEngine.RANGETYPE.BLANK

	if damageResult == "thisKilledSomething":
		RulesEngine.deckThisFromField(get_parent().get_parent().get_parent(),false)
		
	get_parent().emitStartNextSequence()
