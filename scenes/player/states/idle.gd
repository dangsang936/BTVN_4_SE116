extends PlayerState

func _enter() -> void:
	obj.change_animation("idle")

func _update(_delta: float) -> void:
	if control_attack():
		return
	if control_skill():
		return
	if control_spin():
		return
	if control_carry():
		return
	control_jump()
	control_moving()
	if not obj.is_on_floor():
		change_state(fsm.states.fall)
