extends ColorRect

export (int) var numberOfStuffs = 50

func _ready():
	# Turn the rect invisible
	color.a = 0
	splatterStuff()

func splatterStuff():
	for _i in range(numberOfStuffs):
		var xs = randi() % int(rect_size[0])
		var ys = randi() % int(rect_size[1])
		var index = randi() % 15 + 1
		var imgPathToLoad = 'res://Assets/Graphics/BackgroundStuff/backgroundStuff'+str(index)+'.png'
		var spriteTexture : StreamTexture = load(imgPathToLoad)
		var sprite = Sprite.new()
		sprite.texture = spriteTexture
		sprite.position = Vector2(xs, ys)
		$StuffSort.add_child(sprite)
		sprite.offset = Vector2(- spriteTexture.get_width()/2, - spriteTexture.get_height() )
