extends Control

const GAME = preload("res://Scenes/Game.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


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
