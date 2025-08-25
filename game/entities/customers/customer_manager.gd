class_name CustomerManager
extends Node

## Dictionary of all customers.
@export var customers: Dictionary[Customer.Customers, Customer] = {}

var _current_customer: Customer.Customers = Customer.Customers.PEASANT

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var body_sprite: Sprite2D = $body
@onready var head_sprite: Sprite2D = $body/head

@onready var dialogue_player: DialoguePlayer = %DialoguePlayer
@onready var audio_stream: PitchRandomizedPlayer = $"../../../AudioStreamPlayer"

# TODO: Delete this once the "Jobs system" is refactored
var id_to_customer= {
	0: [Customer.Customers.PEASANT, ""],
	1: [Customer.Customers.WIFE, ""],
	2: [Customer.Customers.KING, ""],
	3: [Customer.Customers.KING, "good"],
	4: [Customer.Customers.KING, "bad"],
	5: [Customer.Customers.BUTCHER, ""],
	6: [Customer.Customers.ELDER, ""],
}

func _ready():
	body_sprite.position.x = -1600
	SignalBus.connect("progress_dialogue", on_progress_dialogue)

func set_customer_sprite(id: int):
	# TODO: Remove this function once the "Jobs system" is refactored
	assert(id in id_to_customer)
	var customer_info = id_to_customer[id]
	set_customer(customer_info[0], customer_info[1])

func set_customer(customer: Customer.Customers, variant: String = ""):
	assert(customer in customers)

	_current_customer = customer
	var visuals = customers[customer].get_visuals(variant) as CustomerVisualVariant
	body_sprite.set_texture(visuals.body)
	head_sprite.set_texture(visuals.head)

func enter():
	animation_player.play("enter")

func leave():
	animation_player.play("leave")

func talk():
	_play_random_voice()
	animation_player.play("talk")

func _play_random_voice():
	var sound = customers[_current_customer].voices.pick_random() as AudioStreamMP3
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
