extends Control

var warriorCount = 0
var rangedCount = 0
var riderCount = 0

var Counts = {
	"warrior": 0,
	"ranged": 0,
	"rider": 0
}


func _ready():
	pass


func on_minion_die(minionType):
	print("IM BEING CALLED", minionType)
	Counts[minionType.baseClass] -= 1

	$Soldiers/Warriors/HBoxContainer/Label.text = "Warriors: " + str(Counts.warrior)
	$Soldiers/Ranged/HBoxContainer/Label.text = "Ranged: " + str(Counts.ranged)
	$Soldiers/Riders/HBoxContainer/Label.text = "Riders: " + str(Counts.rider)


func _on_player_controller_minion_spawned(minionType):
	Counts[minionType.baseClass] += 1

	$Soldiers/Warriors/HBoxContainer/Label.text = "Warriors: " + str(Counts.warrior)
	$Soldiers/Ranged/HBoxContainer/Label.text = "Ranged: " + str(Counts.ranged)
	$Soldiers/Riders/HBoxContainer/Label.text = "Riders: " + str(Counts.rider)
