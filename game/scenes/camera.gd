extends Camera2D

@onready var viewport_rect: Rect2 = get_viewport_rect()
@onready var center: Vector2 = viewport_rect.size / 2.0

var center_margin: float = 120
var target: Vector2 = center
var center_rect: Rect2
var viewport_scale: Vector2

var magic_constant: float = 12

# Called when the node enters the scene tree for the first time.
func _ready():
	var margin_vector: Vector2 = Vector2(center_margin, center_margin)
	center_rect = Rect2(margin_vector, viewport_rect.size - 2 * margin_vector)
	viewport_scale = Vector2(magic_constant/viewport_rect.size.x,
							 magic_constant/viewport_rect.size.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):							
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var offset = mouse_pos - center
	position = center + _scale(offset)

func _scale(offset: Vector2):
	offset = offset * viewport_scale
	return Vector2(
		exp(offset.x) - 1 if offset.x > 0 else -(exp(abs(offset.x)) - 1),
		exp(offset.y) - 1 if offset.y > 0 else -(exp(abs(offset.y)) - 1)		
	)
