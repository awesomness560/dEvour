shader_type canvas_item;

// Grid properties
uniform float cell_size : hint_range(8.0, 128.0) = 32.0;
uniform float dot_size : hint_range(0.05, 0.8) = 0.3;

// Colors
uniform vec4 background_color : source_color = vec4(0.08, 0.08, 0.08, 1.0);
uniform vec4 dot_color : source_color = vec4(0.25, 0.25, 0.25, 1.0);

// Camera offset for infinite scrolling (set this from your script)
uniform vec2 camera_offset = vec2(0.0, 0.0);
uniform float camera_zoom : hint_range(0.1, 10.0) = 1.0;

// Quality settings
uniform float anti_aliasing_factor : hint_range(0.001, 0.1) = 0.02;
uniform int stochastic_samples : hint_range(1, 32) = 8;

// Fade settings for distance-based visibility
uniform bool enable_fade = true;
uniform float fade_start : hint_range(0.1, 2.0) = 0.8;
uniform float fade_end : hint_range(1.0, 5.0) = 2.0;

// Zoom-based grid scaling
uniform bool enable_density_fade = true;
uniform float min_dot_size : hint_range(0.1, 2.0) = 0.5;

// Pseudo-random number generator with better distribution
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Improved random with multiple seeds for better stochastic sampling
vec2 random2(vec2 st, float seed) {
    return vec2(
        fract(sin(dot(st + seed, vec2(12.9898, 78.233))) * 43758.5453123),
        fract(sin(dot(st + seed, vec2(93.9898, 67.345))) * 23421.6312341)
    );
}

void fragment() {
    // Get screen space position and apply camera offset
    vec2 screen_pos = FRAGCOORD.xy + camera_offset;
    vec4 final_color = vec4(0.0);

    // Calculate effective cell size based on camera zoom
    // When zoomed out (camera_zoom > 1), grid cells appear smaller
    float effective_cell_size = cell_size / camera_zoom;

    // Adaptive sampling based on zoom level
    float zoom_factor = clamp(camera_zoom, 0.1, 4.0);
    int adaptive_samples = max(1, int(float(stochastic_samples) / sqrt(zoom_factor)));

    // Early exit for extreme zoom levels to maintain performance
    if (camera_zoom > 10.0) {
        COLOR = background_color;
    }

    for (int i = 0; i < adaptive_samples; i++) {
        // Generate better distributed random offset
        vec2 random_offset = (random2(FRAGCOORD.xy, float(i)) - 0.5) * SCREEN_PIXEL_SIZE;
        vec2 sample_pos = screen_pos + random_offset;

        // Scale by effective cell size to get grid coordinates
        vec2 grid_pos = sample_pos / effective_cell_size;

        // Find nearest grid intersection
        vec2 nearest_intersection = round(grid_pos) * effective_cell_size;

        // Calculate distance from sample point to nearest intersection
        float dist = length(sample_pos - nearest_intersection);

        // Calculate dot radius - keep dots visible at all zoom levels
        float radius = dot_size * effective_cell_size * 0.5;

        // Ensure dots don't become too small when zoomed out
        float min_radius = 0.5; // Minimum radius in screen pixels
        radius = max(radius, min_radius);

        // Improved anti-aliasing with zoom-adjusted edge width
        float edge_width = anti_aliasing_factor * max(effective_cell_size, 2.0);
        float alpha = smoothstep(radius - edge_width, radius + edge_width, dist);

        // Optional: Fade dots based on distance from camera for performance
        float fade_factor = 1.0;
        if (enable_fade) {
            float camera_dist = length(sample_pos - camera_offset) / effective_cell_size;
            fade_factor = 1.0 - smoothstep(fade_start * 10.0, fade_end * 10.0, camera_dist);
        }

        // Fade dots when they become too dense (zoomed out very far)
        float density_fade = 1.0;
        if (effective_cell_size < 4.0) {
            density_fade = smoothstep(1.0, 4.0, effective_cell_size);
        }

        // Mix colors with fade factors
        vec4 sample_color = mix(dot_color * fade_factor * density_fade, background_color, alpha);
        final_color += sample_color;
    }

    // Average all samples
    COLOR = final_color / float(adaptive_samples);

    // Ensure background alpha is maintained
    COLOR.a = background_color.a;
}