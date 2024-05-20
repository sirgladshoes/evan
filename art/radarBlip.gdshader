shader_type canvas_item;

uniform vec3 color = vec3(0, 1, 0);

void vertex() {
    // Called for every vertex the material is visible on.
}

void fragment() {
    float currentTime = TIME - trunc(TIME);
    
    if ( distance( UV, vec2(0.5,0.5) ) < currentTime / 2.0f ) {
        COLOR = vec4(color.x, color.y, color.z, ((1.0f - (currentTime - distance(UV, vec2(0.5,0.5))/2.0f)) / 1.5f) );
    } 
    else {
        COLOR = vec4(.0, 0, 0, 0);
    }
}