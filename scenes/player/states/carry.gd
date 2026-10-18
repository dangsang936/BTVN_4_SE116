extends PlayerState

## Currently carrying something overhead.

const LIFT_TIME := 0.18
const CARRY_SPEED_SCALE := 0.6
const THROW_DISTANCE := 5.0
const THROW_TIME := 0.6

var _lift_tween: Tween = null
var _lifting: bool = false


func _enter() -> void:
	obj.stop_horizontal()
	obj.change_animation("carry_idle")
	if obj.held == null or not is_instance_valid(obj.held):
		change_state(fsm.states.idle)
		return
	obj.held.be_picked_up(obj.hold_point)
	_lifting = true
	_lift_tween = obj.create_tween()
	_lift_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	_lift_tween.tween_property(obj.held, "position", Vector3.ZERO, LIFT_TIME) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_lift_tween.finished.connect(func() -> void: _lifting = false)


func _exit() -> void:
	if _lift_tween != null and _lift_tween.is_valid():
		_lift_tween.kill()
	_lift_tween = null
	_lifting = false
	if obj.held != null and is_instance_valid(obj.held):
		obj.held.be_dropped(obj.held.global_position)
	obj.held = null


func _update(_delta: float) -> void:
	if _lifting:
		obj.stop_horizontal()
		return
	if obj.held == null or not is_instance_valid(obj.held):
		change_state(fsm.states.idle)
		return

	if Input.is_action_just_pressed("carry"):
		var thing: BaseCharacter = obj.held
		obj.held = null
		thing.be_thrown(_throw_velocity(thing))
		change_state(fsm.states.throw)
		return

	if move_by_input(CARRY_SPEED_SCALE):
		obj.change_animation("carry")
	else:
		obj.change_animation("carry_idle")


func _throw_velocity(thing: BaseCharacter) -> Vector3:
	var t := THROW_TIME
	var h := maxf(thing.global_position.y - obj.global_position.y, 0.0)
	var v: Vector3 = obj.forward() * (THROW_DISTANCE / t)
	v.y = (0.5 * thing.gravity * t * t - h) / t
	return v
