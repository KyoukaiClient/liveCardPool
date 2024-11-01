extends Node2D
#Cloudfaring Dragon


func canIPayMyOpenCost():
	var playerDiscard
	var checkCardsNode
	var discardShatterableCount = []
	var sameNameHit = false
	var discardCheckResult = false
	
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
					for name in discardShatterableCount:
						if name == checkCardsNode.get_node("CardP" + str(Global.whichPlayerAmI) + " - " + str(card) + "/Card").dataLookup("name"):
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
	var snapZoneNode
	snapZoneNode = get_node(Global.pathStrings["cursorMouseCatch"]+"/"+get_parent().get_parent().inZoneID)
	RulesEngine.toggleZoneMarkers(true, snapZoneNode, get_parent().get_parent(), RulesEngine.MARKERTYPES.OPENCOST)
	RulesEngine.requestPileChoice(get_parent(), RulesEngine.PILES.DISCARD,3,3,"noDupe", "Choose [3] differently named [gate] to Shatter:", RulesEngine.DESTINATIONS.SHATTER)

func resoForOpenMe():
	get_parent().get_parent().readyMe()
	var snapZoneNode
	snapZoneNode = get_node(Global.pathStrings["cursorMouseCatch"]+"/"+get_parent().get_parent().inZoneID)
