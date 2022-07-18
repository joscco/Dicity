extends Label

func updateText():
	match GameManager.reasonForGameOver:
		GameManager.GAME_OVER_REASON.NOT_ENOUGH_POINTS:
			text = "You didn't score enough points."
		GameManager.GAME_OVER_REASON.NO_FOOD:
			text = "Your town couldn't supply enough food."
		GameManager.GAME_OVER_REASON.NO_FUN:
			text = "Your town couldn't supply enough entertainment."
		GameManager.GAME_OVER_REASON.NO_EDUCATION:
			text = "Your town couldn't supply enough education."
