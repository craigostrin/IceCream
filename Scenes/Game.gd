extends Node2D

var debug := false

# Cannon setup
const NUM_CANNONS := 8
const CANNON_SPAWN_POS := 45.0
const CANNON_SPAWN_OFFSET := 90.0

# Difficulty
const BASE_MAX_BULLETS_PER_LEVEL := 25
const STARTING_LIVES := 4

const Cannon = preload("res://Scenes/Cannon.tscn")
const Player = preload("res://Scenes/Player.tscn")

var player: Area2D
onready var levelStartPopup = $CanvasLayer/LevelStartPopup
onready var victoryPopup = $CanvasLayer/VictoryPopup
onready var debugPanel = $CanvasLayer/DebugPanel

var num_of_cannons := NUM_CANNONS

# To set on cannons, which also have their own game_speed var
# Multiplies bullet speed, might be used for reload/fire rates but not currently? 3/7/21
var game_speed: float

var bullets_dodged: int
var max_bullets: int

var level_index: int
var num_of_levels: int # including bonus levels
var bonus_level: bool
var score: int
var lives: int

var points_per_normal_bullet_dodged = 5

### TODO ###
## BONUS LEVEL = Waffle cone

# Power ups and bonus point bullets need to be coordinated from Game node:
### Random generator will randomly pick a cannon out of the children of Cannons
### On that cannon, set "make next bullet bonus/powerup of X type"
### Cannon will take care of the rest 

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

#### FOR FUN ####
# Roguelike mode
# Cheat detector (for when they go out of the window)

func _ready():
	Events.connect("click_to_start", self, "_on_click_to_start")
	Events.connect("player_hit", self, "_on_player_hit")
	for i in range(num_of_cannons):
		var new_cannon = Cannon.instance()
		new_cannon.position.x = CANNON_SPAWN_POS + CANNON_SPAWN_OFFSET * i
		$Cannons.add_child(new_cannon)
	
	player = Player.instance()
	player.position = Vector2(360,360)
	self.add_child(player)
	
	num_of_levels = $LevelData.get_num_levels()
	
	# LEVEL 1 SETUP
	debugPanel.hide()
	level_index = 0
	score = 0
	lives = STARTING_LIVES
	Stats.runs += 1
	
	if debug:
		debugPanel.show()
		debugPanel.debug = true
		max_bullets = 1000
	
	setup_level(level_index)


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
	level_index += 1
	clear_everything()
	
	if level_index >= num_of_levels:
		win_the_game()
	else:
		setup_level(level_index)


func setup_level(index):
	bonus_level = $LevelData.is_bonus_level(index)
	if bonus_level: print("bonus")
	
	max_bullets = 1 #$LevelData.get_num_bullets(index)
	update_cannon_params(index)
	
	levelStartPopup.bullets_to_show = max_bullets
	levelStartPopup.popup()


func _on_click_to_start():
	start_level()


func game_over():
	print("game over")


func win_the_game():
	victoryPopup.cash_earned = score
	victoryPopup.popup()

func update_cannon_params(_level_index):
	var index = _level_index
	var dict = {}
	
	dict = $LevelData.get_level_param_dict(index)
	
	get_tree().call_group("cannons", "update_all_params_with_dict", dict)
	print("level " + str(level_index) + ": " + str(dict))


func _on_player_hit(area):
	if bonus_level:
		level_cleared()
	
	else:
		clear_everything()
		lives -= 1
		Events.emit_signal("update_lives", lives)
		if lives == 0:
			game_over()
		else:
			print("uh oh you died")
			yield(get_tree().create_timer(3.0), "timeout")
			print("lets try again")
			fancy_start_cannons()


func clear_everything():
	Events.emit_signal("stop_cannons")
	get_tree().call_group("cannons", "clear_chambered_bullet")
	get_tree().call_group("bullets", "clear_fired_bullet")


func _on_CleanupZone_area_entered(area):
	area.queue_free()
	bullets_dodged += 1
	score += points_per_normal_bullet_dodged
	Events.emit_signal("update_bullets_and_score", bullets_dodged, max_bullets, score)
	
	if bullets_dodged == max_bullets:
		level_cleared()
