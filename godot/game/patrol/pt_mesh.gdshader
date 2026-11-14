// 巡陰角色：原圖網格變形（GPU 蒙皮）。VERTEX 傳入嘅係原圖 uv；CUSTOM0 = 4 個權重、CUSTOM1 = 4 個骨頭號
shader_type canvas_item;
uniform vec4 bone[12];          // 每條骨：cos、sin、tx、ty（原圖比例座標）
uniform vec3 dims = vec3(100.0, 100.0, 1.0);   // W（闊）、h（高）、ar（圖高／圖闊）
uniform vec4 aff_a = vec4(1.0, 0.0, 0.0, 1.0); // 之後嘅仿射：x 軸 (a,b)、y 軸 (c,d)
uniform vec2 aff_o = vec2(0.0);
uniform float flash = 0.0;      // 受擊閃白（lighter 疊多一次）
uniform int mode = 0;           // 0 正常、1 衣服換色（只畫頸以下）
uniform mat3 cm = mat3(1.0);    // 衣服顏色矩陣（CSS filter）
uniform vec2 clip_y = vec2(-1e6, 1e6);
uniform float cloth_a = 0.72;
varying float ry;
void vertex() {
	float u = VERTEX.x; float vy = VERTEX.y * dims.z;
	vec4 w = CUSTOM0; vec4 ix = CUSTOM1;
	vec2 p = vec2(0.0);
	for (int k = 0; k < 4; k++) {
		vec4 q = bone[int(ix[k] + 0.5)];
		p += w[k] * vec2(q.x * u - q.y * vy + q.z, q.y * u + q.x * vy + q.w);
	}
	vec2 l = vec2(p.x * dims.x, p.y / dims.z * dims.y);
	vec2 r = vec2(aff_a.x * l.x + aff_a.z * l.y, aff_a.y * l.x + aff_a.w * l.y) + aff_o;
	ry = r.y;
	VERTEX = r;
}
void fragment() {
	vec4 c = texture(TEXTURE, UV);
	if (mode == 1) {
		if (ry < clip_y.x || ry > clip_y.y) discard;
		c.rgb = clamp(cm * c.rgb, 0.0, 1.0);
		c.a *= cloth_a;
	}
	c.rgb = min(vec3(1.0), c.rgb * (1.0 + flash * 0.8 * c.a));
	COLOR = c * COLOR;
}
