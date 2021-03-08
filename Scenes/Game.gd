extends Node2D

var debug := true

const Cannon = preload("res://Scenes/Cannon.tscn")
const Player = preload("res://Scenes/Player.tscn")
var player: Area2D
onready var levelStartPopup = $CanvasLayer/LevelStartPopup
onready var debugPanel = $CanvasLayer/DebugPanel

var num_of_cannons := 8
const CANNON_SPAWN_POS := 45.0
const CANNON_SPAWN_OFFSET := 90.0

# To set on cannons, which also have their own game_speed var
# Multiplies bullet speed, might be used for reload/fire rates but not currently? 3/7/21
var game_speed: float
const BASE_GAME_SPEED := 1.0

var bullets_dodged: int
var max_bullets: int
const BASE_MAX_BULLETS_PER_LEVEL := 25

var level: int
var score: int
var lives: int

var points_per_normal_bullet_dodged = 5

### TODO ###
## Build a debugging tool to change bullet speed, reload time, fire time while game is running

## Powerups - must touch the bullet, one slot, get overwritten (encouraged to use them quickly)
#### - pause & teleport
#### - get tiny
#### - clear all bullets in a vertical line
#### - clear all bullets on screen
#### - extra life
#### - bubble shield, take one more hit
#### - point multiplier for limited time (maybe with faster bullets? trade-off)
#### - invincibility
## Different colors of bullets for variety
#### - bullets with bonus points

func _ready():
	Events.connect("click_to_start", self, "on_click_to_start")
	for i in range(num_of_cannons):
		var new_cannon = Cannon.instance()
		new_cannon.position.x = CANNON_SPAWN_POS + CANNON_SPAWN_OFFSET * i
		$Cannons.add_child(new_cannon)
	
	player = Player.instance()
	player.position = Vector2(360,360)
	self.add_child(player)
	
	# LEVEL 1 SETUP
	debugPanel.hide()
	level = 1
	score = 0
	lives = 4
	game_speed = BASE_GAME_SPEED
	max_bullets = BASE_MAX_BULLETS_PER_LEVEL
	
	if debug:
		debugPanel.show()
		max_bullets = 1000
	
	get_tree().call_group("cannons", "update_game_speed", game_speed)
	start_level()


func _input(_event):
	if Input.is_action_just_pressed('quit'):
		get_tree().quit()


func _process(_delta):
	player.position = get_global_mouse_position()


func start_level():
	bullets_dodged = 0
	Events.emit_signal("update_lives", lives)
	Events.emit_signal("update_bullets_and_score", bullets_dodged, max_bullets, score)
	fancy_start_cannons()


# Cannons do a staggered reload
# I don't know how to do something like this with signals @_@
func fancy_start_cannons():
	var cannons = $Cannons.get_children()
	for cannon in cannons:
		yield(get_tree().create_timer(0.1), "timeout")
		cannon.on_start_cannons()


func level_cleared():
	# Stop everything
	Events.emit_signal("stop_cannons")
	get_tree().call_group("cannons", "clear_chambered_bullet")
	get_tree().call_group("bullets", "clear_fired_bullet")
	
	# Get next level ready
	setup_next_level()


func setup_next_level():
	level += 1
	game_speed = BASE_GAME_SPEED + 1.0
	get_tree().call_group("cannons", "update_game_speed", game_speed)
	max_bullets = BASE_MAX_BULLETS_PER_LEVEL * level
	levelStartPopup.bullets_to_show = max_bullets
	levelStartPopup.popup()


func on_click_to_start():
	start_level()


func _on_CleanupZone_area_entered(area):
	area.queue_free()
	bullets_dodged += 1
	score += points_per_normal_bullet_dodged
	Events.emit_signal("update_bullets_and_score", bullets_dodged, max_bullets, score)
	if bullets_dodged == max_bullets:
		level_cleared()
