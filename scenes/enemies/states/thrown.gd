extends EnemyState

const MIN_FLIGHT_TIME := 0.1
const KILL_HEIGHT := -30.0

const THROWN_HIT_SHAPE := "Direction/ThrownHitArea3D/CollisionShape3D"

var _can_land: bool = false


func _enter() -> void:
	obj.movement_enabled = true
	obj.change_animation("hurt")
	obj.set_shape_disabled("CollisionShape3D", false)
	obj.set_shape_disabled(THROWN_HIT_SHAPE, not obj.thrown_harmful)
	_can_land = false
	timer = MIN_FLIGHT_TIME


func _exit() -> void:
	obj.set_shape_disabled(THROWN_HIT_SHAPE, true)
	obj.set_carry_shapes_disabled(false)
	obj.stop_horizontal()


func _update(delta: float) -> void:
	if update_timer(delta):
		_can_land = true
	if obj.global_position.y < KILL_HEIGHT:
		obj.queue_free()
		return
	if _can_land and obj.is_on_floor():
		change_state(fsm.default_state)


func take_damage(_damage_dir: Vector3, _damage: float) -> void:
	pass
