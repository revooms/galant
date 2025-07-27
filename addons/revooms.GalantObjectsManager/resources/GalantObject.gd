extends Resource
class_name GalantObject

@export var uuid: String
@export var title: String = "Untitled Object"
@export var description: String = "Lorem ipsum"
@export var weight: float = 1.0
@export var grid_size: Vector2i = Vector2i(1,0)
@export var is_container: bool = false
@export var is_flammable: bool = false
@export var is_fluid: bool = false
@export var is_stackable: bool = false
@export var max_stack: int = 10
