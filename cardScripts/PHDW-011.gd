extends Node2D
var cardNode = get_parent().get_parent()
#Pathfinding Pixie
#done for 0.04


func costForOpenMe():
	get_parent().foreseeX(2)
	RulesEngine.requestResponse(cardNode, "openedAGate")

func resoForOpenMe(source, targetArray):
	RulesEngine.discardForesee(cardNode.cardOwnerIndex)
	get_parent().emitStartNextSequence()

func canIUseASkill():
	var playerDiscard
	var checkCardsNode
	var discardShatterableCount = 0
	var sameNameHit = false
	
	playerDiscard = GameManager.P1CurrentDiscard
	checkCardsNode = get_node(Global.pathStrings["pileList1/SearchBG"])
	if playerDiscard.size() > 0:
		for card in playerDiscard:
			if checkCardsNode.get_node("CardP1 - " + str(card) + "/Card/cardScript").canIBeShattered():
				discardShatterableCount += 1
	
	if discardShatterableCount == 0:
		playerDiscard = GameManager.P2CurrentDiscard
		checkCardsNode = get_node(Global.pathStrings["pileList2/SearchBG"])
		if playerDiscard.size() > 0:
			for card in playerDiscard:
				if checkCardsNode.get_node("CardP2 - " + str(card) + "/Card/cardScript").canIBeShattered():
					discardShatterableCount += 1
	
	if discardShatterableCount > 0:
		return true
	else:
		return false

func costForSkill():
	cardNode.restMe()
	var keepLooping = true
	while keepLooping:
		RulesEngine.requestPileChoice(get_parent(), RulesEngine.PILES.DISCARD,1,0,1,"", "Choose [1] [gate] to Shatter, or [0] to see other [discard]:", RulesEngine.DESTINATIONS.SHATTER)
		await RulesEngine.pileChoiceReceived
		if RulesEngine.lastPileChoiceList != []:
			keepLooping = false
		else:
			RulesEngine.requestPileChoice(get_parent(), RulesEngine.PILES.DISCARD,2,0,1,"", "Choose [1] [gate] to Shatter, or [0] to see other [discard]:", RulesEngine.DESTINATIONS.SHATTER)
			await RulesEngine.pileChoiceReceived
			if RulesEngine.lastPileChoiceList != []:
				keepLooping = false
	RulesEngine.requestResponse(cardNode, "costForMySkill")
			
			
		
	
