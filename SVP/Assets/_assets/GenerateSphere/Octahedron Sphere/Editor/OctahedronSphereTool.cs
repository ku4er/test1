using UnityEditor;
using UnityEngine;

[CustomEditor(typeof(OctahedronSphereTester))]
public class OctahedronSphereTool : Editor 
{
    OctahedronSphereTester _this;

    public void OnEnable()
    {
        _this = (OctahedronSphereTester)target;
    }

    public override void OnInspectorGUI()
    {
        if (GUILayout.Button("Generate"))
        {
            _this.Generate();
        }
        if (GUILayout.Button("ToSphere"))
        {
            _this.ToSphere();
        }
        DrawDefaultInspector();
    }
}
