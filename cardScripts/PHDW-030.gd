extends Node2D
var cardNode = get_parent().get_parent()
#Refined Potion
#done for 0.04

func isInSkillRange(myZone, originZone):
	var targetNode
	var targetCardNode
	var acceptableTypes = ["Summon"]
	targetNode = Global.getCardNodeInZone(myZone)
	if targetNode == null:
		return false
	else:
		targetCardNode = targetNode.get_node("Card")
		if targetCardNode.cardOwnerIndex == 1:
			if not targetCardNode.cardReady:
				if acceptableTypes.has(targetCardNode.dataLookup("type")):
					if targetCardNode.dataLookup("name").to_lower().contains("slime"):
						return true
	return false

func resoForOpenMe(source, targetArray):
	RulesEngine.requestSkillChoice(cardNode)
	
	await RulesEngine.skillChoiceReceived
	if RulesEngine.skillChoiceZoneID != "FIZZLE":
		await RulesEngine.discardThisFromField(Global.getCardNodeInZone(RulesEngine.skillChoiceZoneID),cardNode)
		RulesEngine.currentP1EntrantNode.get_node('Card').readyMe()
		
	get_parent().emitStartNextSequence()
