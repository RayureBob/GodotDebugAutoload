class_name ConsoleLogs extends VBoxContainer

enum LOG_TYPE {
	INFO,
	WARNING,
	ERROR
}

var logs:Array[RichTextLabel]

func _init() -> void:
	set_anchors_preset(PRESET_FULL_RECT)
	custom_minimum_size = Vector2.ONE * 500

func _to_string() -> String:
	return "ConsoleLogs"

func push_log(_source:Object, _log:Variant, type:LOG_TYPE) -> void:
	var label = RichTextLabel.new()
	var color:Color
	
	match type:
		LOG_TYPE.INFO:
			color = Color.TEAL
		LOG_TYPE.WARNING:
			color = Color.ORANGE
		LOG_TYPE.ERROR:
			color = Color.RED
	
	append_with_color(label, "{0} ".format([char(0x25A0)]), color)
	
	label.scroll_active = false
	label.append_text(Time.get_time_string_from_system() + ", ")
	append_with_color(label,"%s " % str(_source), Color.LIGHT_CORAL)
	label.append_text("%s " % char(0x25BA))
	label.append_text(_log)
	label.fit_content = true
	logs.append(label)
	add_child(label)
	logs.reverse()

func log_info(_source:Object, _log:Variant) -> void:
	push_log(_source, _log, LOG_TYPE.INFO)

func log_warning(_source:Object, _log:Variant) -> void:
	push_log(_source, _log, LOG_TYPE.WARNING)

func log_error(_source:Object, _log:Variant) -> void:
	push_log(_source, _log, LOG_TYPE.ERROR)

func append_with_color(label:RichTextLabel, type:String, color:Color) -> void:
	label.push_color(color)
	label.append_text(type)
	label.pop()

func flush_logs() -> void:
	for label in logs:
		label.free()

func write_to_disk() -> void:
	var file = FileAccess.open("user://logs.txt", FileAccess.WRITE)
	if file == null:
		log_error(self, "Couldn't open logs file to write in.")
		return
	
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	for _log in logs:
		file.store_string(regex.sub(_log.text, "", true))
