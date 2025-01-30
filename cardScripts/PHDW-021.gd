extends Node2D
var cardNode = get_parent().get_parent()
#Pathfinder's Foresight Glass
#done for 0.04

func costForOpenMe():
	get_parent().foreseeX(2)
	RulesEngine.requestResponse(cardNode, "openedAGate")

func resoForOpenMe(source, targetArray):
	RulesEngine.requestPileChoice(get_parent(),RulesEngine.PILES.FORESEE,1,0,1,"", "You can choose [1] [gate] to discard:", RulesEngine.DESTINATIONS.DISCARD)
	
	await RulesEngine.pileChoiceReceived
	RulesEngine.requestPileChoice(get_parent(),RulesEngine.PILES.FORESEE,1,0,1,"", "You can choose [1] [gate] to put on top of your [deck]:", RulesEngine.DESTINATIONS.DECKTOP)
	
	await RulesEngine.pileChoiceReceived
	get_parent().emitStartNextSequence()
