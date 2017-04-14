//
//  SoundViewController.swift
//  Sound Board
//
//  Created by Nannapaneni, Vijay on 4/14/17.
//  Copyright © 2017 Crap App. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var audioURL : URL?
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func setupRecorder() {
        do {
            // Create an Audio Session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            // Create URL for the Audio Files
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)
            
            // Create settings for the AudioRecorder
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = kAudioFormatMPEG4AAC as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            // create AudioRecorder object
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            
        } catch let error as NSError {
            print(error)
        }
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder!.isRecording {
            // Stop the recording
            audioRecorder?.stop()
            
            // Change button title to Stop
            recordButton.setTitle("Record", for: .normal)
            
            playButton.isEnabled = true
            addButton.isEnabled = true
        } else {
            //start the recording
            audioRecorder?.record()
            
            // Change button title to stop
            recordButton.setTitle("Stop", for: .normal)
        }
    }
    
    @IBAction func playTapped(_ sender: Any) {
        do {
        try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        } catch {}
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sound = Sound(context: context)
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf: audioURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
}
