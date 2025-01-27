extends Node2D
var skillChosenZone = ""
#Hunting Eagle
#done for 0.02


func canIUseASkill():
	return true

func resoForOpenMe(source, targetArray):
	get_parent().get_parent().readyMe()
	get_parent().emitStartNextSequence()

func isInSpecialSkillRange(myZone, originZone):
	var originRow = get_parent().rowConvert[originZone.left(1)]
	var originColumn = int(originZone.right(2))-1
	var targetRow = get_parent().rowConvert[myZone.left(1)]
	var targetColumn = int(myZone.right(2))-1

	var pathLength = get_node("/root/Main").pathGrid.get_id_path(Vector2i(originRow,originColumn),Vector2i(targetRow,targetColumn)).size()-1
	
	if (pathLength) == 1 or (pathLength) == 0:
		return true
	else:
		return false

func isInSkillRange(myZone, originZone):
	var originRow = get_parent().rowConvert[originZone.left(1)]
	var originColumn = int(originZone.right(2))-1
	var targetRow = get_parent().rowConvert[myZone.left(1)]
	var targetColumn = int(myZone.right(2))-1
	var targetSolid = get_node("/root/Main").pathGrid.is_point_solid(Vector2i(targetRow,targetColumn))
	if targetSolid == true:
		get_node("/root/Main").pathGrid.set_point_solid(Vector2i(targetRow,targetColumn),false)
	var pathLength = get_node("/root/Main").pathGrid.get_id_path(Vector2i(originRow,originColumn),Vector2i(targetRow,targetColumn)).size()-1
	if targetSolid == true:
		get_node("/root/Main").pathGrid.set_point_solid(Vector2i(targetRow,targetColumn),true)
	
	if (pathLength) == 1:
		return true
	else:
		return false

func costForSkill():
	get_parent().get_parent().restMe()
	get_parent().chooseATargetAtCost("costForMySkill")

func resoForSkill(source,targetArray):
	for target in targetArray:
		await RulesEngine.dealDamageToZone(target["zoneID"], source, 2)
	RulesEngine.requestSpSkillChoice(get_parent().get_parent())
	await RulesEngine.spSkillChoiceReceived
	
	if RulesEngine.spSkillChoiceZoneID != "FIZZLE":
		skillChosenZone = RulesEngine.spSkillChoiceZoneID
		if skillChosenZone != get_parent().get_parent().inZoneID:
			get_parent().get_parent().moveMeFromZoneToZone(skillChosenZone)
	get_parent().emitStartNextSequence()
