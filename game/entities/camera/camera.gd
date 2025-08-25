extends Camera2D

enum State {ACTIVE, IDLE, INACTIVE}

@onready var viewport_rect: Rect2 = get_viewport_rect()
@onready var center: Vector2 = viewport_rect.size / 2.0
@onready var inactive_target: Vector2 = center - Vector2(0,260)

var viewport_scale: Vector2
var state: State = State.INACTIVE
var magic_constant: float = 12


# Called when the node enters the scene tree for the first time.
func _ready():
	viewport_scale = Vector2(magic_constant/viewport_rect.size.x,
							 magic_constant/viewport_rect.size.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == State.ACTIVE:
		var mouse_pos: Vector2 = get_viewport().get_mouse_position()
		var camera_offset = mouse_pos - center
		var target = center + _scale(camera_offset)
		position = position + (target - position) * delta
	elif state == State.IDLE:
		position = position + (center - position) * delta
	elif state == State.INACTIVE:
		position = position + (inactive_target - position) * delta

func _scale(pos: Vector2):
	pos = pos * viewport_scale
	return Vector2(
		exp(pos.x) - 1 if pos.x > 0 else -(exp(abs(pos.x)) - 1),
		exp(pos.y) - 1 if pos.y > 0 else -(exp(abs(pos.y)) - 1)
	)

func activate():
	state = State.ACTIVE
	
func deactivate():
	state = State.INACTIVE

func idle():
	state = State.IDLE
