using UnityEngine;
using System.Collections;

public class Twist : EffectBase {

	public float rand = 1;
	public float timer = 1;
	public float val2 = 0.1f;
	public float val3 = 0.1f;
	
	protected override void InitShader()
	{
		shaderName = "Custom/Twist";
		base.InitShader();
	}
	
	protected override void UpdateParams()
	{
		material.SetFloat ("rand", rand);
		material.SetFloat ("timer", timer);
		material.SetFloat ("val2", val2);
		material.SetFloat ("val3", val3);
	}
	
}

