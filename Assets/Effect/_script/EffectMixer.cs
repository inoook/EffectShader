using UnityEngine;
using System.Collections;

public class EffectMixer : MonoBehaviour {

	public Displacement displacement;
	public Shaker shaker;
	public Glow glow;
	public DotScreen dotScreen;
	public Slitscan slitscan;
	public DotMatrix dotMatrix;
	public Twist twist;
	public Film film;
	public RGBShift rgbShift;
	public Kaleidoscope kaleidoscope;
	public ColorControl colorControl;
	public OutlineMod outlineMod;

	private MonoBehaviour[] effects;
	// Use this for initialization
	void Start () {
		effects = new MonoBehaviour[]{
			displacement, shaker, glow, dotScreen, slitscan, dotMatrix, twist, film, rgbShift, kaleidoscope, colorControl, outlineMod
		};
	}

	public bool isAnime = false;
	public GUISkin skin;

	private float t = 0.0f;
	private float t2 = 0.0f;
	private float limitTime = 0.5f;

	// Update is called once per frame
	void Update () {
		if(!isAnime){ return; }

		Vector3 mousePos = Input.mousePosition;
		float mouseX = (mousePos.x / Screen.width) - 0.5f;
		float mouseY = (mousePos.y / Screen.height) - 0.5f; 

		t += Time.deltaTime;
		if( t / 3.0f > 1.0f){
			RandomEffect();
			t = 0.0f;
		}

//		int step = Random.Range(1, 50);
//		if( Time.frameCount % step == 0){
//			RandomParams();
//		}

		t2 += Time.deltaTime;
		if( t2 / limitTime > 1.0f){
			RandomParams();
			t2 = 0.0f;
			limitTime = Random.Range(0.20f, 0.55f);
		}
		
		if(colorControl.enabled){
			colorControl.riseR = mouseX;
			colorControl.riseG = mouseY;
		}
	}

	void RandomParams()
	{
		if(displacement.enabled){
			displacement.vx = Random.Range(-0.2f, 0.2f);
			displacement.vy = Random.Range(-0.2f, 0.2f);
			displacement.scale = Random.value * 2;
		}
		if(shaker.enabled){
			shaker.blur_vec_x = Random.Range(-0.5f, 0.5f);
			shaker.blur_vec_y = Random.Range(-0.5f, 0.5f);
		}
		
		if(dotScreen.enabled){
			dotScreen.scale = Random.value * 3.0f;
		}
		if(dotMatrix.enabled){
			dotMatrix.spacing = Random.Range(1, 20);
			dotMatrix.size = Random.Range(1, 50);
			dotMatrix.blur = Random.Range(1, 20);
		}
		if(twist.enabled){
			twist.timer = Random.Range(0.0f, 1.0f);
			twist.val2 = Random.Range(0.1f, 1.0f);
			twist.val3 = Random.Range(0.0f, 0.1f);
		}
		if(rgbShift.enabled){
			rgbShift.amount = Random.Range(0.0f, 0.02f);
			rgbShift.angle = Random.Range(0.0f, Mathf.PI*2);
		}
	}

	void RandomEffect()
	{
		for(int i = 0; i < effects.Length; i++){
			effects[i].enabled = (Random.value > 0.5f);
		}

		RandomParams();
		
		if(colorControl.enabled){
			float range = 0.35f;
			colorControl.riseR = Random.Range(-range, range);
			colorControl.riseG = Random.Range(-range, range);
			colorControl.riseB = Random.Range(-range, range);
		}
	}

	void ClearEffect()
	{
		isAnime = false;
		for(int i = 0; i < effects.Length; i++){
			effects[i].enabled = false;
		}
	}

	Rect windowRect = new Rect(20,20,280, 400);
	void OnGUI()
	{
		GUI.skin = skin;

		windowRect = GUILayout.Window(0, windowRect, DoMyWindow, "Effect");

	}

	void DoMyWindow(int windowId){
		
//		GUILayout.BeginArea(new Rect(20,20,300,Screen.height - 40));
//		GUILayout.BeginVertical("Box");

//		if( GUILayout.Button("anime: "+isAnime.ToString()) ){
//			isAnime = !isAnime;
//			if(isAnime){
//				RandomEffect();
//			}
//		}
		if( GUILayout.Button("RandomEffect") ){
			RandomEffect();
		}
		if( GUILayout.Button("Clear") ){
			ClearEffect();
		}
		GUIControls.HR();
		
		displacement.enabled = GUILayout.Toggle(displacement.enabled, "displacementMap");
		if(displacement.enabled){
			DrawSlider(ref displacement.vx, "vx", -0.2f, 0.2f);
			DrawSlider(ref displacement.vy, "vy", -0.2f, 0.2f);
			DrawSlider(ref displacement.scale, "scale", 0.0f, 2.0f);
		}
		
		shaker.enabled = GUILayout.Toggle(shaker.enabled, "shaker");
		if(shaker.enabled){
			DrawSlider(ref shaker.blur_vec_x, "vx", -0.5f, 0.5f);
			DrawSlider(ref shaker.blur_vec_y, "vy", -0.5f, 0.5f);
		}
		
		glow.enabled = GUILayout.Toggle(glow.enabled, "glow");
		
		dotScreen.enabled = GUILayout.Toggle(dotScreen.enabled, "dotScreen");
		if(dotScreen.enabled){
			DrawSlider(ref dotScreen.scale, "scale", 0.5f, 4.0f);
		}
		
		slitscan.enabled = GUILayout.Toggle(slitscan.enabled, "slitscan");
		if(slitscan.enabled){
			DrawSlider(ref slitscan.val3, "val", 0.01f, 0.1f);
		}
		
		dotMatrix.enabled = GUILayout.Toggle(dotMatrix.enabled, "dotMatrix");
		if(dotMatrix.enabled){
			DrawSlider(ref dotMatrix.spacing, "spacing", 1, 20);
			DrawSlider(ref dotMatrix.size, "size", 1, 50);
			DrawSlider(ref dotMatrix.blur, "blur", 1, 20);
		}
		
		twist.enabled = GUILayout.Toggle(twist.enabled, "twist");
		if(twist.enabled){
			DrawSlider(ref twist.timer, "timer", 0, 1);
			DrawSlider(ref twist.val2, "val2", 0.1f, 1);
			DrawSlider(ref twist.val3, "val3", 0.0f, 0.1f);
		}
		
		film.enabled = GUILayout.Toggle(film.enabled, "film");
		if(film.enabled){
			DrawSlider(ref film.nIntensity, "nIntensity", 0, 1);
			DrawSlider(ref film.sIntensity, "sIntensity", 0, 1);
		}
		
		rgbShift.enabled = GUILayout.Toggle(rgbShift.enabled, "rgbShift");
		if(rgbShift.enabled){
			DrawSlider(ref rgbShift.amount, "amount", 0, 0.02f);
			DrawSlider(ref rgbShift.angle, "angle", 0, Mathf.PI*2);
		}
		
		kaleidoscope.enabled = GUILayout.Toggle(kaleidoscope.enabled, "kaleidoscope");
		if(kaleidoscope.enabled){
			DrawSliderInt(ref kaleidoscope.sides, "num", 3, 12);
			DrawSlider(ref kaleidoscope.angle, "angle", 0, 360);
		}
		
		colorControl.enabled = GUILayout.Toggle(colorControl.enabled, "colorControl");
		if(colorControl.enabled){
			DrawSlider(ref colorControl.riseR, "r", -0.5f, 0.5f);
			DrawSlider(ref colorControl.riseG, "g", -0.5f, 0.5f);
			DrawSlider(ref colorControl.riseB, "b", -0.5f, 0.5f);
		}

		outlineMod.enabled = GUILayout.Toggle(outlineMod.enabled, "outlineMod");

//		GUILayout.EndVertical();
//		GUILayout.EndArea();

		GUI.DragWindow();
	}


	void DrawSlider(ref float param, string name, float min=0.0f, float max=1.0f)
	{
		GUILayout.BeginHorizontal();
		GUILayout.Label("\t"+name + ": "+param.ToString("0.00"), GUILayout.Width(120));
		param = GUILayout.HorizontalSlider(param, min, max);
		GUILayout.EndHorizontal();
	}
	void DrawSliderInt(ref float param, string name, int min=0, int max=1)
	{
		GUILayout.BeginHorizontal();
		GUILayout.Label("\t"+name + ": "+param.ToString("0"), GUILayout.Width(120));
		param = (int)GUILayout.HorizontalSlider(param, min, max);
		GUILayout.EndHorizontal();
	}
}
