// Uniforms
uniform mat4 unWVP;
uniform mat4 unW;
uniform float unFreezeTemp;

// Input
in vec4 vPosition; // Position in object space
in vec3 vTangent;
in vec4 vColor_Temp;
in vec2 vUV;
in float vDepth;

// Output
out vec3 fColor;
out vec2 fUV;
out float fTemp;
out float fDepth;
out float frozen; // Needed to prevent shader precision issues
out mat3 fTbn;
out vec3 fEyeDir;

void main() {
  vec3 normal = normalize(vPosition.xyz);

  // Compute direction to eye
  fEyeDir = normalize(-(unW * vPosition).xyz);
  
  // Compute TBN for converting to world space
  vec3 n = normalize((unW * vec4(normal, 0.0)).xyz);
  vec3 t = normalize((unW * vec4(vTangent, 0.0)).xyz);
  vec3 b = normalize((unW * vec4(cross( normal, vTangent), 0.0)).xyz);
  fTbn = mat3(t, n, b);
  
  // Check if the liquid is frozen
  if (vColor_Temp.a <= unFreezeTemp) {
    frozen = 1.0;
  } else {
    frozen = 0.0;
  }
  
  gl_Position = unWVP * vPosition;
  fColor = vColor_Temp.rgb;
  fTemp = vColor_Temp.a;
  fUV = vUV;
  fDepth = vDepth;
}