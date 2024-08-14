extends Node2D
@export var player :CharacterBody2D
@onready var game_over_canvas = $gameOver_canvas
@onready var you_won_canvas = $youWon_canvas

@export var end_point : Area2D
func _ready():
		game_over_canvas.visible= false
		you_won_canvas.visible= false
	
func _process(delta):
	if player.is_dead:
		game_over_canvas.visible= true
		get_tree().paused=true

func _on_button_pressed():
	get_tree().paused=false
	get_tree().reload_current_scene()



func _on_area_2d_body_entered(body):
	if body.name == "Player":
		you_won_canvas.visible= true
		get_tree().paused=true


func _on_won_button_pressed():
	get_tree().paused=false
	get_tree().reload_current_scene()


func _on_death_area_body_entered(body):
	if body.name == "Player":
		game_over_canvas.visible= true
		get_tree().paused=true


func _on_exit_pressed():
	get_tree().quit()
