shader_type canvas_item;

uniform float height = 3.0;
uniform float curve = 0.02;
uniform float speed = 2.0;

void vertex() {
    VERTEX.y += height * sin(VERTEX.x * curve + TIME * speed);
}