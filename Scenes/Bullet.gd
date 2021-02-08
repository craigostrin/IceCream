extends Area2D

var speed: float
var firing := false

func init(_speed):
	speed = _speed


func _process(delta):
	if firing:
		position.y -= speed * delta
