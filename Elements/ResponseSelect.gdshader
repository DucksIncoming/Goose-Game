shader_type canvas_item;
uniform float fillAmount = 0.0;

void fragment() {
	bool baseColored = UV.x < (fillAmount + (0.02*sin(5.0*TIME + 10.0*(UV.y*UV.y))));
	bool shadowColored = UV.x < (fillAmount + 0.03 + (0.02*sin(5.0*TIME + 12.0*(UV.y*UV.y))));
	
	if (baseColored) {
		COLOR = COLOR * vec4(1.0,0.782,0.394,1);
	}
	else if (shadowColored) {
		COLOR = COLOR * vec4(0.502, 0.424, 0.259, 1.0);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
