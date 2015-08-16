using UnityEngine;
using System.Collections;
#if UNITY_EDITOR
using UnityEditor;
#endif

public class EffectTemplate : EffectBase {

	public float _amount = 0.005f;
	public float _angle = 0.0f;

	protected override void InitShader()
	{
		shaderName = "Custom/RGBShift";
		base.InitShader();
	}

	public float amount
	{
		set{
			_amount = value;
			material.SetFloat("amount", _amount);
		}
		get{
			return _amount;
		}
	}
	public float angle
	{
		set{
			_angle = value;
			material.SetFloat("angle", _angle);
		}
		get{
			return _angle;
		}
	}
}

#if UNITY_EDITOR
[CustomEditor(typeof(EffectTemplate))]
class EffectTemplateEditor : Editor {

	override public void OnInspectorGUI () {
		EffectTemplate _target = (EffectTemplate)target;
		_target.amount = EditorGUILayout.FloatField("amount", _target.amount);
		_target.angle = EditorGUILayout.FloatField("angle", _target.angle);
	}
}
#endif
