extends CharacterBody2D

var bullet_position: Vector2
var speed: float
@export var bullet_damage: float
var damage_emitter

func _ready() -> void:
	global_position = bullet_position
	damage_emitter = get_node("DamageEmitter")
	damage_emitter.area_entered.connect(on_emit_damage.bind())
	
func _physics_process(delta: float) -> void:
	velocity = Vector2(speed,0)
	move_and_slide()
	
func on_emit_damage(damage_receiver: DamageReceiver) -> void:
	var direction := Vector2.LEFT if damage_receiver.global_position.x < global_position.x else Vector2.RIGHT
	damage_receiver.damage_received.emit(bullet_damage,direction)
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
