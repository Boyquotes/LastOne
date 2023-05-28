shader_type canvas_item;

// Size of each diamond, in pixels.
uniform float diamondPixelSize = 1;
uniform float circle_size : hint_range(0,1) = 0.5f;

/*void fragment(){
	if (distance(vec2(0.5,0.5), UV) < circle_size){
		COLOR.a = 0.0;
	}
}*/

void fragment() {
    float xFraction = fract(FRAGCOORD.x / diamondPixelSize);
    float yFraction = fract(FRAGCOORD.y / diamondPixelSize);
    
    float xDistance = abs(xFraction - 0.5);
    float yDistance = abs(yFraction - 0.5);
    
    if (xDistance + yDistance + UV.x + UV.y > circle_size * 4.0f) {
        discard;
    }
}