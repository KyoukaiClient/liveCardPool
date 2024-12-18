extends Node2D
#Stone Throw
#done for 0.02


func isInSkillRange(myZone, originZone):
	return true
	


func costForOpenMe():
	get_parent().chooseATargetAtCost("openedAGate")

func resoForOpenMe(source, targetArray):
	var _targetRow
	var _targetColumn
	var _nextZone
	for target in targetArray:
		_targetRow = get_parent().rowConvert[target["zoneID"].left(1)]
		_targetColumn = int(target["zoneID"].right(2))-1
		
		RulesEngine.dealDamageToZone(target["zoneID"], source, 1)
		
		for dir in GameManager.dirArray:
			_nextZone = Global.getBorderingZoneInADirection(target["zoneID"],dir)
			if _nextZone != "OFFFIELD":
				RulesEngine.dealDamageToZone(_nextZone, source, 1)
		
	get_parent().emitStartNextSequence()
