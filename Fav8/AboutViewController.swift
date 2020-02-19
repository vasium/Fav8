//
//  AboutViewController.swift
//  Fav8
//
//  Created by Administrator on 2018-05-18.
//  Copyright © 2018 Woqomoqo. All rights reserved.
//

import UIKit


class AboutViewController: UIViewController {
    
    
    @IBOutlet weak var labelVersion: UILabel!
    
    
    @IBOutlet weak var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.labelVersion.text = "Version \(version)"
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        label.sizeToFit()
    }
    
}
