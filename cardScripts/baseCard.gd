extends Node2D
var rowConvert = {"A":0, "B":1, "C":2, "D":3, "E":4, 0:"A", 1:"B", 2:"C", 3:"D", 4:"E"}
var myAttack
var myAttackRange
var myMovement
var myDefense
var discardAfterSequence = false

var custom

# Called when the node enters the scene tree for the first time.
func _ready():
	custom = get_node("customScripts")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func isThisChoiceValid(sortToUse: String, optionsArray:Array, selectedArray:Array, choice):
	if RulesEngine.pileChoiceList.size() > RulesEngine.pileMaxChoice:
		return false
	if sortToUse == "noDupe":
		for card in selectedArray:
			if card.get_node("Card").dataLookup("name") == choice.get_node("Card").dataLookup("name"):
				return false
		return true
	elif(custom.has_method("isThisChoiceValid")):
		return custom.isThisChoiceValid(sortToUse, optionsArray, selectedArray, choice)
	else:
		return true

	   #.oooooo.   ooooo      ooo      oooooooooooo ooooo oooooooooooo ooooo        oooooooooo.   
	  #d8P'  `Y8b  `888b.     `8'      `888'     `8 `888' `888'     `8 `888'        `888'   `Y8b  
	 #888      888  8 `88b.    8        888          888   888          888          888      888 
	 #888      888  8   `88b.  8        888oooo8     888   888oooo8     888          888      888 
	 #888      888  8     `88b.8        888    "     888   888    "     888          888      888 
	 #`88b    d88'  8       `888        888          888   888       o  888       o  888     d88' 
	  #`Y8bood8P'  o8o        `8       o888o        o888o o888ooooood8 o888ooooood8 o888bood8P'   
 
func amISelectable():
	if(custom.has_method("amISelectable")):
		return custom.amISelectable()
	else:
		if Global.liveScene == Global.LIVESCENE.FIELD:
			if Global.whichPlayerAmI == get_parent().cardOwnerIndex and \
										not get_parent().inDiscard and \
										not get_parent().inShatter and \
										not get_parent().inForesee and \
										get_parent().cardReady == true:
				canIBeOpened()
				if get_parent().cardOpenable:
					get_parent().cardSelectable = false
				elif get_parent().cardInHand or get_parent().inSpiritDeck:
					get_parent().cardSelectable = false
				else:
					get_parent().cardSelectable = true
		#		print(get_parent().dataLookup("name") + " inHand " + str(get_parent().cardInHand) + " openable " + str(get_parent().cardOpenable) + " draggable " + str(get_parent().cardDraggable) + " Selectable " + str(get_parent().cardSelectable))
			else:
				get_parent().cardSelectable = false
				get_parent().cardDraggable = false
				get_parent().cardOpenable = false
		elif Global.liveScene == Global.LIVESCENE.DECK:
			get_parent().cardSelectable = false
			get_parent().cardDraggable = true
			get_parent().cardOpenable = false


	   #.oooooo.   ooooooooo.   oooooooooooo ooooo      ooo      ooo        ooooo oooooooooooo 
	  #d8P'  `Y8b  `888   `Y88. `888'     `8 `888b.     `8'      `88.       .888' `888'     `8 
	 #888      888  888   .d88'  888          8 `88b.    8        888b     d'888   888         
	 #888      888  888ooo88P'   888oooo8     8   `88b.  8        8 Y88. .P  888   888oooo8    
	 #888      888  888          888    "     8     `88b.8        8  `888'   888   888    "    
	 #`88b    d88'  888          888       o  8       `888        8    Y     888   888       o 
	  #`Y8bood8P'  o888o        o888ooooood8 o8o        `8       o8o        o888o o888ooooood8 

func canIPayMyOpenCost():
	if(custom.has_method("canIPayMyOpenCost")):
		return custom.canIPayMyOpenCost()
	else:
		return true

func costForOpenMe():
	if(custom.has_method("costForOpenMe")):
		return custom.costForOpenMe()
	else:
		RulesEngine.requestReponse(get_parent(), "openedAGate")



func resoForOpenMe():
	if(custom.has_method("resoForOpenMe")):
		return custom.resoForOpenMe()
	else:
		var snapZoneNode
		snapZoneNode = get_node(Global.pathStrings["cursorMouseCatch"]+"/"+get_parent().inZoneID)

func canIOpenHere(myZone):
	if(custom.has_method("canIOpenHere")):
		return custom.canIOpenHere(myZone)
	else:
		if not canIPayMyOpenCost():
			return false
		else:
			var myRow = rowConvert[myZone.left(1)]
			var myColumn = int(myZone.right(2))-1
			var snapMatrix1 = get_node(Global.pathStrings["P1Snaps"]).zoneHas
			var snapMatrix2 = get_node(Global.pathStrings["P2Snaps"]).zoneHas
			var myMatrix
			if get_parent().cardOwnerIndex == 1:
				myMatrix = snapMatrix1
			else:
				myMatrix = snapMatrix2
			
			if snapMatrix1[myRow][myColumn] != 0 or snapMatrix2[myRow][myColumn] != 0:
				return false
			if myRow-1 >= 0:
				if myMatrix[myRow-1][myColumn] != 0:
					if get_node("/root/Main/playField/Field/CardP" + str(get_parent().cardOwnerIndex) + " - " + str(myMatrix[myRow-1][myColumn])).get_node("Card").cardReady:
						return true
			if myColumn-1 >= 0:
				if myMatrix[myRow][myColumn-1] != 0:
					if get_node("/root/Main/playField/Field/CardP" + str(get_parent().cardOwnerIndex) + " - " + str(myMatrix[myRow][myColumn-1])).get_node("Card").cardReady:
						return true
			if myRow+1 <=4:
				if myMatrix[myRow+1][myColumn] != 0:
					if get_node("/root/Main/playField/Field/CardP" + str(get_parent().cardOwnerIndex) + " - " + str(myMatrix[myRow+1][myColumn])).get_node("Card").cardReady:
						return true
			if myColumn+1 <= 4:
				if myMatrix[myRow][myColumn+1] != 0:
					if get_node("/root/Main/playField/Field/CardP" + str(get_parent().cardOwnerIndex) + " - " + str(myMatrix[myRow][myColumn+1])).get_node("Card").cardReady:
						return true
			return false

func canIBeOpened():
	if(custom.has_method("canIBeOpened")):
		return custom.canIBeOpened()
	else:
		var openZoneFound = false
		var nextZoneID
		for child in get_node("/root/Main/playField/Field/cursorMouseCatch").get_children():
			nextZoneID = child.name
			if canIOpenHere(nextZoneID):
				openZoneFound = true
				break
		var inOpenableLocation = false
		if get_parent().cardInHand or get_parent().inSpiritDeck:
			inOpenableLocation = true
		if openZoneFound and inOpenableLocation:
			if get_parent().dataLookup("type") == "Spirit" and get_parent().inSpiritDeck:
				get_parent().cardDraggable = true
				get_parent().cardOpenable = true
			elif get_parent().cardInHand:
				get_parent().cardDraggable = true
				get_parent().cardOpenable = true
		else:
			get_parent().cardDraggable = false
			get_parent().cardOpenable = false


	 #ooo        ooooo   .oooooo.   oooooo     oooo oooooooooooo      ooo        ooooo oooooooooooo 
	 #`88.       .888'  d8P'  `Y8b   `888.     .8'  `888'     `8      `88.       .888' `888'     `8 
	  #888b     d'888  888      888   `888.   .8'    888               888b     d'888   888         
	  #8 Y88. .P  888  888      888    `888. .8'     888oooo8          8 Y88. .P  888   888oooo8    
	  #8  `888'   888  888      888     `888.8'      888    "          8  `888'   888   888    "    
	  #8    Y     888  `88b    d88'      `888'       888       o       8    Y     888   888       o 
	 #o8o        o888o  `Y8bood8P'        `8'       o888ooooood8      o8o        o888o o888ooooood8 

func canIMove():
	if(custom.has_method("canIMove")):
		return custom.canIMove()
	else:
		return true

func isInMoveRange(myZone, originZone):
	if(custom.has_method("isInMoveRange")):
		return custom.isInMoveRange(myZone, originZone)
	else:
		var originRow = rowConvert[originZone.left(1)]
		var originColumn = int(originZone.right(2))-1
		var targetRow = rowConvert[myZone.left(1)]
		var targetColumn = int(myZone.right(2))-1
		var pathLength = get_node("/root/Main").pathGrid.get_id_path(Vector2i(originRow,originColumn),Vector2i(targetRow,targetColumn)).size()-1
		if (pathLength) <= myMovement and pathLength != -1:
			return true
		else:
			return false

func costForMoveMe():
	if(custom.has_method("costForMoveMe")):
		return custom.costForMoveMe()
	else:
		get_parent().restMe()
		RulesEngine.requestReponse(get_parent(), "costForMoveMe")
	

func resoForMoveMe():
	if(custom.has_method("resoForMoveMe")):
		return custom.resoForMoveMe()
	else:
		RulesEngine.afterMoveMode = true
		RulesEngine.requestMoveTarget(get_parent())

		   #.o.       ooooooooooooo ooooooooooooo       .o.         .oooooo.   oooo    oooo 
		  #.888.      8'   888   `8 8'   888   `8      .888.       d8P'  `Y8b  `888   .8P'  
		 #.8"888.          888           888          .8"888.     888           888  d8'    
		#.8' `888.         888           888         .8' `888.    888           88888[      
	   #.88ooo8888.        888           888        .88ooo8888.   888           888`88b.    
	  #.8'     `888.       888           888       .8'     `888.  `88b    ooo   888  `88b.  
	 #o88o     o8888o     o888o         o888o     o88o     o8888o  `Y8bood8P'  o888o  o888o 

func canIAttack():
	if(custom.has_method("canIAttack")):
		return custom.canIAttack()
	else:
		return true

func isInAttackRange(myZone, originZone):
	if(custom.has_method("isInAttackRange")):
		return custom.isInAttackRange(myZone, originZone)
	else:
		var originRow = rowConvert[originZone.left(1)]
		var originColumn = int(originZone.right(2))-1
		var targetRow = rowConvert[myZone.left(1)]
		var targetColumn = int(myZone.right(2))-1
		var targetSolid = get_node("/root/Main").pathGrid.is_point_solid(Vector2i(targetRow,targetColumn))
		
		if targetSolid == true:
			get_node("/root/Main").pathGrid.set_point_solid(Vector2i(targetRow,targetColumn),false)
		var pathLength = get_node("/root/Main").pathGrid.get_id_path(Vector2i(originRow,originColumn),Vector2i(targetRow,targetColumn)).size()-1
		if targetSolid == true:
			get_node("/root/Main").pathGrid.set_point_solid(Vector2i(targetRow,targetColumn),true)
		if (pathLength) <= myMovement + myAttackRange and pathLength != -1:
			return true
		else:
			return false

func costForAttack():
	if(custom.has_method("costForAttack")):
		return custom.costForAttack()
	else:
		get_parent().restMe()
		RulesEngine.requestAttackTarget(get_parent())

func resoForAttack():
	if(custom.has_method("resoForAttack")):
		return custom.resoForAttack()
	else:
		RulesEngine.dealDamageToZone(RulesEngine.attackChoiceZoneID, RulesEngine.waitingToAttackNode, myAttack)
		RulesEngine.attackChoiceZoneID = ""
		RulesEngine.waitingForAttackChoice = false
		RulesEngine.waitingToAttackNode = null
		RulesEngine.rangePurpose = "selectedDisplay"

func isInNoMoveAttackRange(myZone, originZone):
	if(custom.has_method("isInNoMoveAttackRange")):
		return custom.isInNoMoveAttackRange(myZone, originZone)
	else:
		var originRow = rowConvert[originZone.left(1)]
		var originColumn = int(originZone.right(2))-1
		var targetRow = rowConvert[myZone.left(1)]
		var targetColumn = int(myZone.right(2))-1
		var targetSolid = get_node("/root/Main").pathGrid.is_point_solid(Vector2i(targetRow,targetColumn))
		
		if targetSolid == true:
			get_node("/root/Main").pathGrid.set_point_solid(Vector2i(targetRow,targetColumn),false)
		var pathLength = get_node("/root/Main").pathGrid.get_id_path(Vector2i(originRow,originColumn),Vector2i(targetRow,targetColumn)).size()-1
		if targetSolid == true:
			get_node("/root/Main").pathGrid.set_point_solid(Vector2i(targetRow,targetColumn),true)
		if myZone != originZone:
			if (pathLength) <= myAttackRange and pathLength != -1:
				return true
			else:
				return false
		else:
			return false





	  #.oooooo..o oooo    oooo ooooo ooooo        ooooo        
	 #d8P'    `Y8 `888   .8P'  `888' `888'        `888'        
	 #Y88bo.       888  d8'     888   888          888         
	  #`"Y8888o.   88888[       888   888          888         
		  #`"Y88b  888`88b.     888   888          888         
	 #oo     .d8P  888  `88b.   888   888       o  888       o 
	 #8""88888P'  o888o  o888o o888o o888ooooood8 o888ooooood8 


func canIUseDiscardSkill():
	return false

func canIUseShatterSkill():
	return false
	
func canIUseForeseeSkill():
	return false
	
func canIUseSpiritSkill():
	return false

func canIUseASkill():
	if(custom.has_method("canIUseASkill")):
		return custom.canIUseASkill()
	else:
		if get_parent().dataLookup("skillName") != "":
			if get_parent().dataLookup("skillType") != "Passive":
				return true
			else:
				return false
		else:
			return false

func costForSkill():
	if(custom.has_method("costForSkill")):
		return custom.costForSkill()
	else:
		pass

func resoForSkill():
	if(custom.has_method("resoForSkill")):
		return custom.resoForSkill()
	else:
		pass


	 #ooooooooo.         .o.        .oooooo..o  .oooooo..o ooooo oooooo     oooo oooooooooooo  .oooooo..o 
	 #`888   `Y88.      .888.      d8P'    `Y8 d8P'    `Y8 `888'  `888.     .8'  `888'     `8 d8P'    `Y8 
	  #888   .d88'     .8"888.     Y88bo.      Y88bo.       888    `888.   .8'    888         Y88bo.      
	  #888ooo88P'     .8' `888.     `"Y8888o.   `"Y8888o.   888     `888. .8'     888oooo8     `"Y8888o.  
	  #888           .88ooo8888.        `"Y88b      `"Y88b  888      `888.8'      888    "         `"Y88b 
	  #888          .8'     `888.  oo     .d8P oo     .d8P  888       `888'       888       o oo     .d8P 
	 #o888o        o88o     o8888o 8""88888P'  8""88888P'  o888o       `8'       o888ooooood8 8""88888P'  

func applyMyPassive():
	if(custom.has_method("applyMyPassive")):
		return custom.applyMyPassive()
	else:
		pass


	 #oooooooooo.  ooooooooo.         .o.       ooooo      ooo   .oooooo.   ooooo   ooooo oooooooooooo  .oooooo..o 
	 #`888'   `Y8b `888   `Y88.      .888.      `888b.     `8'  d8P'  `Y8b  `888'   `888' `888'     `8 d8P'    `Y8 
	  #888     888  888   .d88'     .8"888.      8 `88b.    8  888           888     888   888         Y88bo.      
	  #888oooo888'  888ooo88P'     .8' `888.     8   `88b.  8  888           888ooooo888   888oooo8     `"Y8888o.  
	  #888    `88b  888`88b.      .88ooo8888.    8     `88b.8  888           888     888   888    "         `"Y88b 
	  #888    .88P  888  `88b.   .8'     `888.   8       `888  `88b    ooo   888     888   888       o oo     .d8P 
	 #o888bood8P'  o888o  o888o o88o     o8888o o8o        `8   `Y8bood8P'  o888o   o888o o888ooooood8 8""88888P'  

func canIUseABranch():
	if(custom.has_method("canIUseABranch")):
		return custom.canIUseABranch()
	else:
		return false

	 #ooooooooo.   oooooooooooo ooooo          .oooooo.     .oooooo.         .o.       ooooooooooooo oooooooooooo 
	 #`888   `Y88. `888'     `8 `888'         d8P'  `Y8b   d8P'  `Y8b       .888.      8'   888   `8 `888'     `8 
	  #888   .d88'  888          888         888      888 888              .8"888.          888       888         
	  #888ooo88P'   888oooo8     888         888      888 888             .8' `888.         888       888oooo8    
	  #888`88b.     888    "     888         888      888 888            .88ooo8888.        888       888    "    
	  #888  `88b.   888       o  888       o `88b    d88' `88b    ooo   .8'     `888.       888       888       o 
	 #o888o  o888o o888ooooood8 o888ooooood8  `Y8bood8P'   `Y8bood8P'  o88o     o8888o     o888o     o888ooooood8 

func canIBeShattered():
	if(custom.has_method("canIBeShattered")):
		return custom.canIBeShattered()
	else:
		return true

func canIBeDiscarded():
	if(custom.has_method("canIBeDiscarded")):
		return custom.canIBeDiscarded()
	else:
		return true
