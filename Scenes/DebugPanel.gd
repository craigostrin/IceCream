extends Panel

onready var minSpeedEdit = $HBoxContainer/VBoxContainer2/HBoxContainer/MinSpeedLineEdit
onready var maxSpeedEdit = $HBoxContainer/VBoxContainer2/HBoxContainer4/MaxSpeedLineEdit
onready var levelEdit = $HBoxContainer/VBoxContainer4/HBoxContainer/LevelLineEdit
onready var reloadEdit = $HBoxContainer/HBoxContainer2/ReloadLineEdit
onready var minFireEdit = $HBoxContainer/VBoxContainer/HBoxContainer3/MinFireLineEdit
onready var maxFireEdit = $HBoxContainer/VBoxContainer/HBoxContainer4/MaxFireLineEdit

var firing := true
var debug := false

# Right-click start/stop button shortcut
func _input(event):
	if debug:
		if Input.is_action_just_pressed('right_click'):
			if firing:
				_on_StopButton_pressed()
			else:
				_on_StartButton_pressed()

func _on_MinSpeedLineEdit_text_entered(new_text):
	if new_text.is_valid_float():
		var value = float(new_text)
		get_tree().call_group("cannons", "update_min_bullet_speed", value)
		print("Min Bullet Speed = " + new_text)
	else:
		print("Please enter a valid number.")


func _on_MaxSpeedLineEdit_text_entered(new_text):
	if new_text.is_valid_float():
		var value = float(new_text)
		get_tree().call_group("cannons", "update_max_bullet_speed", value)
		print("Max Bullet Speed = " + new_text)
	else:
		print("Please enter a valid number.")


# This could probably use some tweaks
func _on_LevelLineEdit_text_entered(new_text):
	if new_text.is_valid_integer():
		var value = int(new_text)
		var game = get_tree().get_root().get_node("Game")
		game.level_index = value - 1
		game.level_cleared()
	else:
		print("Please enter a valid integer")


func _on_ReloadLineEdit_text_entered(new_text):
	if new_text.is_valid_float():
		var value = float(new_text)
		get_tree().call_group("cannons", "update_reload_time", value)
		print("Reload Time = " + new_text)
	else:
		print("Please enter a valid number.")


func _on_MinFireLineEdit_text_entered(new_text):
	if new_text.is_valid_float():
		var value = float(new_text)
		get_tree().call_group("cannons", "update_min_fire_time", value)
		print("Min Fire Time = " + new_text)
	else:
		print("Please enter a valid number.")


func _on_MaxFireLineEdit_text_entered(new_text):
	if new_text.is_valid_float():
		var value = float(new_text)
		get_tree().call_group("cannons", "update_max_fire_time", value)
		print("Max Fire Time = " + new_text)
	else:
		print("Please enter a valid number.")


# Stop everything
func _on_StopButton_pressed():
	Events.emit_signal("stop_cannons")
	get_tree().call_group("cannons", "clear_chambered_bullet")
	get_tree().call_group("bullets", "clear_fired_bullet")
	firing = false
	print("======STOP!======")

func _on_StartButton_pressed():
	Events.emit_signal("start_cannons")
	firing = true
	print("======START======")


