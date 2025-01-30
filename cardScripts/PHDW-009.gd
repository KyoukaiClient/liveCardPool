extends Node2D
var cardNode = get_parent().get_parent()
#Defusing Weasel
#done for 0.04

func canIUseASkill():
	return true

func costForOpenMe():
	RulesEngine.requestResponse(cardNode, "openedAGate", true)

func resoForOpenMe(source, targetArray):
	cardNode.readyMe()
	get_parent().emitStartNextSequence()

func isInSkillRange(myZone, originZone):
	if get_parent().isBorderingGateFaceDown(myZone, originZone, ["Flip"]):
		return true
	elif get_parent().isBorderingGateWithBranch(myZone, originZone):
		return true
	else:
		return false


func costForSkill():
	get_parent().get_parent().restMe()
	RulesEngine.requestResponse(cardNode, "costForMySkill", true)

func resoForSkill(source,targetArray):
	RulesEngine.requestSkillChoice(cardNode)
	await RulesEngine.skillChoiceReceived
	if RulesEngine.skillChoiceZoneID != "FIZZLE":
		var chosenCard = Global.getCardNodeInZone(RulesEngine.skillChoiceZoneID).get_node("Card")
		if chosenCard.cardFaceDown:
			chosenCard.flipMeUp()
			await get_tree().create_timer(.5).timeout
			RulesEngine.discardThisFromField(chosenCard.get_parent(), cardNode)
	#Add Branch Code Later
	get_parent().emitStartNextSequence()
