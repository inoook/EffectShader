using UnityEngine;
using System.Collections;

public class DrawingEffectSimpleDebug : MonoBehaviour {

	public DrawingEffectSimple effect;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	public Color guiColor = Color.black;
	void OnGUI()
	{
		GUILayout.BeginArea(new Rect(10,10,300,600));
		GUILayout.BeginVertical("box", GUILayout.Width(200));
		GUILayout.Label("A: toggle Effect");
		GUILayout.Label("right mouseDrag: orbit");
		if(effect.enabled){
			GUILayout.Label("Base image");
			GUILayout.Label("brightness");
			effect.brightness = GUILayout.HorizontalSlider(effect.brightness, 0.5f, 2.0f);
			GUILayout.Label("contrast");
			effect.contrast = GUILayout.HorizontalSlider(effect.contrast, 0.5f, 2.0f);
			GUILayout.Space(15);

			GUILayout.Label("Line");
			if(GUILayout.Button("Enable Line / "+enableLine.ToString())){
				ToggleLine();
			}
			if(enableLine){
				GUILayout.Label("thickness");
				effect.sampleDist = GUILayout.HorizontalSlider(effect.sampleDist, 0.5f, 3.0f);
				GUILayout.Label("noise");
				effect.lineNoise = GUILayout.HorizontalSlider(effect.lineNoise, 0.0f, 1.0f);
			}
			GUILayout.Space(15);
			GUILayout.Label("Paint");
			if(GUILayout.Button("Enable paint / "+enablePaint.ToString())){
				TogglePaint();
			}
			if(enablePaint){
				GUILayout.Label("step");
				effect.colorStep = (int)GUILayout.HorizontalSlider(effect.colorStep, 1, 15);
				GUILayout.Label("noise");
				effect.textureNoise = GUILayout.HorizontalSlider(effect.textureNoise, 0.0f, 0.5f);
			}
		}
		GUILayout.BeginVertical();
		GUILayout.EndArea();
	}

	public bool enableLine = true;
	private float preLineDist;
	void ToggleLine()
	{
		enableLine = !enableLine;
		if(!enableLine){
			preLineDist = effect.sampleDist;
			effect.sampleDist = 0;
		}else{
			effect.sampleDist = preLineDist;
		}
	}

	public bool enablePaint = true;
	void TogglePaint()
	{
		enablePaint = !enablePaint;
		effect.textureV = enablePaint ? 1.0f : 0.0f;
	}

}
