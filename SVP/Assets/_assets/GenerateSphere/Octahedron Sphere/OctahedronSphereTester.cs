	using UnityEngine;

	[RequireComponent(typeof(MeshFilter))]
	public class OctahedronSphereTester : MonoBehaviour {

        [SerializeField]
		private int _subdivisions = 4;
        [SerializeField]
        private float _radius = -1;
		
		private void Awake () {
            GetComponent<MeshFilter>().mesh = OctahedronSphereCreator.Create(_subdivisions, _radius);
		}

        public void Generate()
        {
            var radius = _radius < 0 ? Main.RADIUS_SPHERE : _radius;
            GetComponent<MeshFilter>().sharedMesh = OctahedronSphereCreator.Create(_subdivisions, radius);
        }

        public void ToSphere()
        {
            Mesh mesh = GetComponent<MeshFilter>().sharedMesh;
            Vector3[] vertices = mesh.vertices;
            var radius = _radius < 0 ? Main.RADIUS_SPHERE : _radius;

            for (var i = 0; i < vertices.Length; i++)
            {

                vertices[i] = vertices[i].normalized * radius;

            }

            mesh.vertices = vertices;
            mesh.RecalculateNormals();
            mesh.RecalculateBounds();
        }
	}