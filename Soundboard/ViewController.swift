//
//  ViewController.swift
//  Soundboard
//
//  Created by CarlosDeLaRocha on 8/20/17.
//  Copyright © 2017 CarlosDeLaRocha. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var sonidos : [Sound] = []
    var audioPlayer : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    //---
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            sonidos = try context.fetch(Sound.fetchRequest())
            tableView.reloadData()
        }catch{}
    }
    
    //cantidad de cosas en la tabla en la celda
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sonidos.count
    }

    //que es lo que contiene cada celda
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celdas = UITableViewCell()
        let archivo = sonidos[indexPath.row]
        
        celdas.textLabel?.text = archivo.name
        
        return celdas
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Esto nos va a permitir reproducir contenido directamente desde las celdas
        let archivo = sonidos[indexPath.row]
        do{
            audioPlayer = try AVAudioPlayer(data: archivo.audio! as Data)
            audioPlayer?.play()
        }catch{}
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

