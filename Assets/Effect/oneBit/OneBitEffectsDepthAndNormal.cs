using UnityEngine;
using System.Collections;

public class OneBitEffectsDepthAndNormal : MonoBehaviour {

	public enum OverlayBlendMode {
		Additive = 0,
		ScreenBlend = 1,
		Multiply = 2,
		Overlay = 3,
		AlphaBlend = 4,	
	}

	public Material effectBCSMat;//Brightness Contrast Saturation
	public Material effectMat;
	public Material effectEdgeOutlineMat;
	public Material effectOverlayMat;

	public float saturation = 1.0f;
	public float brightness = 1.0f;
	public float contrast = 2.0f;

	public float sensitivityDepth = 1.0f;
	public float sensitivityNormals = 1.0f;
	public float sampleDist = 1.0f;
	
	public OneBitEffectsDepthAndNormal.OverlayBlendMode blendMode = OneBitEffectsDepthAndNormal.OverlayBlendMode.Overlay;
	public float intensity = 1.0f;
	

	public Color color = Color.white;

	void Start()
	{
		GetComponent<Camera>().depthTextureMode = DepthTextureMode.DepthNormals;			
	}

	public bool enableOneBitEffect = true;
	public bool enableOutlineEffect = true;

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

		// 1bit effect
		//  - dot draw
		RenderTexture rt1 = RenderTexture.GetTemporary(s.width, s.height);
		effectMat.SetColor("_Color", color);
		Graphics.Blit(rt_src, rt1, effectMat, 0); 

		if(!enableOutlineEffect){
			Graphics.Blit(rt1, d);
			RenderTexture.ReleaseTemporary(rt1);
			return;
		}
		
		// -outline
		RenderTexture rt2 = RenderTexture.GetTemporary(s.width, s.height);
		Vector2 sensitivity = new Vector2 (sensitivityDepth, sensitivityNormals);
		effectEdgeOutlineMat.SetColor("_Color", color);
		effectEdgeOutlineMat.SetVector ("_Sensitivity", new Vector4 (sensitivity.x, sensitivity.y, 1.0f, sensitivity.y));	
		effectEdgeOutlineMat.SetFloat ("_SampleDistance", sampleDist);
		Graphics.Blit(rt_src, rt2, effectEdgeOutlineMat); 
		
		RenderTexture.ReleaseTemporary(rt_src);

		//Graphics.Blit(rt2, d);

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
		effectOverlayMat.SetTexture ("_Overlay", rt2);
		Graphics.Blit(rt1, d, effectOverlayMat, (int)blendMode);
		
		RenderTexture.ReleaseTemporary(rt1);
		RenderTexture.ReleaseTemporary(rt2);
	}
}