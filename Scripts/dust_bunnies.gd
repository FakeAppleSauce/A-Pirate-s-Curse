extends TextureButton 


var clickable = false
var holeTime = 0
var holePressed = false

@onready var atlas_texture: AtlasTexture = texture_normal as AtlasTexture
@onready var dust_bunnies: TextureButton = $"."
@onready var cpu_particles_2d: CPUParticles2D = $"../CPUParticles2D"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("bunnies")
	
	position = Vector2(randi_range(7, 883), randi_range(12, 407))
	rotation = randi_range(0,360)
	if Global.task == "barrels":
		atlas_texture.region = Rect2(0, 256, 256, 256)
	elif Global.task == "cannons":
		atlas_texture.region = Rect2(256, 256, 256, 256)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if holePressed == true:
		holeTime += 0.1
		cpu_particles_2d.position = get_viewport().get_mouse_position()
	
	
	if holeTime >= 4:
		cpu_particles_2d.emitting = false
		Global.dustLeft -= 1
		queue_free()
		
	if Global.dustLeft == 0:
		cpu_particles_2d.restart()
		cpu_particles_2d.emitting = false


func _on_pressed() -> void:
	if Global.task == "cannons":
		queue_free()
		Global.dustLeft -= 1



func _on_button_down() -> void:
	if Global.task == "barrels":
		cpu_particles_2d.emitting = true
		holePressed = true
		


func _on_button_up() -> void:
	if Global.task == "barrels":
		cpu_particles_2d.emitting = false
		holePressed = false

func killCopy():
	print("d")
	queue_free()
