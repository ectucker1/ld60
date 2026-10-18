// Cloud shadows slowly rolling over the scene.
// Adapted from "2D Fog Overlay" by HexagonNico (godotshaders.com/shader/2d-fog-overlay-2, CC0).

shader_type canvas_item;

// Seamless noise that the cloud shapes come from
uniform sampler2D noise_texture : repeat_enable, filter_linear;
// Color of the cloud shadow, its alpha scales the overall darkness too
uniform vec4 shadow_color : source_color = vec4(0.03, 0.03, 0.08, 1.0);
// How dark the cloud shadows get
uniform float density : hint_range(0.0, 1.0) = 0.35;
// How much of the sky is covered by cloud
uniform float coverage : hint_range(0.0, 1.0) = 0.5;
// How soft the cloud edges are
uniform float softness : hint_range(0.01, 1.0) = 0.35;
// Bigger values make bigger clouds
uniform float cloud_scale = 1.0;
// Matches the sprite's width:height so clouds aren't squashed, lower x for wider, flatter clouds
uniform vec2 cloud_stretch = vec2(1.5, 1.0);
// Drift speed of the main cloud layer, in screens per second
uniform vec2 speed = vec2(0.006, 0.0015);
// A second, finer layer drifting at its own speed, so clouds slowly change shape as they roll
uniform float detail_strength : hint_range(0.0, 1.0) = 0.35;
uniform float detail_scale = 2.3;
uniform vec2 detail_speed = vec2(0.011, -0.002);
// Snap the clouds to a pixel grid for a chunkier pixel-art look, 0 keeps them smooth
uniform float pixel_grid = 0.0;

void fragment() {
	vec2 uv = UV;
	if (pixel_grid > 0.0) {
		uv = floor(uv * pixel_grid) / pixel_grid;
	}
	uv = uv * cloud_stretch / cloud_scale;

	float main_layer = texture(noise_texture, uv + speed * TIME).r;
	float detail_layer = texture(noise_texture, uv * detail_scale + detail_speed * TIME + vec2(0.37, 0.71)).r;
	float noise = mix(main_layer, detail_layer, detail_strength);

	float edge = 1.0 - coverage;
	float cloud = smoothstep(edge - softness * 0.5, edge + softness * 0.5, noise);
	COLOR = vec4(shadow_color.rgb, cloud * density * shadow_color.a);
}
