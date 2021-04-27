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

func get_level_param_dict(i) -> Dictionary:
	return data.level[i].param

func get_bullet_texture_filename(i) -> String:
	return data.level[i].param.bulletTexture

func get_num_bullets(i) -> int:
	return data.level[i].numBullets

func get_cream(i) -> String:
	return data.level[i].cream

func is_bonus_level(i) -> bool:
	return data.level[i].bonus

func get_num_levels() -> int:
	return data.level.size()
