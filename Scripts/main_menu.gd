extends Control

@onready var main_menu: Control = $MainMenu
@onready var complete_menu: Control = $CompleteMenu
@onready var treasures: Control = $Treasures



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.currentScreen == "mainMenu":
		main_menu.visible = true
		complete_menu.visible = false
		treasures.visible = false
	elif Global.currentScreen == "completeMenu":
		complete_menu.visible = true
		main_menu.visible = false
		treasures.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	Global.currentScreen = "game"
	get_tree().change_scene_to_file("res://Scenes/MainGame.tscn")


func _on_next_ride_button_pressed() -> void:
	Global.island += 1
	Global.firstDust = true
	get_tree().change_scene_to_file("res://Scenes/MainGame.tscn")
