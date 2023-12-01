extends Node2D

@onready var item_parent = $"Base/Beam Joint/Beam/Left Pan Joint/Left Pan/Task Item Parent"
@export var debug : bool = true

@export_group("Joint")
@export var softness: float = 0
@export var stiffness: float = 20
@export var damping: float = 1
@export var length: float = 50
@export var rest_length: float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$"Base/Beam Joint".softness = softness
	_update_springs()

func get_task_item_parent():
	return item_parent

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if debug:
		$"Base/Beam Joint".softness = softness
		_update_springs()
	
func _update_springs():
	$"Base/DampedSpringJoint Left".stiffness = stiffness
	$"Base/DampedSpringJoint Left".damping = damping
	$"Base/DampedSpringJoint Left".length = length
	$"Base/DampedSpringJoint Left".rest_length = rest_length
	
	$"Base/DampedSpringJoint Right".stiffness = stiffness
	$"Base/DampedSpringJoint Right".damping = damping
	$"Base/DampedSpringJoint Right".length = length
	$"Base/DampedSpringJoint Right".rest_length = rest_length
