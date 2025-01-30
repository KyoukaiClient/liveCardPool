extends Node2D
var cardNode = get_parent().get_parent()
#First Form - Exerting Dodge
#done for 0.04

func canIOpenHere(myZone):
	var entrantZone = RulesEngine.currentP1EntrantNode.get_node("Card").inZoneID
	var check = Global.whatDirectionIsThisBorderingZone(entrantZone,myZone)
	if check != "NotBordering" and Global.isEmpty(myZone):
		return true
	else:
		return false

func resoForOpenMe(source, targetArray):
	var myZone = cardNode.inZoneID
	var entrantZone
	
	if cardNode.cardOwnerIndex == 1:
		entrantZone = RulesEngine.currentP1EntrantNode.get_node("Card").inZoneID
		RulesEngine.currentP1EntrantNode.get_node("Card").moveMeFromZoneToZone(myZone)
		cardNode.moveMeFromZoneToZone(entrantZone)
		
		
		if not RulesEngine.currentP1EntrantNode.get_node("Card").cardReady:
			if get_node(Global.pathStrings["Hand"]).handCards.size() > 0:
				RulesEngine.requestHandChoice(get_parent(),1,true,false,1,1,"","Choose [1] [gate] to discard:", RulesEngine.DESTINATIONS.DISCARD)
				await RulesEngine.handChoiceReceived
	elif cardNode.cardOwnerIndex == 2:
		entrantZone = RulesEngine.currentP2EntrantNode.get_node("Card").inZoneID
		RulesEngine.currentP2EntrantNode.get_node("Card").moveMeFromZoneToZone(myZone)
		cardNode.moveMeFromZoneToZone(entrantZone)
		
	
	get_parent().emitStartNextSequence()
