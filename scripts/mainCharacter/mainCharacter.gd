extends KinematicBody2D

#Constantes de estado geral do personagem
const INITIAL = "Initial"
const CARRY = "Carry"
const DROP = "Drop"
const HURT = "Hurt"
const TIME = "Time"
const HEALTH = "Health"
#Constantes para animação de vestir os EPI
const W_MASK = "WearMask"
const W_GLOVE = "WearGlove"
const W_COAT = "WearCoat"

#Constantes de estado dos EPI do personagem
const G_NONE = "NoGear"
const G_MASK = "Mask"
const G_GLOVE = "Glove"
const G_COAT = "Coat"
const G_MASK_GLOVE = "MaskGlove"
const G_MASK_COAT = "MaskCoat"
const G_GLOVE_COAT = "GloveCoat"
const G_ALL = "AllGear"

#Contantes para melhor legibilidade das direções do personagem
const UP = 0
const RIGHT = 1
const DOWN = 2
const LEFT = 3

export (int) var speed

var characterHealth
var characterIdle
var velocity
var raycastCurrent
var raycastPrevious
var characterDirection
var carriedResidue
var characterState
var gearState
var maskDurability
var gloveDurability
var coatDurability

signal updateHealth
signal updateGear
signal error
signal hint
signal observation
signal time

func _ready():
	ConnectAnimationFinished()
	get_node("Timer").connect("timeout", self, "_on_Timer_timeout")
	characterHealth = 4
	velocity = Vector2()
	raycastCurrent = null
	raycastPrevious = null
	characterDirection = DOWN
	carriedResidue = null
	characterState = INITIAL
	gearState = G_NONE
	characterIdle = "Idle"
	maskDurability = 0
	gloveDurability = 0
	coatDurability = 0

func _on_AnimatedSprite_finished():
	if (characterState == W_MASK or characterState == W_GLOVE or characterState == W_COAT):
		UpdateGearState()
		characterState = INITIAL
	elif (characterState == DROP):
		DamageCharacter()
	elif (characterState == HURT):
		characterState = INITIAL
	elif (characterState == TIME):
		emit_signal("time")
	elif (characterState == HEALTH):
		emit_signal("updateHealth", "Health", characterHealth)

func _on_Timer_timeout():
	emit_signal("hint", carriedResidue)

func _process(delta):
	move_and_slide(velocity)
	CharacterStateMachine()

func ConnectAnimationFinished():
	get_node("NoGearSprites").connect("animation_finished", self, "_on_AnimatedSprite_finished")
	get_node("MaskSprites").connect("animation_finished", self, "_on_AnimatedSprite_finished")
	get_node("GloveSprites").connect("animation_finished", self, "_on_AnimatedSprite_finished")
	get_node("CoatSprites").connect("animation_finished", self, "_on_AnimatedSprite_finished")
	get_node("MaskGloveSprites").connect("animation_finished", self, "_on_AnimatedSprite_finished")
	get_node("MaskCoatSprites").connect("animation_finished", self, "_on_AnimatedSprite_finished")
	get_node("GloveCoatSprites").connect("animation_finished", self, "_on_AnimatedSprite_finished")
	get_node("AllGearSprites").connect("animation_finished", self, "_on_AnimatedSprite_finished")

func CharacterStateMachine():
	match characterState:
		INITIAL:
			CharacterMovementInput()
			CharacterInteractionInput()
			CharacterIdle()
			CharacterAnimation()
			get_node("Timer").stop()
		CARRY:
			CharacterMovementInput()
			CharacterInteractionInput()
			CharacterIdle()
			CharacterAnimation()
			CarryingTimer()
		DROP:
			velocity = Vector2()
			CharacterIdle()
			CharacterAnimation()
			get_node("Timer").stop()
		HURT:
			velocity = Vector2()
			CharacterIdle()
			CharacterAnimation()
			get_node("Timer").stop()
		TIME:
			velocity = Vector2()
			CharacterIdle()
			CharacterAnimation()
			get_node("Timer").stop()
		HEALTH:
			velocity = Vector2()
			CharacterIdle()
			CharacterAnimation()
			get_node("Timer").stop()
		_:
			velocity = Vector2()
			CharacterIdle()
			CharacterAnimation()
			get_node("Timer").stop()

func CharacterMovementInput():
	velocity = Vector2()
	UpdateRaycastDirection()
	if (Input.is_action_pressed("ui_left")):
		velocity.x -= 1
		characterDirection = LEFT
	if (Input.is_action_pressed("ui_right")):
		velocity.x += 1
		characterDirection = RIGHT
	if (Input.is_action_pressed("ui_up")):
		velocity.y -= 1
		characterDirection = UP
	if (Input.is_action_pressed("ui_down")):
		velocity.y += 1
		characterDirection = DOWN
	velocity = velocity.normalized() * speed

func CharacterIdle():
	if (velocity.x == 0 and velocity.y == 0):
		characterIdle = "Idle"
	else:
		characterIdle = "NotIdle"

func CharacterAnimation():
	VisibleCharacterAnimation()
	GearAnimation()

func VisibleCharacterAnimation():
	var characterAnimations = get_tree().get_nodes_in_group("CharacterAnimation")
	for node in characterAnimations:
		if (node.get_name() == gearState + "Sprites"):
			node._set_playing(true)
			node.show()
		else:
			node.hide()
			node._set_playing(false)

func UpdateGearState():
	if (coatDurability > 0):
		if (gloveDurability > 0 && maskDurability > 0):
			gearState = G_ALL
		elif (gloveDurability > 0):
			gearState = G_GLOVE_COAT
		elif (maskDurability > 0):
			gearState = G_MASK_COAT
		else:
			gearState = G_COAT
	elif (gloveDurability > 0):
		if (maskDurability > 0):
			gearState = G_MASK_GLOVE
		else:
			gearState = G_GLOVE
	elif (maskDurability > 0):
		gearState = G_MASK
	else:
		gearState = G_NONE
	emit_signal("updateGear", maskDurability, gloveDurability, coatDurability)

func CheckFullGear():
	if (coatDurability <= 0 or gloveDurability <= 0 or maskDurability <= 0):
		return false
	else:
		return true

func DamageCharacter():
	if (!GameMaster.GetPlaySafe()):
		characterHealth -= 1
		maskDurability -= 2
		gloveDurability -= 2
		coatDurability -= 2
		if (maskDurability <= 0 or gloveDurability <= 0 or coatDurability <= 0):
			get_node("AudioStreamPlayer").play()
	UpdateGearState()
	if (characterHealth == 0):
		characterState = HEALTH
	else:
		characterState = HURT
		if (!GameMaster.GetPlaySafe()):
			emit_signal("updateHealth", "Hurt", characterHealth)

func CarryingTimer():
	if (get_node("Timer").is_stopped() and !GameMaster.GetPlaySafe()):
		get_node("Timer").set_wait_time(10)
		get_node("Timer").start()

func GearAnimation():
	match characterDirection:
		UP:
			get_node(gearState + "Sprites").set_animation(characterIdle + characterState + "Back")
			get_node(gearState + "Sprites").set_flip_h(false)
		RIGHT:
			get_node(gearState + "Sprites").set_animation(characterIdle + characterState + "Side")
			get_node(gearState + "Sprites").set_flip_h(false)
		DOWN:
			get_node(gearState + "Sprites").set_animation(characterIdle + characterState + "Front")
			get_node(gearState + "Sprites").set_flip_h(false)
		LEFT:
			get_node(gearState + "Sprites").set_animation(characterIdle + characterState + "Side")
			get_node(gearState + "Sprites").set_flip_h(true)

func UpdateRaycastDirection():
	match characterDirection:
		UP:
			get_node("RayCast2D").set_cast_to(Vector2(0,-50))
		RIGHT:
			get_node("RayCast2D").set_cast_to(Vector2(50,0))
		DOWN:
			get_node("RayCast2D").set_cast_to(Vector2(0,50))
		LEFT:
			get_node("RayCast2D").set_cast_to(Vector2(-50,0))

func RaycastInteraction():
	if (get_node("RayCast2D").is_colliding()):
		if (raycastCurrent == null):
			raycastCurrent = get_node("RayCast2D").get_collider()
			raycastCurrent.get_node("Light2D").set_enabled(true)
			if (!GameMaster.GetPlaySafe()):
				emit_signal("observation", get_node("RayCast2D").get_collider(), true)
		elif (raycastCurrent != null and raycastCurrent != get_node("RayCast2D").get_collider()):
			raycastCurrent.get_node("Light2D").set_enabled(false)
			raycastPrevious = raycastCurrent
			raycastCurrent = get_node("RayCast2D").get_collider()
			raycastCurrent.get_node("Light2D").set_enabled(true)
			if (!GameMaster.GetPlaySafe()):
				emit_signal("observation", get_node("RayCast2D").get_collider(), true)
		if (raycastCurrent.is_in_group("Residue") and (raycastCurrent.GetResidueState() == "Ready" or raycastCurrent.GetResidueState() == "Initialized")):
			raycastCurrent.LightEquipment(true)
		return true
	elif (raycastCurrent != null):
		raycastCurrent.get_node("Light2D").set_enabled(false)
		if (raycastCurrent.is_in_group("Residue") and (raycastCurrent.GetResidueState() == "Ready" or raycastCurrent.GetResidueState() == "Initialized")):
			raycastCurrent.LightEquipment(false)
		raycastPrevious = raycastCurrent
		raycastCurrent = null
		if (!GameMaster.GetPlaySafe()):
			emit_signal("observation", get_node("RayCast2D").get_collider(), false)
		return false

func CharacterInteractionInput():
	if (characterState == INITIAL):
		if (RaycastInteraction() and Input.is_action_just_pressed("ui_select")):
			if (raycastCurrent.get_name() == "MaskStore"):
				characterState = W_MASK
				maskDurability = 3
			elif (raycastCurrent.get_name() == "GloveStore"):
				characterState = W_GLOVE
				gloveDurability = 6
			elif (raycastCurrent.get_name() == "CoatStore"):
				characterState = W_COAT
				coatDurability = 9
			elif (raycastCurrent.is_in_group("Residue")):
				characterState = CARRY
				carriedResidue = raycastCurrent
				if (carriedResidue.GetResidueState() != "Idle"):
					carriedResidue.FreeEquipment()
					carriedResidue.show()
				carriedResidue.SetResidueState("CARRIED")
				carriedResidue.SetTargetObject(get_path())
	elif (characterState == CARRY):
		if (!CheckFullGear()):
			characterState = DROP
			carriedResidue.SetResidueState("FALL")
			carriedResidue = null
			emit_signal("error", "NoEPI")
		if (RaycastInteraction() and Input.is_action_just_pressed("ui_select")):
			if (raycastCurrent.is_in_group("EPI")):
				characterState = DROP
				carriedResidue.SetResidueState("FALL")
				carriedResidue = null
				emit_signal("error", "ResidueEPI")
			elif (raycastCurrent.is_in_group("Residue")):
				carriedResidue.SetResidueState("BOOM")
				if (raycastCurrent.GetResidueState() != "Idle"):
					raycastCurrent.FreeEquipment()
					emit_signal("error", "DoneEquipment")
				else:
					emit_signal("error", "MixResidue")
				raycastCurrent.queue_free()
				raycastCurrent = null
				carriedResidue = null
				DamageCharacter()
			elif (raycastCurrent.is_in_group("Equipment")):
				if (raycastCurrent.GetEquipState() == "Idle"):
					if (raycastCurrent.CheckResidueMatch(carriedResidue.GetResidueName(), carriedResidue.GetResidueStage())):
						characterState = INITIAL
						carriedResidue.queue_free()
						carriedResidue = null
					else:
						carriedResidue.SetResidueState("BOOM")
						carriedResidue = null
						DamageCharacter()
						emit_signal("error", "WrongEquipment")
				elif (raycastCurrent.GetEquipState() == "Active"):
					raycastCurrent.SetEquipState("Idle")
					carriedResidue.SetResidueState("BOOM")
					carriedResidue = null
					DamageCharacter()
					emit_signal("error", "ActiveEquipment")
			else:
				characterState = INITIAL
				carriedResidue.SetResidueState("IDLE")
				carriedResidue.SetTargetObject(raycastCurrent.get_path())
				carriedResidue = null
		elif (Input.is_action_just_pressed("ui_select")):
			characterState = DROP
			carriedResidue.SetResidueState("FALL")
			carriedResidue = null
			emit_signal("error", "DropResidue")

func GetCharacterState():
	return characterState

func SetCharacterState(state):
	characterState = state

func GetCarriedResidue():
	return carriedResidue

func SetCharacterHealth(value):
	characterHealth = value
