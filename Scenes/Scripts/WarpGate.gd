extends Area2D

signal incEgg

func _on_WarpGate_body_entered(body):
	body.warped()

