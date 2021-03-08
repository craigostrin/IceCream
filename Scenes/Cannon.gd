extends Node2D

var rng = RandomNumberGenerator.new()
var bullet = preload("res://Scenes/Bullet.tscn")
onready var reloadTimer = $ReloadTimer
onready var fireTimer = $FireTimer

const BASE_RELOAD_TIME := 1.0
const BASE_MIN_FIRE_TIME := 1.0
const BASE_MAX_FIRE_TIME := 5.0
const BASE_MIN_BULLET_SPEED := 125.0
const BASE_MAX_BULLET_SPEED := 175.0

var chambered_bullet: Area2D

var game_speed: float
var min_bullet_speed := BASE_MIN_BULLET_SPEED
var max_bullet_speed := BASE_MAX_BULLET_SPEED
var firing = false

var reload_time := BASE_RELOAD_TIME
var min_fire_time := BASE_MIN_FIRE_TIME
var max_fire_time := BASE_MAX_FIRE_TIME

func _ready():
	rng.randomize()
	
	#warning-ignore:return_value_discarded
	Events.connect("start_cannons", self, "on_start_cannons")
	#warning-ignore:return_value_discarded
	Events.connect("stop_cannons", self, "on_stop_cannons")
	reloadTimer.connect("timeout", self, "on_ReloadTimer_timeout")
	fireTimer.connect("timeout", self, "on_FireTimer_timeout")


func on_ReloadTimer_timeout():
	_reload()


func _reload():
	# If no bullet is ready, make a bullet, add a random speed
	if not chambered_bullet:
		chambered_bullet = bullet.instance()
		chambered_bullet.init(game_speed * get_bullet_speed())
		self.add_child(chambered_bullet)
	if firing:
		start_fire_timer()


func on_FireTimer_timeout():
	if chambered_bullet:
		chambered_bullet.firing = true
		chambered_bullet = null
	else:
		print("No bullet chambered! Can't fire!")
	start_reload_timer()


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
	firing = true
	_reload()


func on_stop_cannons():
	firing = false
	reloadTimer.stop()
	fireTimer.stop()


func clear_chambered_bullet():
	if chambered_bullet:
		chambered_bullet.queue_free()
		chambered_bullet = null


func update_game_speed(value):
	game_speed = value


# DEBUG ONLY
func update_min_bullet_speed(value):
	min_bullet_speed = value

func update_max_bullet_speed(value):
	max_bullet_speed = value

func update_reload_time(value):
	reload_time = value

func update_min_fire_time(value):
	min_fire_time = value

func update_max_fire_time(value):
	max_fire_time = value
