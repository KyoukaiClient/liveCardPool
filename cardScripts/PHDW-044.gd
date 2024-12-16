extends Node2D
var skillChosenZone = ""
#Zodiac Horse - Cavalry
#done for 0.00


func canIUseASkill():
	return true

func isInSkillRange(myZone, originZone):
	return get_parent().isBorderingGateOfTypes(myZone, originZone, ["Summon","Spirit","Entrant"])

func isInSpecialSkillRange(myZone, originZone):
	return get_parent().isEmptyBorderingZone(myZone, originZone)
	

func costForSkill():
	get_parent().get_parent().restMe()
	RulesEngine.requestResponse(get_parent().get_parent(), "costForMySkill")

func resoForSkill(source,targetArray):
	RulesEngine.requestSkillChoice(get_parent().get_parent())
	await RulesEngine.skillChoiceReceived
	
	if RulesEngine.skillChoiceZoneID != "FIZZLE":
		skillChosenZone = RulesEngine.skillChoiceZoneID
		if skillChosenZone == "":
			get_parent().emitStartNextSequence()
		else:
			RulesEngine.skillChoiceZoneID = ""
			RulesEngine.waitingForSkillChoice = false
			RulesEngine.waitingToSkillNode = null
			RulesEngine.rangePurpose = RulesEngine.RANGETYPE.BLANK
			RulesEngine.selRangePurpose = RulesEngine.RANGETYPE.BLANK
			
			RulesEngine.requestSpSkillChoice(get_parent().get_parent())
			await RulesEngine.spSkillChoiceReceived
			
			if RulesEngine.spSkillChoiceZoneID != "FIZZLE":
				var moveDir = Global.whatDirectionIsThisBorderingZone(get_parent().get_parent().inZoneID,RulesEngine.spSkillChoiceZoneID)
				var cardToMove = Global.getCardNodeInZone(skillChosenZone)
				var otherGateDestination = Global.getBorderingZoneInADirection(skillChosenZone,moveDir)
				get_parent().get_parent().moveMeFromZoneToZone(RulesEngine.spSkillChoiceZoneID)
				if otherGateDestination != "OFFFIELD":
					if Global.getCardNodeInZone(otherGateDestination) == null:
						cardToMove.get_node("Card").moveMeFromZoneToZone(otherGateDestination)
				
	RulesEngine.waitingForSpSkillChoice = false
	RulesEngine.waitingForSkillChoice = false
	RulesEngine.spSkillChoiceZoneID = ""
	get_parent().emitStartNextSequence()
