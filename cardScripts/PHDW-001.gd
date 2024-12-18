extends Node2D
var skillChosenZone = ""
#Participant
#done for 0.02

func canIUseASkill():
	return true

func isInSkillRange(myZone, originZone):
	return get_parent().isBorderingGateOfTypes(myZone, originZone, ["Summon"], true)

func isInSpecialSkillRange(myZone, originZone):
	var originRow = get_parent().rowConvert[skillChosenZone.left(1)]
	var originColumn = int(skillChosenZone.right(2))-1
	var targetRow = get_parent().rowConvert[myZone.left(1)]
	var targetColumn = int(myZone.right(2))-1
	var targetSolid = get_node("/root/Main").pathGrid.is_point_solid(Vector2i(targetRow,targetColumn))
	var pathLength = get_node("/root/Main").pathGrid.get_id_path(Vector2i(originRow,originColumn),Vector2i(targetRow,targetColumn)).size()-1

	
	if (pathLength) == 1:
		return true
	else:
		return false

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
			await get_tree().create_timer(.1).timeout
			RulesEngine.skillChoiceZoneID = ""
			RulesEngine.waitingForSkillChoice = false
			RulesEngine.waitingToSkillNode = null
			RulesEngine.rangePurpose = RulesEngine.RANGETYPE.BLANK
			RulesEngine.selRangePurpose = RulesEngine.RANGETYPE.BLANK
			
			RulesEngine.requestSpSkillChoice(get_parent().get_parent())
			await RulesEngine.spSkillChoiceReceived
			
			if RulesEngine.spSkillChoiceZoneID != "FIZZLE":
				var cardToMove = Global.getCardNodeInZone(skillChosenZone)
				cardToMove.get_node("Card").moveMeFromZoneToZone(RulesEngine.spSkillChoiceZoneID)
				get_parent().get_parent().moveMeFromZoneToZone(skillChosenZone)
	await get_tree().create_timer(.1).timeout
	RulesEngine.waitingForSpSkillChoice = false
	RulesEngine.waitingForSkillChoice = false
	RulesEngine.spSkillChoiceZoneID = ""
	get_parent().emitStartNextSequence()
