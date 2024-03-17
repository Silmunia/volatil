extends Control

export (AudioStream) var slowestClock
export (AudioStream) var slowClock
export (AudioStream) var fastClock
export (AudioStream) var fastestClock
export (AudioStream) var alarmClock

var timeAlarmControl
var characterGear
var stageMode

func _ready():
	timeAlarmControl = [true, true, true, true, true]
	characterGear = Vector3(0, 0, 0)
	get_node("CanvasLayer/PlayerInfo/CharacterPortrait").set_animation("4")
	get_node("CanvasLayer/GearInfo/MaskIcon").set_animation("0")
	get_node("CanvasLayer/GearInfo/GloveIcon").set_animation("0")
	get_node("CanvasLayer/GearInfo/CoatIcon").set_animation("0")
	get_node("CanvasLayer/Messages/Positive").hide()
	get_node("CanvasLayer/Messages/Negative").hide()
	get_node("CanvasLayer/Messages/Hint").hide()
	get_node("CanvasLayer/Messages/Observation").hide()
	get_node("CanvasLayer/Messages/Timer").connect("timeout", self, "_on_MessagesTimer_timeout")
	get_node("CanvasLayer/PlayerInfo/ClockAnimation").connect("animation_finished", self, "_on_ClockAnimation_finished")
	get_node("CanvasLayer/PlayerInfo/ProfileAnimation").connect("animation_finished", self, "_on_ProfileAnimation_finished")

func _process(delta):
	BlinkCharacterGear()

func _on_MessagesTimer_timeout():
	get_node("CanvasLayer/Messages").hide()

func _on_ClockAnimation_finished(animation):
	if (animation == "ClockAlarm" and stageMode == "Normal"):
		GameMaster.GoToVictory()
	if (animation != "None"):
		get_node("CanvasLayer/PlayerInfo/ClockAnimation").set_current_animation("None")

func _on_ProfileAnimation_finished(animation):
	if (animation != "None"):
		get_node("CanvasLayer/PlayerInfo/ProfileAnimation").set_current_animation("None")

func UpdateStageProgress(stageType, residueCounter, residueGoal):
	if (stageType == "Normal"):
		stageMode = stageType
		get_node("CanvasLayer/StageProgress/Challenge").hide()
		get_node("CanvasLayer/StageProgress/Normal/Counter").set_text(convert(residueCounter, TYPE_STRING))
		get_node("CanvasLayer/StageProgress/Normal").show()
	elif (stageType == "Challenge"):
		stageMode = stageType
		get_node("CanvasLayer/StageProgress/Normal").hide()
		get_node("CanvasLayer/StageProgress/Challenge/Counter").set_text(convert(residueCounter, TYPE_STRING))
		get_node("CanvasLayer/StageProgress/Challenge/TextureProgress").set_max(residueGoal + 1)
		get_node("CanvasLayer/StageProgress/Challenge/TextureProgress").set_value(residueCounter)
		get_node("CanvasLayer/StageProgress/Challenge").show()

func UpdateStageTime(totalTime, currentTime):
	var frameNumber = 24
	var animationPercent = floor(frameNumber * (currentTime / totalTime))
	if (animationPercent == floor(frameNumber*0.2) and timeAlarmControl[0]):
		timeAlarmControl[0] = false
		get_node("CanvasLayer/PlayerInfo/ClockAnimation").set_current_animation("SlowestClockPulse")
		get_node("CanvasLayer/PlayerInfo/AudioStreamPlayer").set_stream(slowestClock)
		get_node("CanvasLayer/PlayerInfo/AudioStreamPlayer").play()
	elif (animationPercent == floor(frameNumber*0.4) and timeAlarmControl[1]):
		timeAlarmControl[1] = false
		get_node("CanvasLayer/PlayerInfo/ClockAnimation").set_current_animation("SlowClockPulse")
		get_node("CanvasLayer/PlayerInfo/AudioStreamPlayer").set_stream(slowClock)
		get_node("CanvasLayer/PlayerInfo/AudioStreamPlayer").play()
	elif (animationPercent == floor(frameNumber*0.6) and timeAlarmControl[2]):
		timeAlarmControl[2] = false
		get_node("CanvasLayer/PlayerInfo/ClockAnimation").set_current_animation("FastClockPulse")
		get_node("CanvasLayer/PlayerInfo/AudioStreamPlayer").set_stream(fastClock)
		get_node("CanvasLayer/PlayerInfo/AudioStreamPlayer").play()
	elif (animationPercent == floor(frameNumber*0.8) and timeAlarmControl[3]):
		timeAlarmControl[3] = false
		get_node("CanvasLayer/PlayerInfo/ClockAnimation").set_current_animation("FastestClockPulse")
		get_node("CanvasLayer/PlayerInfo/AudioStreamPlayer").set_stream(fastestClock)
		get_node("CanvasLayer/PlayerInfo/AudioStreamPlayer").play()
	elif (animationPercent >= frameNumber and timeAlarmControl[4]):
		timeAlarmControl[4] = false
		get_node("CanvasLayer/PlayerInfo/ClockAnimation").set_current_animation("ClockAlarm")
		get_node("CanvasLayer/PlayerInfo/AudioStreamPlayer").set_stream(alarmClock)
		get_node("CanvasLayer/PlayerInfo/AudioStreamPlayer").play()
		return
	get_node("CanvasLayer/PlayerInfo/TimePortrait").show()
	get_node("CanvasLayer/PlayerInfo/TimePortrait").set_animation(str(animationPercent))

func PositiveFeedback():
	get_node("CanvasLayer/Messages").show()
	get_node("CanvasLayer/Messages/Negative").hide()
	get_node("CanvasLayer/Messages/Hint").hide()
	get_node("CanvasLayer/Messages/Observation").hide()
	get_node("CanvasLayer/Messages/Positive/ProfPortrait").set_frame(0)
	var chance = randf()
	if (chance >= 0.66):
		get_node("CanvasLayer/Messages/Positive/TextureRect/Label").set_text("Queria ter orçamento para mais estagiários como você, Murdock!")
	elif (chance >= 0.33):
		get_node("CanvasLayer/Messages/Positive/TextureRect/Label").set_text("Você realmente está pegando o jeito, hein? Muito bem, Murdock!")
	else:
		get_node("CanvasLayer/Messages/Positive/TextureRect/Label").set_text("Excelente, Murdock! Achei que você demoraria mais para aprender os processos!")
	get_node("CanvasLayer/Messages/Positive").show()
	get_node("CanvasLayer/Messages/Positive/ProfPortrait").play()
	get_node("CanvasLayer/Messages/Timer").set_wait_time(5)
	get_node("CanvasLayer/Messages/Timer").start()

func SetResidueInfo(enable, residueName, residueStage):
	if (enable):
		get_node("CanvasLayer/ResidueInfo/Label/ResidueName").set_text("Resíduo de " + residueName)
		get_node("CanvasLayer/ResidueInfo/ResiduePortrait").set_animation(residueName)
		match residueStage:
			0:
				get_node("CanvasLayer/ResidueInfo/Label/ResidueStage").set_text("Estágio: Inicial")
			1:
				match residueName:
					"Água":
						get_node("CanvasLayer/ResidueInfo/Label/ResidueStage").set_text("Estágio: Filtrado")
					"Cobre":
						get_node("CanvasLayer/ResidueInfo/Label/ResidueStage").set_text("Estágio: Ajustado")
					"Níquel":
						get_node("CanvasLayer/ResidueInfo/Label/ResidueStage").set_text("Estágio: Ajustado")
					"Mercúrio":
						get_node("CanvasLayer/ResidueInfo/Label/ResidueStage").set_text("Estágio: Ajustado")
					"Cádmio":
						get_node("CanvasLayer/ResidueInfo/Label/ResidueStage").set_text("Estágio: Agitado")
			2:
				match residueName:
					"Cobre":
						get_node("CanvasLayer/ResidueInfo/Label/ResidueStage").set_text("Estágio: Filtrado")
					"Níquel":
						get_node("CanvasLayer/ResidueInfo/Label/ResidueStage").set_text("Estágio: Verificado")
					"Mercúrio":
						get_node("CanvasLayer/ResidueInfo/Label/ResidueStage").set_text("Estágio: Repousado")
					"Cádmio":
						get_node("CanvasLayer/ResidueInfo/Label/ResidueStage").set_text("Estágio: Ajustado")
			3:
				match residueName:
					"Níquel":
						get_node("CanvasLayer/ResidueInfo/Label/ResidueStage").set_text("Estágio: Filtrado")
					"Mercúrio":
						get_node("CanvasLayer/ResidueInfo/Label/ResidueStage").set_text("Estágio: Filtrado")
					"Cádmio":
						get_node("CanvasLayer/ResidueInfo/Label/ResidueStage").set_text("Estágio: Aquecido")
			4:
				match residueName:
					"Mercúrio":
						get_node("CanvasLayer/ResidueInfo/Label/ResidueStage").set_text("Estágio: Verificado")
					"Cádmio":
						get_node("CanvasLayer/ResidueInfo/Label/ResidueStage").set_text("Estágio: Filtrado")
			5:
				get_node("CanvasLayer/ResidueInfo/Label/ResidueStage").set_text("Estágio: Verificado")
		get_node("CanvasLayer/ResidueInfo").show()
	else:
		get_node("CanvasLayer/ResidueInfo").hide()

func _on_MainCharacter_updateHealth(characterState, health):
	get_node("CanvasLayer/PlayerInfo/ProfileAnimation").set_current_animation("ProfileShake")
	get_node("CanvasLayer/PlayerInfo/CharacterPortrait").set_animation(convert(health, TYPE_STRING))

func _on_MainCharacter_updateGear(mask, glove, coat):
	if (mask < 0):
		mask = 0
	if (glove < 0):
		glove = 0
	if (coat < 0):
		coat = 0
	characterGear = Vector3(mask, glove, coat)
	get_node("CanvasLayer/GearInfo/MaskIcon").set_animation(convert(mask, TYPE_STRING))
	get_node("CanvasLayer/GearInfo/GloveIcon").set_animation(convert(ceil(glove/2), TYPE_STRING))
	get_node("CanvasLayer/GearInfo/CoatIcon").set_animation(convert(ceil(coat/3), TYPE_STRING))

func BlinkCharacterGear():
	if (characterGear[0] == 0):
		get_node("CanvasLayer/GearInfo/MaskIcon/LightAnimation").set_current_animation("BlinkRedLights")
	else:
		get_node("CanvasLayer/GearInfo/MaskIcon/LightAnimation").set_current_animation("None")
	if (characterGear[1] == 0):
		get_node("CanvasLayer/GearInfo/GloveIcon/LightAnimation").set_current_animation("BlinkRedLights")
	else:
		get_node("CanvasLayer/GearInfo/GloveIcon/LightAnimation").set_current_animation("None")
	if (characterGear[2] == 0):
		get_node("CanvasLayer/GearInfo/CoatIcon/LightAnimation").set_current_animation("BlinkRedLights")
	else:
		get_node("CanvasLayer/GearInfo/CoatIcon/LightAnimation").set_current_animation("None")

func _on_MainCharacter_error(error):
	if (!GameMaster.GetPlaySafe()):
		get_node("CanvasLayer/Messages/Positive").hide()
		get_node("CanvasLayer/Messages/Hint").hide()
		get_node("CanvasLayer/Messages/Observation").hide()
		get_node("CanvasLayer/Messages").show()
		match error:
			"NoEPI":
				var text = "Não tente pegar os resíduos sem vestir os EPI, Murdock! É muito perigoso!"
				get_node("CanvasLayer/Messages/Negative/TextureRect/Label").set_text(text)
			"ResidueEPI":
				var text = "Por que você está colocando o resíduo nos armários de EPI, Murdock?"
				get_node("CanvasLayer/Messages/Negative/TextureRect/Label").set_text(text)
			"DropResidue":
				var text = "Tenha mais cuidado ao segurar os resíduos, Murdock! Não pegue eles de qualquer jeito!"
				get_node("CanvasLayer/Messages/Negative/TextureRect/Label").set_text(text)
			"MixResidue":
				var text = "Não tente misturar os resíduos, Murdock! Você não sabe o que pode acontecer!"
				get_node("CanvasLayer/Messages/Negative/TextureRect/Label").set_text(text)
			"DoneEquipment":
				var text = "Este equipamento já tinha um resíduo pronto, Murdock! Era só pegar!"
				get_node("CanvasLayer/Messages/Negative/TextureRect/Label").set_text(text)
			"WrongEquipment":
				var text = "Não, Murdock! Veja se o resíduo está no estágio certo e no equipamento certo!"
				get_node("CanvasLayer/Messages/Negative/TextureRect/Label").set_text(text)
			"ActiveEquipment":
				var text = "Este equipamento ainda estava no meio do processo, Murdock! Olhe a barra de progresso!"
				get_node("CanvasLayer/Messages/Negative/TextureRect/Label").set_text(text)
		get_node("CanvasLayer/Messages/Negative/ProfPortrait").set_frame(0)
		get_node("CanvasLayer/Messages/Negative").show()
		get_node("CanvasLayer/Messages/Negative/ProfPortrait").play()
		get_node("CanvasLayer/Messages/Timer").set_wait_time(5)
		get_node("CanvasLayer/Messages/Timer").start()

func _on_MainCharacter_hint(residue):
	get_node("CanvasLayer/Messages/Negative").hide()
	get_node("CanvasLayer/Messages/Positive").hide()
	get_node("CanvasLayer/Messages/Observation").hide()
	get_node("CanvasLayer/Messages").show()
	get_node("CanvasLayer/Messages/Hint/ProfPortrait").set_frame(0)
	match residue.GetResidueStage():
		0:
			match residue.GetResidueName():
				"Água":
					get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Meio perdido, Murdock? Experimente FILTRAR as suas opções!")
				"Cobre":
					get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Como está o laboratório, Murdock? Alguma coisa precisa de AJUSTE?")
				"Níquel":
					get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Como está o laboratório, Murdock? Alguma coisa precisa de AJUSTE?")
				"Mercúrio":
					get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Como está o laboratório, Murdock? Alguma coisa precisa de AJUSTE?")
				"Cádmio":
					get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Cuidado para não derrubar nada se precisar AGITAR um resíduo, Murdock!")
		1:
			match residue.GetResidueName():
				"Água":
					get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Como está o estoque de EPI, Murdock? Acho que precisamos ARMAZENAR mais")
				"Cobre":
					get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Meio perdido, Murdock? Experimente FILTRAR as suas opções!")
				"Níquel":
					get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Murdock, preciso que você VERIFIQUE uns documentos amanhã, ok?")
				"Mercúrio":
					get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Você parece estressado, Murdock. Sugiro REPOUSAR um pouco quando acabar aí!")
				"Cádmio":
					get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Como está o laboratório, Murdock? Alguma coisa precisa de AJUSTE?")
		2:
			match residue.GetResidueName():
				"Cobre":
					get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Como está o estoque de EPI, Murdock? Acho que precisamos ARMAZENAR mais")
				"Níquel":
					get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Meio perdido, Murdock? Experimente FILTRAR as suas opções!")
				"Mercúrio":
					get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Meio perdido, Murdock? Experimente FILTRAR as suas opções!")
				"Cádmio":
					get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Acho que o laboratório precisa de um sistema para AQUECER. É muito frio aqui!")
		3:
			match residue.GetResidueName():
				"Níquel":
					get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Como está o estoque de EPI, Murdock? Acho que precisamos ARMAZENAR mais")
				"Mercúrio":
					get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Murdock, preciso que você VERIFIQUE uns documentos amanhã, ok?")
				"Cádmio":
					get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Meio perdido, Murdock? Experimente FILTRAR as suas opções!")
		4:
			match residue.GetResidueName():
				"Mercúrio":
					get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Como está o estoque de EPI, Murdock? Acho que precisamos ARMAZENAR mais")
				"Cádmio":
					get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Murdock, preciso que você VERIFIQUE uns documentos amanhã, ok?")
		5:
			get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Como está o estoque de EPI, Murdock? Acho que precisamos ARMAZENAR mais")
	get_node("CanvasLayer/Messages/Hint").show()
	get_node("CanvasLayer/Messages/Hint/ProfPortrait").play()
	get_node("CanvasLayer/Messages/Timer").set_wait_time(5)
	get_node("CanvasLayer/Messages/Timer").start()

func _on_MainCharacter_observation(observed, enable):
	if (enable):
		CharacterHUDObservation(observed)
	else:
		get_node("CanvasLayer/Messages/Observation").hide()

func CharacterHUDObservation(observed):
	get_node("CanvasLayer/Messages/Positive").hide()
	get_node("CanvasLayer/Messages/Hint").hide()
	get_node("CanvasLayer/Messages/Negative").hide()
	get_node("CanvasLayer/Messages").show()
	var text = ""
	if (observed.is_in_group("Residue")):
		var residueState = observed.GetResidueState()
		if (residueState == "Initialized"):
			text = "Esse aqui é o GERADOR de resíduos. Parece ter acabado de gerar um resíduo novo"
		elif (residueState == "Idle"):
			text = "Essa bancada tem um resíduo parado. Não posso esquecer de tratar ele"
		else:
			var equip = observed.GetTargetObject()
			if (get_node(equip).is_in_group("Balance")):
				text = "Esse aqui é o AJUSTADOR de pH. Parece ter acabado de processar um resíduo"
			elif (get_node(equip).is_in_group("Filter")):
				text = "Esse aqui é o FILTRO. Parece ter acabado de processar um resíduo"
			elif (get_node(equip).is_in_group("Checker")):
				text = "Esse aqui é o VERIFICADOR. Parece ter acabado de processar um resíduo"
			elif (get_node(equip).is_in_group("Rester")):
				text = "Esse aqui é o REPOUSADOR. Parece ter acabado de processar um resíduo"
			elif (get_node(equip).is_in_group("Shaker")):
				text = "Esse aqui é o AGITADOR. Parece ter acabado de processar um resíduo"
			elif (get_node(equip).is_in_group("Heater")):
				text = "Esse aqui é o AQUECEDOR. Parece ter acabado de processar um resíduo"
			elif (get_node(equip).is_in_group("Storage")):
				text = "Todo tratamento acaba aqui, com a mãozinha do ARMAZENADOR"
	elif (observed.is_in_group("EPI")):
		text = "Um dos armários de EPI. Não posso esquecer de vestir todos eles"
	elif (observed.is_in_group("Desk")):
		text = "Essa é só uma BANCADA. Posso colocar um resíduo em cima dela se precisar"
	else:
		if (observed.is_in_group("Spawner")):
			text = "Esse aqui é o GERADOR de resíduos. Fica gerando os resíduos que preciso tratar"
		elif (observed.is_in_group("Balance")):
			text = "Esse aqui é o AJUSTADOR de pH. Alguns resíduos precisam desse ajuste para tratar"
		elif (observed.is_in_group("Filter")):
			text = "Esse aqui é o FILTRO. Muitos resíduos precisam passar por ele durante o tratamento"
		elif (observed.is_in_group("Checker")):
			text = "Esse aqui é o VERIFICADOR. Serve para verificar a eficiência de algumas reações"
		elif (observed.is_in_group("Rester")):
			text = "Esse aqui é o REPOUSADOR. Alguns resíduos precisam repousar por um tempo"
		elif (observed.is_in_group("Shaker")):
			text = "Esse aqui é o AGITADOR. Porque às vezes não basta só adicionar um reagente"
		elif (observed.is_in_group("Heater")):
			text = "Esse aqui é o AQUECEDOR. Só sei de um resíduo que precisa passar por aqui"
		elif (observed.is_in_group("Storage")):
			text = "Todo tratamento acaba aqui, com a mãozinha do ARMAZENADOR"
	get_node("CanvasLayer/Messages/Observation/TextureRect/Label").set_text(text)
	get_node("CanvasLayer/Messages/Observation/ProfPortrait").set_frame(0)
	get_node("CanvasLayer/Messages/Observation").show()
	get_node("CanvasLayer/Messages/Observation/ProfPortrait").play()
	get_node("CanvasLayer/Messages/Timer").set_wait_time(9)
	get_node("CanvasLayer/Messages/Timer").start()

func SetPauseCurrentStage(stage):
	get_node("CanvasLayer/PauseMenu").SetCurrentStage(stage)
