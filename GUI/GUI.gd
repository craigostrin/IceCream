extends Control

onready var livesLabel = $FooterPanel/HBoxContainer/CenterContainer/LivesLabel
onready var bulletsLabel = $FooterPanel/HBoxContainer/CenterContainer2/BulletsLabel
onready var scoreLabel = $FooterPanel/HBoxContainer/CenterContainer3/ScoreLabel

func _ready():
	#warning-ignore:return_value_discarded
	Events.connect("update_lives", self, "on_lives_updated")
	#warning-ignore:return_value_discarded
	Events.connect("update_bullets_and_score", self, "on_bullets_and_score_updated")


func on_bullets_and_score_updated(bullets_dodged, max_bullets, total_score):
	bulletsLabel.text = "Scoops: " + str(bullets_dodged) + "/" + str(max_bullets)
	scoreLabel.text = "Cash: $" + str(total_score)


func on_lives_updated(value):
	livesLabel.text = "Lives: " + str(value)
