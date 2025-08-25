extends Node2D
class_name DialoguePlayer

@onready var background: TextureRect = $Background
@onready var text_label: RichTextLabel = $"Text Label"
@onready var yes_button: BaseButton = $Yes
@onready var no_button: BaseButton = $No
@onready var job_manager: JobManager = %"Job Manager"
@onready var mouse_icon: Sprite2D = $Background/Lmb

var TEXT_SPEED: float = 6.0

var in_progress: bool = false
var is_animating: bool = false
var current_text: Array[String] = []

func _ready():
	disable()

func _process(_delta):
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
	mouse_icon.visible = false
	job_manager.on_dialogue_finished()
	
	if job_manager.is_waiting():
		show_buttons()
		enable_buttons()

func disable():
	text_label.text = ""
	background.visible = false
	hide_buttons()
	disable_buttons()

func is_in_progress():
	return in_progress

func show_buttons():
	yes_button.visible = true
	no_button.visible = true
	mouse_icon.visible = false
	
func hide_buttons():
	yes_button.visible = false
	no_button.visible = false
	mouse_icon.visible = true

func disable_buttons():
	yes_button.disabled = true
	no_button.disabled = true

func enable_buttons():
	yes_button.disabled = false
	no_button.disabled = false

func _on_yes_pressed():
	SignalBus.emit_signal("finish_job", true)

func _on_no_pressed():
	SignalBus.emit_signal("finish_job", false)
