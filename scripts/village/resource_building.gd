class_name ResourceBuilding extends Building

const BUILDING_NAMES = ["Woodcutter", "Clay pit", "Iron mine", "Farm"]
@export var _resource : GlobalData.ResourceType

func _init(resource : GlobalData.ResourceType, village : Village) -> void:
	super(BUILDING_NAMES[resource], village)
	_resource = resource
	pass


func get_resource_amount() -> int:
	return _data.production[_level]
