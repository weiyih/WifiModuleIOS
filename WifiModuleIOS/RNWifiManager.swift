//
//  RNWifiModule.swift
//  WifiModuleIOS
//
//  Created by Kevin Wei on 2018-07-16.
//  Copyright © 2018 Kevin Wei. All rights reserved.
//

import Foundation
import NetworkExtension
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork
import SystemConfiguration.SCNetwork

@objc(RNWifiManager)
class RNWifiManager: NSObject {
    static var MAILBOX_SSID: String = "ShipperBee"
    static var MAILBOX_PASS: String = "Test@vault@2018"

    func test() -> Void {
        let manager = NEHotspotConfigurationManager.shared
        manager.getConfiguredSSIDs(completionHandler: { (ssidList) in
            for ssid in ssidList {
                print("SSID = ", ssid)
            }
        })
    }

    // Returns the currentWifi
    func getCurrentWifi() -> String? {
        let interface = CNCopySupportedInterfaces()

        if interface != nil {
            let array = CFBridgingRetain(interface) as! NSArray
            print(array)

            if (array.count > 0) {
                let name = array[0] as! CFString
                let data = CNCopyCurrentNetworkInfo(name)! as NSDictionary
                let ssid = data["SSID"] as! String
                return ssid
            }
        }
        return nil
    }

    /*
     Connect attempts connection to the mailbox soft ap
     joinOnce = true to allow the app to reconnect back to the home network by removeConfigurationForSSID: OR
         The app stays in the background for more than 15 seconds.
         The device sleeps.
         The app crashes, quits, or is uninstalled.
         The app connects the device to a different Wi-Fi network.
         The user connects the device to a different Wi-Fi network.
     */
    // TODO - Event Emitters
    @objc
    func connect() -> Void {
        let manager = NEHotspotConfigurationManager.shared
        let config = createSoftAPConfig()

        manager.apply(config, completionHandler: { (error) in
            if error != nil {
                print("ERROR", error!)
                // TODO - Promise
            } else {
                // TODO - Promise
                print("Success")
                self.test()
                print("SSID", self.getCurrentWifi())
            }
        })
    }

    func createSoftAPConfig() -> NEHotspotConfiguration {
        let softApConfig = NEHotspotConfiguration.init(ssid: "ShipperBee", passphrase: "Test@vault@2018", isWEP: false)
        // Automatically dissoiciate from the soft AP when user leaves app
        softApConfig.joinOnce = true
        return softApConfig
    }

    func saveCurrentNetwork() -> Void {

    }

    func reconnectAfterProvision() -> Void {
        print("RECONNECT")
        let manager = NEHotspotConfigurationManager.shared
        manager.removeConfiguration(forSSID: RNWifiManager.MAILBOX_SSID)
        print("SSID", self.getCurrentWifi())
    }
}
