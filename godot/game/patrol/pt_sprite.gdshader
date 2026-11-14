// 巡陰：普通角色圖（冇骨架）——鬼嘅下半身漸隱、受擊閃白
shader_type canvas_item;
uniform float flash = 0.0;
uniform vec2 fade = vec2(2.0, 3.0);  // uv.y 由 fade.x 開始淡，到 fade.y 係最淡
uniform float fade_k = 0.0;
void fragment() {
	vec4 c = texture(TEXTURE, UV);
	float t = clamp((UV.y - fade.x) / max(0.0001, fade.y - fade.x), 0.0, 1.0);
	float g = t < 0.6 ? t / 0.6 * 0.22 : 0.22 + (t - 0.6) / 0.4 * 0.33;
	c.a *= 1.0 - g * fade_k;
	c.rgb = min(vec3(1.0), c.rgb * (1.0 + flash * 0.8 * c.a));
	COLOR = c * COLOR;
}
