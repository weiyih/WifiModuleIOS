//
//  ViewController.swift
//  WifiModuleIOS
//
//  Created by Kevin Wei on 2018-07-12.
//  Copyright © 2018 Kevin Wei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = RNWifiManager()

        manager.connect()

        let wifi = manager.getCurrentWifi()
        if (wifi! == RNWifiManager.MAILBOX_SSID) {
            manager.reconnectAfterProvision()
        }


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

