extends Node2D

const Cannon = preload("res://Scenes/Cannon.tscn")
const Player = preload("res://Scenes/Player.tscn")
var player

var num_of_cannons = 8
var cannon_spawn_pos = 45
var cannon_spawn_offset = 90

var bullets_dodged = 0
var max_bullets = 25

var lives


func _ready():
	for i in range(num_of_cannons):
		var new_cannon = Cannon.instance()
		new_cannon.position.x = cannon_spawn_pos + cannon_spawn_offset * i
#		Events.connect('start_cannons', new_cannon, 'on_start_cannons')
#		Events.connect('stop_cannons', new_cannon, 'on_stop_cannons')
		$Cannons.add_child(new_cannon)
	
	Events.emit_signal('start_cannons')
	
	player = Player.instance()
	player.position = Vector2(360,360)
	self.add_child(player)


func _input(event):
	if Input.is_action_just_pressed('quit'):
		get_tree().quit()


func _process(delta):
	player.position = get_global_mouse_position()


func _on_CleanupZone_area_entered(area):
	area.queue_free()
	bullets_dodged += 1
	Events.emit_signal("bullet_dodged", bullets_dodged, max_bullets)
	if bullets_dodged == max_bullets:
		Events.emit_signal("stop_cannons")
		print("you win")
