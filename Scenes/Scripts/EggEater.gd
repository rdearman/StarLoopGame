extends KinematicBody2D

var velocity = Vector2(0,0)
export var direction = -1
export var detects_cliffs = true
var halted = false
var GRAVITY = 30

func _ready():
	velocity.y += GRAVITY
	if direction == 1:
		$Sprite.flip_h = true
	$FloorDetector.position.x = $BodyCollision.shape.get_extents().x * direction
	$FloorDetector.enabled = detects_cliffs
	velocity = move_and_slide(velocity,Vector2.UP)
	
	
func _physics_process(delta):
	velocity.y += GRAVITY
	if is_on_wall() or not $FloorDetector.is_colliding() and detects_cliffs and is_on_floor():
		direction = direction * -1
		$Sprite.flip_h = not $Sprite.flip_h
		$FloorDetector.position.x = $BodyCollision.shape.get_extents().x * direction
	if not halted :		
		velocity.y += GRAVITY
		velocity.x = 50 * direction
		## velocity.x = lerp(velocity.x,0,0.05)
	velocity = move_and_slide(velocity,Vector2.UP)


func food():
	halted = true
	$Timer.start()
	if $Sprite.scale.x < 1 :
		$Sprite.scale.x += 1
	

func _on_Area2D_body_entered(body):
	## print ("EATER:" + body.get_name() )
	halted = true
	$Timer.start()
	velocity = move_and_slide(velocity,Vector2.UP)
	if body.name == "Steve":
		halted = true
		$soundSquash.play()
		$Sprite.set_modulate( Color(0, 0, .5))
	if body.name == "Egg":
		food()
	

func _on_Timer_timeout():
	halted = false
	$Sprite.set_modulate (Color(1, 1, 1))
