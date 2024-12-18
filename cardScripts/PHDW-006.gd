extends Node2D
#Wandering Lion
#done for 0.02

func canIUseASkill():
	return true

func isInSkillRange(myZone, originZone):
	return get_parent().isBorderingZone(myZone, originZone)


func isInSpecialSkillRange(myZone, originZone):
	return get_parent().isBorderingGate(myZone, originZone)

func costForSkill():
	get_parent().get_parent().restMe()
	get_parent().chooseATargetAtCost("costForMySkill")

func resoForSkill(source,targetArray):
	var damageResult = RulesEngine.dealDamageToZone(targetArray[0]["zoneID"], source, get_parent().myAttack)
	if damageResult == "thisKilledSomething":
		get_parent().get_parent().moveMeFromZoneToZone(targetArray[0]["zoneID"])
		RulesEngine.requestSpSkillChoice(get_parent().get_parent())
		await RulesEngine.spSkillChoiceReceived
	
		if RulesEngine.spSkillChoiceZoneID != "FIZZLE":
			RulesEngine.dealDamageToZone(RulesEngine.spSkillChoiceZoneID, source, get_parent().myAttack)

	get_parent().emitStartNextSequence()
