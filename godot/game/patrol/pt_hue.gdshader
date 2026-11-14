// 巡陰特效圖：色相旋轉（CSS hue-rotate + saturate），疊光
shader_type canvas_item;
render_mode blend_add;
uniform mat3 cm = mat3(1.0);
void fragment() {
	vec4 c = texture(TEXTURE, UV);
	c.rgb = clamp(cm * c.rgb, 0.0, 1.0);
	COLOR = c * COLOR;
}
