shader_type canvas_item;


// Scrolling speed
uniform float scrollSpeed = 0.1;

/* Manipulate vertex points */
void vertex() {
	// Scroll the background
	UV.x += TIME * scrollSpeed;
}
