extends Area2D

# When ship is destroyed, remove boundaries
func _on_ship_destroyed() -> void:
  print('despawn boundary')
  queue_free()
