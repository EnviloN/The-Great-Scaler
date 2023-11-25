extends Resource

class_name Job

@export var id: int
@export var is_base: bool

@export var customer_id: int
@export var item: String
@export var answer: bool

@export var dialogue: Array[String]
@export var success_dialogue: Array[String]
@export var fail_dialogue: Array[String]

@export var on_sucess_id: int
@export var on_sucess_pos: int

@export var on_fail_id: int
@export var on_fail_pos: int
