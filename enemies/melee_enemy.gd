extends CharacterBody2D
var health = 5
var detected_left = false
var detected_right = false
var GRAVITY = 10
var can_attack=false
var damage = 3
@export var p :CharacterBody2D
@export var original_dir :Marker2D
@onready var progress_bar = $ProgressBar
@onready var animated_sprite_2d = $AnimatedSprite2D



enum State {Idle , Attack}
var current_state 
func _ready():
	progress_bar.max_value = health 
	progress_bar.value = health
	current_state =State.Idle
	
	
func _physics_process(delta):
	velocity.y += GRAVITY
	
	move_toward_player(delta)
	if health == 0 :
		queue_free()
	progress_bar.value = health
	enemy_animation()
	flip_enemy()
	move_and_slide()	

func move_toward_player(delta):
	
	if detected_left:
		var dir = p.position.x - position.x
		velocity.x = dir / .2 * delta
		print(dir)
		detected_right = false
	if detected_right:
		var dir = p.position.x + position.x
		velocity.x = dir / 1* delta
		print(dir)
		detected_left = false
	if !detected_left and !detected_right or p.velocity.y !=0:
		velocity.x = 0

func flip_enemy():
	if velocity.x > 0 :
		animated_sprite_2d.flip_h = true
	elif velocity.x < 0 :
		animated_sprite_2d.flip_h = false

func _on_enemy_hitbox_area_entered(area):
	if area.name == "Bullet":
		health-=1
		

func enemy_animation():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Attack:
		animated_sprite_2d.play("attack")


func _on_timer_timeout():
	if can_attack:
		p.health-=1




# detection -------------------------------------------------
func _on_enemy_hitbox_body_entered(body):
	print(body)
	if body.name=="Player":
		can_attack = true


func _on_enemy_hitbox_body_exited(body):
	if body.name=="Player":
		can_attack= false


func _on_detect_player_area_right_body_entered(body):
	if body.name =="Player":
		detected_right=true


func _on_detect_player_area_left_body_entered(body):
	if body.name =="Player":
		detected_left=true


func _on_detect_player_area_left_body_exited(body):
	if body.name =="Player":
		detected_left=false

func _on_detect_player_area_right_body_exited(body):
	if body.name =="Player":
		detected_left=false
