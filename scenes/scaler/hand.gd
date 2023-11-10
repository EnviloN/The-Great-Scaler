extends CharacterBody2D


@onready var animation = $AnimatedSprite2D
@onready var grab_area: Area2D = $"Grab Area"
@onready var grab_joint: Node2D = $"Grab Joint"
@onready var weights_parent: Node2D = %"Weight Container"

const SPEED: int = 8
var grabbed: bool = false
var grabbed_weight: Node2D = null


func _ready():
	pass

func _process(_delta):
	if not Input.is_action_pressed("LMB") and animation.frame > 0:
		if grabbed: _drop_weight()
		animation.play_backwards()
	elif Input.is_action_pressed("LMB") and animation.frame < 2:
		if (not grabbed and Input.is_action_just_pressed("LMB") 
			and grab_area.has_overlapping_areas()):
			var overlapping = grab_area.get_overlapping_areas()
			_grab_weight(overlapping[0].get_node(".."))
		animation.play()

func _physics_process(_delta):
	var mouse_position = get_viewport().get_mouse_position()
	var direction = mouse_position - position 
	
	velocity = direction * SPEED
	move_and_slide()
	
func _grab_weight(weight: Node2D):
	grabbed_weight = weight
	grabbed_weight.freeze = true
	grabbed_weight.reparent(self)
	self.move_child(grabbed_weight, 0)
	grabbed_weight.position = Vector2.ZERO
#	grab_joint.node_b = grabbed_weight
	grabbed = true

func _drop_weight():
	grabbed_weight.freeze = false
	grabbed_weight.reparent(weights_parent)
	grabbed = false
	grabbed_weight = null
