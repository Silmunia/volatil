extends Node

export (AudioStream) var hoverMenu
export (AudioStream) var selectMenu

var creditsPosition

func _ready():
	creditsPosition = 0
	get_node("FadeAnimation").connect("animation_finished", self, "_on_FadeAnimation_finished")
	get_node("CreditsAnimation").connect("animation_finished", self, "_on_CreditsAnimation_finished")

func _on_FadeAnimation_finished(animation):
	if (animation == "FadeOut"):
		GoToOptions()

func _on_CreditsAnimation_finished(animation):
	GameMaster.SetPlayerInputPermission(true)

func _process(delta):
	if (GameMaster.GetPlayerInputPermission()):
		if (Input.is_action_just_pressed("ui_cancel")):
			get_node("AudioStreamPlayer").set_stream(selectMenu)
			get_node("AudioStreamPlayer").play()
			GameMaster.SetPlayerInputPermission(false)
			get_node("Cursor").set_animation("Select")
			get_node("FadeAnimation").play("FadeOut")
		if (creditsPosition == 0 and Input.is_action_just_pressed("ui_right")):
			get_node("AudioStreamPlayer").set_stream(hoverMenu)
			get_node("AudioStreamPlayer").play()
			GameMaster.SetPlayerInputPermission(false)
			creditsPosition = 1
			get_node("CreditsAnimation").play("Position0To1")
		elif (creditsPosition == 1 and Input.is_action_just_pressed("ui_left")):
			get_node("AudioStreamPlayer").set_stream(hoverMenu)
			get_node("AudioStreamPlayer").play()
			GameMaster.SetPlayerInputPermission(false)
			creditsPosition = 0
			get_node("CreditsAnimation").play("Position1To0")
		if (Input.is_action_just_pressed("ui_select")):
			get_node("AudioStreamPlayer").set_stream(selectMenu)
			get_node("AudioStreamPlayer").play()
			GameMaster.SetPlayerInputPermission(false)
			get_node("Cursor").set_animation("Select")
			get_node("FadeAnimation").play("FadeOut")

func GoToOptions():
	GameMaster.goto_scene("res://scenes/menus/Options.tscn", "Fast")
	GameMaster.SetPlayerInputPermission(true)
