using UnityEngine;
using System.Collections;

public class Glow : EffectBase {
	
	protected override void InitShader()
	{
		shaderName = "Custom/Glow";
		base.InitShader();
	}
}

