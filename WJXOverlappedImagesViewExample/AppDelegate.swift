//
//  AppDelegate.swift
//  WJXOverlappedImagesViewExample
//
//  Created by Jiuxing Wang on 2019/3/16.
//  Copyright © 2019年 Jiuxing Wang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        KMCGeigerCounter.shared()?.isEnabled = true
        
        return true
    }
}
