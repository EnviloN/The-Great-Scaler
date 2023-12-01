extends Node
class_name CustomerManager

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var body_sprite: Sprite2D = $body
@onready var head_sprite: Sprite2D = $body/head
@onready var dialogue_player: DialoguePlayer = %DialoguePlayer
@onready var audio_stream: AudioStreamPlayer2D = $"../../../AudioStreamPlayer"



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

var voices: Dictionary = {}

func _ready():
	body_sprite.position.x = -1600
	SignalBus.connect("progress_dialogue", on_progress_dialogue)
	
	for i in range(7):
		if i in [3, 4]: continue
		var dir_path = "res://sounds/voices/{id}".format({"id": i})
		var files = DirAccess.get_files_at(dir_path)
		var sounds = []
		for file in files:
			if not file.ends_with(".import"):
				sounds.append(load(dir_path + "/{file}".format({"file": file})))
		
		voices[i] = sounds
		
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
	var sound = (voices[id] as Array).pick_random()
	audio_stream.stream = sound
	audio_stream.play()

func start_talking():
	dialogue_player.start_dialogue()
	talk()

func on_progress_dialogue():
	if dialogue_player.is_in_progress():
		var success = dialogue_player.next_line()
		if success:
			talk()
