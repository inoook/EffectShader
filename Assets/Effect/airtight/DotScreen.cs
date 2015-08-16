using UnityEngine;
using System.Collections;

public class DotScreen : EffectBase {

	public Vector2 tSize = new Vector2( 256, 256);
	public Vector2 center = new Vector2( 0.5f, 0.5f);
	public float angle = 1.57f;
	public float scale = 1.0f;

	protected override void InitShader()
	{
		shaderName = "Custom/DotScreen";
		base.InitShader();
	}

	protected override void UpdateParams()
	{
		material.SetVector("tSize", tSize);
		material.SetVector("center", center);
		material.SetFloat ("angle", angle);
		material.SetFloat ("scale", scale);
	}

}

