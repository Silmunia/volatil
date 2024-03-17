extends Control

export (AudioStream) var hoverMenu
export (AudioStream) var selectMenu

#Variável para mudança nos gráficos da opção em destaque
var pauseState
var selectedChoice
var currentStage
var volume

func _ready():
	pauseState = "Pause"
	volume = GameMaster.GetGameVolume()
	get_node("CanvasLayer/Options/MasterVolume/Value").set_text(str(volume[0]))
	get_node("CanvasLayer/Options/MusicVolume/Value").set_text(str(volume[1]))
	get_node("CanvasLayer/Options/EffectVolume/Value").set_text(str(volume[2]))
	#Inicia com a opção em destaque sendo "Continuar"
	selectedChoice = 0
	get_node("CanvasLayer/FadeAnimation").connect("animation_finished", self, "_on_FadeAnimation_finished")
	hide()

func _process(delta):
	if (pauseState == "Pause" and GameMaster.GetPlayerInputPermission() and Input.is_action_just_pressed("ui_cancel")):
		get_tree().set_pause(!get_tree().is_paused())
	if (get_tree().is_paused()):
		show()
		PauseStateMachine()
	else:
		hide()

func PauseStateMachine():
	if (pauseState == "Pause"):
		get_node("CanvasLayer/Options").hide()
		get_node("CanvasLayer/Pause").show()
		if (GameMaster.GetPlayerInputPermission()):
			get_node("CanvasLayer/Pause/Cursor").set_animation("Hover")
			get_node("CanvasLayer/Pause/Cursor").set_position(Vector2(663, 389 + selectedChoice*68))
			#Muda selectedChoice conforme a entrada do usuário
			if (Input.is_action_just_pressed("ui_down")):
				get_node("AudioStreamPlayer").set_stream(hoverMenu)
				get_node("AudioStreamPlayer").play()
				selectedChoice += 1
				#Restringe o valor de selectedChoice para a faixa [0 - 3]
				selectedChoice = selectedChoice % 4
			elif (Input.is_action_just_pressed("ui_up")):
				get_node("AudioStreamPlayer").set_stream(hoverMenu)
				get_node("AudioStreamPlayer").play()
				selectedChoice -= 1
				#Faz valores negativos irem para a última opção
				if (selectedChoice < 0):
					selectedChoice = 3
			if (Input.is_action_just_pressed("ui_select")):
				get_node("AudioStreamPlayer").set_stream(selectMenu)
				get_node("AudioStreamPlayer").play()
				get_node("CanvasLayer/Pause/Cursor").set_animation("Select")
				if (selectedChoice == 0):
					get_tree().set_pause(false)
				elif (selectedChoice == 1 or selectedChoice == 3):
					GameMaster.SetPlayerInputPermission(false)
					get_node("CanvasLayer/FadeAnimation").play("FadeOut")
				elif (selectedChoice == 2):
					get_node("AudioStreamPlayer").set_stream(selectMenu)
					get_node("AudioStreamPlayer").play()
					pauseState = "Options"
					selectedChoice = 0
					get_node("CanvasLayer/Pause/Cursor").set_animation("Select")
					get_node("CanvasLayer/Pause").hide()
					get_node("CanvasLayer/Options").show()
	elif (pauseState == "Options"):
		get_node("CanvasLayer/Options").show()
		get_node("CanvasLayer/Pause").hide()
		if (GameMaster.GetPlayerInputPermission()):
			get_node("CanvasLayer/Options/Cursor").set_animation("Hover")
			get_node("CanvasLayer/Options/Cursor").set_position(Vector2(663, 389 + selectedChoice*68))
			#Muda selectedChoice conforme a entrada do usuário
			if (Input.is_action_just_pressed("ui_down")):
				get_node("AudioStreamPlayer").set_stream(hoverMenu)
				get_node("AudioStreamPlayer").play()
				selectedChoice += 1
				#Restringe o valor de selectedChoice para a faixa [0 - 4]
				selectedChoice = selectedChoice % 5
			elif (Input.is_action_just_pressed("ui_up")):
				get_node("AudioStreamPlayer").set_stream(hoverMenu)
				get_node("AudioStreamPlayer").play()
				selectedChoice -= 1
				#Faz valores negativos irem para a última opção
				if (selectedChoice < 0):
					selectedChoice = 4
		if (selectedChoice == 0):
			if (GameMaster.GetPlayerInputPermission()):
				get_node("CanvasLayer/Options/Cursor").set_animation("Hover")
				if (Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_left")):
					OS.set_borderless_window(!OS.get_borderless_window())
					OS.set_window_fullscreen(!OS.is_window_fullscreen())
			if (OS.is_window_fullscreen() == true):
				get_node("CanvasLayer/Options/ScreenMode/Value").set_text("Tela cheia")
			else:
				get_node("CanvasLayer/Options/ScreenMode/Value").set_text("Janela")
			get_node("CanvasLayer/Options/Arrows/ArrowRight").show()
			get_node("CanvasLayer/Options/Arrows/ArrowLeft").show()
			get_node("CanvasLayer/Options/Arrows/ArrowAnimation").set_current_animation("PauseLargeArrowLoop")
			get_node("CanvasLayer/Options/Arrows").set_position(Vector2(0, 0))
			get_node("CanvasLayer/Options/Cursor").set_position(Vector2(518, 260))
		elif (selectedChoice > 0 and selectedChoice < 4):
			if (GameMaster.GetPlayerInputPermission()):
				get_node("CanvasLayer/Options/Cursor").set_animation("Hover")
				if (Input.is_action_pressed("ui_right")):
					volume[selectedChoice - 1] = volume[selectedChoice - 1] + 1
					if (volume[selectedChoice - 1] > 100):
						volume[selectedChoice - 1] = 100
				elif (Input.is_action_pressed("ui_left")):
					volume[selectedChoice - 1] = volume[selectedChoice - 1] - 1
					if (volume[selectedChoice - 1] < 0):
						volume[selectedChoice - 1] = 0
				get_node("CanvasLayer/Options/MasterVolume/Value").set_text(str(volume[0]))
				get_node("CanvasLayer/Options/MusicVolume/Value").set_text(str(volume[1]))
				get_node("CanvasLayer/Options/EffectVolume/Value").set_text(str(volume[2]))
				GameMaster.SetGameVolume(volume)
			get_node("CanvasLayer/Options/Arrows/ArrowRight").show()
			get_node("CanvasLayer/Options/Arrows/ArrowLeft").show()
			if (volume[selectedChoice - 1] == 100):
				get_node("CanvasLayer/Options/Arrows/ArrowRight").hide()
			elif (volume[selectedChoice - 1] == 0):
				get_node("CanvasLayer/Options/Arrows/ArrowLeft").hide()
			get_node("CanvasLayer/Options/Arrows/ArrowAnimation").set_current_animation("PauseShortArrowLoop")
			get_node("CanvasLayer/Options/Arrows").set_position(Vector2(0, 0 + 80*selectedChoice))
			get_node("CanvasLayer/Options/Cursor").set_position(Vector2(518, 260 + selectedChoice*80))
		elif (selectedChoice == 4):
			if (GameMaster.GetPlayerInputPermission()):
				get_node("CanvasLayer/Options/Cursor").set_animation("Hover")
				if (Input.is_action_just_pressed("ui_select")):
					get_node("AudioStreamPlayer").set_stream(selectMenu)
					get_node("AudioStreamPlayer").play()
					pauseState = "Pause"
					selectedChoice = 0
					get_node("CanvasLayer/Options/Cursor").set_animation("Select")
					get_node("CanvasLayer/Options").hide()
					get_node("CanvasLayer/Pause").show()
			get_node("CanvasLayer/Options/Arrows/ArrowRight").hide()
			get_node("CanvasLayer/Options/Arrows/ArrowLeft").hide()
			get_node("CanvasLayer/Options/Cursor").set_position(Vector2(650, 610))

func _on_FadeAnimation_finished(animation):
	match selectedChoice:
		1:
			GoToStage()
		3:
			GoToSelect()

func SetCurrentStage(stage):
	currentStage = stage

# Inicia mudança de cena e devolve controle ao jogador
func GoToStage():
	GameMaster.SetPlaySafe(false)
	GameMaster.SetGameMusic("Menu")
	GameMaster.goto_scene(currentStage, "Fast")
	get_tree().set_pause(false)
	GameMaster.SetPlayerInputPermission(true)

# Inicia mudança de cena e devolve controle ao jogador
func GoToSelect():
	GameMaster.SetPlaySafe(false)
	GameMaster.SetGameMusic("Menu")
	GameMaster.goto_scene("res://scenes/menus/SelectStage.tscn", "Fast")
	get_tree().set_pause(false)
	GameMaster.SetPlayerInputPermission(true)
