extends Node2D
var cardNode = get_parent().get_parent()
#Escape Route
#done for 0.04

func costForOpenMe():
	get_parent().costForOpenSealed()

func resoForOpenMe(source, targetArray):
	get_parent().stopOpenDiscard = true
	cardNode.readyMe()
	get_parent().emitStartNextSequence()

func canIUseASkill():
	if cardNode.cardFaceDown and not Structure.isItMyTurn:
		return true
	else:
		return false

func isInSkillRange(myZone, originZone):
	if get_parent().isBorderingGate(myZone, originZone) and get_parent().isMyGate(myZone, originZone):
		return true
	else:
		return false

func costForSkill():
	get_parent().costForSealedSkill()
	

func resoForSkill(source,targetArray):
	RulesEngine.requestSkillChoice(cardNode)
	await RulesEngine.skillChoiceReceived
	
	if RulesEngine.skillChoiceZoneID != "FIZZLE":
		var chosenNode = Global.getCardNodeInZone(RulesEngine.skillChoiceZoneID)
		var currentZone = cardNode.inZoneID
		if chosenNode != null:
			cardNode.moveMeFromZoneToZone(RulesEngine.skillChoiceZoneID)
			chosenNode.get_node("Card").moveMeFromZoneToZone(currentZone)
	get_parent().stopOpenDiscard = false
	get_parent().emitStartNextSequence()
