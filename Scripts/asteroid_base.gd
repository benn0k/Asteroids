extends Area2D

#*^ Constants
# 0 = Positive rotation, 1 = Negative rotation
var ROTATION_DIRECTION = randi_range(0, 1)
# Randomize Rotation speed
var ROTATION_SPEED = randf_range(.001, .01)
# Move Speed
var SPEED := 150.0
var move_to_point := Vector2(0,0)

signal destroyed


func _ready() -> void: 
  #Signals
	area_entered.connect(on_area_entered)

  #*Move logic
  #Check global position, and depending on it's coordinates, move to other side of viewport

  #If spawns outside of right side of viewport
	if global_position.x >=900:
  #Generate random y coord, and move across screen
		var rand_y := randi_range(0,800)
		move_to_point = Vector2(-300, rand_y)
  
  #Bottom of viewport
	if global_position.y >= 900:
		var rand_x := randi_range(0,800)
		move_to_point = Vector2(rand_x, -300)

  #Left of viewport 
	if global_position.x <= -100:
		var rand_y := randi_range(0,800)
		move_to_point = Vector2(1000, rand_y)

  #Top of Viewport
	if global_position.y <= -100:
		var rand_x := randi_range(0,800)
		move_to_point = Vector2(rand_x, 1000)

func _process(delta: float) -> void:
 
  #* Rotate - the idea here is to add a little variation to each asteroid
  #? If, for whatever reason, I need to optimize, start here
  #^I bet this could be solved with a tween 

  #They shouldn't all spin the same direction, and not at the same speed 
  #Currently, we're appending rotation speed each frame, which is a lot of calculations
  #I could consider making an adjustment so that we calculate rotation once (ROTATION_SPEED)
  #then figure out how to set a linear rotation each frame
  
	if ROTATION_DIRECTION == 1:
		rotation += ROTATION_SPEED * -1
	if ROTATION_DIRECTION == 0:
		rotation += ROTATION_SPEED
  
  #*Move to Position
  # Moving is easy, we just set position to increment by .direction_to() multiplied by speed and delta
	position += position.direction_to(move_to_point) * SPEED * delta 

# Despawn Asteroid when it leaves the screen
func on_area_entered(area_that_entered):
	if area_that_entered.is_in_group("score"):
		print('score')
	if area_that_entered.is_in_group("despawn"):
		queue_free()


