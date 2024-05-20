extends Control

@export var yellowHighlight:Texture2D
@export var greenHighlight:Texture2D
@export var blackHighlight:Texture2D

@onready var sentryHighlight:TextureRect = $SentryButton/highlight
@onready var miningHighlight:TextureRect = $MiningButton/highlight

signal disable_mining()
signal disable_sentries()
signal set_mining()
signal set_sentry()


func update_sentry(value):
	match value:
		"all":
			sentryHighlight.texture = greenHighlight
		"some":
			sentryHighlight.texture = yellowHighlight
		"none":
			sentryHighlight.texture = blackHighlight

func update_mining(value):
	match value:
		"all":
			miningHighlight.texture = greenHighlight
		"some":
			miningHighlight.texture = yellowHighlight
		"none":
			miningHighlight.texture = blackHighlight


func _on_mining_button_pressed():
	if miningHighlight.texture == greenHighlight or miningHighlight.texture == yellowHighlight:
		disable_mining.emit()
	else:
		set_mining.emit()


func _on_sentry_button_pressed():
	if sentryHighlight.texture == greenHighlight or sentryHighlight.texture == yellowHighlight:
		disable_sentries.emit()
	else:
		set_sentry.emit()
