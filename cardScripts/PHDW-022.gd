extends Node2D
var cardNode = get_parent().get_parent()
#Second Form - Counterpunch
#done for 0.04

func isThisChoiceValid(sortToUse, optionsArray, selectedArray, choice):
	if choice.get_node("Card").dataLookup("name").to_lower().contains("first form"):
		return true
	else:
		return false


func canIPayMyOpenCost():
	var playerDiscard
	var checkCardsNode
	var sameNameHit = false
	
	if Global.whichPlayerAmI == 1:
		playerDiscard = GameManager.P1CurrentDiscard
		checkCardsNode = get_node(Global.pathStrings["pileList1/SearchBG"])
	elif Global.whichPlayerAmI == 2:
		playerDiscard = GameManager.P2CurrentDiscard
		checkCardsNode = get_node(Global.pathStrings["pileList2/SearchBG"])
	if playerDiscard.size() > 0:
		for card in playerDiscard:
			if checkCardsNode.get_node("CardP" + str(Global.whichPlayerAmI) + " - " + str(card) + "/Card/cardScript").canIBeShattered():
				if checkCardsNode.get_node("CardP" + str(Global.whichPlayerAmI) + " - " + str(card) + "/Card").dataLookup("name").to_lower().contains("first form"):
					return true
	return false


func costForOpenMe():
	RulesEngine.requestPileChoice(get_parent(), RulesEngine.PILES.DISCARD,1,1,1,"custom", "Choose [1] \"First Form\" [gate] to Shatter:", RulesEngine.DESTINATIONS.SHATTER)
		
	await RulesEngine.pileChoiceReceived
	RulesEngine.requestResponse(get_parent().get_parent(), "openedAGate")

func resoForOpenMe(source, targetArray):
	var cardToHit
	if int(RulesEngine.currentlyResolvingSequenceNumber) > 1:
		cardToHit = RulesEngine.sequenceArray[int(RulesEngine.currentlyResolvingSequenceNumber)-2]["source"]
		if cardToHit.name == "Card":
			if cardToHit.amIOnField():
				await RulesEngine.dealDamageToZone(cardToHit.inZoneID,cardNode,9)
			else:
				await cardNode.fizzleMeAnimation()
		else:
			await cardNode.fizzleMeAnimation()
	else:
		await cardNode.fizzleMeAnimation()
		
	get_parent().emitStartNextSequence()
