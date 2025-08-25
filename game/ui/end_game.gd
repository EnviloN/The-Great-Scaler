extends Node2D

@onready var sprtite = $Sprite2D
@onready var label = $Sprite2D/RichTextLabel
@onready var timer = $Timer

func _ready():
	sprtite.visible = false

func end_game(text: String):
#	label.text = "[center]" + text + "[/center]"
	timer.start()
	

func _on_timer_timeout():
	sprtite.visible = true
