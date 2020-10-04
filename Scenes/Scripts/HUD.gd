extends CanvasLayer

var saved = 0
var broken = 0

func _ready():
	$Saved.text = String(saved)
	$Broken.text = String(broken)
	

func _on_Egg_eggStatus(savedEgg):
	if savedEgg:
		saved += 1
	else:
		broken += 1
		
	$Saved.text = String(saved)
	$Broken.text = String(broken)
