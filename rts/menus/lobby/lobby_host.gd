extends Control

var panel_data = {"A1":null, "A2":null, "A3":null, "B1":null, "B2":null, "B3":null}
var players_waiting = []

func _ready():
	Network.on_client_select_lobby_panel.connect(client_select_panel)
	Network.on_client_sent_join_data.connect(client_joined_lobby)
	Network.on_client_join_waiting.connect(client_join_waiting)
	Network.on_client_disconnected.connect(client_left_lobby)
	
	var host_name = Network.player_id_and_name[1]
	add_waiting(host_name)


func select_panel(panel_id, selector_name):
		var team = panel_id[0]
		var num = panel_id[1]
		var panel = get_node("team" + team + "_back").get_node("team" + team + "_" + num)
		panel.text = selector_name
		panel_data[panel_id] = selector_name
		panel.disabled = true

func deselect_panel(panel_id):
	var team = panel_id[0]
	var num = panel_id[1]
	var panel = get_node("team" + team + "_back").get_node("team" + team + "_" + num)
	panel.text = ""
	panel_data[panel_id] = null
	panel.disabled = false


func add_waiting(player_name):
	#handles desecting other panels
	if panel_data.values().has(player_name):
		var current_panel_id = panel_data.keys()[panel_data.values().find(player_name)]
		deselect_panel(current_panel_id)
	
	if !players_waiting.has(player_name):
		$waiting.add_item(player_name, null, false)
		$start_game.disabled = true
		players_waiting.append(player_name)


func client_select_panel(panel_id, client_name):
	if panel_data[panel_id] == null:
		if players_waiting.has(client_name):
			$waiting.remove_item(players_waiting.find(client_name))
			players_waiting.erase(client_name)
		
		#checks if other panels are occupied by client so they can be deslected
		if panel_data.values().has(client_name):
			#finds panel id and gets the node
			var current_panel_id = panel_data.keys()[panel_data.values().find(client_name)]
			deselect_panel(current_panel_id)
		
		#gets panel and sets it text to the name of the client
		select_panel(panel_id, client_name)
		
		if players_waiting.size() == 0:
			$start_game.disabled = false
		
		Network.push_lobby_state(panel_data, players_waiting)

func client_join_waiting(client_name):
	add_waiting(client_name)
	
	Network.push_lobby_state(panel_data, players_waiting)

func client_joined_lobby(client_name):
	add_waiting(client_name)
	
	Network.push_lobby_state(panel_data, players_waiting)

func client_left_lobby(client_id):
	var client_name = Network.player_id_and_name[client_id]
	if players_waiting.has(client_name):
		$waiting.remove_item(players_waiting.find(client_name))
		players_waiting.erase(client_name)
	
	if panel_data.values().has(client_name):
		var panel_id = panel_data.keys()[panel_data.values().find(client_name)]
		deselect_panel(panel_id)
	
	if players_waiting.size() == 0:
		$start_game.disabled = false
	
	Network.push_lobby_state(panel_data, players_waiting)

#functions for host selecting
func host_select_panel(panel_id):
	var host_name = Network.player_id_and_name[1]
	if players_waiting.has(host_name):
		$waiting.remove_item(players_waiting.find(host_name))
		players_waiting.erase(host_name)
	if panel_data.values().has(host_name):
		var current_panel_id = panel_data.keys()[panel_data.values().find(host_name)]
		deselect_panel(current_panel_id)
	select_panel(panel_id, host_name)
	
	if players_waiting.size() == 0:
		$start_game.disabled = false
	Network.push_lobby_state(panel_data, players_waiting)

func _on_team_A1_pressed():
	host_select_panel("A1")

func _on_team_A2_pressed():
	host_select_panel("A2")

func _on_team_A3_pressed():
	host_select_panel("A3")

func _on_team_B1_pressed():
	host_select_panel("B1")

func _on_team_B2_pressed():
	host_select_panel("B2")

func _on_team_B3_pressed():
	host_select_panel("B3")


func _on_join_waiting_pressed():
	var host_name = Network.player_id_and_name[1]
	add_waiting(host_name)
	
	Network.push_lobby_state(panel_data, players_waiting)
