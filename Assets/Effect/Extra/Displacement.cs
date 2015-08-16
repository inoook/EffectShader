using UnityEngine;
using System.Collections;
#if UNITY_EDITOR
using UnityEditor;
#endif

public class Displacement : EffectBase {
	
	public float vx = 0.1f;
	public float vy = 0.1f;
	public float scale = 0.1f;
	public Texture displaceTexture;


	protected override void InitShader()
	{
		shaderName = "Custom/Displacement";
		base.InitShader();
	}

	protected override void UpdateParams()
	{
		material.SetFloat("vx", vx);
		material.SetFloat("vy", vy);
		material.SetFloat("scale", scale);
		material.SetTexture("_DispTex", displaceTexture);
	}
//
//	public Texture displaceTexture
//	{
//		set{
//			_displaceTexture = value;
//			material.SetTexture("_DispTex", _displaceTexture);
//		}
//		get{
//			return _displaceTexture;
//		}
//	}

}

//#if UNITY_EDITOR
//[CustomEditor(typeof(Displacement))]
//class DisplacementEditor : Editor {
//
//	override public void OnInspectorGUI () {
//		Displacement _target = (Displacement)target;
//		_target.displaceTexture = (Texture)EditorGUILayout.ObjectField("displaceTexture", _target.displaceTexture, typeof(Texture), false);
//	}
//}
//#endif
