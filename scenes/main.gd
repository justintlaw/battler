extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_VoiceHandler_issue_command(jsonCommand):
	if jsonCommand.target == "minions":
		handle_minions_command(jsonCommand)
	elif jsonCommand.target == "game":
		pass
	elif jsonCommand.target == "volume":
		pass


func handle_minions_command(jsonCommand):
	if jsonCommand.action == "buy":
		for i in range(jsonCommand.amount):
			if jsonCommand.item == "warrior":
				var cost = MinionStats.DWARF_WARRIOR.cost

				if cost <= State.gold:
					$PlayerController.spawn_minion(MinionStats.DWARF_WARRIOR)
					State.gold -= cost
				else:
					print("not enough gold")
			elif jsonCommand.item == "ranged":
				pass
#				$PlayerController.spawn_minion(MinionStats.DWARF_RANGED)
			elif jsonCommand.item == "rider":
				$PlayerController.spawn_minion(MinionStats.DWARF_RIDER)


func _on_gold_timer_timeout():
	State.gold += 20
