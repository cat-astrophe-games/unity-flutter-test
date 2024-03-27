using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FlutterUnityIntegration;

public class TestFlutterCommunication : MonoBehaviour
{
    public Transform reportTransform;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        UnityMessageManager messages = GetComponent<UnityMessageManager>();
        messages.SendMessageToFlutter("Rotation:" + reportTransform.localRotation.ToString());
    }
}
