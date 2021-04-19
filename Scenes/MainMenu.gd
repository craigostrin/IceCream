extends Control

const GAME_PATH = "res://Scenes/Game.tscn"

func _on_StartGame_pressed():
	get_tree().change_scene(GAME_PATH)


func _on_Button4_pressed():
	get_tree().quit()
