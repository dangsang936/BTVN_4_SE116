extends EnemyState

func _enter() -> void:
	obj.movement_enabled = false
	obj.stop_move()
	obj.set_carry_shapes_disabled(true)
	obj.change_animation("run")


func take_damage(_damage_dir: Vector3, _damage: float) -> void:
	pass
