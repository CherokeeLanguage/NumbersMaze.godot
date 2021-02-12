extends Node2D

"""
I exist solely to stop issues with the dreaded 'already loaded' packed scene errors
"""

class_name PackedScenesScript

const FadeOutIn:PackedScene = preload("res://nodes/FadeOutIn.tscn")

const StartMenu:PackedScene = preload("res://ui/menus/StartMenu.tscn")
const SelectGameSlot:PackedScene = preload("res://ui/menus/SelectGameSlot.tscn")
const OptionsMenu:PackedScene = preload("res://ui/menus/OptionsMenu.tscn")
const AboutMenu:PackedScene = preload("res://ui/menus/AboutMenu.tscn")

const PlayerFireball:PackedScene = preload("res://player/PlayerFireball.tscn")
const DieExplosion:PackedScene = preload("res://nodes/DieExplosion.tscn")

