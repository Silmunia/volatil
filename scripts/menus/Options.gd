extends Node

export (AudioStream) var hoverMenu
export (AudioStream) var selectMenu

var volume
var optionState
var selectedChoice

func _ready():
	selectedChoice = 0
	optionState = 0
	volume = GameMaster.GetGameVolume()
	get_node("MasterVolume/Value").set_text(str(volume[0]))
	get_node("MusicVolume/Value").set_text(str(volume[1]))
	get_node("EffectVolume/Value").set_text(str(volume[2]))
	get_node("FadeAnimation").connect("animation_finished", self, "_on_FadeAnimation_finished")

func _on_FadeAnimation_finished(animation):
	if (animation == "FadeOut"):
		if (selectedChoice == -4):
			GoToCredits()
		elif (selectedChoice == 5):
			GoToMainMenu()

func _process(delta):
	OptionsStateMachine()

func OptionsStateMachine():
	if (optionState == 0):
		if (GameMaster.GetPlayerInputPermission()):
			if (Input.is_action_just_pressed("ui_cancel")):
				get_node("AudioStreamPlayer").set_stream(selectMenu)
				get_node("AudioStreamPlayer").play()
				GameMaster.SetPlayerInputPermission(false)
				selectedChoice = 5
				get_node("Cursor").set_animation("Select")
				get_node("FadeAnimation").play("FadeOut")
			if (Input.is_action_just_pressed("ui_up")):
				get_node("AudioStreamPlayer").set_stream(hoverMenu)
				get_node("AudioStreamPlayer").play()
				selectedChoice = abs(selectedChoice) - 1
				if (selectedChoice < 0):
					selectedChoice = 5
			elif (Input.is_action_just_pressed("ui_down")):
				get_node("AudioStreamPlayer").set_stream(hoverMenu)
				get_node("AudioStreamPlayer").play()
				selectedChoice = abs(selectedChoice) + 1
				if (selectedChoice > 5):
					selectedChoice = selectedChoice % 6
		if (selectedChoice == 0):
			if (GameMaster.GetPlayerInputPermission()):
				get_node("Cursor").set_animation("Hover")
				if (Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left")):
					OS.set_borderless_window(!OS.get_borderless_window())
					OS.set_window_fullscreen(!OS.is_window_fullscreen())
			if (OS.is_window_fullscreen() == true):
				get_node("ScreenMode/Value").set_text("Tela cheia")
			else:
				get_node("ScreenMode/Value").set_text("Janela")
			get_node("Arrows/ArrowRight").show()
			get_node("Arrows/ArrowLeft").show()
			get_node("Arrows/ArrowAnimation").set_current_animation("MainLargeArrowLoop")
			get_node("Arrows").set_position(Vector2(0, 0))
			get_node("Cursor").set_position(Vector2(524, 217))
		elif (selectedChoice > 0 and selectedChoice < 4):
			if (GameMaster.GetPlayerInputPermission()):
				get_node("Cursor").set_animation("Hover")
				if (Input.is_action_pressed("ui_right")):
					volume[selectedChoice - 1] = volume[selectedChoice - 1] + 1
					if (volume[selectedChoice - 1] > 100):
						volume[selectedChoice - 1] = 100
				elif (Input.is_action_pressed("ui_left")):
					volume[selectedChoice - 1] = volume[selectedChoice - 1] - 1
					if (volume[selectedChoice - 1] < 0):
						volume[selectedChoice - 1] = 0
				get_node("MasterVolume/Value").set_text(str(volume[0]))
				get_node("MusicVolume/Value").set_text(str(volume[1]))
				get_node("EffectVolume/Value").set_text(str(volume[2]))
				GameMaster.SetGameVolume(volume)
			get_node("Arrows/ArrowRight").show()
			get_node("Arrows/ArrowLeft").show()
			if (volume[selectedChoice - 1] == 100):
				get_node("Arrows/ArrowRight").hide()
			elif (volume[selectedChoice - 1] == 0):
				get_node("Arrows/ArrowLeft").hide()
			get_node("Arrows/ArrowAnimation").set_current_animation("MainShortArrowLoop")
			get_node("Arrows").set_position(Vector2(0, 0 + 90*selectedChoice))
			get_node("Cursor").set_position(Vector2(524, 307 + (selectedChoice - 1)*90))
		elif (abs(selectedChoice) == 4):
			if (GameMaster.GetPlayerInputPermission()):
				get_node("Cursor").set_animation("Hover")
				if (Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left")):
					get_node("AudioStreamPlayer").set_stream(hoverMenu)
					get_node("AudioStreamPlayer").play()
					selectedChoice *= -1
				if (Input.is_action_just_pressed("ui_select")):
					if (selectedChoice == -4):
						get_node("AudioStreamPlayer").set_stream(selectMenu)
						get_node("AudioStreamPlayer").play()
						get_node("Cursor").set_animation("Select")
						GameMaster.SetPlayerInputPermission(false)
						get_node("FadeAnimation").play("FadeOut")
					elif (selectedChoice == 4 and get_node("Data/Name").get_text() != "Dados apagados"):
						get_node("AudioStreamPlayer").set_stream(selectMenu)
						get_node("AudioStreamPlayer").play()
						get_node("Cursor").set_animation("Select")
						optionState = 1
						selectedChoice = 0
						get_node("EraseData/Cursor").set_position(Vector2(670, 535))
						get_node("EraseData").show()
			get_node("Arrows/ArrowRight").hide()
			get_node("Arrows/ArrowLeft").hide()
			get_node("Cursor").set_position(Vector2(674 - 1*150*sign(selectedChoice), 577))
		elif (selectedChoice == 5):
			if (GameMaster.GetPlayerInputPermission()):
				get_node("Cursor").set_animation("Hover")
				if (Input.is_action_just_pressed("ui_select")):
					get_node("AudioStreamPlayer").set_stream(selectMenu)
					get_node("AudioStreamPlayer").play()
					get_node("Cursor").set_animation("Select")
					GameMaster.SetPlayerInputPermission(false)
					get_node("FadeAnimation").play("FadeOut")
			get_node("Arrows/ArrowRight").hide()
			get_node("Arrows/ArrowLeft").hide()
			get_node("Cursor").set_position(Vector2(674, 697))
	elif (optionState == 1):
		if (GameMaster.GetPlayerInputPermission()):
			get_node("EraseData/Cursor").set_animation("Hover")
			if (Input.is_action_just_pressed("ui_up")):
				if (selectedChoice != 0):
					get_node("AudioStreamPlayer").set_stream(hoverMenu)
					get_node("AudioStreamPlayer").play()
				selectedChoice = 0
			elif (Input.is_action_just_pressed("ui_down")):
				if (selectedChoice != 1):
					get_node("AudioStreamPlayer").set_stream(hoverMenu)
					get_node("AudioStreamPlayer").play()
				selectedChoice = 1
			if (Input.is_action_just_pressed("ui_select")):
				get_node("AudioStreamPlayer").set_stream(selectMenu)
				get_node("AudioStreamPlayer").play()
				get_node("EraseData/Cursor").set_animation("Select")
				if (selectedChoice == 1):
					GameMaster.CheckGameInfo(true)
					get_node("Data/Name").set_text("Dados apagados")
				optionState = 0
				selectedChoice = 4
				get_node("EraseData").hide()
				get_node("EraseData/Cursor").set_position(Vector2(670, 535))
			if (Input.is_action_just_pressed("ui_cancel")):
				get_node("AudioStreamPlayer").set_stream(selectMenu)
				get_node("AudioStreamPlayer").play()
				get_node("EraseData/Cursor").set_position(Vector2(670, 535))
				get_node("EraseData/Cursor").set_animation("Select")
				optionState = 0
				selectedChoice = 4
				get_node("EraseData").hide()
		get_node("EraseData/Cursor").set_position(Vector2(670, 535 + selectedChoice*135))

func GoToCredits():
	GameMaster.goto_scene("res://scenes/menus/Credits.tscn", "Fast")
	GameMaster.SetPlayerInputPermission(true)

func GoToMainMenu():
	GameMaster.goto_scene("res://scenes/menus/MainMenu.tscn", "Fast")
	GameMaster.SetPlayerInputPermission(true)
