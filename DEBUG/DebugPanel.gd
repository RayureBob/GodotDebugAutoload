class_name DebugPanel extends Control

var _margin:MarginContainer
var _background:PanelContainer
var _vertical_box:VBoxContainer
var _content_panel:MarginContainer

var _console_logs:ConsoleLogs
var _runtime_panel:RuntimePanel
var _debug_style_box:StyleBoxFlat = preload("res://Resources/Debug/debug_style_box.tres")
var _debug_panels:Array[Control]

func _init() -> void:
	print("initializing")
	set_anchors_preset(Control.PRESET_FULL_RECT)
	set_anchor(SIDE_RIGHT, .5)
	_margin = MarginContainer.new()
	_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	_margin.add_theme_constant_override("margin_left", 5)
	_margin.add_theme_constant_override("margin_top", 5)
	_margin.add_theme_constant_override("margin_right", 5)
	_margin.add_theme_constant_override("margin_bottom", 5)
	
	_background = PanelContainer.new()
	_background.size_flags_horizontal = Control.SIZE_FILL
	_background.size_flags_vertical = Control.SIZE_FILL
	_background.add_theme_stylebox_override("panel", _debug_style_box)
	
	_vertical_box = VBoxContainer.new()
	_vertical_box.size_flags_horizontal = Control.SIZE_FILL
	_vertical_box.size_flags_vertical = Control.SIZE_FILL
	
	var categories_button := HBoxContainer.new()
	
	var panel_button := Button.new()
	panel_button.text = "Runtime"
	panel_button.pressed.connect(func(): display_panel(_runtime_panel))
	categories_button.add_child(panel_button)
	
	panel_button = Button.new()
	panel_button.text = "Console"
	panel_button.pressed.connect(func(): display_panel(_console_logs))
	categories_button.add_child(panel_button)
	
	_content_panel = MarginContainer.new()
	_content_panel.add_theme_constant_override("margin_left", 5)
	_content_panel.add_theme_constant_override("margin_right", 5)
	
	_console_logs = ConsoleLogs.new()
	_console_logs.visible = false
	
	_runtime_panel = RuntimePanel.new()
	_runtime_panel.visible = false
	
	_debug_panels.append(_runtime_panel)
	_debug_panels.append(_console_logs)
	
	add_child(_margin)
	_margin.add_child(_background)
	_background.add_child(_vertical_box)
	_vertical_box.add_child(categories_button)
	_vertical_box.add_child(_content_panel)
	_content_panel.add_child(_runtime_panel)
	_content_panel.add_child(_console_logs)
	visible = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_F1 and not event.is_released():
			visible = !visible

func _debug_category_selected(category:DEBUG_CATEGORY) -> void:
	var target_panel:Control
	match category:
		DEBUG_CATEGORY.CONSOLE:
			target_panel = _console_logs
			print("selected console")
		DEBUG_CATEGORY.RUNTIME_VALUES:
			target_panel = _runtime_panel
			print("selected runtime")
		DEBUG_CATEGORY.GIZMOS:
			print("selected gizmos")
			pass
	
	for panel in _debug_panels:
		panel.visible = panel == target_panel

func display_panel(panel:Node) -> void:
	for p in _debug_panels:
		p.visible = p == panel

func log_node_value(target:Node, data:Variant) -> void:
	var _log := ""
	if data == null:
		_log = "null"
	
	if data is Array:
		for datum in data:
			_log = _log + datum + "\n"
	else:
		_log = str(data)
	
	_runtime_panel.display_node(target, _log)

func remove_node_value(target:Node) -> void:
	_runtime_panel.remove_node_display(target)

enum DEBUG_CATEGORY {
	CONSOLE,
	RUNTIME_VALUES,
	GIZMOS
}

const DebugCategoryNames:Dictionary[DEBUG_CATEGORY, String] = {
	DEBUG_CATEGORY.CONSOLE: "Console",
	DEBUG_CATEGORY.RUNTIME_VALUES: "Runtime values",
	DEBUG_CATEGORY.GIZMOS: "Gizmos"
}
