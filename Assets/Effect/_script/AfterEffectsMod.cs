using UnityEngine;
using System.Collections;
#if UNITY_EDITOR
using UnityEditor;
#endif

public class AfterEffectsMod : MonoBehaviour {
	public EffectBase[] effects;
	
	void OnRenderImage(RenderTexture source, RenderTexture destination){
		RenderTexture rt = RenderTexture.GetTemporary(source.width, source.height);
		Graphics.Blit(source, rt);
		
		foreach(EffectBase effectBase in effects){
			Material effect = effectBase.material;
			for(int i = 0; i < effect.passCount; i++){
				RenderTexture rt2 = RenderTexture.GetTemporary(rt.width, rt.height);
				Graphics.Blit(rt, rt2, effect, i);
				RenderTexture.ReleaseTemporary(rt);
				rt = rt2;
			}
		}
		Graphics.Blit(rt, destination);
		RenderTexture.ReleaseTemporary(rt);
	}
}

#if UNITY_EDITOR
[CustomEditor(typeof(AfterEffectsMod))]
class AfterEffectsModEditor : Editor {
	
	override public void OnInspectorGUI () {
		AfterEffectsMod _target = (AfterEffectsMod)target;

		DrawDefaultInspector();

		for(int i = 0; i < _target.effects.Length; i++){
			GUILayout.Label(_target.effects[i].GetType().Name +", ");
		}

	}
}
#endif