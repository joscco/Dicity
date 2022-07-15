extends Node

onready var audioPlayer: AudioStreamPlayer = $AudioPlayer

# Looping Sound files work way better in ogg format!
var mainMusicIntro = preload("res://Assets/Music/Intro.ogg")
var mainMusic = preload("res://Assets/Music/Main.ogg")

var HitSound = preload("res://Assets/Sounds/hit.mp3")
var ShellSound = preload("res://Assets/Sounds/shells.mp3")
var ShootSound = preload("res://Assets/Sounds/shoot.mp3")
var BlipSound = preload("res://Assets/Sounds/blip.wav")
var DiceSound = preload("res://Assets/Sounds/diceroll.wav")
var ErrorSound = preload("res://Assets/Sounds/error.mp3")

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
	
func playSound(sfx = "hit"):
	var asp = AudioStreamPlayer.new()
	
	add_child(asp)
	if sfx == "hit":
		asp.stream = HitSound
	if sfx == "shells":
		asp.stream = ShellSound
	if sfx == "shoot":
		asp.stream = ShootSound
	if sfx == "blip":
		asp.stream = BlipSound
	if sfx == "diceroll":
		asp.stream = DiceSound
	if sfx == "error":
		asp.stream = ErrorSound
	asp.play()
