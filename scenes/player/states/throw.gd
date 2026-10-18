extends PlayerState

## The throw pose.

func _enter() -> void:
	obj.change_animation("throw")
	obj.stop_horizontal()
	timer = 0.25


func _update(delta: float) -> void:
	if update_timer(delta):
		change_state(fsm.states.idle)
