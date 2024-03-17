extends Node

#stageState controla o passo-a-passo do mini-tutorial até a fase
#começar de verdade para o jogador
var stageState

#flowControl determina o acontecimento de certos eventos na
#StageStateMachine() junto com FlowTimer
var flowControl

#spawnerControl controla a frequência do gerador de resíduos
#junto com SpawnTimer
var spawnerControl

#stageType informa à HUD qual o tipo de fase (Normal ou Avançada)
var stageType

#residueCounter registra a quantidade de resíduos tratada pelo jogador
var residueCounter

func _ready():
	stageState = 0
	stageType = "Normal"
	GameMaster.SetGameMusic("Stage1")
	spawnerControl = true
	flowControl = true
	residueCounter = 0
	get_node("HUD").SetPauseCurrentStage("res://scenes/stages/Stage 1/Stage1Normal.tscn")
	get_node("HUD").UpdateStageProgress(stageType, residueCounter, null)
	get_node("YSort/MainCharacter").connect("updateHealth", get_node("HUD"), "_on_MainCharacter_updateHealth")
	get_node("YSort/MainCharacter").connect("updateHealth", self, "_on_MainCharacter_updateHealth")
	get_node("YSort/MainCharacter").connect("updateGear", get_node("HUD"), "_on_MainCharacter_updateGear")
	get_node("YSort/MainCharacter").connect("error", get_node("HUD"), "_on_MainCharacter_error")
	get_node("YSort/MainCharacter").connect("hint", get_node("HUD"), "_on_MainCharacter_hint")
	get_node("YSort/MainCharacter").connect("observation", get_node("HUD"), "_on_MainCharacter_observation")
	get_node("YSort/Storage").connect("residueFinished", self, "_on_Storage_residueFinished")
	get_node("SpawnTimer").connect("timeout", self, "_on_SpawnTimer_timeout")
	get_node("StageTimer").connect("timeout", self, "_on_StageTimer_timeout")
	get_node("FlowTimer").connect("timeout", self, "_on_FlowTimer_timeout")

func _on_MainCharacter_updateHealth(characterState, health):
	if (characterState == "Health"):
		GameMaster.SetStageEndInfo("1", stageType, residueCounter)
		GameMaster.GoToHealthLoss()

func _on_Storage_residueFinished():
	residueCounter += 1
	get_node("HUD").PositiveFeedback()
	get_node("HUD").UpdateStageProgress(stageType, residueCounter, null)

func _on_StageTimer_timeout():
	GameMaster.SetStageEndInfo("1", stageType, residueCounter)

func _on_SpawnTimer_timeout():
	get_node("YSort/Spawner").SpawnResidue("Cobre")
	get_node("SpawnTimer").stop()
	spawnerControl = true

func _on_FlowTimer_timeout():
	if (str(stageState) == "LostResidue"):
		stageState = 9
		get_node("HUD/CanvasLayer/Messages/Hint").show()
		get_node("HUD/CanvasLayer/Messages/Negative").hide()
	elif (stageState == 6 or stageState == 11 or stageState == 17 or stageState == 22 or stageState == 26 or stageState == 31 or stageState == 36):
		stageState -= 1
	elif (stageState == 37):
		stageState = 38
		get_node("HUD").get_node("CanvasLayer/Messages/Positive").hide()
		get_node("HUD").get_node("CanvasLayer/PlayerInfo/TimePortrait").show()
		get_node("HUD").get_node("CanvasLayer/StageProgress/Normal").show()
		GameMaster.SetPlaySafe(false)
		get_node("StageTimer").start()
	else:
		stageState += 1
	flowControl = true

func _process(delta):
	StageStateMachine()
	UpdateResidueInfo()

func StageStateMachine():
	match stageState:
		0:
			GameMaster.SetPlaySafe(true)
			get_node("HUD").get_node("CanvasLayer/PlayerInfo/TimePortrait").hide()
			get_node("HUD").get_node("CanvasLayer/StageProgress/Normal").hide()
			get_node("HUD").get_node("CanvasLayer/Messages/Hint").show()
			TutorialFlowControl(0, 1, null)
		1:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Ok, Murdock! Vamos começar devagar para você aprender aos poucos")
			TutorialFlowControl(1, 5, "Hint")
			TutorialCheckAdvance(0, null, null)
		2:
			TutorialFlowControl(0, 1, null)
			TutorialCheckAdvance(0, null, null)
		3:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Primeiro, nunca esqueça de vestir os EPI: Equipamentos de Proteção Individual")
			TutorialFlowControl(1, 5, "Hint")
			TutorialCheckAdvance(0, null, null)
		4:
			TutorialFlowControl(0, 1, null)
			TutorialCheckAdvance(0, null, null)
		5:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Vá até os armários dos EPI e vista os três. Se eles estragarem, é só vestir novos")
			if (flowControl):
				var objectsGroup = get_tree().get_nodes_in_group("EPI")
				for object in objectsGroup:
					object.get_node("AnimationPlayer").play("BlinkLights")
				get_node("HUD").get_node("CanvasLayer/Messages/Hint/ProfPortrait").set_frame(0)
				get_node("HUD").get_node("CanvasLayer/Messages/Hint/ProfPortrait").play()
				get_node("HUD").get_node("CanvasLayer/Messages").show()
				get_node("FlowTimer").set_wait_time(5)
				get_node("FlowTimer").start()
				flowControl = false
			TutorialCheckAdvance(0, null, null)
		6:
			TutorialFlowControl(0, 1, null)
		7:
			TutorialFlowControl(0, 1, null)
		8:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Muito bem, Murdock! Sempre vista os três EPI antes de mexer em resíduos")
			TutorialFlowControl(1, 5, "Hint")
		9:
			TutorialFlowControl(0, 1, null)
		10:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Agora vá até o gerador de resíduos e pegue o resíduo que será tratado")
			if (flowControl):
				if (!get_tree().has_group("Residue")):
					get_node("YSort/Spawner").SpawnResidue("Cobre")
				get_node("HUD").get_node("CanvasLayer/Messages/Hint/ProfPortrait").set_frame(0)
				get_node("HUD").get_node("CanvasLayer/Messages/Hint/ProfPortrait").play()
				get_node("HUD").get_node("CanvasLayer/Messages").show()
				get_node("FlowTimer").set_wait_time(5)
				get_node("FlowTimer").start()
				flowControl = false
			if (get_node("YSort/MainCharacter").GetCharacterState() == "Carry"):
				stageState = 12
				flowControl = true
				get_node("FlowTimer").stop()
				get_node("YSort/Spawner").get_node("AnimationPlayer").play("OffLights")
		11:
			TutorialFlowControl(0, 5, null)
			if (get_node("YSort/MainCharacter").GetCharacterState() == "Carry"):
				stageState = 12
				flowControl = true
				get_node("FlowTimer").stop()
				var objectsGroup = get_tree().get_nodes_in_group("Spawner")
				for object in objectsGroup:
					object.get_node("AnimationPlayer").play("OffLights")
		12:
			TutorialFlowControl(0, 1, null)
			TutorialCheckResidueError(1, "Spawner")
			TutorialCheckAdvance(1, "Balance", 18)
		13:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Agora que você tem o resíduo de COBRE em mãos, é hora de começar o tratamento")
			TutorialFlowControl(1, 5, "Hint")
			TutorialCheckResidueError(0, null)
			TutorialCheckAdvance(1, "Balance", 18)
		"LostResidue":
			get_node("HUD").get_node("CanvasLayer/Messages/Negative/TextureRect/Label").set_text("Vejo que deu algo errado com o resíduo... Tudo bem, vamos recomeçar o tratamento")
			TutorialFlowControl(1, 5, "Negative")
		14:
			TutorialFlowControl(0, 1, null)
			TutorialCheckResidueError(0, null)
			TutorialCheckAdvance(1, "Balance", 18)
		15:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("A primeira etapa do tratamento do resíduo de cobre é AJUSTAR O PH")
			TutorialFlowControl(1, 5, "Hint")
			TutorialCheckResidueError(0, null)
			TutorialCheckAdvance(1, "Balance", 18)
		16:
			TutorialFlowControl(0, 1, null)
			TutorialCheckResidueError(0, null)
			TutorialCheckAdvance(1, "Balance", 18)
		17:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Para ajustar o pH de um resíduo, use qualquer AJUSTADOR DE PH disponível")
			if (flowControl):
				var objectsGroup = get_tree().get_nodes_in_group("Balance")
				for object in objectsGroup:
					object.get_node("AnimationPlayer").play("BlinkLights")
				get_node("HUD").get_node("CanvasLayer/Messages/Hint/ProfPortrait").set_frame(0)
				get_node("HUD").get_node("CanvasLayer/Messages/Hint/ProfPortrait").play()
				get_node("HUD").get_node("CanvasLayer/Messages").show()
				get_node("FlowTimer").set_wait_time(5)
				get_node("FlowTimer").start()
				flowControl = false
			TutorialCheckResidueError(1, "Balance")
			TutorialCheckAdvance(1, "Balance", 18)
		18:
			TutorialFlowControl(0, 1, null)
		19:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Os equipamentos levam alguns segundos para processar o resíduo. Espere um pouco")
			TutorialFlowControl(1, 16, "Hint")
			var objectsGroup = get_tree().get_nodes_in_group("Balance")
			for object in objectsGroup:
				if (object.GetEquipState() == "Done"):
					stageState = 20
					flowControl = true
					get_node("FlowTimer").stop()
		20:
			TutorialFlowControl(0, 1, null)
		21:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Quando o equipamento piscar verde, o resíduo está pronto para ser pego")
			if (flowControl):
				get_node("HUD").get_node("CanvasLayer/Messages/Hint/ProfPortrait").set_frame(0)
				get_node("HUD").get_node("CanvasLayer/Messages/Hint/ProfPortrait").play()
				get_node("HUD").get_node("CanvasLayer/Messages").show()
				get_node("FlowTimer").set_wait_time(5)
				get_node("FlowTimer").start()
				flowControl = false
			TutorialCheckResidueError(1, "Balance")
			if (get_node("YSort/MainCharacter").GetCharacterState() == "Carry"):
				get_node("FlowTimer").stop()
				stageState = 23
				flowControl = true
				var objectsGroup = get_tree().get_nodes_in_group("Balance")
				for object in objectsGroup:
					object.get_node("AnimationPlayer").play("OffLights")
		22:
			TutorialCheckResidueError(0, null)
			if (get_node("YSort/MainCharacter").GetCharacterState() == "Carry"):
				stageState = 23
				flowControl = true
				get_node("FlowTimer").stop()
			elif (flowControl):
				get_node("FlowTimer").set_wait_time(5)
				get_node("FlowTimer").start()
				flowControl = false
		23:
			TutorialFlowControl(0, 1, null)
		24:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("A segunda etapa do tratamento do resíduo de cobre é FILTRAR")
			TutorialFlowControl(1, 5, "Hint")
			TutorialCheckResidueError(1, "Balance")
			TutorialCheckAdvance(1, "Filter", 27)
		25:
			TutorialFlowControl(0, 1, null)
			TutorialCheckResidueError(1, "Balance")
			TutorialCheckAdvance(1, "Filter", 27)
		26:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Para filtrar um resíduo, use qualquer FILTRO disponível no laboratório")
			if (flowControl):
				var objectsGroup = get_tree().get_nodes_in_group("Filter")
				for object in objectsGroup:
					object.get_node("AnimationPlayer").play("BlinkLights")
				get_node("HUD").get_node("CanvasLayer/Messages/Hint/ProfPortrait").set_frame(0)
				get_node("HUD").get_node("CanvasLayer/Messages/Hint/ProfPortrait").play()
				get_node("HUD").get_node("CanvasLayer/Messages").show()
				get_node("FlowTimer").set_wait_time(7)
				get_node("FlowTimer").start()
				flowControl = false
			TutorialCheckResidueError(1, "Filter")
			TutorialCheckAdvance(1, "Filter", 27)
		27:
			TutorialFlowControl(0, 1, null)
		28:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Os equipamentos levam alguns segundos para processar o resíduo. Espere um pouco")
			TutorialFlowControl(1, 16, "Hint")
			var objectsGroup = get_tree().get_nodes_in_group("Filter")
			for object in objectsGroup:
				if (object.GetEquipState() == "Done"):
					stageState = 29
					flowControl = true
					get_node("FlowTimer").stop()
		29:
			TutorialFlowControl(0, 1, null)
		30:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Como você pode ver pela luz verde, o resíduo terminou de ser filtrado")
			if (flowControl):
				get_node("HUD").get_node("CanvasLayer/Messages/Hint/ProfPortrait").set_frame(0)
				get_node("HUD").get_node("CanvasLayer/Messages/Hint/ProfPortrait").play()
				get_node("HUD").get_node("CanvasLayer/Messages").show()
				get_node("FlowTimer").set_wait_time(5)
				get_node("FlowTimer").start()
				flowControl = false
			TutorialCheckResidueError(1, "Filter")
			if (get_node("YSort/MainCharacter").GetCharacterState() == "Carry"):
				get_node("FlowTimer").stop()
				stageState = 32
				flowControl = true
				var objectsGroup = get_tree().get_nodes_in_group("Filter")
				for object in objectsGroup:
					object.get_node("AnimationPlayer").play("OffLights")
		31:
			TutorialCheckResidueError(0, null)
			if (get_node("YSort/MainCharacter").GetCharacterState() == "Carry"):
				stageState = 32
				flowControl = true
				get_node("FlowTimer").stop()
			elif (flowControl):
				get_node("FlowTimer").set_wait_time(5)
				get_node("FlowTimer").start()
				flowControl = false
		32:
			TutorialFlowControl(0, 1, null)
		33:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Para encerrar, a etapa final de todo resíduo é o ARMAZENAMENTO")
			TutorialFlowControl(1, 5, "Hint")
			TutorialCheckResidueError(1, "Filter")
			TutorialCheckAdvance(2, null, null)
		34:
			TutorialFlowControl(0, 1, null)
			TutorialCheckResidueError(1, "Filter")
			TutorialCheckAdvance(2, null, null)
		35:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Leve o resíduo de cobre até o equipamento indicado para ARMAZENAR adequadamente")
			if (flowControl):
				var objectsGroup = get_tree().get_nodes_in_group("Storage")
				for object in objectsGroup:
					object.get_node("AnimationPlayer").play("BlinkLights")
				get_node("HUD").get_node("CanvasLayer/Messages/Hint/ProfPortrait").set_frame(0)
				get_node("HUD").get_node("CanvasLayer/Messages/Hint/ProfPortrait").play()
				get_node("HUD").get_node("CanvasLayer/Messages").show()
				get_node("FlowTimer").set_wait_time(5)
				get_node("FlowTimer").start()
				flowControl = false
			TutorialCheckResidueError(1, "Storage")
			TutorialCheckAdvance(2, null, null)
		36:
			TutorialFlowControl(0, 5, null)
			TutorialCheckResidueError(1, "Storage")
			TutorialCheckAdvance(2, null, null)
		37:
			get_node("HUD").get_node("CanvasLayer/Messages/Positive/TextureRect/Label").set_text("Excelente! Agora trate os outros resíduos por conta própria até o fim do expediente!")
			TutorialFlowControl(1, 5, "Positive")
		38:
			get_node("HUD").UpdateStageTime(get_node("StageTimer").get_wait_time(), get_node("StageTimer").get_wait_time() - get_node("StageTimer").get_time_left())
			SpawnResidueTimer()

func TutorialFlowControl(type, waitTime, portraitType):
	if (type == 0):
		get_node("HUD").get_node("CanvasLayer/Messages").hide()
		if (flowControl):
			get_node("FlowTimer").set_wait_time(waitTime)
			get_node("FlowTimer").start()
			flowControl = false
	elif (type == 1):
		if (flowControl):
			get_node("HUD").get_node("CanvasLayer/Messages/" + portraitType + "/ProfPortrait").set_frame(0)
			get_node("HUD").get_node("CanvasLayer/Messages/" + portraitType + "/ProfPortrait").play()
			get_node("HUD").get_node("CanvasLayer/Messages").show()
			get_node("FlowTimer").set_wait_time(waitTime)
			get_node("FlowTimer").start()
			flowControl = false

func TutorialCheckResidueError(type, group):
	if (type == 0):
		if (get_node("YSort/MainCharacter").GetCharacterState() == "Hurt" or get_node("YSort/MainCharacter").GetCharacterState() == "Drop"):
			stageState = "LostResidue"
			flowControl = true
			get_node("FlowTimer").stop()
			get_node("HUD").get_node("CanvasLayer/Messages/Hint").hide()
			get_node("HUD").get_node("CanvasLayer/Messages/Negative").show()
	elif (type == 1):
		if (get_node("YSort/MainCharacter").GetCharacterState() == "Hurt" or get_node("YSort/MainCharacter").GetCharacterState() == "Drop"):
			stageState = "LostResidue"
			flowControl = true
			get_node("FlowTimer").stop()
			get_node("HUD").get_node("CanvasLayer/Messages/Hint").hide()
			get_node("HUD").get_node("CanvasLayer/Messages/Negative").show()
			var objectsGroup = get_tree().get_nodes_in_group(group)
			for object in objectsGroup:
				object.get_node("AnimationPlayer").play("OffLights")

func TutorialCheckAdvance(type, group, stateChange):
	if (type == 0):
		if (get_node("YSort/MainCharacter").CheckFullGear()):
			var objectsGroup = get_tree().get_nodes_in_group("EPI")
			for object in objectsGroup:
				object.get_node("AnimationPlayer").play("OffLights")
			stageState = 7
	elif (type == 1):
		if (!get_tree().has_group("Residue") and get_node("YSort/MainCharacter").GetCharacterState() == "Initial"):
			stageState = stateChange
			flowControl = true
			get_node("FlowTimer").stop()
			var objectsGroup = get_tree().get_nodes_in_group(group)
			for object in objectsGroup:
				object.get_node("AnimationPlayer").play("OffLights")
	elif (type == 2):
		if (!get_tree().has_group("Residue") and get_node("YSort/MainCharacter").GetCharacterState() == "Initial"):
			stageState = 37
			flowControl = true
			get_node("FlowTimer").stop()
			get_node("HUD").get_node("CanvasLayer/Messages/Hint").hide()
			get_node("HUD").get_node("CanvasLayer/Messages/Positive").show()
			var objectsGroup = get_tree().get_nodes_in_group("Storage")
			for object in objectsGroup:
				object.get_node("AnimationPlayer").play("OffLights")

func SpawnResidueTimer():
	if (spawnerControl and get_node("YSort/Spawner").GetEquipState() == "Idle"):
		spawnerControl = false
		get_node("SpawnTimer").start()

func UpdateResidueInfo():
	if (get_node("YSort/MainCharacter").GetCharacterState() == "Carry"):
		get_node("HUD").SetResidueInfo(true, get_node("YSort/MainCharacter").GetCarriedResidue().GetResidueName(), get_node("YSort/MainCharacter").GetCarriedResidue().GetResidueStage())
	else:
		get_node("HUD").SetResidueInfo(false, null, null)
