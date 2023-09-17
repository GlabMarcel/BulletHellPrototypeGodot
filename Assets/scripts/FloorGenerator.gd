extends TileMap

var chunk_size = 64  # Size of each additional chunk to generate
@onready var player = get_node("../Player")

var generated_chunks = {}  # A dictionary to store generated chunks

func _ready():
	generate_chunk(Vector2.ZERO)

func _process(_delta):
	var player_chunk = local_to_map(player.global_position) / chunk_size
	player_chunk = Vector2(floor(player_chunk.x), floor(player_chunk.y))

	for x in range(-2, 3):
		for y in range(-2, 3):
			var current_chunk = player_chunk + Vector2(x, y)
			if not generated_chunks.has(current_chunk):
				generate_chunk(current_chunk)

func generate_chunk(chunk_pos):
	var start_pos = chunk_pos * chunk_size
	var end_pos = start_pos + Vector2(chunk_size, chunk_size)

	for x in range(start_pos.x, end_pos.x):
		for y in range(start_pos.y, end_pos.y):
			var tile_coord = Vector2i(0, 0)  # Default to plain grass

			if randf() < 0.9:
				tile_coord.x = randi() % 4  # 90% chance to pick a plain grass tile
			else:
				# 10% chance to pick a decorative tile
				tile_coord.x = randi() % 4
				tile_coord.y = randi() % 3 + 1

			set_cell(0,Vector2(x, y), 0, tile_coord)

	generated_chunks[chunk_pos] = true
