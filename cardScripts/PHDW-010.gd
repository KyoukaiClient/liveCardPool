extends Node2D
var cardNode = get_parent().get_parent()
var skillSource
#Basic Slime
#done for 0.04

func isThisChoiceValid(sortToUse, optionsArray, selectedArray, choice):
	if choice.get_node("Card").dataLookup("name").to_lower().contains("slime"):
		return true
	else:
		return false

func costForOpenMe():
	get_parent().foreseeX(2)
	RulesEngine.requestResponse(cardNode, "openedAGate")

func resoForOpenMe(source, targetArray):
	RulesEngine.requestPileChoice(get_parent(),RulesEngine.PILES.FORESEE,1,0,40,"custom", "Choose any number of Slime [summon] to add to [hand]:", RulesEngine.DESTINATIONS.HAND)
	
	await RulesEngine.pileChoiceReceived
	get_parent().emitStartNextSequence()



func isInSkillRange(myZone, originZone):
	var targetNode
	var targetCardNode
	var acceptableTypes = ["Summon", "Spirit"]
	targetNode = Global.getCardNodeInZone(myZone)
	if targetNode == null:
		return false
	else:
		targetCardNode = targetNode.get_node("Card")
		if targetCardNode.cardOwnerIndex == 1:
			if not targetCardNode.cardReady:
				if acceptableTypes.has(targetCardNode.dataLookup("type")):
					return true
	return false

func whenIAmDiscarded(source):
	await get_parent().transferMySkill(source)

func effectToTransfer(source):
	skillSource = source
	RulesEngine.requestSkillChoice(source)
	
	await RulesEngine.skillChoiceReceived
	if RulesEngine.skillChoiceZoneID != "FIZZLE":
		await Global.getCardNodeInZone(RulesEngine.skillChoiceZoneID).get_node("Card").readyMe()
	
