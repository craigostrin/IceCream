extends Control

onready var scoopsLabel = $FooterPanel/HBoxContainer/ScoopsLabel

func _ready():
	Events.connect("bullet_dodged", self, "on_bullet_dodged")
	scoopsLabel.text = "Scoops: 0/25"

func on_bullet_dodged(bullets_dodged, max_bullets):
	scoopsLabel.text = "Scoops: " + str(bullets_dodged) + "/" + str(max_bullets)
