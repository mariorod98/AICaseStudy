class_name PlayerController extends Node

# INFO: yes, this is a terrible way of handling IDs, but for this project it is enough
static var _next_player_id = 0

@export var _id := GlobalData.INVALID_ID
@export var _name := ""
@export var _villages : Array[Village] = []

# TODO: maybe these should be part of the UIManager ?
@export var _focused_village : int = 0
@export var _focused_building : int = -1

@export var _ui_controller : UIController

var _is_in_turn = false

# signal emited when the player starts a turn
signal on_new_turn

# signal emited when the player finishes their turn
signal on_turn_ended


func initialize(player_name : String) -> void:
	_name = player_name
	name = player_name
	_id = _next_player_id
	_next_player_id += 1
	_ui_controller._owner = self


func set_current_village(village_idx : int) -> void:
	_focused_village = village_idx
	#TODO: Update UI


func set_current_building(building_idx : int) -> void:
	_focused_building = building_idx
	_ui_controller.open_building_ui(_villages[_focused_village]._buildings[_focused_building])


func upgrade_focused_building() -> void:
	var village = _villages[_focused_village]
	var building = village._buildings[_focused_building]
	building.upgrade()


func cancel_upgrade() -> void:
	pass


func start_turn() -> void:
	print("Turn of " + _name)
	# update all buildings
	on_new_turn.emit()
	# TODO: player turn shouldn't start AFTER all the buildings have been updated
	print("Pre-turn update finished")
	_is_in_turn = true
	
	# TODO: Find right place to put this (currently here because in _ready
	# we have not yet added a village)
	_ui_controller.open_village_ui(_villages[_focused_village])


func end_turn() -> void:
	_is_in_turn = false
	on_turn_ended.emit()
	print("End of turn for " + _name)
