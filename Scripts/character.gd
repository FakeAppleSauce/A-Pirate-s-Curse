extends CharacterBody2D


@onready var player = $Idle
@onready var skeleton = $Skeleton2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ui: CanvasLayer = $"../UI"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var camera_2d: Camera2D = $Camera2D

@onready var world_environment: WorldEnvironment = $"../WorldEnvironment"



const SPEED = 100.0
const JUMP_VELOCITY = -200.0
var isJumping = false
var onLadder = false
var temp = false
var distanceToFloor = 0


func _ready() -> void:
	position.x = Global.playerpositionX
	position.y = Global.playerpositionY


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
		
	
	if Input.is_action_pressed("moveLeft"):
		skeleton.scale.x = 1
		animation_player.play("Running_2")
		

		
	if velocity == Vector2(0,0) && isJumping == false:
		animation_player.current_animation = "Idle"

func jump():
	await get_tree().create_timer(0.65).timeout
	isJumping = false

func shakeCamera():
	camera_2d.offset = Vector2(randi_range(-3,3), randi_range(-3,3))
	await get_tree().create_timer(0.1).timeout
	camera_2d.offset = Vector2(randi_range(-3,3), randi_range(-3,3))
	await get_tree().create_timer(0.1).timeout
	camera_2d.offset = Vector2(0,0)
