shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1.0);
uniform float line_thickness : hint_range(0, 100) = 15.0;

uniform bool active = false; // Add this

void fragment() {
	if (active) {
		vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
		float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
		outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
		outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
		outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
		outline = min(outline, 1.0);
		
		
		vec4 color = texture(TEXTURE, UV);
		vec4 outline_color = vec4(line_color.rgb, outline);
	
		COLOR = mix(color, outline_color, outline - color.a);
	}
}