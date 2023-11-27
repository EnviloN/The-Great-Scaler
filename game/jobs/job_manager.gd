extends Node

class_name JobManager

enum JobState {NONE, INIT, WAITING, FINISH}

@onready var customer_manager: CustomerManager = %Customers
@onready var dialogue_player: DialoguePlayer = %DialoguePlayer

@onready var finish_timer: Timer = $"Finish Timer"
@onready var next_timer: Timer = $"Next Job Timer"

@export var buffer: Array[Job]
var current: Job = null
var state: JobState = JobState.NONE

func _ready():
	SignalBus.connect("finish_job", on_finish_job)

func start_next_job():
	assert(is_job_available())
	current = buffer.pop_front() as Job
	state = JobState.INIT
	
	dialogue_player.set_dialogue_text(current.dialogue) 
	customer_manager.set_customer_sprite(current.customer_id)
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
		finish_timer.start()

func on_finish_job(answer: bool):
	if current.answer == answer:
		dialogue_player.set_dialogue_text(current.success_dialogue)
		if current.on_sucess_id != 0:
			var next_job = _load_job_id(current.on_sucess_id)
			if current.on_sucess_pos <= -1:
				buffer.push_back(next_job)
			else:
				buffer.insert(current.on_sucess_pos, next_job)
	else:
		dialogue_player.set_dialogue_text(current.fail_dialogue) 
		if current.on_fail_id != 0:
			var next_job = _load_job_id(current.on_fail_id)
			if current.on_fail_pos <= -1:
				buffer.push_back(next_job)
			else:
				buffer.insert(current.on_fail_pos, next_job)
				
	state = JobState.FINISH
	customer_manager.start_talking()
	dialogue_player.hide_buttons()
	
func _load_job_id(job_id: int):
	return load("res://jobs/{id}.tres".format({"id": job_id})) as Job

func _on_finish_timer_timeout():
	dialogue_player.disable()
	customer_manager.leave()
	current = null
	if is_job_available():
		next_timer.start()

func _on_next_job_timer_timeout():
	start_next_job()
