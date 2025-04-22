class_name Coelho1
extends Character
#pulo
var jump_intensity = 100
var speed_on_jump = 500
var height := 0
var height_speed 
const GRAVITY := 600.0
var default_speed = 200 #VARIAVEL AUXILIAR QUE DEVE TER O MESMO VALOR DA SPEED

#arma
var ammo = 30
var bullet_path = preload ("res://scenes/objects/bullet.tscn")
@onready var bullet_flip = $BulletFlip
var bullet_speed = 2000

func _physics_process(delta: float) -> void:
	if can_fire() and Input.is_action_just_pressed("attack"):
		shoot()
		state = State.FIRE

func _process(delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animations()
	handle_air_time(delta)
	flip_sprites()
	character_sprite.position = Vector2.UP * height
	die()
	move_and_slide()

func handle_input() -> void:
	var direction := Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = direction*speed	
	if can_jump() and Input.is_action_just_pressed("jump"):
		state = State.TAKEOFF
		
func handle_movement() -> void:
	if can_move():
		if velocity.length() == 0:
			state = State.IDLE
		else:
			state = State.WALK
	
func handle_air_time(delta:float) -> void:
	if state == State.JUMPLOOP:
		height += height_speed*delta
		speed = speed_on_jump
		if height < 0:
			height = 0
			height_speed = jump_intensity
			speed = default_speed
			state = State.LAND
		else:
			height_speed -= GRAVITY*delta

func flip_sprites() -> void:
	if velocity.x > 0:
		sprite_position.scale.x = 1
		sprite_position.position.x = 75
		damage_emitter.scale.x = 1
		bullet_flip.scale.x = 1
	elif velocity.x < 0:
		sprite_position.scale.x = -1
		sprite_position.position.x = -75
		damage_emitter.scale.x = -1
		bullet_flip.scale.x = -1
		#bullet_direction = -1

func can_jump() -> bool:
	return state == State.IDLE or state == State.WALK

func on_takeoff_complete() -> void:
	if state == State.TAKEOFF:
		state = State.JUMP
		height_speed = jump_intensity
	
func on_land_complete() -> void:
	state = State.IDLE

func on_jump_animation_end() -> void:
	state = State.JUMPLOOP

func can_fire() -> bool:
	return state == State.IDLE or state == State.WALK
	
func shoot():
	var bullet = bullet_path.instantiate()
	get_parent().add_child(bullet)
	if bullet_flip.scale.x == 1:
		bullet.speed = bullet_speed
	elif bullet_flip.scale.x == -1:
		bullet.speed = -bullet_speed
	bullet.position = $BulletFlip/BulletSpawn.global_position
	
func die():
	if health <= 0:
		print("Player morreu")
		get_tree().change_scene_to_file("res://GameOver.tscn")
