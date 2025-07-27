extends Node

@export var _n_players := 2
@export var _players : Array[PlayerController] = []

@export var _players_root : Node
@export var _villages_root : Node
@export var _simulation : Simulation
@export var _player_bp : PackedScene

func start_game() -> void:
	print("Starting game with " + str(_n_players) + " players")
	for i in _n_players:
		# create new player
		var player_scene = _player_bp.instantiate()
		_players_root.add_child(player_scene)
		var player = player_scene as PlayerController
		player.initialize("Player" + str(i))
		_players.append(player)
		
		# create first village for player
		var village = Village.new(player)
		player._villages.append(village)
		_villages_root.add_child(village)
	
	_simulation.start()



func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_S:
			start_game()
