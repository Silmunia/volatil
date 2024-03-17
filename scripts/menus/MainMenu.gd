extends Node

export (AudioStream) var hoverMenu
export (AudioStream) var selectMenu

#Variável para mudança nos gráficos da opção em destaque
var selectedChoice

func _ready():
	#Inicia com a opção em destaque sendo "Jogar"
	selectedChoice = 0
	GameMaster.SetGameMusic("Menu")
	get_node("FadeAnimation").connect("animation_finished", self, "_on_FadeAnimation_finished")

func _process(delta):
	
	#Restringe o valor de selectedChoice para a faixa [0 - 2]
	selectedChoice = selectedChoice % 3
	
	if (GameMaster.GetPlayerInputPermission()):
		
		#Muda selectedChoice conforme a entrada do usuário
		if (Input.is_action_just_pressed("ui_down")):
			get_node("AudioStreamPlayer").set_stream(hoverMenu)
			get_node("AudioStreamPlayer").play()
			selectedChoice += 1
		elif (Input.is_action_just_pressed("ui_up")):
			get_node("AudioStreamPlayer").set_stream(hoverMenu)
			get_node("AudioStreamPlayer").play()
			selectedChoice -= 1
			
			#Faz valores negativos irem para a última opção
			if selectedChoice < 0:
				selectedChoice = 2
		ChoiceStatus()

#Controla aparência das opções conforme a selecionada
#e ativa transição de telas
func ChoiceStatus():
	if (Input.is_action_just_pressed("ui_select")):
		get_node("AudioStreamPlayer").set_stream(selectMenu)
		get_node("AudioStreamPlayer").play()
		GameMaster.SetPlayerInputPermission(false)
		get_node("Cursor").set_animation("Select")
		get_node("FadeAnimation").play("FadeOut")
	else:
		get_node("Cursor").set_animation("Hover")
		match selectedChoice:
			0:
				get_node("Cursor").set_position(Vector2(168, 452))
				#get_node("Cursor").set_rotation(deg2rad(4.7))
			1:
				get_node("Cursor").set_position(Vector2(149, 575))
				#get_node("Cursor").set_rotation(deg2rad(-5.6))
			2:
				get_node("Cursor").set_position(Vector2(140, 702))
				#get_node("Cursor").set_rotation(deg2rad(-12.2))

func _on_FadeAnimation_finished(animation):
	if (animation == "FadeOut"):
		match selectedChoice:
			0:
				GoToSelect()
			1:
				GoToOptions()
			2:
				GoToQuit()

# Inicia mudança de cena e devolve controle ao jogador
func GoToSelect():
	GameMaster.goto_scene("res://scenes/menus/SelectStage.tscn", "Fast")
	GameMaster.SetPlayerInputPermission(true)

# Inicia mudança de cena e devolve controle ao jogador
func GoToOptions():
	GameMaster.goto_scene("res://scenes/menus/Options.tscn", "Fast")
	GameMaster.SetPlayerInputPermission(true)

#Encerra programa
func GoToQuit():
	get_tree().quit()
