extends CharacterBody2D
class_name Enemy

@export var knockback_intensity: float
@export var health: int = 1

enum State { IDLE, DAMAGED }
var state := State.IDLE

@onready var damage_emitter: Area2D = $DamageEmitter
@onready var damage_receiver: Area2D = $DamageReceiver

var player: Node2D
var speed = 100

func _ready() -> void:
	call_deferred("_find_player")
	damage_receiver.damage_received.connect(on_receive_damage.bind())

func _find_player():
	var path = "actors_container/coelho1"
	if get_tree().get_root().has_node(path):
		player = get_tree().get_root().get_node(path)
		print("✅ Player found:", player)
	else:
		print("❌ Player not found at path:", path)

func on_receive_damage(damage: int, direction: Vector2) -> void:
	health -= damage
	print(health)
	print(direction.x)
	if health <= 0:
		queue_free()

func _physics_process(delta):
	if player:
		var direction = (player.global_position - global_position)
		if direction.length() > 5:
			velocity = direction.normalized() * speed
		else:
			velocity = Vector2.ZERO
		move_and_slide()
