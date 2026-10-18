class_name Player
extends BaseCharacter

## Turned on throughout the Hurt state so one hit doesn't drain health every single frame in a row.
var is_invulnerable: bool = false

var held: BaseCharacter = null
@onready var hold_point: Marker3D = $HoldPoint
@onready var grab_area: GrabArea3D = $Direction/GrabArea3D

@export var knife_speed: float = 16.0
@export var knife_cooldown: float = 0.5
@onready var knife_factory: Node3DFactory = $Direction/KnifeFactory
var _knife_cooldown_left: float = 0.0

@export var spin_cooldown: float = 1.0
var _spin_cooldown_left: float = 0.0


func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Idle)
	super._ready()


func _physics_process(delta: float) -> void:
	_knife_cooldown_left = maxf(_knife_cooldown_left - delta, 0.0)
	_spin_cooldown_left = maxf(_spin_cooldown_left - delta, 0.0)
	super._physics_process(delta)


## Every state of the fox can take damage, so this calls straight into the current state; whichever
## state doesn't want to lose health (Dead) overrides take_damage().
func _on_hurt_area_3d_hurt(_direction: Vector3, damage: float) -> void:
	if is_invulnerable:
		return
	fsm.current_state.take_damage(int(damage))


func find_carriable() -> BaseCharacter:
	return grab_area.find_carriable()


func can_throw_knife() -> bool:
	return _knife_cooldown_left <= 0.0


func throw_knife() -> void:
	_knife_cooldown_left = knife_cooldown
	var knife := knife_factory.create()
	if knife == null:
		return
	knife.launch(forward() * knife_speed)


func can_spin() -> bool:
	return _spin_cooldown_left <= 0.0


func start_spin_cooldown() -> void:
	_spin_cooldown_left = spin_cooldown
