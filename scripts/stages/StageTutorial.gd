extends Node

#spawnerControl controla a frequência do gerador de resíduos
#junto com SpawnTimer
var spawnerControl

#stageState controla o passo-a-passo do mini-tutorial até a fase
#começar de verdade para o jogador
var stageState

var stageType

#flowControl determina o acontecimento de certos eventos na
#StageStateMachine() junto com FlowTimer
var flowControl

var residueCounter

func _ready():
	stageState = 0
	residueCounter = 0
	flowControl = true
	spawnerControl = true
	stageType = "Normal"
	get_node("HUD").SetPauseCurrentStage("res://scenes/stages/Tutorial/StageTutorial.tscn")
	get_node("HUD").UpdateStageProgress(stageType, residueCounter, null)
	get_node("FlowTimer").connect("timeout", self, "_on_FlowTimer_timeout")

func _on_FlowTimer_timeout():
	if (stageState == 35 or stageState == 39 or stageState == 63 or stageState == 81 or stageState == 97 or stageState == 107 or stageState == 141):
		stageState -= 1
	else:
		stageState += 1
	flowControl = true

func _process(delta):
	if (stageState >= 78):
		SpawnResidueTimer()
		get_node("YSort/MainCharacter").SetCharacterHealth(4)
		UpdateResidueInfo()
	StageStateMachine()

func StageStateMachine():
	match stageState:
		0:
			GameMaster.SetPlaySafe(true)
			get_node("HUD").get_node("CanvasLayer/PlayerInfo/CharacterPortrait").hide()
			get_node("HUD").get_node("CanvasLayer/PlayerInfo/TimePortrait").hide()
			get_node("HUD").get_node("CanvasLayer/Messages").hide()
			get_node("HUD").get_node("CanvasLayer/ResidueInfo").hide()
			get_node("HUD").get_node("CanvasLayer/GearInfo").hide()
			get_node("HUD").get_node("CanvasLayer/StageProgress").hide()
			get_node("HUD").get_node("CanvasLayer/PauseMenu").hide()
			TutorialFlowControl(0, 1, null)
		1:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Olá! Este é o tutorial com os básicos de como jogar \"Volátil\"!")
			TutorialFlowControl(1, 5, "Hint")
		2:
			TutorialFlowControl(0, 1, null)
		3:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Vamos falar deste primeiro elemento do jogo: estas mensagens do jogo")
			TutorialFlowControl(1, 5, "Hint")
		4:
			TutorialFlowControl(0, 1, null)
		5:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Estas mensagens servem para dar informação extra que ajude você a jogar melhor")
			TutorialFlowControl(1, 5, "Hint")
		6:
			TutorialFlowControl(0, 1, null)
		7:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Para agilizar as coisas, cada tipo de mensagem possui uma aparência diferente")
			TutorialFlowControl(1, 5, "Hint")
		8:
			TutorialFlowControl(0, 1, null)
		9:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Mensagens com esta aparência são DICAS para esclarecer possíveis dúvidas")
			TutorialFlowControl(1, 5, "Hint")
		10:
			TutorialFlowControl(0, 1, null)
		11:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Se você tiver um resíduo em mãos e estiver com dúvidas, uma dica aparecerá para ajudar")
			TutorialFlowControl(1, 5, "Hint")
		12:
			TutorialFlowControl(0, 1, null)
		13:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Mas as dicas só aparecerão depois de um tempo para garantir que você precisa delas")
			TutorialFlowControl(1, 5, "Hint")
		14:
			TutorialFlowControl(0, 1, null)
		15:
			get_node("HUD").get_node("CanvasLayer/Messages/Positive/TextureRect/Label").set_text("Esta aparência é para mensagens POSITIVAS, com alguns elogios")
			TutorialFlowControl(1, 5, "Positive")
		16:
			TutorialFlowControl(0, 1, null)
		17:
			get_node("HUD").get_node("CanvasLayer/Messages/Positive/TextureRect/Label").set_text("Estas mensagens aparecem quando você termina de tratar um resíduo com sucesso")
			TutorialFlowControl(1, 5, "Positive")
		18:
			TutorialFlowControl(0, 1, null)
		19:
			get_node("HUD").get_node("CanvasLayer/Messages/Negative/TextureRect/Label").set_text("Por outro lado, mensagens NEGATIVAS aparecem quando você cometer algum erro")
			TutorialFlowControl(1, 5, "Negative")
		20:
			TutorialFlowControl(0, 1, null)
		21:
			get_node("HUD").get_node("CanvasLayer/Messages/Negative/TextureRect/Label").set_text("Para ajudar você, essas mensagens também dão detalhes sobre o erro cometido")
			TutorialFlowControl(1, 5, "Negative")
		22:
			TutorialFlowControl(0, 1, null)
		23:
			get_node("HUD").get_node("CanvasLayer/Messages/Negative/TextureRect/Label").set_text("Vamos falar mais sobre os tipos de erro muito em breve")
			TutorialFlowControl(1, 5, "Negative")
		24:
			TutorialFlowControl(0, 1, null)
		25:
			get_node("HUD").get_node("CanvasLayer/Messages/Observation/TextureRect/Label").set_text("Por fim, esta é a aparência das OBSERVAÇÕES sobre o laboratório")
			TutorialFlowControl(1, 5, "Observation")
		26:
			TutorialFlowControl(0, 1, null)
		27:
			get_node("HUD").get_node("CanvasLayer/Messages/Observation/TextureRect/Label").set_text("Sempre que você chegar perto de um objeto, ela vai aparecer para falar sobre ele")
			TutorialFlowControl(1, 5, "Observation")
		28:
			TutorialFlowControl(0, 1, null)
		29:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Agora vamos falar de algo muito importante: como interromper o jogo")
			TutorialFlowControl(1, 5, "Hint")
		30:
			TutorialFlowControl(0, 1, null)
		31:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("A qualquer momento, você pode apertar a tecla ESC para pausar o jogo")
			TutorialFlowControl(1, 5, "Hint")
			if (Input.is_action_just_pressed("ui_cancel")):
				stageState = 36
		32:
			TutorialFlowControl(0, 1, null)
			if (Input.is_action_just_pressed("ui_cancel")):
				stageState = 36
		33:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Além de pausar, isso permite reiniciar a fase, sair dela e mexer nas opções de jogo")
			TutorialFlowControl(1, 5, "Hint")
			if (Input.is_action_just_pressed("ui_cancel")):
				stageState = 36
		34:
			TutorialFlowControl(0, 1, null)
			if (Input.is_action_just_pressed("ui_cancel")):
				stageState = 36
		35:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Experimente apertar ESC para dar uma olhada no menu de pausa!")
			TutorialFlowControl(1, 5, "Hint")
			if (Input.is_action_just_pressed("ui_cancel")):
				stageState = 36
		36:
			TutorialFlowControl(0, 1, null)
		37:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Agora vamos falar de Murdock, o coala estagiário do laboratório")
			TutorialFlowControl(1, 5, "Hint")
		38:
			TutorialFlowControl(0, 1, null)
		39:
			if (flowControl and !get_tree().has_group("Player")):
				FadeInStuff("Player")
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Aí está ele. Você pode mover Murdock pelo laboratório usando as SETAS do teclado!")
			TutorialFlowControl(1, 5, "Hint")
			if (get_node("YSort/MainCharacter").get_position() != Vector2(585, 350)):
				stageState = 40
		40:
			TutorialFlowControl(0, 1, null)
		41:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Não se preocupe: ele concordou com tudo isso quando aceitou o estágio")
			TutorialFlowControl(1, 5, "Hint")
		42:
			TutorialFlowControl(0, 1, null)
		43:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Agora vamos preparar você para fazer algo de verdade no laboratório")
			TutorialFlowControl(1, 5, "Hint")
		44:
			TutorialFlowControl(0, 1, null)
		45:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Primeiro, é importante saber quando você está PERTO o suficiente para mexer em algo")
			TutorialFlowControl(1, 5, "Hint")
		46:
			TutorialFlowControl(0, 1, null)
		47:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Se aproxime de uma bancada. Quando ela estiver no seu alcance, ela vai se iluminar")
			TutorialFlowControl(1, 5, "Hint")
		48:
			TutorialFlowControl(0, 1, null)
		49:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Além de estar perto o bastante, é importante estar olhando na DIREÇÃO do objeto")
			TutorialFlowControl(1, 5, "Hint")
		50:
			TutorialFlowControl(0, 1, null)
		51:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Veja como apenas a bancada na direção do olhar de Murdock está iluminada!")
			TutorialFlowControl(1, 5, "Hint")
		52:
			TutorialFlowControl(0, 1, null)
		53:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Agora que tratamos disso, vamos falar de segurança no laboratório!")
			TutorialFlowControl(1, 5, "Hint")
		54:
			TutorialFlowControl(0, 1, null)
		55:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("NUNCA esqueça de vestir os EPI: os Equipamentos de Proteção Individual!")
			TutorialFlowControl(1, 5, "Hint")
		56:
			TutorialFlowControl(0, 1, null)
		57:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Aqui usamos três EPI: máscara, luvas e jaleco. Sempre vista TODOS os três")
			TutorialFlowControl(1, 5, "Hint")
		58:
			TutorialFlowControl(0, 1, null)
		59:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Como você pode ver no lado esquerdo da tela, Murdock não está vestindo nenhum")
			TutorialFlowControl(1, 5, "Hint")
			get_node("HUD").get_node("CanvasLayer/GearInfo").show()
		60:
			TutorialFlowControl(0, 1, null)
		61:
			if (flowControl and !get_tree().has_group("EPI")):
				FadeInStuff("EPI")
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Vamos mudar isso: vá até os armários dos EPI e vista os três!")
			TutorialFlowControl(1, 5, "Hint")
			if (get_node("YSort/MainCharacter").CheckFullGear()):
				stageState = 64
		62:
			TutorialFlowControl(0, 1, null)
			if (get_node("YSort/MainCharacter").CheckFullGear()):
				stageState = 64
		63:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Quando você estiver perto dos armários, aperte ESPAÇO para vestir os EPI!")
			TutorialFlowControl(1, 5, "Hint")
			if (get_node("YSort/MainCharacter").CheckFullGear()):
				stageState = 64
		64:
			TutorialFlowControl(0, 1, null)
		65:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Como você pode ver no lado esquerdo da tela, os ícones mudaram!")
			TutorialFlowControl(1, 5, "Hint")
		66:
			TutorialFlowControl(0, 1, null)
		67:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("A aparência dos ícones vai mudar conforme a durabilidade dos EPI reduzir")
			TutorialFlowControl(1, 5, "Hint")
		68:
			TutorialFlowControl(0, 1, null)
		69:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Vamos falar mais da durabilidade dos EPI muito em breve")
			TutorialFlowControl(1, 5, "Hint")
		70:
			TutorialFlowControl(0, 1, null)
		71:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Agora vamos para o seu trabalho de verdade: o tratamento de resíduos!")
			TutorialFlowControl(1, 5, "Hint")
		72:
			TutorialFlowControl(0, 1, null)
		73:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Em \"Volátil\", tudo gira em torno do tratamento de resíduos do laboratório!")
			TutorialFlowControl(1, 5, "Hint")
		74:
			TutorialFlowControl(0, 1, null)
		75:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Todos os resíduos que você deve tratar vão sair do GERADOR de resíduos")
			TutorialFlowControl(1, 5, "Hint")
		76:
			TutorialFlowControl(0, 1, null)
		77:
			if (flowControl and !get_tree().has_group("Spawner")):
				FadeInStuff("Spawner")
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Você pode ver o gerador de resíduos junto das bancadas da esquerda do laboratório")
			TutorialFlowControl(1, 5, "Hint")
			if (get_node("YSort/MainCharacter").GetCharacterState() == "Carry"):
				stageState = 82
		78:
			TutorialFlowControl(0, 1, null)
			if (get_node("YSort/MainCharacter").GetCharacterState() == "Carry"):
				stageState = 82
		79:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Ele faz um som ao gerar resíduos e, quando tiver um lá, ele pisca uma luz verde")
			TutorialFlowControl(1, 5, "Hint")
			if (get_node("YSort/MainCharacter").GetCharacterState() == "Carry"):
				stageState = 82
		80:
			TutorialFlowControl(0, 1, null)
			if (get_node("YSort/MainCharacter").GetCharacterState() == "Carry"):
				stageState = 82
		81:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Agora vá até o gerador e pegue o resíduo apertando ESPAÇO para iniciar o tratamento")
			TutorialFlowControl(1, 5, "Hint")
			if (get_node("YSort/MainCharacter").GetCharacterState() == "Carry"):
				stageState = 82
		82:
			TutorialFlowControl(0, 1, null)
		83:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Como você pode ver no canto superior direito da tela, esse \"resíduo\" é só água")
			TutorialFlowControl(1, 5, "Hint")
			#get_node("HUD").get_node("CanvasLayer/ResidueInfo").show()
		84:
			TutorialFlowControl(0, 1, null)
		85:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Como resíduos de verdade são perigosos, vamos começar com esse de mentira")
			TutorialFlowControl(1, 5, "Hint")
		86:
			TutorialFlowControl(0, 1, null)
		87:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Cada resíduo possui um processo diferente, passando por vários estágios de tratamento")
			TutorialFlowControl(1, 5, "Hint")
		88:
			TutorialFlowControl(0, 1, null)
		89:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Você pode consultar o estágio atual nas informações do canto superior direito")
			TutorialFlowControl(1, 5, "Hint")
		90:
			TutorialFlowControl(0, 1, null)
		91:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Além disso, é possível ver o estágio pela aparência do resíduo nas mãos de Murdock")
			TutorialFlowControl(1, 5, "Hint")
		92:
			TutorialFlowControl(0, 1, null)
		93:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Agora vamos fazer esse tratamento. Para \"tratar\" esse \"resíduo\" leve até um FILTRO")
			TutorialFlowControl(1, 5, "Hint")
		94:
			TutorialFlowControl(0, 1, null)
		95:
			if (flowControl and !get_tree().has_group("Filter")):
				FadeInStuff("Filter")
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Temos um filtro disponível ali na parte de baixo do laboratório, junto com as bancadas")
			TutorialFlowControl(1, 5, "Hint")
			if (get_node("YSort/Filter").GetEquipState() == "Active"):
				stageState = 98
		96:
			TutorialFlowControl(0, 1, null)
			if (get_node("YSort/Filter").GetEquipState() == "Active"):
				stageState = 98
		97:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Se aproxime do filtro e aperte ESPAÇO para colocar o resíduo nele")
			TutorialFlowControl(1, 5, "Hint")
			if (get_node("YSort/Filter").GetEquipState() == "Active"):
				stageState = 98
		98:
			TutorialFlowControl(0, 1, null)
		99:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Esta barra perto do equipamento indica o progresso nesta etapa de tratamento")
			TutorialFlowControl(1, 5, "Hint")
		100:
			TutorialFlowControl(0, 1, null)
		101:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Quando a barra encher, o equipamento pisca verde para indicar que o resíduo está pronto")
			TutorialFlowControl(1, 5, "Hint")
		102:
			TutorialFlowControl(0, 1, null)
		103:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Como no gerador, você pode tirar o resíduo de outros equipamentos apertando ESPAÇO")
			TutorialFlowControl(1, 5, "Hint")
		104:
			TutorialFlowControl(0, 1, null)
		105:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Os tratamentos podem ter várias etapas. Para esse teste, filtrar é suficiente")
			TutorialFlowControl(1, 5, "Hint")
		106:
			TutorialFlowControl(0, 1, null)
			if (residueCounter >= 1):
				stageState = 108
		107:
			if (flowControl and !get_tree().has_group("Storage")):
				FadeInStuff("Storage")
			get_node("YSort/Storage").connect("residueFinished", self, "_on_Storage_residueFinished")
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Por fim, leve o resíduo ao ARMAZENADOR no lado direito do laboratório")
			TutorialFlowControl(1, 5, "Hint")
			if (residueCounter >= 1):
				stageState = 108
		108:
			TutorialFlowControl(0, 1, null)
		109:
			get_node("HUD").get_node("CanvasLayer/Messages/Positive/TextureRect/Label").set_text("Ótimo! Este é o básico em tratar resíduos: vista os EPI, siga as etapas e armazene")
			TutorialFlowControl(1, 5, "Positive")
		110:
			TutorialFlowControl(0, 1, null)
		111:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Terminando um tratamento, o valor no canto inferior esquerdo da tela vai mudar")
			TutorialFlowControl(1, 5, "Hint")
			get_node("HUD").get_node("CanvasLayer/StageProgress").show()
		112:
			TutorialFlowControl(0, 1, null)
		113:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Este contador vai registrar quantos resíduos você tratou no seu expediente")
			TutorialFlowControl(1, 5, "Hint")
		114:
			TutorialFlowControl(0, 1, null)
		115:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Falando nisso, o tempo para o fim do seu expediente fica no canto superior esquerdo!")
			TutorialFlowControl(1, 5, "Hint")
			get_node("HUD").get_node("CanvasLayer/PlayerInfo/TimePortrait").show()
		116:
			TutorialFlowControl(0, 1, null)
		117:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Cada fase em \"Volátil\" apresenta dois modos: o Modo Normal e o Modo Desafio")
			TutorialFlowControl(1, 5, "Hint")
		118:
			TutorialFlowControl(0, 1, null)
		119:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("No Modo Normal você deve tratar quantos resíduos conseguir até o fim do expediente")
			TutorialFlowControl(1, 5, "Hint")
		120:
			TutorialFlowControl(0, 1, null)
		121:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Se a fase tiver um resíduo novo, o Modo Normal vai lhe ensinar como tratar ele")
			TutorialFlowControl(1, 5, "Hint")
		122:
			TutorialFlowControl(0, 1, null)
		123:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Quando o tempo acaba, a fase encerra e você pode ver quantos resíduos tratou")
			TutorialFlowControl(1, 5, "Hint")
		124:
			TutorialFlowControl(0, 1, null)
		125:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("A melhor pontuação fica registrada nas informações da fase!")
			TutorialFlowControl(1, 5, "Hint")
		126:
			TutorialFlowControl(0, 1, null)
		127:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Por outro lado, o Modo Desafio requer que você trate uma certa quantidade de resíduos")
			TutorialFlowControl(1, 5, "Hint")
		128:
			TutorialFlowControl(0, 1, null)
		129:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Se o tempo acabar antes de você tratar todos, você perde a fase e Murdock é demitido")
			TutorialFlowControl(1, 5, "Hint")
		130:
			TutorialFlowControl(0, 1, null)
		131:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Diferente do Modo Normal, o Modo Desafio registra o tempo que você demorou")
			TutorialFlowControl(1, 5, "Hint")
		132:
			TutorialFlowControl(0, 1, null)
		133:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Então apenas o tempo mais rápido fica registrado nas informações da fase!")
			TutorialFlowControl(1, 5, "Hint")
		134:
			TutorialFlowControl(0, 1, null)
		135:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Agora vamos falar de quando as coisas dão errado no tratamento de resíduos")
			TutorialFlowControl(1, 5, "Hint")
		136:
			TutorialFlowControl(0, 1, null)
		137:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Primeiro, pegue um novo \"resíduo\" no gerador para falarmos dos erros")
			TutorialFlowControl(1, 5, "Hint")
		138:
			TutorialFlowControl(0, 1, null)
		139:
			GameMaster.SetPlaySafe(false)
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Se você apertar ESPAÇO sem ter onde colocar o resíduo, ele vai cair no chão")
			TutorialFlowControl(1, 5, "Hint")
			if (get_node("YSort/MainCharacter").GetCharacterState() == "Drop" or get_node("YSort/MainCharacter").GetCharacterState() == "Hurt"):
				stageState = 142
		140:
			TutorialFlowControl(0, 1, null)
			if (get_node("YSort/MainCharacter").GetCharacterState() == "Drop" or get_node("YSort/MainCharacter").GetCharacterState() == "Hurt"):
				stageState = 142
		141:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Aperte ESPAÇO e deixe o resíduo cair para ver o que acontece!")
			TutorialFlowControl(1, 5, "Hint")
			if (get_node("YSort/MainCharacter").GetCharacterState() == "Drop" or get_node("YSort/MainCharacter").GetCharacterState() == "Hurt"):
				stageState = 142
		142:
			TutorialFlowControl(0, 1, null)
		143:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Observe que o resíduo foi perdido e os EPI perderam durabilidade!")
			TutorialFlowControl(1, 5, "Hint")
		144:
			TutorialFlowControl(0, 1, null)
		145:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Os EPI perdem durabilidade conforme você comete erros no tratamento")
			TutorialFlowControl(1, 5, "Hint")
		146:
			TutorialFlowControl(0, 1, null)
		147:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Se você cometer muitos erros, os EPI vão estragar e você terá que vestir novos")
			TutorialFlowControl(1, 5, "Hint")
		148:
			TutorialFlowControl(0, 1, null)
		149:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Se os ícones dos EPI piscarem, é porque você precisa repôr algum deles!")
			TutorialFlowControl(1, 5, "Hint")
		150:
			TutorialFlowControl(0, 1, null)
		151:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Falando em EPI, se você pegar um resíduo sem estar vestindo todos, ele vai cair")
			TutorialFlowControl(1, 5, "Hint")
		152:
			TutorialFlowControl(0, 1, null)
		153:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Mexer em resíduos sem os EPI é outro erro, então tenha muito cuidado com isso!")
			TutorialFlowControl(1, 5, "Hint")
		154:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Se o equipamento que você precisa estiver ocupado, coloque o resíduo em uma bancada")
			TutorialFlowControl(1, 5, "Hint")
		155:
			TutorialFlowControl(0, 1, null)
		156:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Mas atenção: não coloque mais de um resíduo em cada bancada! Este é outro erro")
			TutorialFlowControl(1, 5, "Hint")
		157:
			TutorialFlowControl(0, 1, null)
		158:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("O último tipo de erro é colocar um resíduo no equipamento errado")
			TutorialFlowControl(1, 5, "Hint")
		159:
			TutorialFlowControl(0, 1, null)
		160:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Se você errar a ordem do tratamento do resíduo, ele vai explodir na sua cara")
			TutorialFlowControl(1, 5, "Hint")
		161:
			TutorialFlowControl(0, 1, null)
		162:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Colocar um resíduo em um equipamento por onde ele não passa também vai explodir!")
			TutorialFlowControl(1, 5, "Hint")
		163:
			TutorialFlowControl(0, 1, null)
		164:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Como resíduos reais são perigosos, é claro que essas explosões vão machucar Murdock")
			TutorialFlowControl(1, 5, "Hint")
		165:
			TutorialFlowControl(0, 1, null)
		166:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Você pode ver o estado atual de Murdock ali no canto superior esquerdo da tela")
			TutorialFlowControl(1, 5, "Hint")
			get_node("HUD").get_node("CanvasLayer/PlayerInfo/CharacterPortrait").show()
		167:
			TutorialFlowControl(0, 1, null)
		168:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Quanto mais você errar, mais ele se machuca e o retrato vai mudar de aparência")
			TutorialFlowControl(1, 5, "Hint")
		169:
			TutorialFlowControl(0, 1, null)
		170:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Se ele se machucar demais, ele terá que ir para um hospital e você perderá a fase")
			TutorialFlowControl(1, 5, "Hint")
		171:
			TutorialFlowControl(0, 1, null)
		172:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Isso é tudo! Você vai aprender melhor jogando os modos de cada fase do jogo")
			TutorialFlowControl(1, 5, "Hint")
		173:
			TutorialFlowControl(0, 1, null)
		174:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Se quiser, fique mais tempo no tutorial para pegar o jeito com o resíduo falso")
			TutorialFlowControl(1, 5, "Hint")
		175:
			TutorialFlowControl(0, 1, null)
		176:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Não há limite de tempo e Murdock não vai se machucar, então treine o quanto quiser!")
			TutorialFlowControl(1, 5, "Hint")
		177:
			TutorialFlowControl(0, 1, null)
		178:
			get_node("HUD").get_node("CanvasLayer/Messages/Hint/TextureRect/Label").set_text("Quando quiser sair, basta apertar ESCAPE para ir no menu de pausa e sair da fase")
			TutorialFlowControl(1, 5, "Hint")
		179:
			if (flowControl):
				get_node("YSort/MainCharacter").connect("error", get_node("HUD"), "_on_MainCharacter_error")
				get_node("YSort/MainCharacter").connect("hint", get_node("HUD"), "_on_MainCharacter_hint")
				get_node("YSort/MainCharacter").connect("observation", get_node("HUD"), "_on_MainCharacter_observation")
			TutorialFlowControl(0, 1, null)
		180:
			pass

func TutorialFlowControl(type, waitTime, portraitType):
	if (type == 0):
		get_node("HUD").get_node("CanvasLayer/Messages").hide()
		get_node("HUD").get_node("CanvasLayer/Messages/Positive").hide()
		get_node("HUD").get_node("CanvasLayer/Messages/Observation").hide()
		get_node("HUD").get_node("CanvasLayer/Messages/Hint").hide()
		get_node("HUD").get_node("CanvasLayer/Messages/Negative").hide()
		if (flowControl):
			get_node("FlowTimer").set_wait_time(waitTime)
			get_node("FlowTimer").start()
			flowControl = false
	elif (type == 1):
		if (flowControl):
			get_node("HUD").get_node("CanvasLayer/Messages/" + portraitType + "/ProfPortrait").set_frame(0)
			get_node("HUD").get_node("CanvasLayer/Messages/" + portraitType).show()
			get_node("HUD").get_node("CanvasLayer/Messages/" + portraitType + "/ProfPortrait").play()
			get_node("HUD").get_node("CanvasLayer/Messages").show()
			get_node("FlowTimer").set_wait_time(waitTime)
			get_node("FlowTimer").start()
			flowControl = false

func FadeInStuff(stuffName):
	if (stuffName == "Player"):
		var player = preload("res://scenes/mainCharacter/mainCharacter.tscn").instance()
		player.set_position(Vector2(585, 350))
		player.set_modulate(Color(1,1,1,1))
		get_node("YSort").add_child(player)
	elif (stuffName == "EPI"):
		var coatEPI = preload("res://scenes/equipment/EPI/CoatStore.tscn").instance()
		var gloveEPI = preload("res://scenes/equipment/EPI/GloveStore.tscn").instance()
		var maskEPI = preload("res://scenes/equipment/EPI/MaskStore.tscn").instance()
		coatEPI.set_position(get_node("YSort/HDCoat").get_position())
		gloveEPI.set_position(get_node("YSort/HDGlove").get_position())
		maskEPI.set_position(get_node("YSort/HDMask").get_position())
		get_node("YSort").add_child(coatEPI)
		get_node("YSort").add_child(gloveEPI)
		get_node("YSort").add_child(maskEPI)
		get_node("YSort/HDCoat").queue_free()
		get_node("YSort/HDGlove").queue_free()
		get_node("YSort/HDMask").queue_free()
		get_node("YSort/MainCharacter").connect("updateGear", get_node("HUD"), "_on_MainCharacter_updateGear")
	elif (stuffName == "Spawner"):
		var spawner = preload("res://scenes/equipment/Spawner.tscn").instance()
		spawner.set_position(get_node("YSort/HDSpawner").get_position())
		get_node("YSort").add_child(spawner)
		get_node("YSort/HDSpawner").queue_free()
		get_node("SpawnTimer").connect("timeout", self, "_on_SpawnTimer_timeout")
	elif (stuffName == "Filter"):
		var filter = preload("res://scenes/equipment/Filter.tscn").instance()
		filter.set_position(get_node("YSort/HDFilter").get_position())
		get_node("YSort").add_child(filter)
		get_node("YSort/HDFilter").queue_free()
	elif (stuffName == "Storage"):
		var storage = preload("res://scenes/equipment/Storage.tscn").instance()
		storage.set_position(get_node("YSort/HDStorage").get_position())
		get_node("YSort").add_child(storage)
		get_node("YSort/HDStorage").queue_free()

func SpawnResidueTimer():
	if (spawnerControl and get_node("YSort/Spawner").GetEquipState() == "Idle"):
		spawnerControl = false
		get_node("SpawnTimer").start()

func _on_SpawnTimer_timeout():
	get_node("YSort/Spawner").SpawnResidue("Água")
	get_node("SpawnTimer").stop()
	spawnerControl = true

func UpdateResidueInfo():
	if (get_node("YSort/MainCharacter").GetCharacterState() == "Carry"):
		get_node("HUD").SetResidueInfo(true, get_node("YSort/MainCharacter").GetCarriedResidue().GetResidueName(), get_node("YSort/MainCharacter").GetCarriedResidue().GetResidueStage())
	else:
		get_node("HUD").SetResidueInfo(false, null, null)

func _on_Storage_residueFinished():
	residueCounter += 1
	if (stageState >= 179):
		get_node("HUD").PositiveFeedback()
	get_node("HUD").UpdateStageProgress(stageType, residueCounter, null)
