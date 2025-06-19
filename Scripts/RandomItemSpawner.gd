extends Node2D
#* Nodes
@onready var spawn_timer := get_node("Spawn_Timer")
@onready var inc_timer := get_node("Inc_Timer")
@onready var boost_pickup_timer := get_node("Boost_Pickup_Timer")

#* Global Variables 

var item_count := 0
@export var item_limit := 40

#Preload item collectables
var item_scenes := [
preload("res://Scenes/Asteroids/asteroid_1.tscn"),
preload("res://Scenes/Asteroids/asteroid_2.tscn"),
preload("res://Scenes/Asteroids/asteroid_3.tscn"),
preload("res://Scenes/Asteroids/asteroid_4.tscn"),
preload("res://Scenes/Asteroids/asteroid_5.tscn"),
preload("res://Scenes/Asteroids/asteroid_6.tscn"),
preload("res://Scenes/Asteroids/asteroid_7.tscn"),
preload("res://Scenes/Asteroids/asteroid_8.tscn")]

var boost_pip := preload("res://Scenes/boost_pickup.tscn")

func _ready() -> void:
  #Timer timeout signal
	spawn_timer.timeout.connect(on_timer_timeout)
	inc_timer.timeout.connect(on_inc_timer_timeout)
	boost_pickup_timer.timeout.connect(on_boost_pickup_timer_timeout)

#* Signal Functions

#Runs when item is deleted from scene tree
func on_item_deleted() -> void:
# When item is deleted from scene tree, decrement item_count
	item_count = item_count - 1

#Runs on spawn_timer timeout
func on_timer_timeout() -> void:
 
  #Pick a random Scene from item_scenes array
	var random_item_scene: PackedScene = item_scenes.pick_random()

  #Get viewport size (used to assign random position)
	var spawn_window_margin := 100
	var viewport_size := get_viewport_rect().size - Vector2(spawn_window_margin,spawn_window_margin)
  
  #Generate random position for items
	var random_location := Vector2(0,0)

  #* Determines where asteroid will spawn outside viewport
  #0 (North), 1 (East), 2 (South), 3 (West) 
	var side := randi_range(0,3)
 

  #Top of viewport
	if side == 0:
		random_location.x = randf_range(0, viewport_size.x)
		random_location.y = -100

  #Right of viewport
	if side == 1: 
		random_location.x = 900
		random_location.y = randf_range(0, viewport_size.y)

  #Bottom of viewport
	if side == 2: 
		random_location.x = randf_range(0,viewport_size.x)
		random_location.y = 900
		
	if side == 3: 
		random_location.x = -100
		random_location.y = randf_range(0,viewport_size.y)


  #Instantiate, assign random position
	var item_instance := random_item_scene.instantiate()
	item_instance.position = random_location

  #When item_instance leaves scene tree, run on_item_deleted
	item_instance.tree_exited.connect(on_item_deleted)

  #Skip adding an item if item_count equals limit
	if item_count == item_limit:
		return

  # Add item to scene tree and increment item_count
	add_child(item_instance)
	item_count = item_count + 1

#Runs when the incremental spawn_timer times-out
#This is used to ramp up more asteroids to scene every 10s
func on_inc_timer_timeout() -> void:
	var remaining_time = spawn_timer.get_wait_time()
	if remaining_time == .01:
		return
	spawn_timer.set_wait_time(remaining_time - .01)


#Runs every 5 seconds
func on_boost_pickup_timer_timeout() -> void:
	var boost_pickup = boost_pip.instantiate()
	boost_pickup.position = Vector2(randf_range(100,780),randf_range(100,700))
	add_child(boost_pickup)






