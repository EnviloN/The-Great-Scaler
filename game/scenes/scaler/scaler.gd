extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("RESET")

func sit():
	animation_player.play("sit")

func stand():
	animation_player.play("stand")
