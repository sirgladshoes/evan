extends Control

@export var yellowHighlight:Texture2D
@export var greenHighlight:Texture2D
@export var blackHighlight:Texture2D

@export var sentryHighlight:TextureRect
@export var miningHighlight:TextureRect

@onready var UI: CanvasLayer = owner

func render(units):
	
	var controlled_units = []
	
	for unit in units:
		if unit is controllable_unit:
			controlled_units.append(unit)
			print(unit.mode)
	
	if (controlled_units.size() == 0):
		sentryHighlight.texture = blackHighlight
		miningHighlight.texture = blackHighlight
		return
	
	if (are_all_none(controlled_units)):
		sentryHighlight.texture = null
		miningHighlight.texture = null
		return
	
	#change colors
	if has_miner(controlled_units) && !are_all_mining(controlled_units):
		miningHighlight.texture = yellowHighlight
	elif are_all_mining(controlled_units):
		miningHighlight.texture = greenHighlight
	

#runs when a button is clicked
func click(name):
	var controlled_units = []
	
	if(owner.get_parent().selected_units == 0):
		return
	
	for unit in owner.get_parent().selected_units:
		if unit is controllable_unit:
			controlled_units.append(unit)
	
	match name:
		"SentryButton":
			if are_all_none(controlled_units):
				pass
		"MiningButton":
			pass

func no_miners(units):
	for unit in units:
		if unit.mode == controllable_unit.behaviour.MINING:
			return false
	return true
	
func no_sentry(units):
	for unit in units:
		if unit.mode == controllable_unit.behaviour.SENTRY:
			return false
	return true

func has_miner(units):
	for unit in units:
		if unit.mode == controllable_unit.behaviour.MINING:
			return true
	return false

func has_sentry(units):
	for unit in units:
		if unit.mode == controllable_unit.behaviour.SENTRY:
			return true
	return false

func are_all_mining(units):
	for unit in units:
		if unit.mode == controllable_unit.behaviour.NORMAL || unit.mode == controllable_unit.behaviour.SENTRY:
			return false
	return true
	
func are_all_sentry(units):
	for unit in units:
		if unit.mode == controllable_unit.behaviour.NORMAL || unit.mode == controllable_unit.behaviour.MINING:
			return false
	return true
	
func are_all_none(units):
	for unit in units:
		if unit.mode == controllable_unit.behaviour.SENTRY || unit.mode == controllable_unit.behaviour.MINING:
			return false
	return true
