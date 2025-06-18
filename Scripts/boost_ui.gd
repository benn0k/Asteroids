extends HBoxContainer
# Preload boost ui pips -> node
var ui_pip := preload("res://Scenes/boost_UI_pip.tscn").instantiate()

func _on_ship_is_boosting() -> void:
	#Get children of boost ui (ui pips) and set first to first_child, then remove it 
	var children := get_children()
	if children.size() > 0:
		var first_child := children[0]
		remove_child(first_child)
		first_child.queue_free()

	#add_child(ui_pip)
