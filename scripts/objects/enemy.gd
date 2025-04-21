extends CharacterBody2D
class_name Enemy

@export var knockback_intensity: float
@export var health: int = 25

enum State { IDLE, DAMAGED }
var state := State.IDLE

@onready var damage_emitter: Area2D = $DamageEmitter
@onready var damage_receiver: Area2D = $DamageReceiver
@onready var player_detector: Area2D = $DamageReceiver

var player: Node2D
var speed = 100
var damage_explosion = 30

func _ready() -> void:
	call_deferred("_find_player")
	damage_receiver.damage_received.connect(on_receive_damage.bind())
	player_detector.body_entered.connect(_on_player_detected)

func _find_player():
	var path = "../coelho1"
	if has_node(path):
		player = get_node(path)
		print("✅ Player found:", player)
	else:
		print("❌ Player not found at path:", path)

func _on_player_detected(body):
	if body.name == "coelho1":
		body.state = body.State.HURT
		body.health -= damage_explosion
		queue_free()

func on_receive_damage(damage: int, direction: Vector2) -> void:
	health -= damage
	print(health)
	print(direction.x)
	if health <= 0:
		$AnimatedSprite2D.play("death")

func _physics_process(delta):
	if $AnimatedSprite2D.animation == "death":
		await get_tree().create_timer(0.25).timeout
		queue_free()
	
	if player:
		var direction = (player.global_position - global_position)
		$AnimatedSprite2D.flip_h = direction.x < 0
		
		if direction.length() > 5:
			velocity = direction.normalized() * speed
		else:
			velocity = Vector2.ZERO
		
		move_and_slide()
