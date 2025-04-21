class_name Character
extends CharacterBody2D

@export var health: int
@export var meele_damage: int
@export var speed: float

var animation_player
var character_sprite
var sprite_position
var damage_emitter
var damage_receiver
var collision_shape
enum State {IDLE,WALK,ATTACK,TAKEOFF,JUMP,LAND,JUMPLOOP,FIRE,DEATH,RELOAD,HURT}
var state = State.IDLE

func _ready() -> void:
	animation_player = get_node("SpritePosition/AnimatedSprite2D/AnimationPlayer")
	character_sprite = get_node("SpritePosition/AnimatedSprite2D")
	sprite_position = get_node("SpritePosition")
	damage_emitter = get_node("DamageEmitter")
	damage_receiver = get_node("DamageReceiver")
	collision_shape = get_node("CollisionShape2D")
	damage_emitter.area_entered.connect(on_emit_damage.bind())
	damage_receiver.damage_received.connect(on_receive_damage.bind())
	
func handle_animations() -> void:
	if state == State.IDLE:
		animation_player.play("idle")
	elif state == State.WALK:
		animation_player.play("walk")
	elif state == State.ATTACK:
		animation_player.play("attack")
	elif state == State.JUMP:
		animation_player.play("jump")
	elif state == State.JUMPLOOP:
		animation_player.play("jump_loop")
	elif state == State.TAKEOFF:
		animation_player.play("takeoff")
	elif state == State.LAND:
		animation_player.play("land")	
	elif state == State.FIRE:
		animation_player.play("fire")
	elif state == State.DEATH:
		animation_player.play("dying")
	elif state == State.HURT:
		animation_player.play("hurt")
		
func flip_sprites() -> void:
	pass
		
func can_attack() -> bool:
	return state == State.IDLE or state == State.WALK

func can_move() -> bool:
	return state == State.IDLE or state == State.WALK
	
func on_action_complete() -> void:
	state = State.IDLE

func on_emit_damage(damage_receiver: DamageReceiver) -> void:
	var direction := Vector2.LEFT if damage_receiver.global_position.x < global_position.x else Vector2.RIGHT
	damage_receiver.damage_received.emit(meele_damage,direction)
	#print(damage_receiver)

func on_receive_damage(damage: int, direction: Vector2) -> void:
	health -= damage
	state = State.HURT
