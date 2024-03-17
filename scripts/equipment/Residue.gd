extends Area2D

#Constantes do estado do resíduo
const INITIALIZED = "Initialized"
const CARRIED = "Carried"
const IDLE = "Idle"
const READY = "Ready"
const FALL = "Fall"
const BOOM = "Boom"

var residueState
var targetObject
var residueInfo = {"Name": null, "Stage": null}

func _process(delta):
	ResidueStateMachine()

func ResidueStateMachine():
	ResidueAnimation()
	match residueState:
		INITIALIZED:
			var positionX = get_node(targetObject).get_global_position().x
			var positionY = get_node(targetObject).get_global_position().y
			set_global_position(Vector2(positionX, positionY+1))
			set_collision_layer_bit(0, true)
			get_node("AnimatedSprite").set_global_position(Vector2(positionX, positionY-63))
			get_node("CollisionShape2D").set_global_position(Vector2(positionX, positionY-63))
			get_node("Light2D").set_global_position(Vector2(positionX, positionY-46.5))
		CARRIED:
			var positionX = get_node(targetObject).get_global_position().x
			var positionY = get_node(targetObject).get_global_position().y
			set_collision_layer_bit(0, false)
			set_global_position(Vector2(positionX, positionY))
			get_node("AnimatedSprite").set_global_position(Vector2(positionX-3.5, positionY-98))
			get_node("CollisionShape2D").set_global_position(Vector2(positionX-3.5, positionY-98))
			get_node("Light2D").set_global_position(Vector2(positionX-3.5, positionY-98))
		READY:
			var positionX = get_node(targetObject).get_global_position().x
			var positionY = get_node(targetObject).get_global_position().y
			set_global_position(Vector2(positionX, positionY+1))
			set_collision_layer_bit(0, true)
			get_node("AnimatedSprite").set_global_position(Vector2(positionX, positionY-63))
			get_node("CollisionShape2D").set_global_position(Vector2(positionX, positionY-63))
			get_node("Light2D").set_global_position(Vector2(positionX, positionY-46.5))
		IDLE:
			var positionX = get_node(targetObject).get_global_position().x
			var positionY = get_node(targetObject).get_global_position().y
			set_global_position(Vector2(positionX, positionY+1))
			set_collision_layer_bit(0, true)
			get_node("AnimatedSprite").set_global_position(Vector2(positionX, positionY-63))
			get_node("CollisionShape2D").set_global_position(Vector2(positionX, positionY-63))
			get_node("Light2D").set_global_position(Vector2(positionX, positionY-46.5))
		FALL:
			var positionX = get_global_position().x
			var positionY = get_global_position().y
			set_global_position(Vector2(positionX, positionY+3))
			get_node("AnimatedSprite").set_global_position(Vector2(positionX-3, positionY-73))
			get_node("CollisionShape2D").set_global_position(Vector2(positionX-3, positionY-73))
			get_node("Light2D").set_global_position(Vector2(positionX-3, positionY-73))
			if (get_global_position().y - 60 >= get_node(targetObject).get_global_position().y):
				CreateExplosion(positionX, positionY)
				queue_free()
		BOOM:
			var positionX = get_global_position().x
			var positionY = get_global_position().y
			CreateExplosion(positionX, positionY+60)
			queue_free()

func ResidueAnimation():
	get_node("AnimatedSprite").set_animation(residueInfo["Name"] + convert(residueInfo["Stage"], TYPE_STRING))

func CreateExplosion(positionX, positionY):
	var explosion = preload("res://scenes/vfx/Explosion.tscn").instance()
	explosion.set_global_position(Vector2(positionX-30, positionY-120))
	get_parent().add_child(explosion)

func FreeEquipment():
	get_node(targetObject).SetEquipState("Idle")

func LightEquipment(enable):
	get_node(targetObject).get_node("Light2D").set_enabled(enable)

func SetResidueState(state):
	match state:
		"INITIALIZED":
			residueState = INITIALIZED
		"CARRIED":
			residueState = CARRIED
		"IDLE":
			residueState = IDLE
		"READY":
			residueState = READY
		"FALL":
			residueState = FALL
		"BOOM":
			residueState = BOOM

func GetResidueState():
	return residueState

func SetResidueStage(stage):
	residueInfo["Stage"] = stage

func GetResidueStage():
	return residueInfo["Stage"]

func SetResidueName(residueName):
	residueInfo["Name"] = residueName

func GetResidueName():
	return residueInfo["Name"]

func SetTargetObject(id):
	targetObject = id

func GetTargetObject():
	return targetObject
