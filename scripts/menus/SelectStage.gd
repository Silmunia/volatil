extends Node

export (AudioStream) var hoverMenu
export (AudioStream) var selectMenu

#Variáveis que definem o tipo de seleção sendo feita no menu
var selectionType
var selectedStage
var selectionState
var stageNumber

func _ready():
	#Inicia tela com seletor nas fases
	selectionType = 0
	#Inicia seletor focando na primeira fase
	selectedStage = Vector2(0, 0)
	selectionState = 0
	GameMaster.SetGameMusic("Menu")
	get_node("FadeAnimation").connect("animation_finished", self, "_on_FadeAnimation_finished")
	get_node("InfoAnimation").connect("animation_finished", self, "_on_InfoAnimation_finished")

func _on_FadeAnimation_finished(animation):
	if (animation == "FadeOutLoad"):
		if (stageNumber == 0):
			GoToTutorial()
		else:
			if (selectedStage == Vector2(0, 0)):
				GoToStageNormal(stageNumber)
			elif (selectedStage == Vector2(1, 0)):
				GoToStageChallenge(stageNumber)
	elif (animation == "FadeOut"):
		GoToMainMenu()

func _on_InfoAnimation_finished(animation):
	if (animation == "InfoPopUp"):
		selectionState = 1
		selectionType = 0
		selectedStage = Vector2(0, 0)
		GameMaster.SetPlayerInputPermission(true)
	elif (animation == "InfoPopDown"):
		selectionState = 0
		selectionType = 0
		get_node("StageInfo/Cursor").set_animation("Hover")
		get_node("StageInfo/Cursor").set_position(Vector2(540, 185))
		GameMaster.SetPlayerInputPermission(true)

func _process(delta):
	SelectionStateMachine()

func SelectionStateMachine():
	var stageGroup = get_tree().get_nodes_in_group("Stages")
	if (selectionState == 0):
		stageNumber = selectedStage[0] + selectedStage[1]*7
		for stage in stageGroup:
			if (selectionType == 1):
				stage.set_scale(Vector2(0.9, 0.9))
				stage.set_self_modulate(Color("#e6dcdc"))
			elif (stage.get_name() != "Stage" + str(stageNumber)):
				stage.set_scale(Vector2(0.9, 0.9))
				stage.set_self_modulate(Color("#e6dcdc"))
		if (GameMaster.GetPlayerInputPermission()):
			if (selectionType == 0):
				get_node("Return/AnimatedSprite").set_animation("None")
				get_node("Stages/StageAnimation").set_current_animation("Stage" + str(stageNumber) + "Animation")
				get_node("Stages/Stage" + str(stageNumber)).set_self_modulate(Color("#ffffff"))
				if (Input.is_action_just_pressed("ui_right")):
					selectedStage[0] = selectedStage[0] + 1
					get_node("AudioStreamPlayer").set_stream(hoverMenu)
					get_node("AudioStreamPlayer").play()
					if (selectedStage[0] > 6):
						selectedStage[0] = 0
				elif (Input.is_action_just_pressed("ui_left")):
					selectedStage[0] = selectedStage[0] - 1
					get_node("AudioStreamPlayer").set_stream(hoverMenu)
					get_node("AudioStreamPlayer").play()
					if (selectedStage[0] < 0):
						selectedStage[0] = 6
				if (Input.is_action_just_pressed("ui_up")):
					if (selectedStage[1] != 0):
						get_node("AudioStreamPlayer").set_stream(hoverMenu)
						get_node("AudioStreamPlayer").play()
					selectedStage[1] = 0
				elif (Input.is_action_just_pressed("ui_down")):
					selectedStage[1] = selectedStage[1] + 1
					get_node("AudioStreamPlayer").set_stream(hoverMenu)
					get_node("AudioStreamPlayer").play()
					if (selectedStage[1] > 1):
						selectionType = 1
						selectedStage[1] = 1
				if (Input.is_action_just_pressed("ui_select")):
					GameMaster.SetPlayerInputPermission(false)
					if (stageNumber != 0):
						get_node("StageInfo/Cursor").set_position(Vector2(540, 185))
						get_node("StageInfo/StageModes/Tutorial").hide()
						get_node("StageInfo/StageModes/Normal").show()
						get_node("StageInfo/StageModes/Challenge").show()
					if (stageNumber == 0):
						get_node("StageInfo/Cursor").set_position(Vector2(675, 185))
						get_node("StageInfo/StageModes/Tutorial").show()
						get_node("StageInfo/StageModes/Normal").hide()
						get_node("StageInfo/StageModes/Challenge").hide()
						var residues = {"Residue1": "Água"}
						WriteStageInfo("Tutorial", 1, residues, "", "")
					elif (stageNumber == 1):
						var residues = {"Residue1": "Cobre"}
						WriteStageInfo("Fase 1", 1, residues, "aprenda a tratar o resíduo de cobre", "trate 5 resíduos em até 2 minutos")
					elif (stageNumber == 2):
						var residues = {"Residue1": "Níquel"}
						WriteStageInfo("Fase 2", 1, residues, "aprenda a tratar o resíduo de níquel", "trate 5 resíduos em até 3 minutos")
					elif (stageNumber == 3):
						var residues = {"Residue1": "Cobre", "Residue2": "Níquel"}
						WriteStageInfo("Fase 3", 2, residues, "trate quantos resíduos conseguir", "trate 10 resíduos em até 4 minutos")
					elif (stageNumber == 4):
						var residues = {"Residue1": "Mercúrio"}
						WriteStageInfo("Fase 4", 1, residues, "aprenda a tratar o resíduo de mercúrio", "trate 5 resíduos em até 4 minutos")
					elif (stageNumber == 5):
						var residues = {"Residue1": "Cobre", "Residue2": "Mercúrio"}
						WriteStageInfo("Fase 5", 2, residues, "trate quantos resíduos conseguir", "trate 10 resíduos em até 5 minutos")
					elif (stageNumber == 6):
						var residues = {"Residue1": "Níquel", "Residue2": "Mercúrio"}
						WriteStageInfo("Fase 6", 2, residues, "trate quantos resíduos conseguir", "trate 10 resíduos em até 6 minutos")
					elif (stageNumber == 7):
						var residues = {"Residue1": "Cádmio"}
						WriteStageInfo("Fase 7", 1, residues, "aprenda a tratar o resíduo de cádmio", "trate 5 resíduos em até 4 minutos")
					elif (stageNumber == 8):
						var residues = {"Residue1": "Cobre", "Residue2": "Cádmio"}
						WriteStageInfo("Fase 8", 2, residues, "trate quantos resíduos conseguir", "trate 10 resíduos em até 6 minutos")
					elif (stageNumber == 9):
						var residues = {"Residue1": "Níquel", "Residue2": "Cádmio"}
						WriteStageInfo("Fase 9", 2, residues, "trate quantos resíduos conseguir", "trate 10 resíduos em até 6 minutos")
					elif (stageNumber == 10):
						var residues = {"Residue1": "Mercúrio", "Residue2": "Cádmio"}
						WriteStageInfo("Fase 10", 2, residues, "trate quantos resíduos conseguir", "trate 10 resíduos em até 7 minutos")
					elif (stageNumber == 11):
						var residues = {"Residue1": "Cobre", "Residue2": "Níquel", "Residue3": "Mercúrio"}
						WriteStageInfo("Fase 11", 3, residues, "trate quantos resíduos conseguir", "trate 15 resíduos em até 7 minutos")
					elif (stageNumber == 12):
						var residues = {"Residue1": "Cobre", "Residue2": "Níquel", "Residue3": "Cádmio"}
						WriteStageInfo("Fase 12", 3, residues, "trate quantos resíduos conseguir", "trate 15 resíduos em até 10 minutos")
					elif (stageNumber == 13):
						var residues = {"Residue1": "Níquel", "Residue2": "Mercúrio", "Residue3": "Cádmio"}
						WriteStageInfo("Fase 13", 3, residues, "trate quantos resíduos conseguir", "trate 15 resíduos em até 10 minutos")
					get_node("AudioStreamPlayer").set_stream(selectMenu)
					get_node("AudioStreamPlayer").play()
					get_node("InfoAnimation").set_current_animation("InfoPopUp")
			else:
				get_node("Stages/StageAnimation").play("None")
				get_node("Return/AnimatedSprite").set_animation("Hover")
				if (Input.is_action_just_pressed("ui_up")):
					get_node("AudioStreamPlayer").set_stream(hoverMenu)
					get_node("AudioStreamPlayer").play()
					selectionType = 0
				if (Input.is_action_just_pressed("ui_select")):
					get_node("AudioStreamPlayer").set_stream(selectMenu)
					get_node("AudioStreamPlayer").play()
					GameMaster.SetPlayerInputPermission(false)
					get_node("Return/AnimatedSprite").set_animation("Select")
					get_node("FadeAnimation").play("FadeOut")
			if (Input.is_action_just_pressed("ui_cancel")):
				get_node("AudioStreamPlayer").set_stream(selectMenu)
				get_node("AudioStreamPlayer").play()
				GameMaster.SetPlayerInputPermission(false)
				get_node("Return/AnimatedSprite").set_animation("Select")
				get_node("FadeAnimation").play("FadeOut")
	elif (selectionState == 1):
		for stage in stageGroup:
			stage.set_scale(Vector2(0.9, 0.9))
			stage.set_self_modulate(Color("#e6dcdc"))
		if (selectionType == 0):
			if (stageNumber != 0):
				get_node("StageInfo/Cursor").set_position(Vector2(540 + 285*selectedStage[0], 185))
				if (selectedStage[0] == 0):
					get_node("ModeAnimation").set_current_animation("HoverNormalMode")
				elif (selectedStage[0] == 1):
					get_node("ModeAnimation").set_current_animation("HoverChallengeMode")
			else:
				get_node("StageInfo/Cursor").set_position(Vector2(675, 185))
				get_node("ModeAnimation").set_current_animation("HoverTutorialMode")
		elif (selectionType == 1):
			get_node("StageInfo/Cursor").set_position(Vector2(675, 650))
			get_node("ModeAnimation").set_current_animation("None")
		if (GameMaster.GetPlayerInputPermission()):
			get_node("StageInfo/Cursor").set_animation("Hover")
			if (selectionType == 0):
				if (Input.is_action_just_pressed("ui_left")):
					if (selectedStage != Vector2(0, 0) and stageNumber != 0):
						get_node("AudioStreamPlayer").set_stream(hoverMenu)
						get_node("AudioStreamPlayer").play()
						selectedStage = Vector2(0, 0)
				elif (Input.is_action_just_pressed("ui_right")):
					if (selectedStage != Vector2(1, 0) and stageNumber != 0):
						get_node("AudioStreamPlayer").set_stream(hoverMenu)
						get_node("AudioStreamPlayer").play()
						selectedStage = Vector2(1, 0)
			if (Input.is_action_just_pressed("ui_up")):
				if (selectionType != 0):
					get_node("AudioStreamPlayer").set_stream(hoverMenu)
					get_node("AudioStreamPlayer").play()
					selectionType = 0
			elif (Input.is_action_just_pressed("ui_down")):
				if (selectionType != 1):
					get_node("AudioStreamPlayer").set_stream(hoverMenu)
					get_node("AudioStreamPlayer").play()
					selectionType = 1
			if (Input.is_action_just_pressed("ui_select")):
				get_node("StageInfo/Cursor").set_animation("Select")
				if (selectionType == 0):
					get_node("AudioStreamPlayer").set_stream(selectMenu)
					get_node("AudioStreamPlayer").play()
					GameMaster.SetPlayerInputPermission(false)
					get_node("FadeAnimation").play("FadeOutLoad")
				elif (selectionType == 1):
					GameMaster.SetPlayerInputPermission(false)
					get_node("ModeAnimation").set_current_animation("None")
					get_node("AudioStreamPlayer").set_stream(selectMenu)
					get_node("AudioStreamPlayer").play()
					get_node("InfoAnimation").set_current_animation("InfoPopDown")
					var i = 0
					for i in 15:
						if ("Fase " + str(i) == get_node("StageInfo/StageName").get_text()):
							selectedStage = Vector2(i - floor(i/7)*7, floor(i/7))
							break
					if (i == 15):
						selectedStage = Vector2(0, 0)
			if (Input.is_action_just_pressed("ui_cancel")):
				GameMaster.SetPlayerInputPermission(false)
				get_node("ModeAnimation").set_current_animation("None")
				get_node("AudioStreamPlayer").set_stream(selectMenu)
				get_node("AudioStreamPlayer").play()
				get_node("StageInfo/Cursor").set_position(Vector2(590, 650))
				get_node("StageInfo/Cursor").set_animation("Select")
				get_node("InfoAnimation").set_current_animation("InfoPopDown")
				var i = 0
				for i in 15:
					if ("Fase " + str(i) == get_node("StageInfo/StageName").get_text()):
						selectedStage = Vector2(i - floor(i/7)*7, floor(i/7))
						break
				if (i == 15):
					selectedStage = Vector2(0, 0)

func WriteStageInfo(stageName, residueAmount, residueNames, normalGoal, challengeGoal):
	get_node("StageInfo/Cursor").set_animation("Hover")
	get_node("StageInfo/StageName").set_text(stageName)
	get_node("StageInfo/StageModes/Normal/Image/Goal").set_text(normalGoal)
	get_node("StageInfo/StageModes/Challenge/Image/Goal").set_text(challengeGoal)
	#Define ícones para aparecer
	if (residueAmount == 1):
		get_node("StageInfo/ResidueIcons/Icon2").set_animation(residueNames["Residue1"])
		if (stageName == "Tutorial"):
			get_node("StageInfo/ResidueIcons/Icon2/Label").set_text("Água (apenas para aprender)")
		else:
			get_node("StageInfo/ResidueIcons/Icon2/Label").set_text(residueNames["Residue1"])
		get_node("StageInfo/ResidueIcons/Icon2").show()
		get_node("StageInfo/ResidueIcons/Icon1").hide()
		get_node("StageInfo/ResidueIcons/Icon3").hide()
		get_node("StageInfo/ResidueIcons/Icon4").hide()
		get_node("StageInfo/ResidueIcons/Icon5").hide()
		get_node("StageInfo/ResidueIcons/Icon6").hide()
	elif (residueAmount == 2):
		get_node("StageInfo/ResidueIcons/Icon1").set_animation(residueNames["Residue1"])
		get_node("StageInfo/ResidueIcons/Icon1/Label").set_text(residueNames["Residue1"])
		get_node("StageInfo/ResidueIcons/Icon1").show()
		get_node("StageInfo/ResidueIcons/Icon2").hide()
		get_node("StageInfo/ResidueIcons/Icon3").set_animation(residueNames["Residue2"])
		get_node("StageInfo/ResidueIcons/Icon3/Label").set_text(residueNames["Residue2"])
		get_node("StageInfo/ResidueIcons/Icon3").show()
		get_node("StageInfo/ResidueIcons/Icon4").hide()
		get_node("StageInfo/ResidueIcons/Icon5").hide()
		get_node("StageInfo/ResidueIcons/Icon6").hide()
	elif (residueAmount == 3):
		get_node("StageInfo/ResidueIcons/Icon1").set_animation(residueNames["Residue1"])
		get_node("StageInfo/ResidueIcons/Icon1/Label").set_text(residueNames["Residue1"])
		get_node("StageInfo/ResidueIcons/Icon1").show()
		get_node("StageInfo/ResidueIcons/Icon2").hide()
		get_node("StageInfo/ResidueIcons/Icon3").set_animation(residueNames["Residue2"])
		get_node("StageInfo/ResidueIcons/Icon3/Label").set_text(residueNames["Residue2"])
		get_node("StageInfo/ResidueIcons/Icon3").show()
		get_node("StageInfo/ResidueIcons/Icon4").hide()
		get_node("StageInfo/ResidueIcons/Icon5").set_animation(residueNames["Residue3"])
		get_node("StageInfo/ResidueIcons/Icon5/Label").set_text(residueNames["Residue3"])
		get_node("StageInfo/ResidueIcons/Icon5").show()
		get_node("StageInfo/ResidueIcons/Icon6").hide()
	#Define pontuações escritas
	if (stageName != "Tutorial"):
		var text = ""
		if (GameMaster.GetStageScore(stageName, "Normal") == 0):
			text = "nenhum registro"
		elif (GameMaster.GetStageScore(stageName, "Normal") == 1):
			text = str(GameMaster.GetStageScore(stageName, "Normal")) + " resíduo"
		else:
			text = str(GameMaster.GetStageScore(stageName, "Normal")) + " resíduos"
		get_node("StageInfo/StageModes/Normal/Ranking/Score").set_text(text)
		if (GameMaster.GetStageScore(stageName, "Challenge") == 9999):
			text = "nenhum registro"
		else:
			var formattedSeconds = GameMaster.FormatSecondsTime(GameMaster.GetStageScore(stageName, "Challenge"))
			text = str(formattedSeconds[0]) + " min e " + str(formattedSeconds[1]) + " seg"
		get_node("StageInfo/StageModes/Challenge/Ranking/Score").set_text(text)

func GoToTutorial():
	GameMaster.goto_scene("res://scenes/stages/Tutorial/StageTutorial.tscn", "Slow")
	GameMaster.SetPlayerInputPermission(true)

func GoToStageNormal(stageNumber):
	GameMaster.goto_scene("res://scenes/stages/Stage " + str(stageNumber) + "/Stage" + str(stageNumber) + "Normal.tscn", "Slow")
	GameMaster.SetPlayerInputPermission(true)

func GoToStageChallenge(stageNumber):
	GameMaster.goto_scene("res://scenes/stages/Stage " + str(stageNumber) + "/Stage" + str(stageNumber) + "Challenge.tscn", "Slow")
	GameMaster.SetPlayerInputPermission(true)

func GoToMainMenu():
	GameMaster.goto_scene("res://scenes/menus/MainMenu.tscn", "Fast")
	GameMaster.SetPlayerInputPermission(true)
