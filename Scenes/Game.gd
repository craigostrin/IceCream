extends Node2D

const Cannon = preload("res://Scenes/Cannon.tscn")
const Player = preload("res://Scenes/Player.tscn")
var player: Area2D

var num_of_cannons := 8
var cannon_spawn_pos := 45.0
var cannon_spawn_offset := 90.0

var bullets_dodged := 0
var max_bullets := 25

var score: int
var lives: int


### TODO ###
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
	for i in range(num_of_cannons):
		var new_cannon = Cannon.instance()
		new_cannon.position.x = cannon_spawn_pos + cannon_spawn_offset * i
#		Events.connect('start_cannons', new_cannon, 'on_start_cannons')
#		Events.connect('stop_cannons', new_cannon, 'on_stop_cannons')
		$Cannons.add_child(new_cannon)
	
	player = Player.instance()
	player.position = Vector2(360,360)
	self.add_child(player)
	
	start_level()


func _input(event):
	if Input.is_action_just_pressed('quit'):
		get_tree().quit()


func _process(delta):
	player.position = get_global_mouse_position()


func start_level():
	Events.emit_signal('start_cannons')


func level_cleared():
	Events.emit_signal("stop_cannons")
	get_tree().call_group("bullets", "clear_fired_bullet")
	print("you win")


func _on_CleanupZone_area_entered(area):
	area.queue_free()
	bullets_dodged += 1
	Events.emit_signal("bullet_dodged", bullets_dodged, max_bullets)
	if bullets_dodged == max_bullets:
		level_cleared()
