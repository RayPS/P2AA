//
//  ViewController.swift
//  P2AA
//
//  Created by Ray on 4/10/15.
//  Copyright (c) 2015 RayPS. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.movableByWindowBackground = true
    }
    
    
}
