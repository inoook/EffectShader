using UnityEngine;
using System.Collections;

public class Outline : EffectBase {

	
	protected override void InitShader()
	{
		shaderName = "Custom/Outline";
		base.InitShader();
	}
	
	protected override void UpdateParams()
	{

	}
	
}

