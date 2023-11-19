extends CharacterBody2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var grab_area: Area2D = $"Grab Area"
@onready var weights_parent: Node2D = %"Weight Container"

const SPEED: int = 5
var grabbed: bool = false
var grabbed_weight: Node2D = null
var overlapping_areas: Array

@export var is_active: bool = false

var initial_position = Vector2(1050, 450)
var default_z_index = 25

func _ready():
	z_index = default_z_index
	reset_position()
	

func _process(_delta):
	if is_active:
		if Input.is_action_just_released("LMB"):
			animation_player.play_backwards()
		elif Input.is_action_pressed("LMB"):
			if not grabbed and Input.is_action_just_pressed("LMB"):
				if grab_area.has_overlapping_areas():
					overlapping_areas = grab_area.get_overlapping_areas()
					animation_player.play("grab")
				else:
					animation_player.play("close")

func _physics_process(_delta):
	if is_active:
		var mouse_position = get_global_mouse_position()
		var direction = mouse_position - position 
		
		velocity = direction * SPEED
		move_and_slide()
	
func _grab_weight():
	grabbed_weight = overlapping_areas[0].get_node("..")
	z_index = grabbed_weight.z_index + 1
	grabbed_weight.freeze = true
	grabbed_weight.reparent(self)
	self.move_child(grabbed_weight, 0)
	grabbed_weight.position = Vector2.ZERO
	grabbed = true

func _drop_weight_if_grabbed():
	if grabbed:
		z_index = default_z_index
		grabbed_weight.freeze = false
		grabbed_weight.reparent(weights_parent)
		grabbed = false
		grabbed_weight = null

func activate():
	reset_position()
	animation_player.play("appear")

func deactivate():
	is_active = false
	animation_player.play("disappear")

func reset_position():
	position = initial_position
	animation_player.play("RESET")

func set_active_flag():
	is_active = true
