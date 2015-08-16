using UnityEngine;
using System.Collections;

public class Shaker : EffectBase {

	public float blur_vec_x = 0.2f;
	public float blur_vec_y = 0.2f;
	
	protected override void InitShader()
	{
		shaderName = "Custom/Shaker";
		base.InitShader();
	}
	
	protected override void UpdateParams()
	{
		material.SetFloat("blur_vec_x", blur_vec_x);
		material.SetFloat("blur_vec_y", blur_vec_y);
	}
	
}
