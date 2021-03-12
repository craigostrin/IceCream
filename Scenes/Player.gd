extends Area2D

func _on_Player_area_entered(area):
	Events.emit_signal("player_hit", area)
