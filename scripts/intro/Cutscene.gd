extends Node

export (AudioStream) var hoverMenu
export (AudioStream) var selectMenu

# Variável que registra cena atual da cutscene
var cutscene

# Conecta AnimationPlayer com o Fade e configura cena inicial
func _ready():
	cutscene = 1
	GameMaster.SetGameMusic("Intro")
	get_node("AnimationPlayer").connect("animation_finished", self, "_on_AnimationPlayer_finished")

func _process(delta):
	# Verifica se o jogador tem o controle
	if (GameMaster.playerInputPermission):
		CutsceneChange()
	ControlSignifiers()

func CutsceneChange():
	# Se apertar Enter ou Espaço, a cutscene é totalmente encerrada
	if (cutscene == 4 and Input.is_action_just_pressed("ui_select")):
		get_node("AudioStreamPlayer").set_stream(selectMenu)
		get_node("AudioStreamPlayer").play()
		GameMaster.playerInputPermission = false
		get_node("AnimationPlayer").play("FadeOut")
	
	# Inicia animação para próxima cena
	elif (Input.is_action_just_pressed("ui_right")):
		# Usa animação de acordo com cena atual
		match cutscene:
			1:
				get_node("AudioStreamPlayer").set_stream(hoverMenu)
				get_node("AudioStreamPlayer").play()
				GameMaster.playerInputPermission = false
				cutscene = 2
				get_node("AnimationPlayer").play("Position1To2")
			2:
				get_node("AudioStreamPlayer").set_stream(hoverMenu)
				get_node("AudioStreamPlayer").play()
				GameMaster.playerInputPermission = false
				cutscene = 3
				get_node("AnimationPlayer").play("Position2To3")
			3:
				get_node("AudioStreamPlayer").set_stream(hoverMenu)
				get_node("AudioStreamPlayer").play()
				GameMaster.playerInputPermission = false
				cutscene = 4
				get_node("AnimationPlayer").play("Position3To4")
	
	# Inicia animação para cena anterior
	elif (Input.is_action_just_pressed("ui_left")):
		# Usa animação de acordo com cena atual
		match cutscene:
			2:
				get_node("AudioStreamPlayer").set_stream(hoverMenu)
				get_node("AudioStreamPlayer").play()
				GameMaster.playerInputPermission = false
				cutscene = 1
				get_node("AnimationPlayer").play("Position2To1")
			3:
				get_node("AudioStreamPlayer").set_stream(hoverMenu)
				get_node("AudioStreamPlayer").play()
				GameMaster.playerInputPermission = false
				cutscene = 2
				get_node("AnimationPlayer").play("Position3To2")
			4:
				get_node("AudioStreamPlayer").set_stream(hoverMenu)
				get_node("AudioStreamPlayer").play()
				GameMaster.playerInputPermission = false
				cutscene = 3
				get_node("AnimationPlayer").play("Position4To3")

func ControlSignifiers():
	
	#Se AnimationPlayer estiver em Fade ou mudança de cena,
	#os significadores de controle são escondidos
	if (get_node("AnimationPlayer").is_playing()):
		get_node("PrevScene").hide()
		get_node("NextScene").hide()
		get_node("EndScene").hide()
	#Define para aparecerem apenas os significadores relevantes
	#para a cena atual
	else:
		if (cutscene == 1):
			get_node("PrevScene").hide()
			get_node("NextScene").show()
			get_node("EndScene").hide()
		elif (cutscene == 4):
			get_node("PrevScene").show()
			get_node("NextScene").hide()
			get_node("EndScene").show()
		else:
			get_node("PrevScene").show()
			get_node("NextScene").show()
			get_node("EndScene").hide()

# Inicia mudança de cena ao terminar FadeOut
# Necessário verificar diferença por ter várias animações
# O FadeIn está em autoplay no AnimationPlayer
func _on_AnimationPlayer_finished(animation):
	if (animation == "FadeOut"):
		GoToMainMenu()
	else:
		GameMaster.playerInputPermission = true

# Inicia mudança de cena e devolve controle ao jogador
func GoToMainMenu():
	GameMaster.goto_scene("res://scenes/menus/MainMenu.tscn", "Fast")
	GameMaster.playerInputPermission = true
