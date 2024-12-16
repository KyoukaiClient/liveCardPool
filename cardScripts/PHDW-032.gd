extends Node2D
#Pinfencer Pixie
#done for 0.00

func canIUseASkill():
	return true

func isInSkillRange(myZone, originZone):
	return get_parent().isBorderingZone(myZone, originZone)


func receiveSpecialCostRequest():
	get_parent().myDefense += int(get_parent().get_parent().dataLookup("atk")) - int(get_parent().get_parent().dataLookup("def"))
	get_parent().myAttack += int(get_parent().get_parent().dataLookup("def")) - int(get_parent().get_parent().dataLookup("atk"))
	get_parent().get_parent().updateInfo()

func costForSkill():
	get_parent().get_parent().restMe()
	get_parent().myDefense += int(get_parent().get_parent().dataLookup("atk")) - int(get_parent().get_parent().dataLookup("def"))
	get_parent().myAttack += int(get_parent().get_parent().dataLookup("def")) - int(get_parent().get_parent().dataLookup("atk"))
	get_parent().get_parent().updateInfo()
	GameManager.pushChangeIfOnline(GameManager.GAMEMOVE.CARDCOST,[str(get_parent().get_path()),GameManager.P1CurrentID])
	get_parent().chooseATargetAtCost("costForMySkill")

func resoForSkill(source,targetArray):
	for target in targetArray:
		RulesEngine.dealDamageToZone(target["zoneID"], source, get_parent().myAttack)
	get_parent().emitStartNextSequence()
