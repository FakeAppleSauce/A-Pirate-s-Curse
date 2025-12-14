extends Area2D

@onready var character: CharacterBody2D = $"../../Character"
@onready var timer: Timer = $Timer
@onready var particles: CPUParticles2D = $particles


var canDoTask = false
var dirty = false

@export var instance: int = 0

signal cannonTask

func _ready() -> void:
	timeCycle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Use") and canDoTask == true && dirty == true:
		get_tree().call_group("cannons", "callTask")
		
		Global.currentTaskID = instance
		Global.cannonStatus[instance] = "workingOnIt"
		
	if Global.cannonStatus[instance] == "finished":
		dirty = false
		particles.emitting = false
		modulate = Color(0.8, 0.8, 0.8, 1)
		timeCycle()
		Global.barrelStatus[instance] = "neutral"
		
	


func callTask():
	emit_signal("cannonTask")



func _on_body_entered(body: Node2D) -> void:
	if body == character:
		canDoTask = true

func _on_body_exited(body: Node2D) -> void:
	if body == character:
		canDoTask = false


func timeCycle():
	await get_tree().create_timer(3).timeout
	timer.wait_time = randi_range(10,30)
	timer.start()
	Global.cannonStatus[instance] = "countingDown"
	await timer.timeout
	dirty = true
	Global.cannonStatus[instance] = "dirty"
	particles.emitting = true
	modulate = Color(1, 1, 1, 1)
