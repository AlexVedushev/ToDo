//
//  AppDelegate.swift
//  TODO
//
//  Created by Alexey Vedushev on 21.02.2020.
//  Copyright © 2020 Alexey Vedushev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        Application.shared.configureMainInterface(window)
        self.window = window
        return true
    }

}

