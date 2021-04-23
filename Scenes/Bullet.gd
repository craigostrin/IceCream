extends Area2D

var speed: float
var firing := false

func init(_speed: float, cream: Texture):
	speed = _speed
	$Sprite.texture = cream


func _process(delta):
	if firing:
		position.y -= speed * delta


func stop():
	firing = false


func start():
	firing = true


func clear_fired_bullet():
	if position.y < 0:
		queue_free()
