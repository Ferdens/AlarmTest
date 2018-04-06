//
//  AppDelegate.swift
//  TestAlarm
//
//  Created by anton Shepetuha on 06.04.18.
//  Copyright © 2018 anton Shepetuha. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupaAppearance()
        openMain()
//        AppConstants.requestNotificationsPermission()
        registerForPushNotifications()
        AlarmsManager.setTimersForFutureAlarms()
        return true
    }
    
    func openMain() {
        let navController: UINavigationController
        navController = UINavigationController(rootViewController: MainViewController())
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    func setupaAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor(red: 55.0 / 255.0, green: 201 / 255.0, blue: 230.0 / 255.0, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        UINavigationBar.appearance().tintColor = .white
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        AudioManager.shared.playAlarmAudio()
        completionHandler([.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if AudioManager.shared.alarmIsPlaying() {
            AudioManager.shared.stopAlarmAudio()
        }
        completionHandler()
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        AudioManager.shared.playSilenceAudio()
        if AudioManager.shared.alarmIsPlaying() {
            AudioManager.shared.stopAlarmAudio()
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        AudioManager.shared.stopSilenceAudio()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
      NotificationCenter.default.post(name: NSNotification.Name.applicationDidBecomeActiveNotification, object: nil)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        AlarmsManager.setAllAlarmsTimersNotSet()
    }
    
    // MARK: - Register Remote Notifications
    
    open func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings {
            (settings) in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
}

