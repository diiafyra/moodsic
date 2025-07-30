#include <flutter/runtime_effect.glsl>
uniform vec2 iResolution;
uniform float iTime;
uniform vec2 uCenter;
uniform vec4 uColor;

out vec4 fragColor;

void main(){
  vec2 uv = FlutterFragCoord().xy / iResolution;
  vec2 dir = uv - uCenter / iResolution;
  float dist = length(dir);
  float radius = iTime * 0.3;
  float alpha = exp(-dist * 10.0) * step(dist, radius) * (1.0 - dist/radius);
  fragColor = uColor * alpha;
}
