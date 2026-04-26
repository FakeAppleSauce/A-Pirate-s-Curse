extends Area2D

@onready var character: CharacterBody2D = $"../../Character"
@onready var timer: Timer = $Timer
@onready var particles: CPUParticles2D = $particles
@onready var ui: CanvasLayer = $"../../UI"
@onready var completion_particles: CPUParticles2D = $CompletionParticles
@onready var sprite_2d: Sprite2D = $Sprite2D


var canDoTask = false
var dirty = false
var cooldown = false

@export var instance: int = 0


signal cannonTask()


func _ready() -> void:
	Global.newTask.connect(_on_new_task)
	ui.taskFinished.connect(_on_task_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Use") and canDoTask == true && dirty == true:
		get_tree().call_group("cannons", "callTask")
		
		Global.currentTaskID = instance
		Global.cannonStatus[instance] = "workingOnIt"
		
		
	


func callTask():
	cannonTask.emit()



func _on_body_entered(body: Node2D) -> void:
	if body == character:
		canDoTask = true
		if particles.emitting == true:
			var mat = sprite_2d.material as ShaderMaterial
			mat.set_shader_parameter("active", true)

func _on_body_exited(body: Node2D) -> void:
	if body == character:
		canDoTask = false
		var mat = sprite_2d.material as ShaderMaterial
		mat.set_shader_parameter("active", false)



func startDamaging():
	await get_tree().create_timer(1.5).timeout
	if Global.cannonStatus[instance] == "dirty":
		Global.shipHealth -= 0.75
		ui.set_health(Global.shipHealth)
		character.shakeCamera()
		ui.screenEffect()
		startDamaging()


func _on_task_finished(task, ID):
	if task == "cannon" && ID == instance:
		particles.emitting = false
		completion_particles.emitting = true
		modulate = Color(0.8, 0.8, 0.8, 1)
		dirty = false
		var mat = sprite_2d.material as ShaderMaterial
		mat.set_shader_parameter("active", false)
		Global.barrelStatus[instance] = "neutral"
		cooldown = true
		await get_tree().create_timer(2).timeout
		cooldown = false


func _on_new_task(task, id):
	if task == "cannon" and id == instance:
		if dirty == false && cooldown == false:
			dirty = true
			Global.cannonStatus[instance] = "dirty"
			particles.emitting = true
			modulate = Color(1, 1, 1, 1)
			if canDoTask == true:
				var mat = sprite_2d.material as ShaderMaterial
				mat.set_shader_parameter("active", true)
			
			Global.taskAmountPerRound += 1
			Global.startTasks()
			startDamaging()
		else:
			Global.startTasks()
