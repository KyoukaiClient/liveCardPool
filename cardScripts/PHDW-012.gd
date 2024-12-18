extends Node2D
#Lumbering Tortoise
#done for 0.02

func canIUseASkill():
	return true

func isInSkillRange(myZone, originZone):
	return get_parent().isEmptyBorderingZone(myZone, originZone)

func costForSkill():
	get_parent().get_parent().restMe()
	RulesEngine.requestResponse(get_parent().get_parent(), "costForMySkill")

func resoForSkill(source,targetArray):
	RulesEngine.requestSkillChoice(get_parent().get_parent())
	await RulesEngine.skillChoiceReceived
	
	if RulesEngine.skillChoiceZoneID != "FIZZLE":
		if RulesEngine.skillChoiceZoneID != get_parent().get_parent().inZoneID:
			get_parent().get_parent().moveMeFromZoneToZone(RulesEngine.skillChoiceZoneID)
	get_parent().emitStartNextSequence()
