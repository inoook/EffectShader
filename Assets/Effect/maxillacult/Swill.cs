using UnityEngine;
using System.Collections;

public class Swill : EffectBase {

	public float rand = 0;
	public float timer = 0;
	public float frequency = 1;
	
	protected override void InitShader()
	{
		shaderName = "Custom/Swill";
		base.InitShader();
	}
	
	protected override void UpdateParams()
	{
		material.SetFloat ("rand", rand);
		material.SetFloat ("timer", timer);
		material.SetFloat ("frequency", frequency);
	}
	
}

