extends Node2D

var rng = RandomNumberGenerator.new()
var bullet = preload("res://Scenes/Bullet.tscn")
onready var bulletTimer = $BulletTimer

var min_bullet_speed := 125.0
var max_bullet_speed := 175.0
var firing = false
var min_reload_time := 1.0
var max_reload_time := 3.5

func _ready():
	rng.randomize()
	bulletTimer.connect("timeout", self, "on_BulletTimer_timeout")


func on_BulletTimer_timeout():
	if not firing:
		return
	
	# Make a bullet, add a random speed
	var new_bullet = bullet.instance()
	var random_speed = get_random_bullet_speed()
	new_bullet.init(random_speed)
	self.add_child(new_bullet)
	
	reload()


func reload():
	var random_reload_time = get_random_reload_time()
	bulletTimer.start(random_reload_time)


func get_random_bullet_speed():
	return rng.randf_range(min_bullet_speed, max_bullet_speed)


func get_random_reload_time():
	return rng.randf_range(min_reload_time, max_reload_time)


func on_start_cannons():
	firing = true
	reload()

func on_stop_cannons():
	firing = false
	bulletTimer.stop()
