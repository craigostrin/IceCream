extends Node2D

var rng = Rng.RNG
var bullet = preload("res://Scenes/Bullet.tscn")
onready var reloadTimer = $ReloadTimer
onready var fireTimer = $FireTimer

var chambered_bullet: Area2D
var firing = false

# level params
var min_bullet_speed: float
var max_bullet_speed: float
var reload_time: float
var min_fire_time: float
var max_fire_time: float
var bullet_texture: Texture
var bonus_level: bool
var bonus_textures: Array

func _ready():
	#warning-ignore:return_value_discarded
	Events.connect("level_cleared", self, "_on_level_cleared")
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
		var t = bullet_texture if not bonus_level else get_random_texture_from_array()
		chambered_bullet.init(get_random_bullet_speed(), t)
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
	var random_fire_time = get_random_fire_time()
	fireTimer.start(random_fire_time)


func start_reload_timer():
	reloadTimer.start(reload_time)


func get_random_bullet_speed():
	return rng.randf_range(min_bullet_speed, max_bullet_speed)


func get_random_fire_time():
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


func update_bonus_texture_array(a: Array):
	bonus_textures = a


func get_random_texture_from_array() -> Texture:
	var random_index = rng.randi_range(0, bonus_textures.size() - 1)
	var t = bonus_textures[random_index]
	return t


func _on_level_cleared() -> void:
	if bonus_level:
		bonus_level = false

######## UPDATE PARAMS ##############

func update_all_params_with_dict(dict: Dictionary):
	min_bullet_speed = dict.minSpeed
	max_bullet_speed = dict.maxSpeed
	reload_time = dict.reloadTime
	min_fire_time = dict.minFireTime
	max_fire_time = dict.maxFireTime
	bullet_texture = load("res://Art/" + dict.bulletTexture)

# Below are just used for debug

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
