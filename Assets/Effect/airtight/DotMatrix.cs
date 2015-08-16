using UnityEngine;
using System.Collections;

public class DotMatrix : EffectBase {

	public float spacing = 10.0f;
	public float size = 4.0f;
	public float blur = 4.0f;
	
	protected override void InitShader()
	{
		shaderName = "Custom/DotMatrix";
		base.InitShader();
	}
	
	protected override void UpdateParams()
	{
		material.SetFloat ("spacing", spacing);
		material.SetFloat ("size", size);
		material.SetFloat ("blur", blur);
	}
	
}

