//
//  RecordingSoundViewController.swift
//  PitchPerfectApp
//
//  Created by Ali Shawky on 6/19/19.
//  Copyright © 2019 Ali Shawky. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingSoundViewController: UIViewController , AVAudioRecorderDelegate{

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    private var audioRecorder:AVAudioRecorder!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi(isRecording: false)
        
    }
    
    @IBAction func recordAudio(_ sender: Any) {
       configureUi(isRecording: true)
        
        startRecording()
    }
    @IBAction func stopRecording(_ sender: Any) {
       configureUi(isRecording: false)
        stopRecording()
    }
    
    private func stopRecording(){
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    private func configureUi(isRecording:Bool){
        if isRecording {
            recordingLabel.text = "Recording In Progress"
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
        }else{
            recordingLabel.text = "Tap To Record"
            stopRecordingButton.isEnabled = false
            recordButton.isEnabled = true
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("Error record Audio")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let  recordedAudioURL = sender as! URL
            playSoundsVC.recordingAudioURL = recordedAudioURL
            
        }
    }
    
    private func startRecording() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordVoice.wave"
        let pathArray = [dirPath,recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        print(filePath ?? "")
        
        _ = AVAudioSession.sharedInstance()
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
}

