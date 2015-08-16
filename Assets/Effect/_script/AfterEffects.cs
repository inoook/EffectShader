using UnityEngine;
using System.Collections;

public class AfterEffects : MonoBehaviour {
	public Material[] effectMats;
	
	void OnRenderImage(RenderTexture s, RenderTexture d){
		RenderTexture rt = RenderTexture.GetTemporary(s.width, s.height);
		Graphics.Blit(s, rt);
		
		foreach(Material effect in effectMats){
			for(int i = 0; i < effect.passCount; i++){
				RenderTexture rt2 = RenderTexture.GetTemporary(rt.width, rt.height);
				Graphics.Blit(rt, rt2, effect, i);
				RenderTexture.ReleaseTemporary(rt);
				rt = rt2;
			}
		}
		Graphics.Blit(rt, d);
		RenderTexture.ReleaseTemporary(rt);
	}
}