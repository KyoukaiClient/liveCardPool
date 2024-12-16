extends Node2D
var cardNode = get_parent().get_parent()
var skillChosenZone = ""
#Childhood Guardian
#done for 0.00



func amISelectableOppTurn():
	if RulesEngine.waitingForOppResponse:
		cardNode.cardSelectable = false
		cardNode.cardDraggable = false
		cardNode.cardOpenable = false
		return false
	elif Structure.firstTurnPlayer == 2 and cardNode.inSpiritDeck and Structure.whatPhaseIsIt == Structure.PHASES.SETUP:
		get_parent().canIBeOpened()
		cardNode.cardSelectable = false
		if cardNode.cardOpenable:
			return true
	elif Structure.whatPhaseIsIt == Structure.PHASES.MAIN or Structure.whatPhaseIsIt == Structure.PHASES.END:
		if RulesEngine.waitingForResponse and not cardNode.inDiscard and \
											not cardNode.inSpiritDeck and \
											not cardNode.inShatter and \
											not cardNode.inForesee and \
											Global.whichPlayerAmI == get_parent().get_parent().cardOwnerIndex and \
											cardNode.cardReady:
			cardNode.cardSelectable = true
			cardNode.cardDraggable = false
			cardNode.cardOpenable = false
			return true
		else:
			cardNode.cardSelectable = false
			cardNode.cardDraggable = false
			cardNode.cardOpenable = false
			return false
	else:
		cardNode.cardSelectable = false
		cardNode.cardDraggable = false
		cardNode.cardOpenable = false
		return false

func canIBeOpened():
	if not Structure.isItMyTurn and Structure.whatPhaseIsIt == Structure.PHASES.SETUP and cardNode.cardOwnerIndex == 1:
		var openZoneFound = false
		var nextZoneID
		for child in get_node("/root/Main/playField/Field/cursorMouseCatch").get_children():
			nextZoneID = child.name
			if get_parent().canIOpenHere(nextZoneID):
				openZoneFound = true
				break
		var inOpenableLocation = false
		if cardNode.cardInHand or cardNode.inSpiritDeck:
			inOpenableLocation = true
		if openZoneFound and inOpenableLocation:
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

func resoForOpenMe(source, targetArray):
	cardNode.readyMe()
	get_parent().emitStartNextSequence()

func canIUseASkill():
	return true

func isInSkillRange(myZone, originZone):
	var originRow = get_parent().rowConvert[RulesEngine.currentP1EntrantNode.get_node("Card").inZoneID.left(1)]
	var originColumn = int(RulesEngine.currentP1EntrantNode.get_node("Card").inZoneID.right(2))-1
	var targetRow = get_parent().rowConvert[myZone.left(1)]
	var targetColumn = int(myZone.right(2))-1
	var pathLength = get_node("/root/Main").pathGrid.get_id_path(Vector2i(originRow,originColumn),Vector2i(targetRow,targetColumn)).size()-1
	
	if pathLength == 1:
		return true
	else:
		return false

func costForSkill():
	get_parent().get_parent().restMe()
	RulesEngine.requestResponse(get_parent().get_parent(), "costForMySkill")

func resoForSkill(source = null, targetArray = []):
	RulesEngine.requestSkillChoice(get_parent().get_parent())
	await RulesEngine.skillChoiceReceived
	skillChosenZone = RulesEngine.skillChoiceZoneID
	if skillChosenZone != "FIZZLE":
		get_parent().get_parent().moveMeFromZoneToZone(skillChosenZone)
		
	await get_tree().create_timer(.1).timeout
	RulesEngine.skillChoiceZoneID = ""
	RulesEngine.waitingForSkillChoice = false
	RulesEngine.waitingToSkillNode = null
	RulesEngine.rangePurpose = RulesEngine.RANGETYPE.BLANK
	RulesEngine.selRangePurpose = RulesEngine.RANGETYPE.BLANK
	get_parent().emitStartNextSequence()
