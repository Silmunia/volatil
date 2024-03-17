extends StaticBody2D

const IDLE = "Idle"
const ACTIVE = "Active"
const DONE = "Done"

var equipState

signal residueFinished

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
			pass
		ACTIVE:
			pass
		DONE:
			emit_signal("residueFinished")
			equipState = IDLE

func EquipAnimation():
	get_node("AnimatedSprite").set_animation(equipState)

func CheckResidueMatch(residueName, residueStage):
	if (residueName == "Água"):
		if (residueStage == 1):
			equipState = ACTIVE
			return true
		else:
			return false
	elif (residueName == "Cobre"):
		if (residueStage == 2):
			equipState = ACTIVE
			return true
		else:
			return false
	elif (residueName == "Níquel"):
		if (residueStage == 3):
			equipState = ACTIVE
			return true
		else:
			return false
	elif (residueName == "Mercúrio"):
		if (residueStage == 4):
			equipState = ACTIVE
			return true
		else:
			false
	elif (residueName == "Cádmio"):
		if (residueStage == 5):
			equipState = ACTIVE
			return true
		else:
			return false

func SetEquipState(state):
	equipState = state

func GetEquipState():
	return equipState
