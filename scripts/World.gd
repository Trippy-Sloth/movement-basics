extends Node2D

const TILE_SIZE = 16
const TILE_ID = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	var windowSize = get_viewport().size
	var xNumTiles = windowSize.x / TILE_SIZE
	var yNumTiles = windowSize.y / TILE_SIZE 
	for i in range(xNumTiles):
		$Boundaries.set_cell(i, 0, TILE_ID)
		$Boundaries.set_cell(i, yNumTiles - 1, TILE_ID)
	
	for i in range(yNumTiles):
		$Boundaries.set_cell(0, i, TILE_ID)
		$Boundaries.set_cell(xNumTiles - 1, i, TILE_ID)

func _process(delta):
	$CurrentFuelLabel.text = "Fuel: " + str(int($Player.fuel))
	
