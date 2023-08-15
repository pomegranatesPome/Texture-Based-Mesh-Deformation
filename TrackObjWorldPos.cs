using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Renderer))] // Makes sure this gameobject has a renderer. 
[ExecuteInEditMode]
public class TrackObjWorldPos : MonoBehaviour
{

    Renderer fabricRenderer;
    public Transform sphereTransform; // Assign the Sphere's Transform here in the inspector.
   
    void Start()
    {
        fabricRenderer = GetComponent<Renderer>();
    }

    void Update()
    {
        Vector3 objWorldPos = sphereTransform.position;
        // access this material and sets its property[_WorldPos], as specified in the shader
        Shader.SetGlobalVector("_ObjWorldPos", objWorldPos);
        fabricRenderer.sharedMaterial.SetVector("_ObjWorldPos", objWorldPos); // Avoid .material to avoid creating a lot of instanced materials 

    }
}
