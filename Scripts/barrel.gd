extends Area2D


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite_2d_2: Sprite2D = $Sprite2D2
@onready var square_collider: CollisionShape2D = $SquareCollider
@onready var circle_collider: CollisionShape2D = $CircleCollider

@onready var leaking_water: CPUParticles2D = $LeakingWater
@onready var timer: Timer = $Timer

@onready var character: CharacterBody2D = $"../../Character"
@onready var ui: CanvasLayer = $"../../UI"


@export var instance: int = 0

var leakingWater = false
var canDoTask = false
var timerStarted = false
var canTouch = false


signal openBarrelTask

func _ready() -> void:
	#choosing barrel type
	var barrelType = randi_range(0,1)
	if barrelType == 0:
		sprite_2d.visible = false
		sprite_2d_2.visible = true
		square_collider.disabled = false
		circle_collider.disabled = true
	elif barrelType == 1:
		sprite_2d.visible = true
		sprite_2d_2.visible = false
		square_collider.disabled = true
		circle_collider.disabled = false
		
	startLeakingCycle()
	


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Use") && leakingWater == true && canTouch == true: 
		get_tree().call_group("barrels", "openBarrelTasks")

		Global.currentTaskID = instance
		Global.barrelStatus[instance] = "workingOnIt"
		
		
	if Global.barrelStatus[instance] == "finished":
		leakingWater = false
		leaking_water.emitting = false
		modulate = Color(0.8, 0.8, 0.8, 1)
		startLeakingCycle()
		Global.barrelStatus[instance] = "neutral"
		
		



func startLeakingCycle():
	await get_tree().create_timer(3).timeout
	timer.wait_time = randi_range(5,20)
	timer.start()
	Global.barrelStatus[instance] = "countingDown"
	await timer.timeout
	
	Global.barrelStatus[instance] = "leaking"
	leaking_water.emitting = true
	leakingWater = true
	modulate = Color(1, 1, 1, 1)
	startDamaging()



func startDamaging():
	await get_tree().create_timer(5).timeout
	if Global.barrelStatus[instance] == "leaking":
		Global.shipHealth -= 0.5
		ui.set_health(Global.shipHealth)
		character.shakeCamera()
		startDamaging()



func openBarrelTasks():
	emit_signal("openBarrelTask")


func _on_body_entered(body: Node2D) -> void:
	if body == character:
		canTouch = true


func _on_body_exited(body: Node2D) -> void:
	if body == character:
		canTouch = false
