shader_type canvas_item;

void fragment() {
	vec2 pixel_coord = UV * vec2(1.0) / TEXTURE_PIXEL_SIZE;
	float modu = min(mod(pixel_coord.x, 2.0), mod(pixel_coord.y, 2.0));
	COLOR.a = modu;
}
