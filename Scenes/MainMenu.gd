extends Control

const GAME_PATH = "res://Scenes/Game.tscn"

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_StartGame_pressed():
	get_tree().change_scene(GAME_PATH)


func _on_Quit_pressed():
	get_tree().quit()
