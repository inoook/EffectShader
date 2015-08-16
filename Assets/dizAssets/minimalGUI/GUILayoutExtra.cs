using UnityEngine;
using System;
using System.Collections;

public class GUILayoutExtra {
	
	public static float labelWidth = 150;
	
	public static void sliderWithValue(ref float p, string name, float min, float max){
		GUILayout.BeginHorizontal();
		GUILayout.Label(name +": "+ p.ToString("0.000"), GUILayout.Width(labelWidth));
		p = GUILayout.HorizontalSlider(p, min, max);
		GUILayout.EndHorizontal();
	}
	public static void sliderWithValue(ref int p, string name, int min, int max){
		GUILayout.BeginHorizontal();
		GUILayout.Label(name +": "+ p.ToString("0.000"), GUILayout.Width(labelWidth));
		p = (int)GUILayout.HorizontalSlider(p, min, max);
		GUILayout.EndHorizontal();
	}
	
	public static float slider(float p, string name, float min, float max){
		GUILayout.BeginHorizontal();
		GUILayout.Label(name +": "+ p.ToString("0.000"), GUILayout.Width(labelWidth));
		p = GUILayout.HorizontalSlider(p, min, max);
		GUILayout.EndHorizontal();
		
		return p;
	}
	
	public static int slider(int p, string name, int min, int max){
		GUILayout.BeginHorizontal();
		GUILayout.Label(name +": "+ p.ToString("0"), GUILayout.Width(labelWidth));
		p = (int)GUILayout.HorizontalSlider((float)p, (float)min, (float)max);
		GUILayout.EndHorizontal();
		
		return p;
	}
	
	public static float sliderAndEditableValue(float p, string name, float min, float max){
		return sliderAndEditableValue(p, name, min, max, "0.00");
	}
	public static float sliderAndEditableValue(float p, string name, float min, float max, string format){
		GUILayout.BeginHorizontal();
		GUILayout.Label(name +": ", GUILayout.Width(labelWidth-50));
		string pStr = GUILayout.TextField(p.ToString(format), GUILayout.Width(50));
		p = float.Parse(pStr);
		p = Mathf.Clamp(p, min, max);
		p = GUILayout.HorizontalSlider(p, min, max);
		GUILayout.EndHorizontal();
		
		return p;
	}
	
	public static void sliderWithValueReadOnly(float p, string name, float min, float max){
		GUILayout.BeginHorizontal();
		GUILayout.Label(name +": "+ p.ToString("0.00"), GUILayout.Width(labelWidth));
		GUILayout.HorizontalSlider(p, min, max);
		GUILayout.EndHorizontal();
	}
	
	public static void valueWithLabelReadOnly(float p, string name){
		GUILayout.BeginHorizontal();
		GUILayout.Label(name +": "+ p.ToString("0.00"), GUILayout.Width(labelWidth));
		GUILayout.EndHorizontal();
	}
	
	
	public static void inputWithValue(ref int p, string name){
		GUILayout.BeginHorizontal();
		GUILayout.Label(name +": "+ p.ToString(), GUILayout.Width(labelWidth));
		try{
			p = int.Parse( GUILayout.TextField(p.ToString(), GUILayout.Width(labelWidth)) );
		}catch(System.Exception ex){
			p = 0;
		}
		GUILayout.EndHorizontal();
	}
	public static void inputWithValue(ref float p, string name){
		GUILayout.BeginHorizontal();
		GUILayout.Label(name +": "+ p.ToString("0.00"), GUILayout.Width(labelWidth));
		try{
			p = float.Parse( GUILayout.TextField(p.ToString("0.00"), GUILayout.Width(labelWidth)) );
		}catch(System.Exception ex){
			p = 0;
		}
		GUILayout.EndHorizontal();
	}
	
	//
	public static float inputValue(float p, string name){
		GUILayout.BeginHorizontal();
		GUILayout.Label(name, GUILayout.Width(labelWidth));
		try{
			p = float.Parse( GUILayout.TextField(p.ToString("0.00")) );
		}catch(System.Exception ex){
			p = 0;
		}
		GUILayout.EndHorizontal();
		
		return p;
	}
	public static int inputValue(int p, string name){
		GUILayout.BeginHorizontal();
		GUILayout.Label(name, GUILayout.Width(labelWidth));
		try{
			p = int.Parse( GUILayout.TextField(p.ToString("0")) );
		}catch(System.Exception ex){
			p = 0;
		}
		GUILayout.EndHorizontal();
		
		return p;
	}
	
	//
	public static void toggleWithValue(ref bool p, string name){
		GUILayout.BeginHorizontal();
		GUILayout.Label(name +": ", GUILayout.Width(labelWidth));
		p = GUILayout.Toggle(p, "");
		GUILayout.EndHorizontal();
	}
	public static void toggleWithValueReadOnly(bool p, string name){
		GUILayout.BeginHorizontal();
		GUILayout.Label(name +": ", GUILayout.Width(labelWidth));
		GUILayout.Toggle(p, "");
		GUILayout.EndHorizontal();
	}
	
	public static bool toggle(bool p, string name){
		GUILayout.BeginHorizontal();
		GUILayout.Label(name +": ", GUILayout.Width(labelWidth));
		bool v = GUILayout.Toggle(p, "");
		GUILayout.EndHorizontal();
		
		return v;
	}
	
	//
	
	public static object SelectionEnum(object v, string name, System.Type enumType)
	{
		int modeId = (int)v;
		string[] texts = Enum.GetNames( enumType );
		
		GUILayout.Label(name+" ("+enumType.ToString() +")" );
		modeId = GUILayout.SelectionGrid(modeId, texts, 2);
		GUILayout.Space(10);
		return ( ( Enum.GetValues( enumType ) ).GetValue(modeId) );
	}
	
	
	public static Texture2D whiteTexture;
	
	public static Texture2D getWhiteTexture()
	{
		if(whiteTexture == null){
			whiteTexture = new Texture2D(10,10);
			Color32[] colors = new Color32[10*10];
			for(int i = 0; i < colors.Length; i++){
				colors[i] = new Color32(255,255,255,255);
			}
			whiteTexture.SetPixels32(colors);
			whiteTexture.Apply();
		}
		return whiteTexture;
	}
	
}
