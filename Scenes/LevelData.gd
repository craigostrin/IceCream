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

func get_level_param_dict(i):
	return data.level[i].param


func get_num_bullets(i):
	return data.level[i].numBullets

func is_bonus_level(i):
	return data.level[i].bonus
