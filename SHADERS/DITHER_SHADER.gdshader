shader_type canvas_item;

// This file relies on a dither shader include file, listed further down.
// The paths must match your file's location.
#include "res://SHADERS/dither.gdshaderinc"

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

uniform vec2 player_position;
uniform vec2 shift_offset;

uniform int mixer : hint_range(1, 124, 1) = 1;

uniform float transition : hint_range(0.0, 1.0) = 1.0;

void vertex() {
    g_model_matrix = MODEL_MATRIX;
    g_world_to_clip = SCREEN_MATRIX * CANVAS_MATRIX;
    g_vertex = VERTEX;
}

void fragment() {
	vec4 original_texture = texture(SCREEN_TEXTURE, SCREEN_UV);
	//int x = int(player_position.x) % mixer;
	//int y = int(player_position.y) % mixer;
	//vec2 off = vec2(float(x), float(y));
	
	
    vec4 ditherColor = ditherScreen(SCREEN_TEXTURE, SCREEN_UV, g_vertex, player_position);
	COLOR = mix(original_texture * ditherColor, ditherColor, transition);
}