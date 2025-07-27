class_name Simulation extends Node

var _turn_number := 0
var _current_player := 0


func start() -> void:
	_turn_number = 0
	_current_player = -1 # so next turn starts with player 0
	for player in GameManager._players:
		player.on_turn_ended.connect(next_turn)
	
	next_turn()


func next_turn() -> void:
	_current_player += 1
	if _current_player == GameManager._n_players:
		_turn_number += 1
		_current_player = 0
	
	# TODO: I don't like this coupling, maybe I have to change it to a signal
	GameManager._players[_current_player].start_turn()
