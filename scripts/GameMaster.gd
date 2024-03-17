extends Node

export (AudioStream) var intro
export (AudioStream) var menu
export (AudioStream) var stage1
export (AudioStream) var stage2

const SCORE_PATH = "user://volatilScores.json"

#Variáveis de controle da interação
var playerInputPermission = true
var playSafe
var volume

#Variáveis com informações das fases
var stagePlayed = null
var typePlayed = null
var scorePlayer = 0
var stageScores = {}

#Variáveis de carregamento e mudança de cenas
var currentScene = null
var loader
var resource
var wait_frames
var time_max = 200

func _ready():
	OS.set_borderless_window(true)
	OS.set_window_fullscreen(true)
	volume = Vector3(50, 100, 100)
	SetGameVolume(volume)
	var root = get_tree().get_root()
	currentScene = root.get_child(root.get_child_count() - 1)
	get_node("FadeAnimation").connect("animation_finished", self, "_on_FadeAnimation_finished")
	CheckGameInfo(false)

func CheckGameInfo(enable):
	#Verifica existência de documento de pontuação de fases
	var scoreFile = File.new()
	if (!scoreFile.file_exists(SCORE_PATH) or enable):
		NullScores(scoreFile)
	else:
		scoreFile.open(SCORE_PATH, File.READ)
		stageScores = parse_json(scoreFile.get_as_text())
		scoreFile.close()

func NullScores(scoreFile):
	var totalStages = 13
	for i in range(1,totalStages+1):
		stageScores["Fase " + str(i)] = {
			"Normal": 0,
			"Challenge": 9999,
		}
	scoreFile.open(SCORE_PATH, File.WRITE)
	scoreFile.store_line(to_json(stageScores))
	scoreFile.close()

func RankScore():
	if (typePlayed == "Normal"):
		if (scorePlayer > stageScores["Fase " + str(stagePlayed)][typePlayed]):
			stageScores["Fase " + str(stagePlayed)][typePlayed] = scorePlayer
	elif (typePlayed == "Challenge"):
		if (scorePlayer < stageScores["Fase " + str(stagePlayed)][typePlayed]):
			stageScores["Fase " + str(stagePlayed)][typePlayed] = scorePlayer
	var scoreFile = File.new()
	scoreFile.open(SCORE_PATH, File.WRITE)
	scoreFile.store_line(to_json(stageScores))
	scoreFile.close()

func GetStageScore(stageName, stageType):
	return stageScores[stageName][stageType]

func _on_FadeAnimation_finished(animation):
	SetNewScene(resource)
	get_node("Control").hide()

func goto_scene(path, loadType):
	if (loadType == "Slow"):
		get_node("Control").show()
		loader = ResourceLoader.load_interactive(path)
		set_process(true)
		currentScene.queue_free()
		wait_frames = 1
	elif (loadType == "Fast"):
		# This function will usually be called from a signal callback,
		# or some other function in the current scene.
		# Deleting the current scene at this point is
		# a bad idea, because it may still be executing code.
		# This will result in a crash or unexpected behavior.
		call_deferred("DeferredGoToScene", path)

func _process(time):
	if (loader == null):
		set_process(false)
		return
	if (wait_frames > 0):
		wait_frames -= 1
		return
	var t = OS.get_ticks_msec()
	while (OS.get_ticks_msec() <  t + time_max):
		var err = loader.poll()
		if (err == ERR_FILE_EOF):
			resource = loader.get_resource()
			loader = null
			get_node("Control/TextureProgress").set_value(100)
			get_node("FadeAnimation").play("FadeOut")
			break
		elif (err == OK):
			UpdateLoadProgress()
		else:
			loader = null
			break

func SetNewScene(resource):
	currentScene = resource.instance()
	resource = null
	get_tree().get_root().add_child(currentScene)

func UpdateLoadProgress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	get_node("Control/TextureProgress").set_value(progress * 100)

func DeferredGoToScene(path):
	# It is now safe to remove the current scene
	currentScene.free()
	# Load the new scene.
	var scene = ResourceLoader.load(path)
	# Instance the new scene.
	currentScene = scene.instance()
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(currentScene)
	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(currentScene)

func GetPlaySafe():
	return playSafe

func SetPlaySafe(enable):
	playSafe = enable

func GetStageEndInfo():
	var stageInfo = {"Stage": stagePlayed, "Type": typePlayed, "Score": scorePlayer}
	return stageInfo

func SetStageEndInfo(stage, type, score):
	stagePlayed = stage
	typePlayed = type
	scorePlayer = floor(score)

func GetPlayerInputPermission():
	return playerInputPermission

func SetPlayerInputPermission(permission):
	playerInputPermission = permission

func GetGameVolume():
	return volume

func SetGameVolume(vectorVolume):
	volume = vectorVolume
	var masterVolume
	if (volume[0] == 0):
		masterVolume = -100
	else:
		masterVolume = range_lerp(volume[0], 0, 100, -30, 3)
	var musicVolume
	if (volume[1] == 0):
		musicVolume = -100
	else:
		musicVolume = range_lerp(volume[1], 0, 100, -30, 3)
	var effectVolume
	if (volume[2] == 0):
		effectVolume = -100
	else:
		effectVolume = range_lerp(volume[2], 0, 100, -30, 3)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), masterVolume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), musicVolume)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), effectVolume)

func SetGameMusic(track):
	match track:
		"Intro":
			get_node("AudioStreamPlayer").set_stream(intro)
			get_node("AudioStreamPlayer").play()
		"Menu":
			if (get_node("AudioStreamPlayer").get_stream() != menu):
				get_node("AudioStreamPlayer").set_stream(menu)
				get_node("AudioStreamPlayer").play()
		"Stage1":
			get_node("AudioStreamPlayer").set_stream(stage1)
			get_node("AudioStreamPlayer").play()
		"Stage2":
			get_node("AudioStreamPlayer").set_stream(stage2)
			get_node("AudioStreamPlayer").play()

func StopGameMusic():
	get_node("AudioStreamPlayer").stop()

func FormatSecondsTime(originalTime):
	var formattedTime = Vector2(0, 0)
	var minutes = floor(int(originalTime) / 60)
	var seconds = int(originalTime) - minutes*60
	formattedTime = Vector2(minutes, seconds)
	return formattedTime

func GoToVictory():
	goto_scene("res://scenes/endings/EndingVictory.tscn", "Fast")

func GoToHealthLoss():
	goto_scene("res://scenes/endings/EndingHealth.tscn", "Fast")

func GoToTimeLoss():
	goto_scene("res://scenes/endings/EndingTime.tscn", "Fast")
