extends CharacterBody2D

@export var speed = 400

func get_input():
	var mouse_pos = get_global_mouse_position()
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
