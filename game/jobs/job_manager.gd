extends Node

class_name JobManager

enum JobState {NONE, INIT, WAITING, FINISH}

@onready var customer_manager: CustomerManager = %Customers
@onready var dialogue_player: DialoguePlayer = %DialoguePlayer

@export var buffer: Array[Job]
var current: Job = null
var state: JobState = JobState.NONE

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
		dialogue_player.disable()
		customer_manager.leave()
