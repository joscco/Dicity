extends ParallaxBackground
	
func _process(_delta):
	var newOffset = get_scroll_base_offset() + Vector2(1, -0.5)
	set_scroll_base_offset(newOffset) 
