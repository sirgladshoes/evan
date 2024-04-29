extends Node

@onready var main_menu_packed = preload("res://menus/main_menu.tscn")
@onready var lobby_host_packed = preload("res://menus/lobby/lobby_host.tscn")
@onready var lobby_client_packed = preload("res://menus/lobby/lobby_client.tscn")

@onready var scene_root = get_tree().current_scene

func _ready():
	Network.on_disconnected_from_server.connect(switch_main_menu)


func switch_main_menu():
	var main_menu = main_menu_packed.instantiate()
	load_main(main_menu)

func switch_lobby():
	var lobby
	if Network.is_server:
		lobby = lobby_host_packed.instantiate()
	else:
		lobby = lobby_client_packed.instantiate()
	load_main(lobby)


func load_main(scene):
	unload_main()
	get_tree().get_root().add_child(scene)
	scene_root = scene

func unload_main():
	scene_root.queue_free()
