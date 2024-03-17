extends Node

# Conecta o Timer e AnimationPlayer com o Fade e mudança de cena
func _ready():
	get_node("Timer").connect("timeout", self, "_on_Timer_timeout")
	get_node("AnimationPlayer").connect("animation_finished", self, "_on_AnimationPlayer_finished")

# Verifica se o jogador apertou Enter ou Espaço
# Depois tira a permissão de controle e inicia Fade
func _process(delta):
	if (GameMaster.GetPlayerInputPermission() and Input.is_action_just_pressed("ui_select")) :
		GameMaster.SetPlayerInputPermission(false)
		get_node("Timer").stop()
		get_node("AnimationPlayer").play("FadeOut")

# Inicia FadeOut quando o Timer acaba
func _on_Timer_timeout():
	get_node("AnimationPlayer").play("FadeOut")

# Inicia mudança de cena ao terminar FadeOut
# Necessário verificar diferença porque essa cena tem FadeIn
# O FadeIn está em autoplay no AnimationPlayer
func _on_AnimationPlayer_finished(animation):
	if (animation == "FadeOut"):
		GoToCutscene()

# Inicia mudança de cena e devolve controle ao jogador
func GoToCutscene():
	GameMaster.goto_scene("res://scenes/intro/Cutscene.tscn", "Fast")
	GameMaster.SetPlayerInputPermission(true)
