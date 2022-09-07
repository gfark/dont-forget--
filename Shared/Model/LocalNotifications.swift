//
//  LocalNotifications.swift
//  calendar (iOS)
//
//  Created by Greta Farkas on 8/4/22.
//

import SwiftUI
import UserNotifications

class NotificationManager {
    //upload
    static let instance =  NotificationManager()
    
    func requestAuthorization(){
        
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error) in
            if let error = error {
                
                print("ERROR: \(error)")
            }
            else{
                print("SUCCESS")
            }
        }
    }
    

    func cancelNotification(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()

    }
}

struct LocalNotifications: View {
    
    
    var body: some View{
        
        Button (
            action: {
                NotificationManager.instance.requestAuthorization()            },
            label: {
                Text("Allow notifications")
            }
        )
    }
}

struct LocalNotifications_Previews: PreviewProvider {
    static var previews: some View {
        LocalNotifications()
    }
}


class NotifyMe {
    
    let instance = NotificationManager()
    
    enum NotificationAction: String{
        case dismiss
        
    }
    
    enum NotificationCategory: String {
        case general
    }
    
    func requestNotifications(){
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]){ (success, error) in
                if let error = error {
                    print(error)
                }
                else{
                    print(success)
                }
                    
            }

    }
    
    func constantNotification(){
        let content = UNMutableNotificationContent()
        
        var dateComp = DateComponents()
        dateComp.hour = 8
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
        
        content.title = "Don't Forget!"
        content.sound = .default
        content.subtitle = "Add Event or Check Calendar"
        content.badge = 1
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        
        UNUserNotificationCenter.current().add(request)
        
    }
    func scheduleNotification(taskTitle: String, notificationDate: Date, notificationTime: Date){
        
        let content = UNMutableNotificationContent()
        
        var comp = DateComponents()
        comp = Calendar.current.dateComponents([.day, .month, .year], from: notificationDate)
        comp = Calendar.current.dateComponents([.hour, .minute], from: notificationTime)
    
    
        print(comp)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats:false )
   
        content.title = "Don't Forget!"
        content.sound = .default
        content.subtitle = taskTitle
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.general.rawValue
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        let dismiss = UNNotificationAction(identifier: NotificationAction.dismiss.rawValue, title: "Dismiss", options: [])
        UNUserNotificationCenter.current().add(request)
        
        let generalCategory = UNNotificationCategory(identifier: NotificationCategory.general.rawValue, actions: [dismiss], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([generalCategory])
        
    }
    
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler compleionHandler: @escaping () -> Void){
        
        compleionHandler()
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)  {
        
        completionHandler([.badge, .banner, .sound])
        
    }
}
