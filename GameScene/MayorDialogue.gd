extends Node2D

var tutorialState = 0
var tutorialOver = false

var tutorialTexts = [\
"Hello there 'ol chap. My name is Mayor Diceington of the Dice Dynasty. I must confess, I am not made for the life of a mayor. My lifelong dream is to become a competitive Yahtzee player, but alas my family keeps assigning me project after project.",\
"Would you mind taking over for me? At least for a little while, so I can hone my Yahtzee skills.",\
"Its not as difficult as it looks. Just roll the dice and place them on the land. If it were up to me, you could place them any way you like but my family gives me these ridiculous productivity quotas to fulfill.",\
"Basically if the city doesn't produce enough money after a certain amount of dice rolls they will come check up on me and then we are busted.",\
"Black buildings produce money. As a rule of thumb the larger the number, the larger the yield. Building a cluster of the same building will increase the yield of all buildings in the cluster.",\
"But don't just go building huge clusters of factories. Firstly because you need food, entertainment and education to improve your luck with the dice and secondly because large clusters will negatively impact neighboring tiles.",\
"Nobody wants to live right next to a giant factory complex, right? But then again, I wouldn't want to live right next to a huge cluster of kindergartens either. Everything in moderation, I guess.",\
"I'm sure you'll get the hang of it in no time."\
]


var hintTexts =[\
"The chance to get a Yahtzee on the first roll are only 0.0771% but with enough skill a practiced player can improve those odds to 1 in 1296.",\
"Yahtzee!!",\
"Dammit I need a 4",\
"Remember you don't need to place all dice.",\
"The sound of rolling dice is like music in my ears.",\
"The earliest dice were made of bone. Spooky.",\
"The most important predecessor of Yahtzee is the dice game Yacht, which is an English cousin of Generala and dates back to at least 1938.",\
"My biggest weakness is the Full House.",\
"The chance to get a Yahtzee with the rerolls is 4.6%.",\
"One of the oldest known dice games is Senet. It was played before 3000 BC.",\
"The five dot pattern on many dice is called Quincunx.",\
"A [3] is worth 3 points, [3][3] is worth 12 points and [3][3][3] is worth 27 points. How does that work? Nobody knows.",\
"Sometimes late at night I wonder if I'm just part of a bigger dice game that somebody else is playing.",\
"Some people consider a coin a two sided die. Those people have lost their grasp on reality.",\
"Nothing beats playing dice for hours on end.",\
"The average Yahtzee score when using the perfect strategy is 254.59.",\
"The highest possible Yahtzee score is 1,575.",\
]

func next():
	tutorialState += 1
	$Speechbubble/Text.text = tutorialTexts[tutorialState]