using UnityEngine;
using System.Collections;

public class Postprocess : MonoBehaviour 
{
	public Material PostprocessMaterial;
	public Material SimpleRender;

	public RenderTexture CameraRenderTexture;
	public RenderTexture Buffer;

	public void Start()
	{
		CameraRenderTexture = new RenderTexture (Screen.width, Screen.height, 24);
		Buffer = new RenderTexture (Screen.width, Screen.height, 24);

		Camera.main.targetTexture = CameraRenderTexture;
	}

	void OnPostRender()
	{
		Graphics.SetRenderTarget(Buffer);
		GL.Clear (true, true, Color.black);

		Graphics.SetRenderTarget (Buffer.colorBuffer, CameraRenderTexture.depthBuffer);
		Graphics.Blit(CameraRenderTexture, SimpleRender);
		Graphics.Blit(CameraRenderTexture, PostprocessMaterial);
		
		RenderTexture.active = null;
		Graphics.Blit(Buffer, SimpleRender);
	}
}
