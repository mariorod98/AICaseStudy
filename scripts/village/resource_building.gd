class_name ResourceBuilding extends Building

const BUILDING_NAMES = ["Woodcutter", "Clay pit", "Iron mine", "Farm"]
@export var _resource : GlobalData.ResourceType

func _init(resource : GlobalData.ResourceType, village : Village) -> void:
	super(BUILDING_NAMES[resource], village)
	_resource = resource
	
	if _resource == GlobalData.ResourceType.WOOD:
		_data = load("res://resources/buildingData/wood_building_data.tres")
	if _resource == GlobalData.ResourceType.CLAY:
		_data = load("res://resources/buildingData/clay_building_data.tres")
	if _resource == GlobalData.ResourceType.IRON:
		_data = load("res://resources/buildingData/iron_building_data.tres")
	if _resource == GlobalData.ResourceType.WHEAT:
		_data = load("res://resources/buildingData/wheat_building_Data.tres")
	pass

func get_production() -> int:
	return _data.production[_level]
	
func update() -> void:
	_village.update_resource(_resource, get_production(), true)
