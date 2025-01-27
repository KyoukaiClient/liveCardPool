extends Node2D
#Weathervane Rooster
#done for 0.02

func isInMoveRange(myZone, originZone):
	var originRow = Global.rowConvert[originZone.left(1)]
	var originColumn = int(originZone.right(2))-1
	var targetRow = Global.rowConvert[myZone.left(1)]
	var targetColumn = int(myZone.right(2))-1
	get_node("/root/Main").pathGrid.set_diagonal_mode(AStarGrid2D.DIAGONAL_MODE_ALWAYS)
	var pathLength = get_node("/root/Main").pathGrid.get_id_path(Vector2i(originRow,originColumn),Vector2i(targetRow,targetColumn)).size()-1
	get_node("/root/Main").pathGrid.set_diagonal_mode(AStarGrid2D.DIAGONAL_MODE_NEVER)
	if (pathLength) <= get_parent().myMovement and pathLength > 0:
		return true
	else:
		return false

func isInAttackRange(myZone, originZone):
	var originRow = Global.rowConvert[originZone.left(1)]
	var originColumn = int(originZone.right(2))-1
	var targetRow = Global.rowConvert[myZone.left(1)]
	var targetColumn = int(myZone.right(2))-1
	var targetSolid = get_node("/root/Main").pathGrid.is_point_solid(Vector2i(targetRow,targetColumn))
	
	if targetSolid == true:
		get_node("/root/Main").pathGrid.set_point_solid(Vector2i(targetRow,targetColumn),false)
	get_node("/root/Main").pathGrid.set_diagonal_mode(AStarGrid2D.DIAGONAL_MODE_ALWAYS)
	var pathLength = get_node("/root/Main").pathGrid.get_id_path(Vector2i(originRow,originColumn),Vector2i(targetRow,targetColumn)).size()-1
	get_node("/root/Main").pathGrid.set_diagonal_mode(AStarGrid2D.DIAGONAL_MODE_NEVER)

	if targetSolid == true:
		get_node("/root/Main").pathGrid.set_point_solid(Vector2i(targetRow,targetColumn),true)
	if (pathLength) <= get_parent().myMovement + get_parent().myAttackRange and pathLength != -1:
		return true
	else:
		return false

func isInNoMoveAttackRange(myZone, originZone):
	var originRow = Global.rowConvert[originZone.left(1)]
	var originColumn = int(originZone.right(2))-1
	var targetRow = Global.rowConvert[myZone.left(1)]
	var targetColumn = int(myZone.right(2))-1
	var targetSolid = get_node("/root/Main").pathGrid.is_point_solid(Vector2i(targetRow,targetColumn))
	
	if targetSolid == true:
		get_node("/root/Main").pathGrid.set_point_solid(Vector2i(targetRow,targetColumn),false)
	get_node("/root/Main").pathGrid.set_diagonal_mode(AStarGrid2D.DIAGONAL_MODE_ALWAYS)
	var pathLength = get_node("/root/Main").pathGrid.get_id_path(Vector2i(originRow,originColumn),Vector2i(targetRow,targetColumn)).size()-1
	get_node("/root/Main").pathGrid.set_diagonal_mode(AStarGrid2D.DIAGONAL_MODE_NEVER)
	if targetSolid == true:
		get_node("/root/Main").pathGrid.set_point_solid(Vector2i(targetRow,targetColumn),true)

	if (pathLength) <= get_parent().myAttackRange and pathLength != -1:
		return true
	else:
		return false
