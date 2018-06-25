using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.Text;

[CustomEditor(typeof(CubeSphere))]
public class CubeSphereTool : Editor
{
    CubeSphere _this;

    public void OnEnable()
    {
        _this = (CubeSphere) target;
    }

    public override void OnInspectorGUI()
	{
        if (GUILayout.Button("Generate"))
        {
            _this.Generate();
        }
        if (GUILayout.Button("SaveMesh"))
        {
            if (!string.IsNullOrEmpty(_this.MeshSaveName))
            {
                AssetDatabase.CreateAsset(_this.GetComponent<MeshFilter>().sharedMesh, "Assets/_Models/_Meshes/sphere_" + _this.MeshSaveName + ".asset");
            }
        }
        if (GUILayout.Button("GridGenerate"))
        {
            _this.GetComponent<Grid>().Generate();
        }
        if (GUILayout.Button("TestGenerate"))
        {
            _this.TestGenerate();
        }
        DrawDefaultInspector();
	}
}