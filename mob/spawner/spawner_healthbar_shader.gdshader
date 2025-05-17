shader_type spatial;

uniform sampler2D viewport_texture; // hint_albedo
uniform float background_opacity = 0.2; // hint_range(0.0, 1.0)
uniform vec3 glow_color = vec3(1.0, 0.0, 0.0); // hint_color
uniform float glow_intensity = 1.0; // hint_range(0.0, 10.0)

void fragment() {
    vec4 tex_color = texture(viewport_texture, UV);

    // If the texture has any color, make it fully opaque
    if (tex_color.a > 0.0) {
        ALBEDO = tex_color.rgb;
        ALPHA = 1.0;
        EMISSION = glow_color * glow_intensity;
    } else {
        // Otherwise, render with configurable background opacity
        ALBEDO = vec3(0.0); // Black or any desired background color
        ALPHA = background_opacity;
        EMISSION = vec3(0.0); // No glow for the background
    }
}
