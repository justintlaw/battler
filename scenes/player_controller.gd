extends MinionController


# Called when the node enters the scene tree for the first time.
func _ready():
	group = Constants.Groups.PLAYER
	spawn_minion(MinionStats.DWARF_WARRIOR)
	spawn_minion(MinionStats.DWARF_WARRIOR)
	spawn_minion(MinionStats.DWARF_RIDER)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _on_VoiceHandler_issue_command(command):
#	print("command received", command)
#	spawn_minion(MinionStats.DWARF_WARRIOR)


func hello():
	pass
