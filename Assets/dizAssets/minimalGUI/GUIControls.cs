using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class GUIControls : MonoBehaviour {
	
	public static Color RGBSlider ( Color c ,  string label  ){
		GUI.color=c;
		GUILayout.Label (label);
		GUI.color=Color.red;
		c.r = GUILayout.HorizontalSlider (c.r,0,1);
		GUI.color=Color.green;
		c.g = GUILayout.HorizontalSlider (c.g,0,1);
		GUI.color=Color.blue;
		c.b = GUILayout.HorizontalSlider (c.b,0,1);
		GUI.color=Color.white;
		return c;
	}
	
	public static Color RGBCircle ( Color c ,  string label, float w_, float h_){
		Rect r = new Rect();
		//if(Event.current.type == EventType.Repaint){
		Rect rect = GUILayoutUtility.GetLastRect();
		r = new Rect(rect.x,rect.y+rect.height+2, w_, h_);
		//}
		
		Rect r2 = new Rect(r.x + r.width +5, r.y, 10, r.height);
		HSBColor hsb = new HSBColor (c);//It is much easier to work with HSB colours in this case
		
		Vector2 cp = new Vector2 (r.x + r.width/2, r.y + r.height/2);
		
		if (Input.GetMouseButton (0) && r.x > 0) {// r.x > 0  inok hack 
			
			Vector2 InputVector = Vector2.zero;
			InputVector.x = cp.x - Event.current.mousePosition.x;
			InputVector.y = cp.y - Event.current.mousePosition.y;
			
			float hyp = Mathf.Sqrt( (InputVector.x * InputVector.x) + (InputVector.y * InputVector.y) );
			if (hyp <= r.width/2 + 5) {
				hyp = Mathf.Clamp (hyp,0,r.width/2);
				float a = Vector3.Angle(new Vector3(-1,0,0), InputVector);
				
				if (InputVector.y<0) {
					a = 360 - a;
				}
				
				hsb.h = a / 360;
				hsb.s = hyp / (r.width/2);
			}
		}
		
		HSBColor hsb2 = new HSBColor (c);
		hsb2.b = 1;
		Color c2 = hsb2.ToColor ();
		
		//hsb.b = GUI.VerticalSlider (r2,hsb.b,1.0f,0.0f,"BWSlider","verticalsliderthumb");
		hsb.b = GUI.VerticalSlider (r2, hsb.b,1.0f,0.0f);
		
		GUI.color = c2;
		
		Color guiColor = Color.white * hsb.b;
		guiColor.a = 1.0f;
		GUI.color = guiColor;
		
		GUILayout.Box("", GUIStyle.none, GUILayout.Width(r.width), GUILayout.Height(r.height));//dummySize
		//GUI.Box(r, colorCircle, GUIStyle.none);
		GUI.Box(r, "", "colorCircle");
		
		float w = r.width;
		
		Vector2 pos = (new Vector2 (Mathf.Cos (hsb.h*360*Mathf.Deg2Rad), -Mathf.Sin (hsb.h*360*Mathf.Deg2Rad))* w *hsb.s/2);
		
		GUI.color = c;
		GUI.Box(new Rect(pos.x-5+cp.x, pos.y-5+cp.y, 10, 10),"","ColorcirclePicker");
		//GUI.Box(new Rect(cp.x, cp.y, 10, 10),"","ColorcirclePicker");
		
		c = hsb.ToColor ();
		
		
		//GUILayout.Label(getWhiteTexture(), style, GUILayout.ExpandWidth(true));
		
		// color chip 
		GUIStyle style = new GUIStyle();
		style.stretchWidth = true;
		style.normal.background = GUILayoutExtra.getWhiteTexture();
		style.margin = new RectOffset(0,0,5,5);
		
		Rect r3 = r2;
		r3.x += r2.width + 10;
		//GUI.Label(r3, GUILayoutExtra.getWhiteTexture(), style);
		GUI.Label(r3, " ", "ColorChip");
		GUI.color = Color.white;
		return c;
	}
	/*
	public static Color RGBCircle ( Color c ,  string label ,  Texture2D colorCircle  ){
		Rect r = GUILayoutUtility.GetAspectRect (1);
		
		r.height = r.width -= 15;
		return RGBCircle(c, label, colorCircle, r);
	}
	*/
	
	
	/*
	GUIStyle style = new GUIStyle();
	style.stretchWidth = true;
	style.normal.background = GUILayoutExtra.getWhiteTexture();
	*/
	public static void ColorChip(Color color, string name){
		GUILayout.BeginHorizontal();
		GUILayout.Label(name, GUILayout.Width(GUILayoutExtra.labelWidth));
		GUI.color = color;
		
		GUIStyle style = GUI.skin.GetStyle("ColorChip");
		//GUILayout.Label("", "ColorChip");
		GUILayout.Label("", style);
		GUI.color = Color.white;
		GUILayout.EndHorizontal();
	}
	
	public static void HR(){
		GUIStyle style = GUI.skin.GetStyle("HR");
		GUILayout.Label("", style);
		GUI.color = Color.white;
	}
}
