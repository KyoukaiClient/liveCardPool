extends Node2D
var cardNode = get_parent().get_parent()
#Zodiac Goat - Signpost
#done for 0.02

func amISelectablePreRoutine():
	if not cardNode.inDiscard and not cardNode.inSpiritDeck and not cardNode.inShatter and not cardNode.inForesee and not cardNode.cardInHand:
		var cornerZones = ["A01","A05","E01","E05"]
		if cardNode.inZoneID != cardNode.lastZoneID:
			if cornerZones.has(cardNode.inZoneID):
				cardNode.readyMe()
