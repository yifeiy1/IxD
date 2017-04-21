using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Networking;

public class DoorTrigger : MonoBehaviour {

	Animator anim;
  private int buttonValue;
  private string buttonValString;
  private string particleURI;
  private int buttonState = 0;
  private int buttonStateOld = 0;

	private GUIStyle guiStyle = new GUIStyle();

    IEnumerator GetButtonValue()
    {
        while (true)
        {
            // Assign your URI here
            particleURI = "https://api.particle.io/v1/devices/310020000b51353432383931/hololensBut?access_token=df43a6ada43611342c90e3d2c64b920a17f89e69";

            // Create a GET web request
            UnityWebRequest buttonStateWWW = UnityWebRequest.Get(particleURI);
            // Wait until the data has been received
            yield return buttonStateWWW.Send();

            // Make sure you have JSON Object plugin imported
            JSONObject buttonData = new JSONObject(buttonStateWWW.downloadHandler.text);

            // Open the URI link and you can see the value you want is stored in "result", grab this data and store
            buttonData = buttonData["result"];
            // Convert the JSON object to a string and then to a integer
            buttonValString = buttonData.ToString();
            buttonValue = int.Parse(buttonValString);
            Debug.Log(buttonValue);
            // delay 1 second
            yield return new WaitForSeconds(1);
        }
    }

    void Start () {
		anim = GetComponent<Animator>();
    StartCoroutine(GetButtonValue());
    }

	// Update is called once per frame
	void Update () {

		if (buttonValue!= 0) {

			int buttonState = buttonValue;
			if (buttonState != buttonStateOld) {//Status changed
				if (buttonState.Equals (2) && anim.GetCurrentAnimatorStateInfo (0).IsName ("EmptyStateDoor")) {
					anim.SetTrigger ("OpenDoor");
                    Debug.Log("OpenDoor");
				}
				if (buttonState.Equals (10) && anim.GetCurrentAnimatorStateInfo (0).IsName ("OpenDoor")) {
					anim.SetTrigger ("CloseDoor");
				}

				if (buttonState.Equals (2) && anim.GetCurrentAnimatorStateInfo (0).IsName ("CloseDoor")) {
					anim.SetTrigger ("OpenDoor");
				}

				if (buttonState.Equals (10) && anim.GetCurrentAnimatorStateInfo (0).IsName ("OpenDoor")) {
					anim.SetTrigger ("FinalClose");
				}
			}
			buttonStateOld = buttonState;
		}
	}
	void OnGUI()
	{
		GUI.contentColor = Color.white;
		guiStyle.fontSize = 20;
		string newString = "Connected: " + buttonValue;
		GUI.Label(new Rect(10,10,300,100), newString, guiStyle); //Display new values on GUI

	}
}
