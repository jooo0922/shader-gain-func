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
  // float y = smoothstep(0., 1., st.x); // smoothstep으로 곡선 구현하기
  // 이전 예제처럼 st.x 좌표값을 그대로 할당하지 않고,
  // gain() 함수에서 받은 리턴값을 넣어줌.
  float y = gain(st.x, .5);

  vec3 color = vec3(y);

    // Plot a line
  float pct = plot(st, y);
  color = (1.0 - pct) * color + pct * vec3(0.0, 1.0, 0.0);

  gl_FragColor = vec4(color, 1.0);
}

/*
  gain 함수에 대하여


  Iñigo Quiles 라는 셰이더 고수가 만든 함수임.
  gain 함수는 2개의 인자를 필요로 하는데,

  첫 번째 인자는, 내가 대응시키고 싶은 st.x값 (즉, 각 픽셀의 정규화된 x좌표값),
  두 번째 인자는, float k값이 붙음.
  
  k가 1일 때에는, 인자로 넘겨준 st.x와 동일한 값을 리턴해주지만,

  k가 1보다 클 때에는, smoothstep(0., 1., st.x); 로 구현한 곡선처럼 되어감.
  이 때, smoothstep(0., 1., st.x) 처럼 고정된 smoothstep 기울기의 곡선이 아니라,
  k값이 얼마나 크냐에 따라 기울기가 더 가파른 smoothstep 곡선을 그릴 수 있게 됨.

  k가 1보다 작을 때에는 1보다 클 때의 smoothstep 곡선에 대해
  반대 방향의 곡선을 그려줌.
*/

/*
  왜 이런 곡선을 그리는 걸 강조하는 걸까?

  나중에 셰이더에서 색 보정같은 걸 하게 될 때
  gain 함수의 곡선을 활용해야 하는 경우가 있기 때문!

  이 gain 함수가 리턴해주는 곡선의 값들은
  이처럼 다양한 셰이더 예제의 색 보정이 필요한 상황에서 자주 사용되기 때문에
  따로 코드를 저장해뒀다가 필요할 때 사용할 수 있도록 하는 게 좋음.
*/
