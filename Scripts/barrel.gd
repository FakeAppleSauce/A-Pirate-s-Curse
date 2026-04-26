extends Area2D


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite_2d_2: Sprite2D = $Sprite2D2
@onready var square_collider: CollisionShape2D = $SquareCollider
@onready var circle_collider: CollisionShape2D = $CircleCollider

@onready var leaking_water: CPUParticles2D = $LeakingWater
@onready var completion_particles: CPUParticles2D = $CompletionParticles

@onready var character: CharacterBody2D = $"../../Character"
@onready var ui: CanvasLayer = $"../../UI"


@export var instance: int = 0

var leakingWater = false
var canDoTask = false
var timerStarted = false
var canTouch = false
var cooldown = false


signal openBarrelTask()

func _ready() -> void:
	#Connecting Task Signal
	Global.newTask.connect(_on_new_task)
	ui.taskFinished.connect(_on_task_finished)
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
		
	


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Use") && leakingWater == true && canTouch == true:
		get_tree().call_group("barrels", "openBarrelTasks")
		Global.currentTaskID = instance
		Global.barrelStatus[instance] = "workingOnIt"
		
		



func startDamaging():
	await get_tree().create_timer(1.5).timeout
	if Global.barrelStatus[instance] == "leaking":
		Global.shipHealth -= 0.5
		ui.set_health(Global.shipHealth)
		character.shakeCamera()
		startDamaging()



func openBarrelTasks():
	openBarrelTask.emit()


func _on_body_entered(body: Node2D) -> void:
	if body == character:
		canTouch = true
		if leaking_water.emitting == true:
			if sprite_2d.visible == true:
				var mat = sprite_2d.material as ShaderMaterial
				mat.set_shader_parameter("active", true)
			else:
				var mat = sprite_2d_2.material as ShaderMaterial
				mat.set_shader_parameter("active", true)
			


func _on_body_exited(body: Node2D) -> void:
	if body == character:
		canTouch = false
		if sprite_2d.visible == true:
			var mat = sprite_2d.material as ShaderMaterial
			mat.set_shader_parameter("active", false)
		else:
			var mat = sprite_2d_2.material as ShaderMaterial
			mat.set_shader_parameter("active", false)


func _on_new_task(task, id):
	if task == "barrel" and id == instance:
		if leakingWater == false && cooldown == false:
			Global.barrelStatus[instance] = "leaking"
			leaking_water.emitting = true
			leakingWater = true
			modulate = Color(1, 1, 1, 1)
			print(canTouch)
			if canTouch == true:
				if sprite_2d.visible == true:
					var mat = sprite_2d.material as ShaderMaterial
					mat.set_shader_parameter("active", true)
				else:
					var mat = sprite_2d_2.material as ShaderMaterial
					mat.set_shader_parameter("active", true)
			
			
			Global.taskAmountPerRound += 1
			Global.startTasks()
			startDamaging()
		else:
			Global.startTasks()
			


func _on_task_finished(task, ID):
	if task == "barrel" && ID == instance:
		leaking_water.emitting = false
		completion_particles.emitting = true
		modulate = Color(0.589, 0.589, 0.589, 1)
		leakingWater = false
		cooldown = true
		var mat = sprite_2d.material as ShaderMaterial
		mat.set_shader_parameter("active", false)
		await get_tree().create_timer(1).timeout
		cooldown = false
