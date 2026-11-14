// 巡陰光照：一張 1/4 解像度嘅「剩低幾黑」遮罩（白 = 全黑，挖咗光就變細），疊成黑幕
shader_type canvas_item;
uniform sampler2D mask : filter_linear;
uniform vec4 dark = vec4(0.0, 0.0, 0.0, 0.7);
void fragment() {
	float f = texture(mask, SCREEN_UV).r;
	COLOR = vec4(dark.rgb, dark.a * f);
}
