extends Area2D


func _on_area_entered(area: Area2D) -> void:
	#If ship collids with pickup
	if area.is_in_group('ship'):
		queue_free()
