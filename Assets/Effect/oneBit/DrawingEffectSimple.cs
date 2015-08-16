using UnityEngine;
using System.Collections;

public class DrawingEffectSimple : MonoBehaviour {

	public enum OverlayBlendMode {
		Additive = 0,
		ScreenBlend = 1,
		Multiply = 2,
		Overlay = 3,
		AlphaBlend = 4,	
	}

	public Material effectBCSMat;//Brightness Contrast Saturation
	public Material effectMat;
	public Material effectOverlayMat;

	public float saturation = 1.0f;
	public float brightness = 1.0f;
	public float contrast = 2.0f;

	public float sensitivityDepth = 1.0f;
	public float sensitivityNormals = 1.0f;
	public float sampleDist = 1.0f;
	public int colorStep = 5;
	public float lineNoise = 1.2f;
	public float textureNoise = 0.15f;
	public float textureV = 1.0f;

	public OneBitEffectsDepthAndNormal.OverlayBlendMode textureBlendMode = OneBitEffectsDepthAndNormal.OverlayBlendMode.Overlay;
	public float intensity = 1.0f;

	public Texture paperTexture;

	public Color color = Color.white;
	public Color lineColor = Color.black;

	void Start()
	{
		GetComponent<Camera>().depthTextureMode = DepthTextureMode.DepthNormals;			
	}

	public bool enableOneBitEffect = true;


	void OnRenderImage(RenderTexture s, RenderTexture d){

		// Brightness Contrast Saturation
		RenderTexture rt_src = RenderTexture.GetTemporary(s.width, s.height);
		effectBCSMat.SetFloat("_SaturationAmount", saturation);
		effectBCSMat.SetFloat("_BrightnessAmount", brightness);
		effectBCSMat.SetFloat("_ContrastAmount", contrast);
		Graphics.Blit(s, rt_src, effectBCSMat, 0);

		if(!enableOneBitEffect){
			Graphics.Blit(rt_src, d);
			RenderTexture.ReleaseTemporary(rt_src);
			return;
		}

		//  effect
		//  
		RenderTexture rt1 = RenderTexture.GetTemporary(s.width, s.height);
		effectMat.SetColor("_Color", color);
		effectMat.SetColor("_LineColor", lineColor);
		Vector2 sensitivity = new Vector2 (sensitivityDepth, sensitivityNormals);
		effectMat.SetVector ("_Sensitivity", new Vector4 (sensitivity.x, sensitivity.y, 1.0f, sensitivity.y));	
		effectMat.SetFloat ("_SampleDistance", sampleDist);
		effectMat.SetFloat ("_Step", colorStep);
		effectMat.SetFloat ("_LineNoise", lineNoise);
		effectMat.SetFloat ("_TextureNoise", textureNoise);
		effectMat.SetFloat ("_TextureV", textureV);
		Graphics.Blit(rt_src, rt1, effectMat); 
		RenderTexture.ReleaseTemporary(rt_src);

		// overlay
		Vector4 UV_Transform = new Vector4(1, 0, 0, 1);
		
		#if UNITY_WP8
		// WP8 has no OS support for rotating screen with device orientation,
		// so we do those transformations ourselves.
		if (Screen.orientation == ScreenOrientation.LandscapeLeft) {
			UV_Transform = Vector4(0, -1, 1, 0);
		}
		if (Screen.orientation == ScreenOrientation.LandscapeRight) {
			UV_Transform = Vector4(0, 1, -1, 0);
		}
		if (Screen.orientation == ScreenOrientation.PortraitUpsideDown) {
			UV_Transform = Vector4(-1, 0, 0, -1);
		}	
		#endif


		effectOverlayMat.SetVector("_UV_Transform", UV_Transform);
		effectOverlayMat.SetFloat ("_Intensity", intensity);
		effectOverlayMat.SetTexture ("_Overlay", paperTexture);
		Graphics.Blit(rt1, d, effectOverlayMat, (int)textureBlendMode);

		RenderTexture.ReleaseTemporary(rt1);
	}
}