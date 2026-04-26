extends CharacterBody2D

const FISHING_POLE = preload("res://Scenes/fishing_pole.tscn")

@onready var player = $Idle
@onready var skeleton = $Skeleton2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ui: CanvasLayer = $"../UI"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var camera_2d: Camera2D = $Camera2D

@onready var world_environment: WorldEnvironment = $"../WorldEnvironment"

@onready var fishing: Node = $"../Fishing"


const SPEED = 100.0
const JUMP_VELOCITY = -200.0
var isJumping = false
var onLadder = false
var temp = false
var distanceToFloor = 0

var fishable = false


func _ready() -> void:
	position.x = Global.playerpositionX
	position.y = Global.playerpositionY
	await get_tree().create_timer(5).timeout
	Global.startTasks()
	


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor() and onLadder == false && Global.doingTask == false:
		velocity.y = JUMP_VELOCITY
		animation_player.play("Jump")
		isJumping = true
		jump()
		
		
	if Input.is_action_pressed("Jump") and onLadder == true && Global.doingTask == false:
		velocity.y = JUMP_VELOCITY/2
		
		
	if Input.is_action_just_pressed("Fish") and fishable == true:
		if Global.fishingPoles > 0:
			var fishing_pole = FISHING_POLE.instantiate()
			fishing_pole.position = position
			fishing.add_child(fishing_pole)
			Global.fishingPoles -= 1
		
		
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("moveLeft", "moveRight")
	
	if Global.doingTask == false:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, 300)
	else:
		velocity.x = 0
		
	
	move_and_slide()



func _process(_delta: float) -> void:
		
	if Input.is_action_pressed("moveRight"):
		skeleton.scale.x = -1
		animation_player.play("Running")
		if camera_2d.offset.x != 40:
			await get_tree().create_timer(0.05).timeout
			camera_2d.offset.x = move_toward(camera_2d.offset.x, 20, 1)
		
	
	if Input.is_action_pressed("moveLeft"):
		skeleton.scale.x = 1
		animation_player.play("Running_2")
		if camera_2d.offset.x != -40:
			await get_tree().create_timer(0.05).timeout
			camera_2d.offset.x = move_toward(camera_2d.offset.x, -20, 1)
		

		
	if velocity == Vector2(0,0) && isJumping == false:
		animation_player.current_animation = "Idle"
		await get_tree().create_timer(0.1).timeout
		camera_2d.offset.x = move_toward(camera_2d.offset.x, 0, 2)



func jump():
	await get_tree().create_timer(0.65).timeout
	isJumping = false


func shakeCamera():
	pass
	#camera_2d.drag_horizontal_offset = randf_range(-0.1,0.1)
	#await get_tree().create_timer(0.1).timeout
	#camera_2d.drag_horizontal_offset = randf_range(-0.1,0.1)
	#await get_tree().create_timer(0.1).timeout
	#camera_2d.drag_horizontal_offset = randf_range(-0.1,0.1)
	#await get_tree().create_timer(0.1).timeout
	#camera_2d.drag_horizontal_offset = 0
	


func _on_area_2d_area_entered(_area: Area2D) -> void:
	fishable = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Character":
		fishable = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Character":
		fishable = false
