using UnityEngine;
using System.Collections;

public class EffectBase : MonoBehaviour {
	
	protected string shaderName;
	public Shader shader;
	private Material m_Material;
	
//	protected virtual void Start ()
//	{
//		// Disable if we don't support image effects
//		if (!SystemInfo.supportsImageEffects) {
//			enabled = false;
//			return;
//		}
//	}
//
//	protected virtual void InitShader()
//	{
//		shader = Shader.Find(shaderName);
//	}
//	
//	public Material material {
//		get {
//			if(shader == null){
//
//				InitShader();
//				
//				// Disable the image effect if the shader can't
//				// run on the users graphics card
//				if (!shader || !shader.isSupported)
//					enabled = false;
//			}
//			if (m_Material == null) {
//				m_Material = new Material (shader);
//				m_Material.hideFlags = HideFlags.HideAndDontSave;
//			}
//			return m_Material;
//		} 
//	}
//	
//	protected virtual void OnDisable() {
//		if( m_Material ) {
//			DestroyImmediate( m_Material );
//		}
//	}


	protected virtual void InitShader()
	{
		if(shader == null){
			shader = Shader.Find(shaderName);
		}
	}

	void Awake ()
	{
		// Disable if we don't support image effects
		if (!SystemInfo.supportsImageEffects) {
			enabled = false;
			return;
		}
		InitShader();

		// Disable the image effect if the shader can't
		// run on the users graphics card
		if (!shader || !shader.isSupported)
			enabled = false;
	}
	
	public Material material {
		get {
			InitShader();

			if (m_Material == null) {
				m_Material = new Material (shader);
				m_Material.hideFlags = HideFlags.HideAndDontSave;
			}
			return m_Material;
		} 
	}
	
	protected virtual void OnDisable() {
		if( m_Material ) {
			DestroyImmediate( m_Material );
		}
	}
	
	protected virtual void UpdateParams()
	{

	}

	void OnRenderImage(RenderTexture source, RenderTexture destination){
		if(material == null){
			return;
		}

		UpdateParams();
		RenderTexture rt = RenderTexture.GetTemporary(source.width, source.height);
		Graphics.Blit(source, rt);

		Material effect = this.material;
		for(int i = 0; i < effect.passCount; i++){
			RenderTexture rt2 = RenderTexture.GetTemporary(rt.width, rt.height);
			Graphics.Blit(rt, rt2, effect, i);
			RenderTexture.ReleaseTemporary(rt);
			rt = rt2;
		}

		Graphics.Blit(rt, destination);
		RenderTexture.ReleaseTemporary(rt);

		//Graphics.Blit (source, destination, material);
	}
}
