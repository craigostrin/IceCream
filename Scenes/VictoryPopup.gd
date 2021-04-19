extends Popup

var cash_earned: int


func _on_VictoryPopup_about_to_show():
	$Panel/CashEarnedLabel.text = "$$$ earned: " + str(cash_earned)


func _on_StartAgain_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_MainMenu_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
