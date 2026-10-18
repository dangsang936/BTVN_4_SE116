extends PlayerState

const SPIN_ORDER: Array[String] = ["down", "right", "up", "left"]

@export var spin_time: float = 0.4
@export var turn_interval: float = 0.08

var _turn_timer: float = 0.0
var _turn_index: int = 0


func _enter() -> void:
	obj.start_spin_cooldown()
	obj.stop_horizontal()
	obj.change_animation("attack")
	_turn_index = maxi(SPIN_ORDER.find(obj.direction), 0)
	_turn_timer = turn_interval
	timer = spin_time
	_hit_shape().disabled = false


func _exit() -> void:
	_hit_shape().disabled = true


func _update(delta: float) -> void:
	obj.stop_horizontal()
	_turn_timer -= delta
	if _turn_timer <= 0.0:
		_turn_timer += turn_interval
		_turn_index = (_turn_index + 1) % SPIN_ORDER.size()
		obj.change_direction(SPIN_ORDER[_turn_index])
	if update_timer(delta):
		change_state(fsm.states.idle)


func _hit_shape() -> CollisionShape3D:
	return obj.get_node("SpinHitArea3D/CollisionShape3D")
