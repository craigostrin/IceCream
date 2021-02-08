extends Node2D

var rng = RandomNumberGenerator.new()
var bullet = preload("res://Scenes/Bullet.tscn")
onready var reloadTimer = $ReloadTimer
onready var fireTimer = $FireTimer

var chambered_bullet: Area2D

var min_bullet_speed := 125.0
var max_bullet_speed := 175.0
#var firing = false
var reload_time := 1.0
var min_fire_time := 1.0
var max_fire_time := 5.0

func _ready():
	rng.randomize()
	Events.connect("start_cannons", self, "on_start_cannons")
	Events.connect("stop_cannons", self, "on_stop_cannons")
	reloadTimer.connect("timeout", self, "on_ReloadTimer_timeout")
	fireTimer.connect("timeout", self, "on_FireTimer_timeout")


func on_ReloadTimer_timeout():
	reload()


func on_FireTimer_timeout():
	if chambered_bullet:
		chambered_bullet.firing = true
	else:
		print("No bullet chambered! Can't fire!")
	start_reload_timer()


func reload():
	# Make a bullet, add a random speed
	chambered_bullet = bullet.instance()
	var random_speed = get_bullet_speed()
	chambered_bullet.init(random_speed)
	self.add_child(chambered_bullet)
	start_fire_timer()


func start_fire_timer():
	var random_fire_time = get_fire_time()
	fireTimer.start(random_fire_time)


func start_reload_timer():
	reloadTimer.start(reload_time)


func get_bullet_speed():
	return rng.randf_range(min_bullet_speed, max_bullet_speed)


func get_fire_time():
	return rng.randf_range(min_fire_time, max_fire_time)


func on_start_cannons():
	reload()

func on_stop_cannons():
	fireTimer.stop()
