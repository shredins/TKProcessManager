//
//  AppDelegate.swift
//  ProcessManagerExample
//
//  Created by Tomasz Korab on 20/04/2020.
//  Copyright © 2020 Tomasz Korab. All rights reserved.
//

import UIKit
import ProcessManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        execute()
        return true
    }

    private func execute() {

        let processes: [Process] = (0...120).map { object in
            SyncProcess {
                UIImage(named: "image")?.pngData()
            }
        }

        ProcessManager.shared.add(newProcesses: processes)
    }

}

