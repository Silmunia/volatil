extends Node

#spawnerControl controla a frequência do gerador de resíduos
#junto com SpawnTimer
var spawnerControl

#stageType informa à HUD qual o tipo de fase (Normal ou Avançada)
var stageType

#residueCounter registra a quantidade de resíduos tratada pelo jogador
var residueCounter

#residueGoal registra a quantidade de resíduos que deve ser tratada
var residueGoal

func _ready():
	stageType = "Challenge"
	GameMaster.SetGameMusic("Stage2")
	spawnerControl = true
	residueCounter = 0
	residueGoal = 15
	get_node("HUD").SetPauseCurrentStage("res://scenes/stages/Stage 13/Stage13Challenge.tscn")
	get_node("HUD").UpdateStageProgress(stageType, residueCounter, residueGoal)
	get_node("YSort/MainCharacter").connect("updateHealth", get_node("HUD"), "_on_MainCharacter_updateHealth")
	get_node("YSort/MainCharacter").connect("updateHealth", self, "_on_MainCharacter_updateHealth")
	get_node("YSort/MainCharacter").connect("updateGear", get_node("HUD"), "_on_MainCharacter_updateGear")
	get_node("YSort/MainCharacter").connect("error", get_node("HUD"), "_on_MainCharacter_error")
	get_node("YSort/MainCharacter").connect("hint", get_node("HUD"), "_on_MainCharacter_hint")
	get_node("YSort/MainCharacter").connect("observation", get_node("HUD"), "_on_MainCharacter_observation")
	get_node("YSort/MainCharacter").connect("time", self, "_on_MainCharacter_time")
	get_node("YSort/Storage").connect("residueFinished", self, "_on_Storage_residueFinished")
	get_node("SpawnTimer").connect("timeout", self, "_on_SpawnTimer_timeout")
	get_node("StageTimer").connect("timeout", self, "_on_StageTimer_timeout")

func _process(delta):
	get_node("HUD").UpdateStageTime(get_node("StageTimer").get_wait_time(), get_node("StageTimer").get_wait_time() - get_node("StageTimer").get_time_left())
	SpawnResidueTimer()
	UpdateResidueInfo()

func SpawnResidueTimer():
	if (spawnerControl and get_node("YSort/Spawner").GetEquipState() == "Idle"):
		spawnerControl = false
		get_node("SpawnTimer").start()

func UpdateResidueInfo():
	if (get_node("YSort/MainCharacter").GetCharacterState() == "Carry"):
		get_node("HUD").SetResidueInfo(true, get_node("YSort/MainCharacter").GetCarriedResidue().GetResidueName(), get_node("YSort/MainCharacter").GetCarriedResidue().GetResidueStage())
	else:
		get_node("HUD").SetResidueInfo(false, null, null)

func _on_MainCharacter_updateHealth(characterState, health):
	if (characterState == "Health"):
		GameMaster.SetStageEndInfo("13", stageType, residueCounter)
		GameMaster.GoToHealthLoss()

func _on_MainCharacter_time():
	GameMaster.SetStageEndInfo("13", stageType, residueCounter)
	GameMaster.GoToTimeLoss()

func _on_Storage_residueFinished():
	residueCounter += 1
	get_node("HUD").PositiveFeedback()
	get_node("HUD").UpdateStageProgress(stageType, residueCounter, residueGoal)
	if (residueCounter == residueGoal):
		var timeFinished = get_node("StageTimer").get_wait_time() - get_node("StageTimer").get_time_left()
		GameMaster.SetStageEndInfo("13", stageType, timeFinished)
		GameMaster.GoToVictory()

func _on_StageTimer_timeout():
	var residues = get_tree().get_nodes_in_group("Residue")
	for i in residues.size():
		residues[i].queue_free()
	var storages = get_tree().get_nodes_in_group("Storage")
	for i in storages.size():
		storages[i].SetEquipState("Idle")
	get_node("YSort/MainCharacter").SetCharacterState("Time")

func _on_SpawnTimer_timeout():
	var chance = randf()
	if (chance <= 0.15):
		get_node("YSort/Spawner").SpawnResidue("Níquel")
	elif (chance <= 0.30):
		get_node("YSort/Spawner").SpawnResidue("Mercúrio")
	else:
		get_node("YSort/Spawner").SpawnResidue("Cádmio")
	get_node("SpawnTimer").stop()
	spawnerControl = true
