class_name TVContext
extends RefCounted

## The actual TV node in the scene
var tv: TV

## The TV below this one. May be null.
var below: TVContext

## The TV above this one. May be null.
var above: TVContext

## The TV to the left of this one. May be null.
var left: TVContext

## The TV to the right of this one. May be null.
var right: TVContext

## Returns all discs in this TV
func get_discs() -> Array[Disc]:
	return tv.get_discs()
