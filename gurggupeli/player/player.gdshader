shader_type canvas_item;
uniform vec4 origin : source_color = vec4(0.0, 0.0, 0.1, 1.0);
uniform vec4 new : source_color = vec4(0.0, 0.0, 0.1, 1.0);
uniform vec4 modulate : source_color = vec4(0.0, 0.0, 0.1, 1.0);

void fragment() {
	vec4 origin_pixel = texture(TEXTURE, UV);
	if (origin_pixel == origin) {
		COLOR = new;
	} else {
		COLOR = origin_pixel;
	}
	COLOR *= modulate;
}
