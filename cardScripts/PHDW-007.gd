extends Node2D
#Hunting Eagle

func resoForOpenMe():
	get_parent().get_parent().readyMe()
	var snapZoneNode
	snapZoneNode = get_node(Global.pathStrings["cursorMouseCatch"]+"/"+get_parent().get_parent().inZoneID)
