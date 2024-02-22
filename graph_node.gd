extends GraphNode

@onready var desc = $Description;

func change_desc(text: String):
	desc.text = text

func maximizing_player(is_maximizing_player: bool):
	pass
