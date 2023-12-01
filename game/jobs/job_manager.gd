extends Node

class_name JobManager

enum JobState {NONE, INIT, WAITING, FINISH}

@onready var customer_manager: CustomerManager = %Customers
@onready var dialogue_player: DialoguePlayer = %DialoguePlayer
@onready var weights_parent: Node2D = %"Weight Container"
@onready var game_manager: GameManager = %"Game Manager"

@onready var finish_timer: Timer = $"Finish Timer"
@onready var next_timer: Timer = $"Next Job Timer"

@export var buffer: Array[Job]
var current: Job = null
var state: JobState = JobState.NONE

var task_item: RigidBody2D = null
var item_parent: Node2D
var items: Dictionary = {
	"placeholder": preload("res://scenes/objects/job_items/placeholder.tscn"),
	"copper_ingot": preload("res://scenes/objects/job_items/copper_ingot.tscn"),
	"iron_ingot": preload("res://scenes/objects/job_items/iron_ingot.tscn"),
	"crown": preload("res://scenes/objects/job_items/crown.tscn"),
	"weight_175u_faul": preload("res://scenes/objects/weights/weight_175u_faul.tscn"),
	"weight_1u": preload("res://scenes/objects/weights/weight_1u.tscn"),
}

func _ready():
	SignalBus.connect("finish_job", on_finish_job)
	item_parent = $"../../Workspace/Scale".get_task_item_parent()

func start_next_job():
	assert(is_job_available())
	current = buffer.pop_front() as Job
	state = JobState.INIT
	
	if current.punishment > 0:
		game_manager.punish_player(current.punishment)
	dialogue_player.set_dialogue_text(current.dialogue) 
	customer_manager.set_customer_sprite(current.customer_id)
	if not current.is_task: state = JobState.FINISH
	_spawn_item()
	customer_manager.enter()

func is_job_available():
	return len(buffer) >= 1
	
func is_waiting():
	return state == JobState.WAITING

func on_dialogue_finished():
	if state == JobState.INIT:
		state = JobState.WAITING
	elif state == JobState.FINISH:
		state = JobState.NONE
		_spawn_reward()
		finish_timer.start()

func on_finish_job(answer: bool):
	if current.answer == answer:
		dialogue_player.set_dialogue_text(current.success_dialogue)
		if current.on_sucess_id != "":
			if not (current.on_sucess_id == "200" and game_manager.punishments >= 1):
				var next_job = _load_job_id(current.on_sucess_id)
				if current.on_sucess_pos <= -1:
					buffer.push_back(next_job)
				else:
					buffer.insert(current.on_sucess_pos, next_job)
	else:
		dialogue_player.set_dialogue_text(current.fail_dialogue) 
		if current.reward_item != "":
			current.reward_item = ""
		if current.on_fail_id != "":
			var next_job = _load_job_id(current.on_fail_id)
			if current.on_fail_pos <= -1:
				buffer.push_back(next_job)
			else:
				buffer.insert(current.on_fail_pos, next_job)
				
	_despawn_item()
	state = JobState.FINISH
	customer_manager.start_talking()
	dialogue_player.hide_buttons()
	
func finalize_job_queue():
	if game_manager.punishments >= 3:
		var next_job = _load_job_id("203")
		buffer.push_back(next_job)
		next_timer.start()
	elif game_manager.punishments >= 1:
		game_manager.end_game(1)

func _load_job_id(job_id: String):
	return load("res://jobs/{id}.tres".format({"id": job_id})) as Job
	
func _spawn_item():
	if current.is_task and current.task_item != "":
		task_item = items[current.task_item].instantiate() as RigidBody2D
		task_item.mass = current.task_item_units * Constants.units_to_kg
		item_parent.add_child(task_item)
		
func _despawn_item():
	if task_item != null:
		task_item.free()  # Will also set task_item = null
		
func _spawn_reward():
	if current.reward_item != "":
		var item = items[current.reward_item].instantiate() as RigidBody2D
		weights_parent.add_child(item)

func _on_finish_timer_timeout():
	if current.is_ending:
		game_manager.end_game(current.ending_id)
	else:
		dialogue_player.disable()
		customer_manager.leave()
		current = null
		if is_job_available():
			next_timer.start()
		else:
			finalize_job_queue()

func _on_next_job_timer_timeout():
	start_next_job()
