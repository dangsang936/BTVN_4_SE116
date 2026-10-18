extends RigidBody3D

@export var lifetime: float = 1.2


func _ready() -> void:
	$HitArea3D.hitted.connect(_on_hitted)
	body_entered.connect(_on_body_entered)
	get_tree().create_timer(lifetime).timeout.connect(queue_free)


func launch(velocity: Vector3) -> void:
	if velocity.length_squared() > 0.0001:
		look_at(global_position + velocity, Vector3.UP)
	linear_velocity = velocity


func _on_hitted(_area: Area3D) -> void:
	queue_free()


func _on_body_entered(_body: Node) -> void:
	queue_free()
