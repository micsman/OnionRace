shader_type canvas_item;

uniform float wave_speed : hint_range(0.1, 4.0) = 0.9;
uniform float wave_width : hint_range(0.05, 0.6) = 0.22;
uniform float max_scale : hint_range(1.0, 2.5) = 1.45;

uniform float pause_duration : hint_range(0.0, 4.0) = 0.6;

void fragment() {
	vec2 uv = UV;

	float travel_time = 1.0 / max(wave_speed, 0.001);
	float cycle_length = travel_time + pause_duration;
	float cycle_pos = mod(TIME, cycle_length);

	float start_x = -wave_width * 1.5;
	float end_x = 1.0 + wave_width * 1.5;

	float wave_x;
	float active_mask = 1.0;

	if (cycle_pos <= travel_time) {
		float t = cycle_pos / travel_time;
		wave_x = mix(start_x, end_x, t);
	} else {
		wave_x = end_x;
		active_mask = 0.0;
	}

	float dist_x = uv.x - wave_x;
	float sigma = max(wave_width * 0.45, 0.001);
	float bell = exp(-(dist_x * dist_x) / (2.0 * sigma * sigma)) * active_mask;

	float zoom = mix(1.0, max_scale, bell);

	vec2 pivot = vec2(wave_x, 0.5);
	vec2 scaled_uv = pivot + (uv - pivot) / zoom;

	if (scaled_uv.x < 0.0 || scaled_uv.x > 1.0 || scaled_uv.y < 0.0 || scaled_uv.y > 1.0) {
		COLOR = vec4(0.0);
	} else {
		COLOR = texture(TEXTURE, scaled_uv) * COLOR;
	}
}