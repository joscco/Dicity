extends Node

onready var audioPlayer: AudioStreamPlayer = $AudioPlayer
var mainMusicIntro = preload("res://AssetCreation/Music/Intro.ogg")
var mainMusic = preload("res://AssetCreation/Music/Main.ogg")

var musicPlaying: bool
var introPlaying: bool

func playMusic():
	if !musicPlaying and !introPlaying:
		audioPlayer.stream = mainMusicIntro
		audioPlayer.play()
		
		introPlaying = true
		musicPlaying = true
		
		# Wait until the intro has finished playing
		yield(audioPlayer, "finished")
		introPlaying = false
		audioPlayer.stream = mainMusic
		audioPlayer.play()
		
	
func stopMusic():
	audioPlayer.stop()
