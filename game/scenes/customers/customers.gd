extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var body_sprite: Sprite2D = $body
@onready var head_sprite: Sprite2D = $body/head

var customer_bodies: Array[Texture2D] = [
	preload("res://sprites/concept/customer/0.png"),
	preload("res://sprites/concept/customer/1.png"),
	preload("res://sprites/concept/customer/2.png"),
	preload("res://sprites/concept/customer/3.png")
]
var customer_heads: Array[Texture2D] = [
	preload("res://sprites/concept/customer/0_head.png"),
	preload("res://sprites/concept/customer/1_head.png"),
	preload("res://sprites/concept/customer/2_head.png"),
	preload("res://sprites/concept/customer/3_head.png")
]

func _ready():
	body_sprite.position.x = -1600

func set_customer_sprite(id: int):
	body_sprite.set_texture(customer_bodies[id])
	head_sprite.set_texture(customer_heads[id])	
	
func enter():
	animation_player.play("enter")

func leave():
	animation_player.play("leave")
	
func talk():
	animation_player.play("talk")
