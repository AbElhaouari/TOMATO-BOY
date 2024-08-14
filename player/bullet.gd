extends Area2D
@export var BULLET_SPEED = 200
var dir
func _process(delta):
	move_local_x(dir * BULLET_SPEED * delta)


func _on_body_entered(body):
	queue_free()


func _on_timer_timeout():
	queue_free()


func _on_area_entered(area):
	pass
