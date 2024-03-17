extends StaticBody2D

const IDLE = "Idle"
const ACTIVE = "Active"
const DONE = "Done"

var equipState
var currentResidue = null
var processControl

func _ready():
	equipState = IDLE
	get_node("AnimatedSprite").connect("animation_finished", self, "_on_AnimatedSprite_finished")

func _on_AnimatedSprite_finished():
	if (equipState == ACTIVE):
		equipState = DONE

func _process(delta):
	EquipStateMachine()
	EquipAnimation()

func EquipStateMachine():
	match equipState:
		IDLE:
			currentResidue = null
			processControl = true
		ACTIVE:
			pass
		DONE:
			if (processControl):
				var residue = preload("res://scenes/equipment/Residue.tscn").instance()
				residue.SetResidueName(currentResidue)
				residue.SetResidueStage(0)
				residue.SetResidueState("INITIALIZED")
				residue.SetTargetObject(get_path())
				residue.hide()
				get_parent().add_child(residue)
				get_node("AnimationPlayer").set_current_animation("BlinkGreenLights")
				processControl = false

func SpawnResidue(residueName):
	currentResidue = residueName
	equipState = ACTIVE
	get_node("AudioStreamPlayer").play()

func EquipAnimation():
	if (equipState == IDLE):
		get_node("AnimatedSprite").set_animation(equipState)
	else:
		get_node("AnimatedSprite").set_animation(equipState + currentResidue)

func CheckResidueMatch(residueName, residueStage):
	return false

func SetEquipState(state):
	if (state == "Idle"):
		get_node("AnimationPlayer").set_current_animation("OffLights")
	equipState = state

func GetEquipState():
	return equipState
