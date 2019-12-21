//
//  ViewController.swift
//  Xylophone
//
//  Created by Angela Yu on 27/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import AVFoundation
import segment_appsflyer_ios

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    //properties about UILabel
    @IBOutlet weak var myLabel: UILabel!
    
    
    var audioPlayer : AVAudioPlayer!
    var selectedSoundFileName : String = ""
    
    var selectedButtonColor : String = ""
    
    let soundArray = ["note1", "note2", "note3", "note4", "note5", "note6", "note7"]
    
    let colorArray = ["red", "orange", "yellow", "light green", "green", "blue", "purple"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }



    @IBAction func notePressed(_ sender: UIButton) {
        
        if (sender.tag - 1) == 0 {
            
            AppsFlyerShareInviteHelper.generateInviteUrl(linkGenerator:
             {(_ generator: AppsFlyerLinkGenerator) -> AppsFlyerLinkGenerator in
              generator.setChannel("myTestChannel")
              generator.setReferrerName("Eduardo")
              generator.addParameterValue("2.5", forKey: "af_cost_value")
              return generator },
            completionHandler: {(_ url: URL?) -> Void in
                // write logic to let the user share the invite link
                self.myLabel.text = url?.absoluteString
                print(url?.absoluteString)
            })
            
        }
        
        selectedButtonColor = colorArray[sender.tag - 1]
        
        playSound(soundFileName: soundArray[sender.tag - 1])

        //sends an event named Button Pressed with the note number and color of the note
        SEGAnalytics.shared()?.track("Button Pressed", properties: ["note number" : selectedSoundFileName, "note color": selectedButtonColor, "IDFV": UIDevice.current.identifierForVendor!.uuidString])
        
        
//        sends an event named Testing with three test key and three test values
        SEGAnalytics.shared()?.track("Testing", properties: ["first key" : "first value", "second key": "second value", "third key": "third value"])
        
    }
    
    
    func playSound(soundFileName : String) {
        
        let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "wav")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch {
            print(error)
        }
        
        audioPlayer.play()
    }
    
  

}

