extends Popup

onready var bulletsLabel = $Panel/VBoxContainer/BulletsNumLabel

var bullets_to_show: int


func _input(_event):
	if visible:
		if Input.is_action_just_pressed("left_click"):
			Events.emit_signal("click_to_start")
			hide()


func _on_LevelStartPopup_about_to_show():
	bulletsLabel.text = str(bullets_to_show)
