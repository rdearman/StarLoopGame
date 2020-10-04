extends KinematicBody2D

var velocity = Vector2(0,0)
const WALKSPEED = 100
const JUMP = 750
const GRAVITY = 30
signal throw

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		velocity.x = WALKSPEED;
		$AnimatedSprite.play("walk")
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("left"):
		velocity.x = -WALKSPEED;
		$AnimatedSprite.play("walk")
	elif Input.is_action_pressed("throw"):
		$AnimatedSprite.play("spin")
		emit_signal("throw", position.x)
		
	else:
		$AnimatedSprite.play("idle")
	
	if not is_on_floor():
		$AnimatedSprite.play("air")

	velocity.y += GRAVITY
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP
		$soundJump.play()
		
	velocity = move_and_slide(velocity,Vector2.UP)
	
	velocity.x = lerp(velocity.x,0,0.05)


func _on_bouncers_body_entered(body):
	pass 
	# Bounce Steve back to start after spinning animation
	# Need to spawn a new enemy also. 
	
