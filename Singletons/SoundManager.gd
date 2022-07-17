extends Node

onready var musicPlayer: AudioStreamPlayer = $MusicPlayer
onready var soundPlayer: AudioStreamPlayer = $SoundPlayer
var muted = false

# Looping Sound files work way better in ogg format!
var mainMusicIntro = preload("res://Assets/Music/Intro.ogg")
var mainMusic = preload("res://Assets/Music/Main.ogg")

var noSound1 = preload("res://Assets/Sounds/noSound1.ogg")
var noSound2 = preload("res://Assets/Sounds/noSound2.ogg")
var noSound3 = preload("res://Assets/Sounds/noSound3.ogg")
var noSounds = [noSound1, noSound2, noSound3]
var ohSound = preload("res://Assets/Sounds/ohSound.ogg")
var agreeSound = preload("res://Assets/Sounds/agreeSound.ogg")
var plopSound = preload("res://Assets/Sounds/plopSound.ogg")
var diceSound = preload("res://Assets/Sounds/diceroll.ogg")

var musicPlaying: bool
var introPlaying: bool

func playMusic():
	if !musicPlaying and !introPlaying:
		musicPlayer.stream = mainMusicIntro
		musicPlayer.play()
		
		introPlaying = true
		musicPlaying = true
		
		# Wait until the intro has finished playing
		yield(musicPlayer, "finished")
		introPlaying = false
		musicPlayer.stream = mainMusic
		musicPlayer.play()
		
func stopMusic():
	musicPlayer.stop()
	introPlaying = false
	musicPlaying = false

func mute():
	muted = true
	musicPlayer.stream_paused = true
	soundPlayer.stream_paused = true

func unmute():
	muted = false
	musicPlayer.stream_paused = false
	soundPlayer.stream_paused = false
	
func playSound(sfx: String):
	if sfx == "plop":
		soundPlayer.stream = plopSound
	if sfx == "oh":
		soundPlayer.stream = ohSound
	if sfx == "success":
		soundPlayer.stream = agreeSound
	if sfx == "diceroll":
		soundPlayer.stream = diceSound
	if sfx == "error":
		soundPlayer.stream = noSounds[randi() % 3]
	soundPlayer.play()
