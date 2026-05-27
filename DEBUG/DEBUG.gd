extends CanvasLayer


const DEBUG_CATEGORY = preload("res://Scripts/DEBUG/DebugPanel.gd").DEBUG_CATEGORY

var debug_panel:DebugPanel

@onready var labels: Array[Label] = []
var theme = preload("res://Resources/Debug/debug_theme.tres")
var style_box = preload("res://Resources/Debug/debug_style_box.tres")

var root:Control

var _gizmo_data:Dictionary[Node, GizmoDataList]

func _ready() -> void:
	layer = 1
	root = Control.new()
	root.name = "DEBUG ROOT"
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.theme = theme
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(root)
	
	debug_panel = DebugPanel.new()
	root.add_child(debug_panel)

func on_category_selection(cat:DEBUG_CATEGORY) -> void:
	print(cat as DEBUG_CATEGORY)

func DISPLAY_RUNTIME(source:Node, data:Variant) -> void:
	debug_panel.log_node_value(source, data)

func REMOVE_RUNTIME(source:Node) -> void:
	debug_panel.remove_node_value(source)

func LOG_INFO(source:Object, data:Variant) -> void:
	debug_panel._console_logs.log_info(source, data)

func LOG_WARNING(source:Object, data:Variant) -> void:
	debug_panel._console_logs.log_warning(source, data)

func LOG_ERROR(source:Object, data:Variant) -> void:
	debug_panel._console_logs.log_error(source, data)

func _process(_delta: float) -> void:
	var deleted_owners:Array[Node]
	
	for gizmo_owner in _gizmo_data:
		if gizmo_owner != null:
			_gizmo_data[gizmo_owner].draw()
		else:
			deleted_owners.append(gizmo_owner)
	
	for to_discard in deleted_owners:
		_gizmo_data.erase(to_discard)

const DebugCategoryNames:Dictionary[DEBUG_CATEGORY, String] = {
	DEBUG_CATEGORY.CONSOLE: "Console",
	DEBUG_CATEGORY.RUNTIME_VALUES: "Runtime values",
	DEBUG_CATEGORY.GIZMOS: "Gizmos"
}

func REGISTER_GIZMO(source:Node, data:GizmoDatum) -> void:
	if not _gizmo_data.keys().has(source):
		_gizmo_data[source] = GizmoDataList.new()
	
	_gizmo_data[source].add_gizmo(data)

func FLUSH_GIZMO(source:Node) -> void:
	for node in _gizmo_data.keys():
		if node == source:
			_gizmo_data.erase(node)


enum GIZMO_TYPE
{
	SPHERE,
	LINE
}
