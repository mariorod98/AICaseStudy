extends Node

var _turn_number = 0
signal on_new_turn


func next_turn() -> void:
	_turn_number += 1
	on_new_turn.emit()
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			next_turn()
			
		if event.keycode == KEY_B:
			$Village.upgrade_resource_building(0)
