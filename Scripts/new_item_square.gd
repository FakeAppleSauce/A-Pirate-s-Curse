extends Control

@onready var menu: Control = $"."
@onready var button: Button = $Button
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var treasure = "null"

signal treasurePicked(treasure)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setUp():
	for i in range(Global.treasureList.size()):
		if Global.treasureList[i]["name"] == treasure:
			sprite_2d.texture.region = Global.treasureList[i]["location"]


func _on_button_pressed() -> void:
	print(treasure)
	treasurePicked.emit(treasure)
	print(sprite_2d.texture.region)
	
