extends Control

onready var scoopsLabel = $FooterPanel/HBoxContainer/ScoopsLabel

func ready():
	Events.connect("bullet_dodged", self, "on_bullet_dodged")
	scoopsLabel.bbcode_text = "[center]Scoops: [b]0/25[/b][/center]"
	print("ok")

func on_bullet_dodged(bullets_dodged, max_bullets):
	scoopsLabel.bbcode_text = "[center]Scoops: [b]" + str(bullets_dodged) + "/" + str(max_bullets) + "[/b][/center]"
