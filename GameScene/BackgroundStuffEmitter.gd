extends YSort

export (int) var height = 1080
export (int) var width = 150
export (int) var numberOfStuffs = 50

func _ready():
	splatterStuff()

func splatterStuff():
	for i in range(numberOfStuffs):
		var xs = randi() % width
		var ys = randi() % height
		var index = randi() % 15 + 1
		var imgPathToLoad = 'res://Assets/Graphics/BackgroundStuff/backgroundStuff'+str(index)+'.png'
		var spriteTexture : StreamTexture = load(imgPathToLoad)
		var sprite = Sprite.new()
		sprite.texture = spriteTexture
		sprite.position = Vector2(xs, ys)
		add_child(sprite)
		sprite.offset = Vector2(- spriteTexture.get_width()/2, - spriteTexture.get_height() )
