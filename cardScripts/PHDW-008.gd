extends Node2D
var cardNode = get_parent().get_parent()
#Impeding Golem
#done for 0.04


func amISelectableMain():
	if Global.whichPlayerAmI == cardNode.cardOwnerIndex and \
													not cardNode.inDiscard and \
													not cardNode.inShatter and \
													not cardNode.inForesee and \
													not RulesEngine.afterMoveMode and \
													cardNode.cardReady == true:
		if not RulesEngine.waitingForResponse:
			get_parent().canIBeOpened()
			if cardNode.cardOpenable:
				cardNode.cardSelectable = false
				return true
			elif cardNode.cardInHand or cardNode.inSpiritDeck:
				cardNode.cardSelectable = false
			else:
				cardNode.cardSelectable = true
				return true
		else:
			canIBeOpened()
			if cardNode.cardOpenable:
				cardNode.cardSelectable = false
				return true
			else:
				cardNode.cardSelectable = false
	else:
		cardNode.cardSelectable = false
		cardNode.cardDraggable = false
		cardNode.cardOpenable = false
		return false

func amISelectableEnd():
	if Global.whichPlayerAmI == cardNode.cardOwnerIndex and \
													not cardNode.inDiscard and \
													not cardNode.inShatter and \
													not cardNode.inForesee and \
													not RulesEngine.afterMoveMode and \
													cardNode.cardReady == true:
		if not RulesEngine.waitingForResponse:
			canIBeOpened()
			if cardNode.cardOpenable:
				cardNode.cardSelectable = false
				return true
			elif cardNode.cardInHand or cardNode.inSpiritDeck:
				cardNode.cardSelectable = false
			else:
				cardNode.cardSelectable = true
				return true
		else:
			canIBeOpened()
			if cardNode.cardOpenable:
				cardNode.cardSelectable = false
				return true
			elif cardNode.cardInHand or cardNode.inSpiritDeck:
				cardNode.cardSelectable = false
	else:
		cardNode.cardSelectable = false
		cardNode.cardDraggable = false
		cardNode.cardOpenable = false
		return false

func amISelectableOppTurn():
	if RulesEngine.waitingForOppResponse or Structure.whatPhaseIsIt == Structure.PHASES.SETUP:
		cardNode.cardSelectable = false
		cardNode.cardDraggable = false
		cardNode.cardOpenable = false
		return false
	elif Global.whichPlayerAmI == cardNode.cardOwnerIndex and \
													not cardNode.inDiscard and \
													not cardNode.inShatter and \
													not cardNode.inForesee and \
													not RulesEngine.afterMoveMode and \
													cardNode.cardReady == true:
		if not RulesEngine.waitingForResponse:
			cardNode.cardSelectable = false
			cardNode.cardDraggable = false
			cardNode.cardOpenable = false
			return false
		else:
			canIBeOpened()
			if cardNode.cardOpenable:
				cardNode.cardSelectable = false
				return true
			elif cardNode.cardInHand or cardNode.inSpiritDeck:
				cardNode.cardSelectable = false
				return false
	else:
		cardNode.cardSelectable = false
		cardNode.cardDraggable = false
		cardNode.cardOpenable = false
		return false

func canIBeOpened():
	if cardNode.cardOwnerIndex == 1:
		var openZoneFound = false
		var nextZoneID
		for child in get_node("/root/Main/playField/Field/cursorMouseCatch").get_children():
			nextZoneID = child.name
			if get_parent().canIOpenHere(nextZoneID):
				openZoneFound = true
				break
		var inOpenableLocation = false
		if cardNode.cardInHand:
			inOpenableLocation = true
		if openZoneFound and inOpenableLocation:
			cardNode.cardDraggable = true
			cardNode.cardOpenable = true
		else:
			cardNode.cardDraggable = false
			cardNode.cardOpenable = false
	else:
		cardNode.cardDraggable = false
		cardNode.cardOpenable = false

func resoForOpenMe(source, targetArray):
	var valueToReturn
	var checkZone
	var checkCardNode
	var blockAmount = 3
	var directions = [
		"UpLeft",
		"UpRight",
		"DownLeft",
		"DownRight"
	]
	
	for direction in directions:
		checkZone = Global.getBorderingZoneInADirection(cardNode.inZoneID, direction)
		if checkZone != "OFFFIELD":
			checkCardNode = Global.getCardNodeInZone(checkZone)
			if checkCardNode != null:
				checkCardNode.get_node("Card/cardScript").myDefense += blockAmount
		
	get_parent().emitStartNextSequence()
	await get_tree().create_timer(.1).timeout
	RulesEngine.skillChoiceZoneID = ""
	RulesEngine.waitingForSkillChoice = false
	RulesEngine.waitingToSkillNode = null
	RulesEngine.spSkillChoiceZoneID = ""
	RulesEngine.waitingForSpSkillChoice = false
	RulesEngine.waitingToSpSkillNode = null
	RulesEngine.rangePurpose = RulesEngine.RANGETYPE.BLANK
	RulesEngine.selRangePurpose = RulesEngine.RANGETYPE.BLANK
	RulesEngine.skillModeFocused = false
	RulesEngine.spSkillModeFocused = false
	return valueToReturn
