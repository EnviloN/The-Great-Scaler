extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready():
	animation_player.play("RESET")

func sit():
	animation_player.play("sit")

func stand():
	animation_player.play("stand")
