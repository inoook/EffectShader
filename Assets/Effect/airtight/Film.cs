using UnityEngine;
using System.Collections;

public class Film : EffectBase {

	public float time = 0.0f;
	public float nIntensity = 0.5f;
	public float sIntensity = 0.5f;
	public float sCount = 1024;
	public float grayscale = 0;

	protected override void InitShader()
	{
		shaderName = "Custom/Film";
		base.InitShader();
	}

	protected override void UpdateParams()
	{
		material.SetFloat ("time", time);
		material.SetFloat ("nIntensity", nIntensity);
		material.SetFloat ("sIntensity", sIntensity);
		material.SetFloat ("sCount", sCount);
		material.SetFloat ("grayscale", grayscale);
	}
}

