extends Area2D

var speed: float

func init(_speed):
	speed = _speed


func _process(delta):
	position.y -= speed * delta
