extends Node2D
class_name DialoguePlayer

@onready var background: TextureRect = $Background
@onready var text_label: RichTextLabel = $"Background/Text Label"
@onready var job_manager: JobManager = %"Job Manager"

var TEXT_SPEED: float = 8.0

var in_progress: bool = false
var is_animating: bool = false
var current_text: Array[String] = []

func _ready():
	background.visible = false

func _process(delta):
	if is_animating:
		text_label.visible_ratio += 1.0/text_label.text.length()/TEXT_SPEED
		if text_label.visible_ratio >= 1:
			skip_animation()

func skip_animation():
	text_label.visible_ratio = 1
	is_animating = false
	if current_text.size() == 0:
		finish()

func set_dialogue_text(dialogue: Array[String]):
	current_text = dialogue.duplicate()

func start_dialogue():
	background.visible = true
	in_progress = true
	show_text()

func show_text():
	is_animating = true
	text_label.visible_ratio = 0
	text_label.text = current_text.pop_front()

func next_line():
	if is_animating:
		skip_animation()
		return false
		
	if current_text.size() > 0:
		show_text()
		return true
	else:
		finish()
		return false

func finish():
	in_progress = false
	job_manager.on_dialogue_finished()

func disable():
	text_label.text = ""
	background.visible = false

func is_in_progress():
	return in_progress
