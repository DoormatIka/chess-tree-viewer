extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_file_dialog_file_selected(path):
	var json = JSON.new()
	var file = FileAccess.open(path, FileAccess.READ)
	var error = json.parse(file.get_as_text())
	
	if error == OK:
		var data_received = json.data
		if typeof(data_received["top"]) == TYPE_ARRAY:
			_run_through_top_node(data_received)
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())

func _run_through_top_node(data: Dictionary):
	for fen in data["top"]:
		_run_through_node(data, fen)

func _run_through_node(data: Dictionary, selected_key: String):
	if !data.has(selected_key):
		return
	
	for fen in data[selected_key]:
		_run_through_node(data, fen)
