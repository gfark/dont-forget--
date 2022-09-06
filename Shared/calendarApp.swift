//
//  calendarApp.swift
//  Shared
//
//  Created by Greta Farkas on 7/16/22.
//

import SwiftUI

@main
struct calendarApp: App {
    
    @StateObject var taskEnvironment: TodaysTask = TodaysTask()
    private var delegate: NotificationDelegate = NotificationDelegate()
    
    init(){
        let center = UNUserNotificationCenter.current()
        center.delegate = delegate
        center.requestAuthorization(options: [.alert, .sound ,.badge]) { success, error in
            
            if let error = error {
                
                print(error)
            }
            
        }
    }
    var body: some Scene {
        WindowGroup {
            Home().environmentObject(taskEnvironment)
        
    
        }
    }
}
