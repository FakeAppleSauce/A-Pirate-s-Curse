extends Node

var shipHealth = 75
var takingDamage = false
var dustLeft = 5

var playerpositionX = 50
var playerpositionY = 200
var changingScenes = false

var doingTask = false
var firstDust = true
var currentTaskID = 0
var task = "nothing"
var taskAmountPerRound = 0
var taskPicked = "null"
var taskIDPicked = "null"

var island = 0

var currentScreen = "mainMenu"


var tasksUnlocked = ["barrel", "cannon"]
var barrelStatus = ["timedOut", "timedOut", "timedOut", "timedOut", "timedOut", "timedOut", "timedOut"]
var cannonStatus = ["timedOut", "timedOut", "timedOut", "timedOut", "timedOut", "timedOut"]

var fishingPoles = 1000
var treasuresHolding = 0
var treasureList = [
	{"name": "Doubloons", "description": "AAAA", "ability": "AA", "location": Rect2(0,0,1000,1000)}, #0 
	{"name": "Rum", "description": "AAAA", "ability": "AA", "location": Rect2(1000,0,1000,1000)}, #1
	{"name": "Elephant Tusk", "description": "AAAA", "ability": "AA", "location": Rect2(2000,0,1000,1000)}, #2
	{"name": "Bones", "description": "AAAA", "ability": "AA", "location": Rect2(3000,0,1000,1000)}, #3
	{"name": "Fish Skeleton", "description": "AAAA", "ability": "AA", "location": Rect2(0,1000,1000,1000)}, #4
	{"name": "Golden Fish Skeleton", "description": "AAAA", "ability": "AA", "location": Rect2(1000,1000,1000,1000)}, #5
	{"name": "Coconut", "description": "AAAA", "ability": "AA", "location": Rect2(2000,1000,1000,1000)}, #6
	{"name": "Spices", "description": "AAAA", "ability": "AA", "location": Rect2(3000,1000,1000,1000)}, #7
	{"name": "Golden Skull", "description": "AAAA", "ability": "AA", "location": Rect2(0,2000,1000,1000)}, #8
	{"name": "Boot", "description": "AAAA", "ability": "AA", "location": Rect2(1000,2000,1000,1000)}, #9
	]
var treasuresOwned = []

signal newTask(task, id)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if shipHealth <= 0:
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
		currentScreen = "mainMenu"
		shipHealth = 100


func openMenu(_i):
	pass
	

func startTasks():
	await get_tree().create_timer(taskAmountPerRound*1.75).timeout
	taskPicked = tasksUnlocked[randi_range(0, (len(tasksUnlocked)-1))]
	
	if taskPicked == "barrel":
		taskIDPicked = randi_range(0, len(barrelStatus)-1)
	elif taskPicked == "cannon":
		taskIDPicked = randi_range(0, len(cannonStatus)-1)
	
	newTask.emit(taskPicked, taskIDPicked)
	
