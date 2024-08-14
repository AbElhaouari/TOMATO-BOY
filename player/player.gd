extends CharacterBody2D
@export var SPEED = 100
@export var jump_power = 30
@export var health = 10
var is_grounded = false
var GRAVITY = 10
var can_shoot = false
enum State {Idle ,Run , Shoot_Run , Shoot , Jump}
var current_state 
var did_shoot = false
var damage_rate
var is_dead = false
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var progress_bar = $CanvasLayer/ProgressBar

@onready var marker_2d = %Marker2D
const BULLET = preload("res://player/bullet.tscn")
var direction
var shooting_point
func _ready():
	shooting_point = marker_2d.position
	current_state = State.Idle
	progress_bar.max_value = health
	progress_bar.value = health
	progress_bar.show_percentage = false
	
func _physics_process(delta):
	progress_bar.value=health
	damage_rate = delta
	if velocity.y == 0 :
		is_grounded = true
	else:
		is_grounded=  false

	player_moving()
	player_jump()
	player_shoot()
	player_animation()
	move_and_slide()
	
	if health<=0:
		is_dead=true
	
	
func player_moving():
	direction = Input.get_axis("move_left","move_right")
	velocity.x = direction * SPEED
	velocity.y += GRAVITY
	if velocity.x == 0 and !did_shoot:
		current_state = State.Idle
	if velocity.x != 0 and !did_shoot:
		current_state = State.Run
		
	if marker_2d.position.x <0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false

func player_jump():
	if Input.is_action_just_pressed("jump") and is_grounded:
		velocity.y -= GRAVITY * jump_power
	if not is_grounded:
		current_state = State.Jump
func player_shoot():
	var direction = Input.get_axis("move_left","move_right")	
	if Input.is_action_just_pressed("shoot") and can_shoot:
		if velocity.x == 0:
			current_state = State.Shoot
		if velocity.x != 0:
			current_state = State.Shoot_Run
		did_shoot =true
		can_shoot = false
		print(global_position)
		var b = BULLET.instantiate()
		get_parent().add_child(b)
		b.global_position = marker_2d.global_position
		b.dir = direction
		#shooting while standing and we devide the posision by the position to get value of 1 or -1
		if direction ==0:
			if marker_2d.position.x > 0:
				b.dir = marker_2d.position.x / marker_2d.position.x
			elif marker_2d.position.x < 0:
				b.dir = -marker_2d.position.x / marker_2d.position.x

	#changing the position of the shooting point based on the direction of the  player
	if direction > 0 :
		marker_2d.position.x = shooting_point.x
	elif direction < 0 :
		marker_2d.position.x = -shooting_point.x
	

func _on_hurt_box_area_entered(area):
	print(area)
	if area.name== "SpikeTrap":
		health -= 3
		
	if area.name == "Enemy_Bullet":
		health -= 1
		
		



func _on_hurt_box_body_entered(body):
	pass
	
	#if body.name == "Melee_Enemy":
		#health-=1
	


func _on_timer_timeout():
	can_shoot = true
	did_shoot = false
	




func player_animation():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state ==State.Shoot:
		animated_sprite_2d.play("shoot")
	elif current_state == State.Run:
		animated_sprite_2d.play("run")
	elif current_state == State.Shoot_Run:
		animated_sprite_2d.play("shoot_run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("jump")
		


