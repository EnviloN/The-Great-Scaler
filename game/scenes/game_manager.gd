extends Node
class_name GameManager

@onready var customer_manager: CustomerManager = %Customers
@onready var animation_player: AnimationPlayer = $"AnimationPlayer"
@onready var job_manager: JobManager = %"Job Manager"
@onready var dialogue_player: DialoguePlayer = %DialoguePlayer

@onready var toggle_hint: Node2D = $"../ParallaxBackground/ParallaxLayer2/ToggleHint"
@onready var grab_hint: Node2D = $"../ParallaxBackground/ParallaxLayer3/GrabHint"

var is_weighting: bool = false
var punishments: int = 0

var toggle_hint_visible: bool = false
var grab_hint_visible: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	toggle_hint.visible = false
	grab_hint.visible = false
	job_manager.start_next_job()
	
func show_toggle_hint():
	toggle_hint_visible = true
	toggle_hint.visible = true

func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if (event.is_action_pressed("RMB") and just_pressed
	and job_manager.is_waiting() and not animation_player.is_playing()):
		if grab_hint_visible:
			grab_hint.visible = false
			grab_hint_visible = false
		_toggle_mode()
	if (event.is_action_pressed("LMB") and just_pressed
	and not job_manager.is_waiting()):
		SignalBus.emit_signal("progress_dialogue")
		
func punish_player(severity: int):
	punishments += severity
	print("Punishment: {p}".format({"p": punishments}))

func end_game(ending: int):
	if ending == 1:
		print("neutral_ending")
	elif ending == 2:
		print("good ending")
	elif ending == 3:
		print("bad ending")

func _toggle_mode():
	if is_weighting:
		animation_player.play("sit")
		dialogue_player.enable_buttons()
		is_weighting = false
	else:
		animation_player.play("to_scale")
		dialogue_player.disable_buttons()
		is_weighting = true
		if toggle_hint_visible:
			toggle_hint_visible = false
			toggle_hint.visible = false
			grab_hint.visible = true
			grab_hint_visible = true
