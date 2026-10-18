extends PlayerState

@export var release_delay: float = 0.08
@export var pose_time: float = 0.3

var _release_timer: float = 0.0
var _released: bool = false


func _enter() -> void:
	obj.change_animation("throw")
	obj.stop_horizontal()
	_released = false
	_release_timer = release_delay
	timer = pose_time


func _update(delta: float) -> void:
	if not _released:
		_release_timer -= delta
		if _release_timer <= 0.0:
			obj.throw_knife()
			_released = true
	if update_timer(delta):
		change_state(fsm.states.idle)
