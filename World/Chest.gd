extends StaticBody2D

export(PackedScene) var Item

onready var animation = $Animation

var _closed = true

func _ready():
	assert(Item!=null)

func _on_HurtBox_area_entered(_area):
	if _closed:
		animation.play()
		var item = Item.instance()
		$Item.add_child(item)
		item.play(get_global_transform_with_canvas().get_origin())
	_closed = false
