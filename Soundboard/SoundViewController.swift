//
//  SoundViewController.swift
//  Soundboard
//
//  Created by CarlosDeLaRocha on 8/20/17.
//  Copyright © 2017 CarlosDeLaRocha. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {
    
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var audioRecorder : AVAudioRecorder? = nil
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    //Todo el setup del audio recording
    func setupRecorder (){
        do{
            //Create an audio session
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //Create URL for the audio file
            let basePath : String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            print("---------------------")
            print(audioURL!)
            print("---------------------")
            
            //Create settings for the audio recorder
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject
            settings[AVSampleRateKey] = Int(44100.0) as AnyObject
            settings[AVNumberOfChannelsKey] = Int(2) as AnyObject
            
            //Create Audio recorder object
            audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
            audioRecorder?.prepareToRecord()
            
        }catch let error as NSError {
            print(error)
        }
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        
        if audioRecorder!.isRecording{
            //Stop the recording
            audioRecorder?.stop()
            
            //Change button title to record
            recordButton.setTitle("Record", for: .normal)
            
            //Habilitar mis botones cuando se termine la gravación
            playButton.isEnabled = true
            addButton.isEnabled = true
        }else{
            //Start the recording
            audioRecorder?.record()
            
            //change button title to stop
            recordButton.setTitle("Stop", for:.normal)
            
            //Hacer que mis botones no esten habilitados
            playButton.isEnabled = false
            addButton.isEnabled = false
        }
        
    }
    
    @IBAction func playTapped(_ sender: Any) {
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        }catch{
        }
        
    }
    
    @IBAction func addTapped(_ sender: Any) {
        //conectar mis varibles con las funciones y base de datos
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sonido = Sound(context: context)
        sonido.name = nameTextField.text
        sonido.audio = NSData(contentsOf: audioURL!)
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        navigationController!.popViewController(animated: true)
        
    }
    
}
