extends CharacterBody2D
@export var health = 10
var GRAVITY = 10
const Bullet = preload("res://player/bullet.gd")
const ENEMY_BULLET = preload("res://enemies/enemy_bullet.tscn")
var dir = -1
@onready var marker_2d = $Marker2D
var can_shoot = false
@onready var progress_bar = $ProgressBar
@onready var animated_sprite_2d = $AnimatedSprite2D
enum State {Idle , Attack}
var current_state 
func _ready():
	progress_bar.value = health
	progress_bar.max_value = health
	current_state =State.Idle

func _physics_process(delta):
	velocity.y += GRAVITY
	enemy_animation()
	move_and_slide()
	if health == 0:
		queue_free()
	progress_bar.value = health


func _on_hit_box_area_entered(area):
	if area.name == "Bullet":
		health -=1
		
		
	
func _on_detect_body_entered(body):
	if body.name == "Player":
		can_shoot=true
		current_state = State.Attack
		
	
	
func enemy_shoot ():
	var e_bullet = ENEMY_BULLET.instantiate()
	get_parent().add_child(e_bullet)
	e_bullet.global_position = marker_2d.global_position
	e_bullet.dir = dir
	


func _on_timer_timeout():
	if can_shoot:
		enemy_shoot ()

func _on_detect_body_exited(body):
	if body.name == "Player":
		can_shoot=false
		current_state = State.Idle
func enemy_animation():
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Attack:
		animated_sprite_2d.play("attack")
