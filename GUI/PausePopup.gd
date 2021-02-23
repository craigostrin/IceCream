extends Popup


# PAUSING BREAKS THE GAME AND THEREFORE SHOULD BE A LIMITED POWERUP
func _input(_event):
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			hide()
			get_tree().paused = false
		else:
			show()
			get_tree().paused = true
