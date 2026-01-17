extends CanvasLayer

#Grandpa Text Variables
var is_typing = false
var current_character = 0
var typing_speed = 1
var dialogue = [
#Intro Lines
'Oh! nice of you to finally join me kiddo, I knew you would finally get tired of your pops telling you to "get a job", whatever that means.', 
"But anyways, just in case you forgot, I asked you to come out today to my ship so you could learn how to really take care of one of these.", 
"*COUGH* *COUGH*. Yeah kiddo, I've been getting very sick lately, so it is perfect timing for you to finally come out.", 
"BUT ANYWAYS, lets get to sailing and teach you the ROPES around here *COUGH*",
#Tutorial Lines
"Ok bud, first things first, you gotta make sure you do any chore that comes up or else the ship will start getting damaged.",
"Dont destroy my ship.",
"To continue, you see those barrels at the bottom? well they hold all our food and water. If you notice them start leaking, make sure you plug those holes up",
"*COOOOOUGH*, Sorry kiddo, next up, do you see those cannons there? Well your gramps couldn't afford the nice ones so they get dirty.",
"If you notice it getting dirty, make sure you clean it up or it'll start doing serious damage.",
"NEXT UP, we have th- HOLY COW SON"
]
var current_dialogue = -1

#Healthbar Variables
var health = 0
var prev_health = 0
var took_damage = false
var damage_values = 0
var duplicated_node = 3

var points = 0
var neededPoints = [500, 1000, 1500, 2500, 2000, 5000, 8000, 15000, 25000, 20000, 50000, 70000, 100000, 150000, 125000]

var drawerOpened = false

#References
@onready var health_bar: Control = $HealthBar
@onready var ship_health_bar: TextureProgressBar = $HealthBar/ShipHealthBar
@onready var damage_bar: TextureProgressBar = $HealthBar/DamageBar
@onready var unc_text: Label = $UncText/uncText
@onready var unc_control: Control = $UncText
@onready var task_window: Control = $TaskWindow

@onready var task_items: Node2D = $TaskWindow/TaskItems
@onready var task_window_background: ColorRect = $TaskWindow/TaskWindowBackground
@onready var close_task_screen: TextureButton = $TaskWindow/CloseTaskScreen


@onready var number: Label = $Points/number

@onready var drawer_handle: TextureButton = $"Drawer/Drawer Handle"
@onready var drawer: ColorRect = $Drawer/Drawer
@onready var drawer_stuff: Control = $Drawer/DrawerStuff
@onready var amountof_poles: Label = $Drawer/DrawerStuff/AmountofPoles


const DUST_BUNNY = preload("res://Scenes/dust_bunny.tscn")



func _ready() -> void:
	init_health(Global.shipHealth)
	
	number.text = "0/" + str(neededPoints[Global.island])


func _process(_delta: float) -> void:
#Grandpa text code
	if is_typing == true:
		if unc_text.visible_ratio < 1:
			current_character += 1
			unc_text.visible_characters = current_character*typing_speed
		else:
			is_typing = false
		
	if Input.is_action_just_pressed("next"):
		if current_dialogue < (len(dialogue) - 1):
			current_character = 0
			unc_text.visible_characters = 0
			current_dialogue += 1
			unc_text.text = dialogue[current_dialogue]
			is_typing = true
		else:
			unc_control.visible = false
#End of grandpa text code

#Health bar code
	damage_bar.max_value = damage_values
	if took_damage == true:
		if damage_bar.value > ship_health_bar.value - 0.5:
			damage_bar.value -= 0.5
		else:
			took_damage = false
			
			
#Task Code
	if Global.dustLeft == 0:
		Global.dustLeft = -1
		if Global.task == "barrels":
			Global.barrelStatus[Global.currentTaskID] = "finished"
			points += 30
		elif Global.task == "cannons":
			Global.cannonStatus[Global.currentTaskID] = "finished"
			points += 40
			
		number.text = str(points) + "/" + str(neededPoints[Global.island])
		closeTaskScreen()
		
		
	if points >= neededPoints[Global.island]:
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
		Global.currentScreen = "completeMenu"
		
		
	amountof_poles.text = str(Global.fishingPoles)


#Health bar function
func init_health(_health):
	damage_values = _health
	health = _health
	ship_health_bar.max_value = health
	ship_health_bar.value = health


#Health bar function
func set_health(new_health):
	prev_health = health
	health = new_health
	ship_health_bar.value = health
	
	took_damage = true



func setUpScreen():
	task_window.visible = true
	health_bar.visible = false
	unc_control.visible = false
	
	Global.doingTask = true


func closeTaskScreen():
	task_window.visible = false
	health_bar.visible = true
	
	Global.doingTask = false
	get_tree().call_group("bunnies", "killCopy")


func _on_barrel_open_barrel_task() -> void:
	if Global.doingTask == false:
		Global.task = "barrels"
		setUpScreen()
		task_window_background.color = Color(0.55, 0.33, 0.09, 1)
		Global.dustLeft = 4
		for i in range(4):
			var button_instance = DUST_BUNNY.instantiate()
			task_items.add_child(button_instance)


func _on_cannon_cannon_task() -> void:
	if Global.doingTask == false:
		Global.task = "cannons"
		setUpScreen()
		task_window_background.color = Color(0.35, 0.35, 0.35, 1)
		Global.dustLeft = 7
		for i in range(7):
			var button_instance = DUST_BUNNY.instantiate()
			task_items.add_child(button_instance)



func _on_drawer_handle_pressed() -> void:
	if !Global.doingTask:
		if drawerOpened == false:
			drawer_handle.position.y -= 130
			drawer.position.y = -68
			drawerOpened = true
			drawer_stuff.visible = true
		elif drawerOpened == true:
			drawer_handle.position.y += 130
			drawer.position.y = 51
			drawerOpened = false
			drawer_stuff.visible = false



func _on_close_task_screen_pressed() -> void:
	closeTaskScreen()
	print("d")
	
