extends TileMap

var chunk_size = 64  # Size of each additional chunk to generate
@onready var player = get_node("../Player")

var generated_chunks = {}  # A dictionary to store generated chunks
var last_path_pos = Vector2.ZERO

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

	# Generate the grass and decorative tiles first
	for x in range(start_pos.x, end_pos.x):
		for y in range(start_pos.y, end_pos.y):
			var tile_coord = Vector2i(0, 0)  # Default to plain grass

			if randf() < 0.9:
				tile_coord.x = randi() % 4  # 90% chance to pick a plain grass tile
			else:
				# 10% chance to pick a decorative tile
				tile_coord.x = randi() % 4
				tile_coord.y = randi() % 3 + 1

			set_cell(0, Vector2(x, y), 0, tile_coord)

	# Generate a path through the chunk
	var current_pos = last_path_pos
	var path_length = randi() % (9 * chunk_size) + chunk_size  # Random path length between chunk_size and 10 * chunk_size



	if not generated_chunks.has(chunk_pos):
		current_pos = start_pos + Vector2(randi() % chunk_size, randi() % chunk_size)

	for i in range(path_length):
		var tile_coord = Vector2i(randi() % 4, 4)  # Pick a random path tile
		set_cell(0, current_pos, 0, tile_coord)

		# Move to a random adjacent tile for the next path segment
		current_pos += Vector2(randf_range(-1, 2), randf_range(-1, 2)).snapped(Vector2.ONE)
		current_pos = clamp_vector(current_pos, start_pos, end_pos - Vector2.ONE)  # Keep the path within the chunk bounds
	last_path_pos = current_pos  # Store the last path position for the next chunk
	generated_chunks[chunk_pos] = true
	
func clamp_vector(vec, min_vec, max_vec):
	return Vector2(clamp(vec.x, min_vec.x, max_vec.x), clamp(vec.y, min_vec.y, max_vec.y))

