extends Node

class_name JobManager

@onready var customer_manager: CustomerManager = %Customers

@export var buffer: Array[Job]
var current: Job = null

func start_next_job():
	assert(is_job_available())
	current = buffer.pop_front() as Job
	
	customer_manager.set_customer_sprite(current.customer_id)
	customer_manager.enter()

func is_job_available():
	return len(buffer) >= 1
