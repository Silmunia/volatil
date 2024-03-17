extends Node

export (AudioStream) var hoverMenu
export (AudioStream) var selectMenu

#Variável para mudança nos gráficos da opção em destaque
var selectedChoice
var stageInfo

func _ready():
	#Inicia com a opção em destaque sendo "Jogar"
	GameMaster.SetPlaySafe(false)
	selectedChoice = 0
	stageInfo = GameMaster.GetStageEndInfo()
	GameMaster.SetGameMusic("Menu")
	UpdateText()
	get_node("FadeAnimation").connect("animation_finished", self, "_on_FadeAnimation_finished")

func _process(delta):
	#Restringe o valor de selectedChoice para a faixa [0 - 1]
	selectedChoice = selectedChoice % 2
	if (GameMaster.GetPlayerInputPermission()):
		#Muda selectedChoice conforme a entrada do usuário
		if (Input.is_action_just_pressed("ui_down")):
			selectedChoice += 1
			get_node("AudioStreamPlayer").set_stream(hoverMenu)
			get_node("AudioStreamPlayer").play()
		elif (Input.is_action_just_pressed("ui_up")):
			selectedChoice -= 1
			get_node("AudioStreamPlayer").set_stream(hoverMenu)
			get_node("AudioStreamPlayer").play()
			#Faz valores negativos irem para a última opção
			if selectedChoice < 0:
				selectedChoice = 1
		ChoiceStatus()

#Controla aparência das opções conforme a selecionada
#e ativa transição de telas
func ChoiceStatus():
	if (Input.is_action_just_pressed("ui_select")):
		get_node("AudioStreamPlayer").set_stream(selectMenu)
		get_node("AudioStreamPlayer").play()
		GameMaster.SetPlayerInputPermission(false)
		match selectedChoice:
			0:
				get_node("Retry").set_animation("Select")
				get_node("Return").set_animation("None")
				get_node("FadeAnimation").play("FadeOut")
			1:
				get_node("Retry").set_animation("None")
				get_node("Return").set_animation("Select")
				get_node("FadeAnimation").play("FadeOut")
	else:
		match selectedChoice:
			0:
				get_node("Retry").set_animation("Hover")
				get_node("Return").set_animation("None")
			1:
				get_node("Retry").set_animation("None")
				get_node("Return").set_animation("Hover")

func UpdateText():
	get_node("Title").set_text("Hospitalizado")
	var chance = randf()
	if (chance >= 0.66):
		get_node("Desc").set_text("Os resíduos podem fazer mal para você! Tenha cuidado!")
	elif (chance >= 0.33):
		get_node("Desc").set_text("Você não teria se machucado tanto se lembrasse dos EPI!")
	else:
		get_node("Desc").set_text("Acidentes podem ser extremamente perigosos, então preste atenção!")

func _on_FadeAnimation_finished(animation):
	if (animation == "FadeOut"):
		match selectedChoice:
			0:
				GoToStage()
			1:
				GoToSelect()

# Inicia mudança de cena e devolve controle ao jogador
func GoToStage():
	GameMaster.goto_scene("res://scenes/stages/Stage " + stageInfo["Stage"] + "/Stage" + stageInfo["Stage"] + stageInfo["Type"] + ".tscn", "Fast")
	GameMaster.SetPlayerInputPermission(true)

# Inicia mudança de cena e devolve controle ao jogador
func GoToSelect():
	GameMaster.goto_scene("res://scenes/menus/SelectStage.tscn", "Fast")
	GameMaster.SetPlayerInputPermission(true)
