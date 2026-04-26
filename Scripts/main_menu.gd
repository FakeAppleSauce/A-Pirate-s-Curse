extends Control

@onready var main_menu: Control = $MainMenu
@onready var complete_menu: Control = $CompleteMenu
@onready var treasures: Control = $Treasures
@onready var new_treasure_stuff: Control = $Treasures/NewTreasureStuff
@onready var treasure_title: Label = $Treasures/NewTreasureStuff/treasureTitle
@onready var new_treasures_list: GridContainer = $Treasures/NewTreasureStuff/ScrollContainer/newTreasuresList
@onready var open_treasures: TextureButton = $Treasures/OpenTreasures


@export var newTreasures = []



const NEW_BOX = preload("res://Scenes/new_item_square.tscn")

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


func _on_treasures_pressed() -> void:
	treasures.visible = true
	main_menu.visible = false
	complete_menu.visible = false


func _on_open_treasures_pressed() -> void:
	if Global.treasuresHolding != 0:
		new_treasure_stuff.visible = true
		open_treasures.visible = false
		for i in range(Global.treasuresHolding):
			var newItem = Global.treasureList[randi_range(0, len(Global.treasureList) - 1)]["name"]
			newTreasures.append(newItem)

			var box_instance = NEW_BOX.instantiate()
			new_treasures_list.add_child(box_instance)
			box_instance.treasure = newItem
			box_instance.setUp()
			box_instance.treasurePicked.connect(_on_treasure_picked)
		

func _on_treasure_picked(treasure):
	treasure_title.text = "Treasure:" + treasure



func _on_go_back_pressed() -> void:
	treasures.visible = false
	main_menu.visible = false
	complete_menu.visible = true
