extends KinematicBody2D

signal eggStatus
var velocity = Vector2(0,0)
const WALKSPEED = 100
const JUMP = 250
const GRAVITY = 30
export var direction = -1
var shoved = 150
var initialX
var initialY
var win = false


func _ready():
	initialY = position.y
	initialX = position.x
	var getThrown = get_tree().get_root().find_node("Steve",true,false)
	getThrown.connect("throw",self,"thrown")

func _physics_process(delta):
	# Make eggs subject to gravity.
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity,Vector2.UP)
	velocity.x = lerp(velocity.x,0,0.05)

func _on_sideChecker_body_entered(body):
	# This is some terrible code, but I'm a newbie at GDScript
	
	if body.is_in_group("Eater"):
		$AnimatedSprite.play("crack")
		win = false
		$Timer.start()
		$soundCrack.play()
	elif body.get_name() == "Steve":
		#figure out what side he is on!
		$AnimatedSprite.play("rolling")
		if body.position.x > position.x:
			# steve is right of me?
			velocity.x -= shoved
		elif body.position.x < position.x:
			#steve is left of me?
			velocity.x += shoved
	elif body.get_name() == "WarpGate":
		$AnimatedSprite.play("spin")
		$Timer.start()
		win = true
	else:
		win = false
				
	velocity.x = lerp(velocity.x,0,0.05)

func thrown(x_value):
	if x_value > position.x + 100 or  x_value < position.x - 100:
		var difference = x_value - position.x
		return
	$AnimatedSprite.play("spin")
	$soundThrow.play()
	if x_value > position.x:
		velocity.x -= shoved * 2
		velocity.y += -JUMP
	if x_value < position.x:
		velocity.x += shoved * 2
		velocity.y += -JUMP
		
	velocity = move_and_slide(velocity,Vector2.UP)

func warped():
	$AnimatedSprite.play("spin")
	$Timer.start()
	win = true

func _on_Timer_timeout():
	$Timer.stop()
	respawn()
	
func respawn():
	if win:
		emit_signal("eggStatus", true)
		$soundWarp.play()
	else:
		emit_signal("eggStatus", false)
	
	win = false	
	position.x = initialX
	position.y = initialY
	$AnimatedSprite.play("idle")
