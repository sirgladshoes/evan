extends Control


func _ready():
	Network.on_server_sent_lobby_state.connect(update_lobby_state)


func update_lobby_state(panel_states, waiting_state):
	for panel_id in panel_states:
		if panel_states[panel_id] != null:
			select_panel(panel_id, panel_states[panel_id])
		else:
			deselect_panel(panel_id)
	
	$waiting.clear()
	
	for item in waiting_state:
		$waiting.add_item(item, null, false)

func select_panel(panel_id, selector_name):
		var team = panel_id[0]
		var num = panel_id[1]
		var panel = get_node("team" + team + "_back").get_node("team" + team + "_" + num)
		panel.text = selector_name
		panel.disabled = true

func deselect_panel(panel_id):
	var team = panel_id[0]
	var num = panel_id[1]
	var panel = get_node("team" + team + "_back").get_node("team" + team + "_" + num)
	panel.text = ""
	panel.disabled = false


func _on_team_A1_pressed():
	Network.push_lobby_select_panel("A1")

func _on_team_A2_pressed():
	Network.push_lobby_select_panel("A2")

func _on_team_A3_pressed():
	Network.push_lobby_select_panel("A3")



func _on_team_B1_pressed():
	Network.push_lobby_select_panel("B1")

func _on_team_B2_pressed():
	Network.push_lobby_select_panel("B2")

func _on_team_B3_pressed():
	Network.push_lobby_select_panel("B3")




func _on_join_waiting_pressed():
	Network.push_lobby_join_waiting()
