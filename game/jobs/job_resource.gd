extends Resource

class_name Job

@export var customer_id: int
@export var punishment: int = 0
@export var dialogue: Array[String]

@export var is_task: bool = true
@export var answer: bool
@export var task_item: String
@export var task_item_units: float
@export var reward_item: String

@export var success_dialogue: Array[String]
@export var fail_dialogue: Array[String]

@export var on_sucess_id: String
@export var on_sucess_pos: int

@export var on_fail_id: String
@export var on_fail_pos: int

@export var is_ending: bool = false
@export var ending_id: int = 0
