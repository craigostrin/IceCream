extends Popup

onready var scoopsLabel = $Panel/VBoxContainer/ScoopsLabel
onready var getReadyLabel = $Panel/GetReadyLabel

var first_level: bool
var bonus_level: bool
var bullets_to_show: int
var cream_to_show: String


func _input(_event):
	if visible:
		if Input.is_action_just_pressed("left_click") or Input.is_action_just_pressed("right_click"):
			Events.emit_signal("click_to_start")
			hide()


func _on_LevelStartPopup_about_to_show():
	if first_level:
		getReadyLabel.text = "Move your mouse\nto avoid the ice cream"
	elif bonus_level:
		getReadyLabel.text = "Next: BONUS LEVEL!\nget Ready for " + cream_to_show.capitalize()
	else:
		getReadyLabel.text = "Level cleared.\nget Ready for " + cream_to_show.capitalize()
	
	scoopsLabel.text = "Dodge " + str(bullets_to_show) + " scoops!"
