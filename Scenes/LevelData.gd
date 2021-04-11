extends Node

const filepath = "res://LevelData.json"

var data = {}

func _ready():
	var file = File.new()
	if file.open(filepath, File.READ) != OK:
		print("File open error")
		return
	
	#file.open(filepath, file.READ)
	var text = file.get_as_text()
	file.close()
	
	var json_parse = JSON.parse(text)
	if json_parse.error != OK:
		return
	
	data = json_parse.result
	
	# How to access first level's max bullet speed:
	# data.level[0].param.maxSpeed
