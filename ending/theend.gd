extends Control

func _ready() -> void:
	%Carrots.text = "Carrots: " + str(Globals.carrots) + " / " + str(Globals.totalCarrots)
