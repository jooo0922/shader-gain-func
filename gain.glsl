#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

// gain 함수
float gain(float x, float k) {
  float a = 0.5 * pow(2.0 * ((x < 0.5) ? x : 1.0 - x), k);
  return (x < 0.5) ? a : 1.0 - a;
}

// Plot a line on Y using a value between 0.0-1.0
float plot(vec2 st, float pct) {
  return smoothstep(pct - 0.02, pct, st.y) - smoothstep(pct, pct + 0.02, st.y);
}

void main() {
  vec2 st = gl_FragCoord.xy / u_resolution;

  // float y = st.x;
  // 이전 예제처럼 st.x 좌표값을 그대로 할당하지 않고,
  // gain() 함수에서 받은 리턴값을 넣어줌.
  float y = gain(st.x + 0.0, 1.752);

  vec3 color = vec3(y);

    // Plot a line
  float pct = plot(st, y);
  color = (1.0 - pct) * color + pct * vec3(0.0, 1.0, 0.0);

  gl_FragColor = vec4(color, 1.0);
}
