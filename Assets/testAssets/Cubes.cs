using UnityEngine;
using System.Collections;

public class Cubes : MonoBehaviour {

	public int num = 100;

	public Mesh mesh;

	public Material mat;
	private Material[] mats;

	public float rotateSpeed = 8.0f;

	public bool isAnim = true;

	// Use this for initialization
	void Start () {
		mats = new Material[3];
		for(int i = 0; i < mats.Length; i++){
			mats[i] = new Material(mat);
		}
		mats[0].color = new Color32(50, 255, 100, 255);
		mats[1].color = new Color32(255, 50, 100, 255);
		mats[2].color = new Color32(255, 255, 255, 255);
	}

	// Update is called once per frame
	void Update () {

		if(isAnim){
		this.transform.Rotate(Vector3.one * Time.deltaTime * rotateSpeed);
		}

		for(int i = 0; i < num; i++){
			Matrix4x4 mtx = new Matrix4x4();
			float x = (Mathf.PerlinNoise((float)i/2.4f, 0.0f) - 0.5f) * 30;
			float y = (Mathf.PerlinNoise((float)i/5.6f, 0.25f) - 0.5f) * 30;
			float z = (Mathf.PerlinNoise((float)i/8.2f, 0.5f) - 0.5f) * 30;
			Vector3 size = Vector3.one * (Mathf.PerlinNoise((float)i/3.4f, 0.5f) + 0.01f);
			Vector3 pos = this.transform.rotation * new Vector3(x, y, z);
			Quaternion rot = Quaternion.AngleAxis((Mathf.PerlinNoise((float)i/num, 0.0f) - 0.5f) * 360, new Vector3(0.5f, 0.5f, 0.5f));
			mtx.SetTRS(pos, rot, size);

			Material _mat;
			if(i % 5 == 0){
				_mat = mats[0];
			}else if(i % 9 == 0){
				_mat = mats[1];
			}else{
				_mat = mats[2];
			}
			Graphics.DrawMesh(mesh, mtx, _mat, 0);
		}

	}
}
