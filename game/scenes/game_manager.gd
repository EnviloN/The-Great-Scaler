extends Node

@onready var customer_manager: Node2D = %Customers

# Called when the node enters the scene tree for the first time.
func _ready():
#	Input.set_mouse_mode(Input.)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("RMB"):
		customer_manager.enter()
