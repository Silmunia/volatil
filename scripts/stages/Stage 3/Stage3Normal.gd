extends Node

#spawnerControl controla a frequência do gerador de resíduos
#junto com SpawnTimer
var spawnerControl

#stageType informa à HUD qual o tipo de fase (Normal ou Avançada)
var stageType

#residueCounter registra a quantidade de resíduos tratada pelo jogador
var residueCounter

func _ready():
	stageType = "Normal"
	GameMaster.SetGameMusic("Stage1")
	spawnerControl = true
	residueCounter = 0
	get_node("HUD").SetPauseCurrentStage("res://scenes/stages/Stage 3/Stage3Normal.tscn")
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

func _on_MainCharacter_updateHealth(characterState, health):
	if (characterState == "Health"):
		GameMaster.SetStageEndInfo("3", stageType, residueCounter)
		GameMaster.GoToHealthLoss()

func _on_Storage_residueFinished():
	residueCounter += 1
	get_node("HUD").PositiveFeedback()
	get_node("HUD").UpdateStageProgress(stageType, residueCounter, null)

func _on_StageTimer_timeout():
	GameMaster.SetStageEndInfo("3", stageType, residueCounter)

func _on_SpawnTimer_timeout():
	var chance = randf()
	if (chance >= 0.5):
		get_node("YSort/Spawner").SpawnResidue("Cobre")
	else:
		get_node("YSort/Spawner").SpawnResidue("Níquel")
	get_node("SpawnTimer").stop()
	spawnerControl = true

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
