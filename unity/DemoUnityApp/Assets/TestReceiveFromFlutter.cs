using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestReceiveFromFlutter : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }

    public void MessageFromFlutter(string message)
    {
        Debug.Log("Message from Flutter: " + message);
        float value = float.Parse(message);
        transform.position = new Vector3(0, value, 0);
    }
}
