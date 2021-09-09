extends Control


export var images := []
var _image_index := 0

const GAME = preload("res://Scenes/Game.tscn")

onready var texture_rect: TextureRect = $Background/ColorRect/MarginContainer/TextureRect
onready var animation: Animation = preload("res://Animation/MainMenu_image_neg_flash.tres")

# Number of times the animation has looped
var _num_loops := 0
export var max_loops := 4


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_change_image_pair(_image_index)


func _on_MusicToggleButton_pressed():
	$MusicPlayer.stream_paused = !$MusicPlayer.stream_paused


func _on_StartLabel_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			#get_tree().change_scene(GAME_PATH)
			var game = GAME.instance()
			game.music_on = !$MusicPlayer.stream_paused
			get_tree().get_root().add_child(game)
			self.queue_free()


func _on_ExitLabel_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			get_tree().quit()


func _on_StartLabel_mouse_entered():
	$StartLabel.bbcode_text = "[center][rainbow freq=0.75 sat=0.5]START[/rainbow][/center]"


func _on_StartLabel_mouse_exited():
	$StartLabel.bbcode_text = "[center]START[/center]"


func _on_ExitLabel_mouse_entered():
	$ExitLabel.set_modulate(Color.red)


func _on_ExitLabel_mouse_exited():
	$ExitLabel.set_modulate(Color.white)


func on_ImageNegFlash_animation_finished() -> void:
	_num_loops += 1
	if _num_loops >= max_loops:
		_change_image_pair(_get_random_image_index())
		_num_loops = 0


func _change_image_pair(image_index) -> void:
	animation.track_set_key_value(0, 0, images[image_index]["base"])
	animation.track_set_key_value(0, 1, images[image_index]["neg"])
	animation.track_set_key_value(0, 2, images[image_index]["base"])

func _get_random_image_index() -> int:
	var rand_index := randi() % images.size()
	if rand_index == _image_index:
		return _get_random_image_index()
	else:
		_image_index = rand_index
	
	return rand_index


#func _setup_base_image_array() -> void:
#	var dir = Directory.new()
#	var folder_path := "res://Art/Public access ice cream/"
#	if dir.open(folder_path) == OK:
#		dir.list_dir_begin(true)
#
#		while true:
#			var file_name = dir.get_next()
#			var key_path := ""
#			var value_path := ""
#
#			if file_name == "":
#				break
#
#			elif file_name.ends_with(".jpg") and not file_name.ends_with("NEG.jpg"):
#				key_path = file_name
#				value_path = file_name.insert(file_name.length() - 4, "_NEG")
#				#var base = load(folder_path + key_path)
#				#var neg = load(folder_path + value_path)
#				var base = load_image(folder_path + key_path)
#				var neg = load_image(folder_path + value_path)
#				images.append( { "base" : base, "neg" : neg } )
#
#	dir.list_dir_end()
#
#
#func load_image(path: String) -> ImageTexture:
#	var stream_texture = load(path)
#	var image_texture = ImageTexture.new()
#	var image = stream_texture.get_data()
#	image.lock()
#	image_texture.create_from_image(image, 0)
#	return image_texture
