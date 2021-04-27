extends Area2D

func _on_Player_area_entered(area):
	Events.emit_signal("player_hit", area)

func mask_on(t: Texture):
	$Mask.set_texture(t)
	$Mask.show()

func mask_off():
	$Mask.hide()
