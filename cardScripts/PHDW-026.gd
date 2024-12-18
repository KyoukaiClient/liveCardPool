extends Node2D
var cardNode = get_parent().get_parent()
#Feng, Emerging Flame
#done for 0.02


func canIBeOpened():
	if cardNode.cardOwnerIndex == 1:
		var openZoneFound = false
		var fengFound = false
		var cardInZone
		var nextZoneID
		for child in get_node("/root/Main/playField/Field/cursorMouseCatch").get_children():
			nextZoneID = child.name
			cardInZone = Global.getCardNodeInZone(nextZoneID)
			if cardInZone != null:
				if cardInZone.get_node("Card").dataLookup("name").contains("Feng"):
					fengFound = true
					break
			if canIOpenHere(nextZoneID):
				openZoneFound = true
	
		var inOpenableLocation = false
		if cardNode.cardInHand or cardNode.inSpiritDeck:
			inOpenableLocation = true
		if openZoneFound and inOpenableLocation and not fengFound:
			if cardNode.dataLookup("type") == "Spirit" and cardNode.inSpiritDeck:
				cardNode.cardDraggable = true
				cardNode.cardOpenable = true
			elif cardNode.cardInHand:
				cardNode.cardDraggable = true
				cardNode.cardOpenable = true
		else:
			cardNode.cardDraggable = false
			cardNode.cardOpenable = false
	else:
		cardNode.cardDraggable = false
		cardNode.cardOpenable = false

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
	
	if snapMatrix1[myRow][myColumn] != 0 or snapMatrix2[myRow][myColumn] != 0:
		return false
	if myRow-1 >= 0:
		if myMatrix[myRow-1][myColumn] != 0:
			myBorderingCount += 1
			if get_node("/root/Main/playField/Field/CardP" + str(myOwner) + " - " + str(myMatrix[myRow-1][myColumn])).get_node("Card").cardReady:
				myBorderingReady += 1
	if myColumn-1 >= 0:
		if myMatrix[myRow][myColumn-1] != 0:
			myBorderingCount += 1
			if get_node("/root/Main/playField/Field/CardP" + str(myOwner) + " - " + str(myMatrix[myRow][myColumn-1])).get_node("Card").cardReady:
				myBorderingReady += 1
	if myRow+1 <=4:
		if myMatrix[myRow+1][myColumn] != 0:
			myBorderingCount += 1
			if get_node("/root/Main/playField/Field/CardP" + str(myOwner) + " - " + str(myMatrix[myRow+1][myColumn])).get_node("Card").cardReady:
				myBorderingReady += 1
	if myColumn+1 <= 4:
		if myMatrix[myRow][myColumn+1] != 0:
			myBorderingCount += 1
			if get_node("/root/Main/playField/Field/CardP" + str(myOwner) + " - " + str(myMatrix[myRow][myColumn+1])).get_node("Card").cardReady:
				myBorderingReady += 1
	
	if myBorderingCount >= 3:
		if myBorderingReady >= 1:
			return true
		else:
			return false
	else:
		return false

func resoForOpenMe(source, targetArray):
	get_parent().get_parent().readyMe()
	get_parent().emitStartNextSequence()

func amISelectablePreRoutine():
	if not cardNode.inSpiritDeck and not cardNode.inDiscard and \
									not cardNode.inShatter and \
									not cardNode.inForesee and \
									not cardNode.cardInHand:
		var nextCardNode
		var nextZone
		var combinedStatsArray = [0,0,0]
		for dir in GameManager.dirArray:
			nextZone = Global.getBorderingZoneInADirection(cardNode.inZoneID,dir)
			if nextZone != "OFFFIELD":
				nextCardNode = Global.getCardNodeInZone(nextZone)
				if nextCardNode != null:
					if combinedStatsArray[0] < int(nextCardNode.get_node("Card/cardScript").myDefense):
						combinedStatsArray[0] = int(nextCardNode.get_node("Card/cardScript").myDefense)
					if combinedStatsArray[1] < int(nextCardNode.get_node("Card/cardScript").myAttack):
						combinedStatsArray[1] = int(nextCardNode.get_node("Card/cardScript").myAttack)
					if combinedStatsArray[2] < int(nextCardNode.get_node("Card/cardScript").myMovement):
						combinedStatsArray[2] = int(nextCardNode.get_node("Card/cardScript").myMovement)
		get_parent().modifierArray[cardNode.cardID] = combinedStatsArray
		get_parent().resetMyStaticStats()
