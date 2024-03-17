extends StaticBody2D

const IDLE = "Idle"
const ACTIVE = "Active"
const DONE = "Done"

var equipState
var currentResidue = {"Name": null, "Stage": null}
var processProgress
var processControl

func _ready():
	equipState = IDLE
	get_node("Timer").connect("timeout", self, "_on_Timer_timeout")

func _process(delta):
	EquipStateMachine()
	EquipAnimation()

func EquipStateMachine():
	match equipState:
		IDLE:
			currentResidue = {"Name": null, "Stage": null}
			processProgress = 0
			processControl = true
			get_node("Node2D/TextureProgress").hide()
			get_node("Timer").stop()
		ACTIVE:
			var currentTime = get_node("Timer").get_wait_time() - get_node("Timer").get_time_left()
			processProgress = lerp(0, 100, currentTime/get_node("Timer").get_wait_time())
			get_node("Node2D/TextureProgress").set_value(processProgress)
		DONE:
			if (processControl):
				var residue = preload("res://scenes/equipment/Residue.tscn").instance()
				residue.SetResidueName(currentResidue["Name"])
				residue.SetResidueStage(currentResidue["Stage"] + 1)
				residue.SetResidueState("READY")
				residue.SetTargetObject(get_path())
				residue.hide()
				get_parent().add_child(residue)
				get_node("AnimationPlayer").set_current_animation("BlinkGreenLights")
				processControl = false

func EquipAnimation():
	get_node("AnimatedSprite").set_animation(equipState)

func CheckResidueMatch(residueName, residueStage):
	if (residueName == "Água"):
		return false
	elif (residueName == "Cobre"):
		return false
	elif (residueName == "Níquel"):
		if (residueStage == 1):
			equipState = ACTIVE
			currentResidue["Name"] = residueName
			currentResidue["Stage"] = residueStage
			get_node("Node2D/TextureProgress").show()
			get_node("Timer").start()
			return true
		else:
			return false
	elif (residueName == "Mercúrio"):
		if (residueStage == 3):
			equipState = ACTIVE
			currentResidue["Name"] = residueName
			currentResidue["Stage"] = residueStage
			get_node("Node2D/TextureProgress").show()
			get_node("Timer").start()
			return true
		else:
			return false
	elif (residueName == "Cádmio"):
		if (residueStage == 4):
			equipState = ACTIVE
			currentResidue["Name"] = residueName
			currentResidue["Stage"] = residueStage
			get_node("Node2D/TextureProgress").show()
			get_node("Timer").start()
			return true
		else:
			return false

func SetEquipState(state):
	if (state == "Idle"):
		get_node("AnimationPlayer").set_current_animation("OffLights")
	equipState = state

func GetEquipState():
	return equipState

func _on_Timer_timeout():
	equipState = DONE
	get_node("Timer").stop()
