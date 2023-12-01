extends Node
class_name CustomerManager

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var body_sprite: Sprite2D = $body
@onready var head_sprite: Sprite2D = $body/head
@onready var dialogue_player: DialoguePlayer = %DialoguePlayer
@onready var audio_stream: PitchRandomizedPlayer = $"../../../AudioStreamPlayer"

var current_customer_id: int = 0

var customer_bodies: Array[Texture2D] = [
	preload("res://sprites/customers/0/0.PNG"),
	preload("res://sprites/customers/1/1.PNG"),
	preload("res://sprites/customers/2/2.PNG"),
	preload("res://sprites/customers/3/3.PNG"),
	preload("res://sprites/customers/4/4.PNG"),
	preload("res://sprites/customers/5/5.PNG"),
	preload("res://sprites/customers/6/6.PNG")
]
var customer_heads: Array[Texture2D] = [
	preload("res://sprites/customers/0/0_head.PNG"),
	preload("res://sprites/customers/1/1_head.PNG"),
	preload("res://sprites/customers/2/2_head.PNG"),
	preload("res://sprites/customers/3/3_head.PNG"),
	preload("res://sprites/customers/4/4_head.PNG"),
	preload("res://sprites/customers/5/5_head.PNG"),
	preload("res://sprites/customers/6/6_head.PNG")
]

var voices: Dictionary = {
	0: [
		preload("res://sounds/voices/0/1.mp3"),
		preload("res://sounds/voices/0/2.mp3"),
		preload("res://sounds/voices/0/3.mp3"),
		preload("res://sounds/voices/0/4.mp3"),
		preload("res://sounds/voices/0/5.mp3"),
		preload("res://sounds/voices/0/6.mp3"),
		preload("res://sounds/voices/0/7.mp3"),
		preload("res://sounds/voices/0/8.mp3")
	],
	1: [
		preload("res://sounds/voices/1/1.mp3"),
		preload("res://sounds/voices/1/2.mp3"),
		preload("res://sounds/voices/1/3.mp3"),
		preload("res://sounds/voices/1/4.mp3"),
		preload("res://sounds/voices/1/5.mp3"),
		preload("res://sounds/voices/1/6.mp3"),
		preload("res://sounds/voices/1/7.mp3"),
		preload("res://sounds/voices/1/8.mp3")
	],
	2: [
		preload("res://sounds/voices/2/1.mp3"),
		preload("res://sounds/voices/2/2.mp3"),
		preload("res://sounds/voices/2/3.mp3"),
		preload("res://sounds/voices/2/4.mp3"),
		preload("res://sounds/voices/2/5.mp3"),
		preload("res://sounds/voices/2/6.mp3"),
		preload("res://sounds/voices/2/7.mp3"),
		preload("res://sounds/voices/2/8.mp3")
	],
	5: [
		preload("res://sounds/voices/5/1.mp3"),
		preload("res://sounds/voices/5/2.mp3"),
		preload("res://sounds/voices/5/3.mp3"),
		preload("res://sounds/voices/5/4.mp3"),
		preload("res://sounds/voices/5/5.mp3"),
		preload("res://sounds/voices/5/6.mp3"),
		preload("res://sounds/voices/5/7.mp3")
	],
	6: [
		preload("res://sounds/voices/6/1.mp3"),
		preload("res://sounds/voices/6/2.mp3"),
		preload("res://sounds/voices/6/3.mp3"),
		preload("res://sounds/voices/6/4.mp3"),
		preload("res://sounds/voices/6/5.mp3"),
		preload("res://sounds/voices/6/6.mp3"),
		preload("res://sounds/voices/6/7.mp3")
	]
}

func _ready():
	body_sprite.position.x = -1600
	SignalBus.connect("progress_dialogue", on_progress_dialogue)
	
func set_customer_sprite(id: int):
	current_customer_id = id
	body_sprite.set_texture(customer_bodies[id])
	head_sprite.set_texture(customer_heads[id])	
	
func enter():
	animation_player.play("enter")

func leave():
	animation_player.play("leave")
	
func talk():
	_play_random_voice()
	animation_player.play("talk")
	
func _play_random_voice():
	var id = current_customer_id if not current_customer_id in [3,4] else 2
	var sound = voices[id].pick_random() as AudioStreamMP3
	audio_stream.stream = sound
	audio_stream.one_shot()

func start_talking():
	dialogue_player.start_dialogue()
	talk()

func on_progress_dialogue():
	if dialogue_player.is_in_progress():
		var success = dialogue_player.next_line()
		if success:
			talk()
