extends Node

#PLEASE PLEASE PLEASE, team members, use signals for communication from network to nodes
#and call functions in network from other nodes, this will make life so much easier for everyone

var is_server = false

signal on_connected_to_server()
signal on_connection_to_server_failed()
signal on_disconnected_from_server()

signal on_server_sent_lobby_state(panel_states)

signal on_host_started()
signal on_client_connected(id)
signal on_client_disconnected(id)

signal on_client_select_lobby_panel(panel_id, client_name)

#used only if is server
var player_id_and_name = {}


func begin_hosting(port, max_players):
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port, max_players)
	multiplayer.set_multiplayer_peer(peer)
	
	multiplayer.connect("peer_connected", client_connected)
	multiplayer.connect("peer_disconnected", client_disconnected)
	is_server = true
	on_host_started.emit()

func begin_join_server(ip, port):
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.set_multiplayer_peer(peer)
	
	multiplayer.connect("connected_to_server", connected_to_server)
	multiplayer.connect("connection_failed", connection_to_server_failed)
	multiplayer.connect("server_disconnected", disconnected_from_server)

#server methods
func client_connected(id):
	on_client_connected.emit(id)
	print(str(id) + " connected")

func client_disconnected(id):
	on_client_disconnected.emit(id)
	if player_id_and_name.has(id):
		player_id_and_name.erase(id)
	print(str(id) + " disconnected")

func push_lobby_state(panel_states):
	rpc("sent_lobby_state", panel_states)

@rpc("any_peer")
func sent_join_data(data):
	var id = multiplayer.get_remote_sender_id()
	player_id_and_name[id] = data

@rpc("any_peer")
func sent_lobby_select_panel(panel_id):
	#assumes we are in lobby and host
	var sender_id = multiplayer.get_remote_sender_id()
	var client_name = player_id_and_name[sender_id]
	on_client_select_lobby_panel.emit(panel_id, client_name)

#client methods
func connected_to_server():
	on_connected_to_server.emit()
	print("connected to server")

func connection_to_server_failed():
	on_connection_to_server_failed.emit()
	print("could not connect to server")

func disconnected_from_server():
	on_disconnected_from_server.emit()
	print("disconnected from server")

func push_join_data(data):
	rpc_id(1, "sent_join_data", data)

func push_lobby_select_panel(panel_id):
	rpc_id(1, "sent_lobby_select_panel", panel_id)

@rpc("authority")
func sent_lobby_state(panel_states):
	on_server_sent_lobby_state.emit(panel_states)

#global methods

