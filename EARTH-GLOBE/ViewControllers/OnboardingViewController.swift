//
//  OnboardingViewController.swift
//  EARTH-GLOBE
//
//  Created by Oleg Rybalko on 28/07/2017.
//  Copyright © 2017 Oleg Rybalko. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var firstPageTxt: UILabel!
    @IBOutlet weak var secondPageTxt: UILabel!
    @IBOutlet weak var thirdPageTxt: UILabel!
    @IBOutlet weak var firstNextButton: UIButton!
    @IBOutlet weak var secondNextButton: UIButton!
    @IBOutlet weak var startExploringButton: UIButton!
    var contentWidth: CGFloat = 0.0
    
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func startExploring(_ sender: UIButton) {
        
        UserDefaults.standard.set("1", forKey: "pressed")
        generator.impactOccurred()
    }
    
    @IBAction func secondNext(_ sender: UIButton) {
        
        generator.impactOccurred()
        
    }
    
    @IBAction func firstNext(_ sender: UIButton) {
        
        generator.impactOccurred()
        
    }
    
    @IBAction func russianBtn(_ sender: UIButton){
        UserDefaults.standard.set("0", forKey: "language")
    }
    
    @IBAction func englishBtn(_ sender: UIButton){
        UserDefaults.standard.set("1", forKey: "language")
    }
}
