extends Area3D
class_name GrabArea3D

func find_carriable() -> BaseCharacter:
	var best: BaseCharacter = null
	var best_distance := INF
	for body in get_overlapping_bodies():
		if not (body is BaseCharacter) or not body.can_be_carried():
			continue
		var distance := global_position.distance_squared_to(body.global_position)
		if distance < best_distance:
			best_distance = distance
			best = body
	return best
