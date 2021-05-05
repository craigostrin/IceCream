extends Popup

var cash_earned: int


func _on_VictoryPopup_about_to_show():
	$Panel/CashEarnedLabel.text = "$$$ earned: " + str(cash_earned)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
