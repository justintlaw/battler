extends Node

signal issue_command

var socket: WebSocketPeer
#var reconnectTimer: Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	socket = WebSocketPeer.new()
	socket.connect_to_url("ws://localhost:8765")
	
#	reconnectTimer = Timer.new()
#	reconnectTimer.connect("timeout", _on_reconnect_timer_timeout)
#	add_child(reconnectTimer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	socket.poll()
	var state = socket.get_available_packet_count()

	if state == WebSocketPeer.STATE_OPEN:
		print("connected!!")
		process_packets()
	elif state == WebSocketPeer.STATE_CLOSING:
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false)


func process_packets():
	while socket.get_available_packet_count():
		var packet = socket.get_packet()
		print("packet", packet)
		
		var command = packet.get_string_from_ascii()
		var jsonCommand = JSON.parse_string(command)
		print("command", packet.get_string_from_ascii())
		print("json", jsonCommand)

		if jsonCommand != null:
			issue_command.emit(jsonCommand)


#func start_reconnect_timer():
#	reconnectTimer.start(5)
#
#
#func _on_reconnect_timer_timeout():
#	socket.connect_to_url("ws://localhost:8765")
