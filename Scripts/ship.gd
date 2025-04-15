extends Area2D

@onready var boost_timer = get_node('Timer')

var max_speed := 300
var velocity := Vector2(0, 0)
var steering_factor := 1.5
var health := 10
var boost_segment:= 1
var boost_mult := 1.5


signal destroyed
#Panel -> Stop Timer
#Animation Player -> Play Blinking Text
#Despawn Boundaries (all) -> Queue Free (Stops score from incrementing further) 
func _ready() -> void:
  area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	
	#*Steering and Movement
	
  var direction := Vector2(0, 0)
  direction.x = Input.get_axis("move_left", "move_right")
  direction.y = Input.get_axis("move_up", "move_down")

  if direction.length() > 1.0:
    direction = direction.normalized()

  var desired_velocity := max_speed * direction
  var steering := desired_velocity - velocity
  velocity += steering * steering_factor * delta
  position += velocity * delta

	#* Wrap ship to other size of viewport

	#Grab viewport size + a Vec2 Buffer
  var viewport_size := get_viewport_rect().size + Vector2(50,50)

	# Wrap ship position using wrapf()
  position.x = wrapf(position.x, 0, viewport_size.x)
  position.y = wrapf(position.y, 0, viewport_size.y)

  #Rotate ship sprite based on direction player is moving
  if velocity.length() > 0.0:
    get_node("Sprite2D").rotation =  velocity.angle()
  
  #Boost Mechanic - player gets 4 'segments' which are refilled by collecting batteries
  if Input.is_action_just_pressed('boost') && boost_segment > 0:
    print('boosting')
    max_speed = max_speed * boost_mult
    steering_factor = 5.0
    boost_timer.start()

#* Signal Functions

#Runs when Ship enters Area2D
func _on_area_entered(area_that_entered) -> void: 
  #Check if area is asteroid - if so, destroy ship
  if area_that_entered.is_in_group("asteroid"):
    destroyed.emit()
    queue_free()
 

#Runs when ship's boost timer timesout
func _on_timer_timeout() -> void:
  max_speed = 300
  steering_factor = 1.5
  print('Boost Stopped')
