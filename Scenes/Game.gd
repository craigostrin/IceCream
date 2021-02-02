extends Node2D

signal start_cannons
signal stop_cannons

const Cannon = preload("res://Scenes/Cannon.tscn")
const Player = preload("res://Scenes/Player.tscn")
var player

var cannon_spawn_pos = 32
var cannon_spawn_offset = 80

func _ready():
	for i in range(7):
		var new_cannon = Cannon.instance()
		new_cannon.position.x = cannon_spawn_pos + cannon_spawn_offset * i
		connect('start_cannons', new_cannon, 'on_start_cannons')
		connect('stop_cannons', new_cannon, 'on_stop_cannons')
		$Cannons.add_child(new_cannon)
	
	emit_signal('start_cannons')
	
	player = Player.instance()
	self.add_child(player)

func _input(event):
	if Input.is_action_just_pressed('quit'):
		get_tree().quit()

func _process(delta):
	player.position = get_global_mouse_position()

func _on_CleanupZone_area_entered(area):
	area.queue_free()
	print(str(area) + ' deleted')
