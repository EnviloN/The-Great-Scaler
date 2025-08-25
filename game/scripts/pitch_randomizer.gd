extends AudioStreamPlayer2D

class_name PitchRandomizedPlayer

@export var min_pitch: float = 0.9
@export var max_pitch: float = 1.1

func one_shot(from_position=0.0):
	pitch_scale = randf_range(min_pitch, max_pitch)
	play(from_position)
