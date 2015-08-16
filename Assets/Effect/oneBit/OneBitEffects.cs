using UnityEngine;
using System.Collections;

public class OneBitEffects : MonoBehaviour {

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
	
	public OneBitEffects.OverlayBlendMode blendMode = OneBitEffects.OverlayBlendMode.Overlay;
	public float intensity = 1.0f;

	public Color color = Color.white;
	
	void OnRenderImage(RenderTexture s, RenderTexture d){

		// Brightness Contrast Saturation
		RenderTexture rt_src = RenderTexture.GetTemporary(s.width, s.height);
		Graphics.Blit(s, rt_src, effectBCSMat, 0);
		
		// 1bit effect
		effectMat.SetColor("_Color", color);

		RenderTexture rt1 = RenderTexture.GetTemporary(s.width, s.height);
		Graphics.Blit(rt_src, rt1, effectMat, 0); // dot draw
		RenderTexture rt2 = RenderTexture.GetTemporary(s.width, s.height);
		Graphics.Blit(rt_src, rt2, effectMat, 1); // outline
		
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
		effectOverlayMat.SetTexture ("_Overlay", rt2);
		Graphics.Blit(rt1, d, effectOverlayMat, (int)blendMode);


		RenderTexture.ReleaseTemporary(rt1);
		RenderTexture.ReleaseTemporary(rt2);
	}
}