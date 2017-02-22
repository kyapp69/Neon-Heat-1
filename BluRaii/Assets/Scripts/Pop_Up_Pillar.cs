﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pop_Up_Pillar : MonoBehaviour {
    GameObject warningSign;
    Vector3 spawnPosition;
    GameObject player;
    Vector3 offset;
    bool spawn = false;
    Vector3 finalRaiseAmount;
    Vector3 raiseAmount = Vector3.zero;
    Vector3 originalPosition;

    // Use this for initialization
    void Start () {
        player = GameObject.FindGameObjectWithTag("Player");

        offset = new Vector3(Random.Range(-1000, 1000), 0, Random.Range(-2000, -20000));
        spawnPosition = new Vector3(City_Duplicator.cityStart.x, City_Duplicator.cityStart.y, player.transform.position.z) + offset;

        warningSign = Instantiate(Resources.Load("warning_sign"), Vector3.zero, Quaternion.identity) as GameObject;

        finalRaiseAmount = Vector3.up * Random.Range(100, 350);

        Invoke("RaisePillar", Random.Range(0.2f, 0.6f));
        originalPosition = spawnPosition;
    }
	
	// Update is called once per frame
	void Update () {
        spawnPosition = new Vector3(City_Duplicator.cityStart.x, City_Duplicator.cityStart.y, player.transform.position.z) + offset;
        warningSign.transform.position = spawnPosition;

        if (spawn) {
            transform.position = originalPosition + raiseAmount;
            raiseAmount = Vector3.Lerp(raiseAmount, finalRaiseAmount, Time.deltaTime / 0.1f);
        } else {
            originalPosition = spawnPosition + Vector3.down * 750;
        }

    }

    public static void Spawn() {
        GameObject rocket = Instantiate(Resources.Load("pop_up_pillar"), Vector3.zero, Quaternion.identity) as GameObject;
    }

    void RaisePillar() {
        transform.position = spawnPosition + Vector3.down * 750;
        spawn = true;
        warningSign.SetActive(false);
    }
}