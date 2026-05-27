class_name RuntimePanel extends VBoxContainer

var node_displayers:Array[NodeDisplayer]

func _init() -> void:
	set_anchors_preset(PRESET_FULL_RECT)

func display_node(target:Node, _log:String) -> void:
	var displayer:NodeDisplayer 
	
	for d in node_displayers:
		if d._source == target:
			displayer = d
	
	if displayer == null:
		displayer = NodeDisplayer.new(target)
		displayer.source_destroyed.connect(remove_node_display)
		displayer.fold()
		node_displayers.append(displayer)
		add_child(displayer)
	
	displayer.add_log(_log)

func remove_node_display(target_displayer:Node) -> void:
	node_displayers.erase(target_displayer)

func _process(_delta: float) -> void:
	if !visible:
		return;
	
	for node_displayer in node_displayers:
		node_displayer.display()
