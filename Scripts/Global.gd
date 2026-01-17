extends Node

var shipHealth = 69
var takingDamage = false
var dustLeft = 5

var playerpositionX = 50
var playerpositionY = 200
var changingScenes = false

var doingTask = false
var firstDust = true
var currentTaskID = 0
var task = "nothing"

var island = 0

var currentScreen = "mainMenu"
var taskAmountPerRound = 0

var tasksUnlocked = ["barrels", "cannon"]
var barrelStatus = ["timedOut", "timedOut", "timedOut", "timedOut", "timedOut", "timedOut", "timedOut"]
var cannonStatus = ["timedOut", "timedOut", "timedOut", "timedOut", "timedOut", "timedOut"]

var fishingPoles = 1000
var treasuresHolding = 0
var treasureList = ["GoldHook", "Dablooms", "GoldAnchor", "GoldFish", "FishSkeleton", "Fish", "DirtyBoot", "GoldSkull"]
var treasuresOwned = []

signal newTask(task)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if shipHealth <= 0:
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
		currentScreen = "mainMenu"
		shipHealth = 100


func openMenu(i):
	pass
	

func startTasks():
	await get_tree().create_timer(taskAmountPerRound + 1).timeout
	
	newTask.emit(tasksUnlocked[randi_range(0, len(tasksUnlocked))])
	
	
