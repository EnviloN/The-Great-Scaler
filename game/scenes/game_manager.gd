extends Node

@onready var customer_manager: Node2D = %Customers
@onready var animation_player: AnimationPlayer = $"AnimationPlayer"

var is_weighting: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	customer_manager.set_customer_sprite(0)
	customer_manager.enter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("RMB") and not animation_player.is_playing():
		_toggle_mode()

func _toggle_mode():
	if is_weighting:
		animation_player.play("sit")
		is_weighting = false
	else:
		animation_player.play("to_scale")
		is_weighting = true
