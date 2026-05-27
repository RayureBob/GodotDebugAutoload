@abstract
class_name GizmoDatum extends RefCounted

signal exhausted

var _active:bool
var _exhaustable:bool

var _life_time:float

func _init(life_time:float) -> void:
	_active = true
	self._life_time = life_time
	_exhaustable = _life_time > 0

func draw(delta:float) -> void:
	if _exhaustable:
		_life_time = _life_time - delta
		if _life_time == 0:
			exhausted.emit()
	
	_draw()

@abstract
func _draw() -> void
