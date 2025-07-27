class_name Building extends Node

const MAX_LEVEL := 10
@export var _name := "UnnamedBuilding"
@export var _level := 0
@export var _turns_to_complete := 0.0
@export var _is_upgrading := false
@export var _data : buildingDataRes
@export var _village : Village

# this function is signaled by the simulation singleton if the building
# is currently doing an upgrade
func on_update():
	if _is_upgrading:
		_turns_to_complete -= _village.get_production_per_turn()
		if _turns_to_complete <= 0:
			finish_upgrade()
			print(_name + " upgraded to level " + str(_level))
		else: 
			var turns_left = _turns_to_complete /  _village.get_production_per_turn()
			print(_name + " is upgrading, " + str(turns_left) + " turns left to complete")

func build() -> void:
	Simulation.on_new_turn.connect(on_update)
	upgrade()
	
# begins the upgrade of the building, it doesn't validate 
# that we have enough resources in the village
func upgrade() -> void:
	_turns_to_complete = get_production_cost(_level + 1)
	_is_upgrading = true
	print("Upgrading" + _name + " to level " + str(_level + 1))


# resets the upgrade state
func finish_upgrade() -> void:
	_turns_to_complete = 0
	_level += 1
	_is_upgrading = false
	Simulation.on_new_turn.disconnect(on_update)


func get_production_cost(level : int) -> int:
	return 0


func get_upgrade_cost(level : int) -> Array[int] :
	if level > MAX_LEVEL:
		return [INF, INF, INF, INF]
	else:
		return [_data.wood_cost[level], _data.clay_cost[level], _data.iron_cost[level], _data.wheat_cost[level]]


func can_upgrade(wood : int, clay : int, iron : int, wheat : int) -> bool:
	if _is_upgrading or _level > MAX_LEVEL:
		return false
		
	var upgrade_cost = get_upgrade_cost(_level + 1)
	return  wood >= upgrade_cost[GlobalData.ResourceType.WOOD] \
		and clay >= upgrade_cost[GlobalData.ResourceType.CLAY] \
		and iron >= upgrade_cost[GlobalData.ResourceType.IRON] \
		and wheat >= upgrade_cost[GlobalData.ResourceType.WHEAT]
