extends CharacterBody2D

var movingLeft = false

func _ready() -> void:
	moving()
	
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
	
	if velocity.x > 0:
		scale.x = -0.1
	else:
		scale.x = 0.1



func moving():
	var newPosition = randi_range(-100, 100)
	velocity.x = 0
	
	if newPosition < 0:
		movingLeft = true
		velocity.x = -25
	else:
		movingLeft = false
		velocity.x = 25
	
	await get_tree().create_timer(randi_range(2,6)).timeout
	#velocity.x = move_toward(velocity.x, 0, 10)
	await get_tree().create_timer(1).timeout
	moving()
