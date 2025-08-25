extends RigidBody2D

@onready var initial_position = position

func _physics_process(_delta):
	# low effort hack how to prevent breaking joints when pushing on scales from the side
	if position != initial_position:
		position = initial_position
