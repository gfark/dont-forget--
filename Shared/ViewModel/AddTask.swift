//
//  AddTask.swift
//  calendar (iOS)
//
//  Created by Greta Farkas on 7/28/22.
//

import SwiftUI
import UIKit
import UserNotifications
import Foundation

struct AddTask: View{
    
    //uploa
    
    @EnvironmentObject var taskEnvironment: TodaysTask
    @State var taskAdded = false
    @State var eventTime: Date = Date()
    @State var clockTime: Date = Date()
    @State var eventTitle = " "
    @State var taskTitle = " "
    @State var showTime = false
    
    let notif = NotifyMe()
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2021, month: 1, day: 1)
        let endComponents = DateComponents(year: 2030, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()
    


    
   @State var toNotify: Bool = false
    
    var body: some View {
        
        
        VStack(){
            
            
            
            Spacer()
            
            
            Text("Add Task")
                .font(.title).bold()
                .padding(.vertical)
                
                
            
         
            HStack{
                Text("Pick a date:")
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 40)
                
            DatePicker("",
                       selection: $eventTime,
                       in: dateRange,
                       displayedComponents: [.date])
            .padding(.trailing, 30)
            .datePickerStyle(.compact)
            .frame(alignment: .center)
                
            }
            .padding(.trailing, 30.0)
            
            
            
                
            Text("Enter your task:")
                .padding(.trailing, 175.0)
                
                
                
            TextField("task title", text: $taskTitle).textFieldStyle(.roundedBorder).padding([.leading, .trailing], 2)
                .border(.gray, width: 1)
                .background(Color(.white))
                .frame(width: 300, height: 40, alignment: .center)
                .padding(.bottom, 5)
            
           
            
            Toggle("Notify me:", isOn: $toNotify).toggleStyle(.switch).padding(.trailing, 135.0).padding(.leading, 45).padding(.bottom, 10)
                .onChange(of: toNotify){ newValue in
                    
        }
            
        VStack(alignment: .leading){
            Toggle("Show time:", isOn: $showTime).toggleStyle(.switch).padding(.trailing, 135.0).padding(.leading, 45)                .onChange(of: showTime){ newValue in
                }
            Text("*only for NO notifications*").font(.caption2).padding(.leading, 45).padding(.top, -12)
                    
                    
                    
                
        
            }
            
            VStack{
            
                    
                    HStack{
                        
                        VStack(alignment: .leading){
                    Text("Select a time:")
                            
                            
                        }
                        
                    
                    DatePicker("",
                               selection: $clockTime,
                               in: dateRange,
                               displayedComponents: [.hourAndMinute])
                    .datePickerStyle(.automatic)
                        
                    }.frame(width: 245.0)
                    .padding(.trailing, 50.0)
                    .padding()
                
          
    
                Button(
                    action:{
                        
                       
                        
        
                        
                        if (toNotify){
                            notif.requestNotifications()
                            notif.scheduleNotification(taskTitle: taskTitle, notificationDate: eventTime, notificationTime: clockTime)
                            
                            
                            let currentTask = createTask(eDate: eventTime, name: taskTitle, notify: true, clockTime: clockTime, showTime: true)
                            taskAdded = true
                            
                            if (isSameDay(date1: currentTask.time, date2: Date.now)){
                                taskEnvironment.add(t: currentTask)
                                taskEnvironment.addToAllTasks(t:currentTask, futureDate: eventTime)
                                
                            }
                            else{
                                taskEnvironment.addToAllTasks(t: currentTask, futureDate: eventTime)

                            }
                            
                        }
                        else if (showTime == true && toNotify == false){
                            
                            let currentTask = createTask(eDate: eventTime, name: taskTitle, notify: false, clockTime: clockTime, showTime: true)
                                
                            if (isSameDay(date1: currentTask.time, date2: Date.now)){
                                    taskEnvironment.add(t: currentTask)
                                taskEnvironment.addToAllTasks(t: currentTask, futureDate: eventTime)

                                }
                            else{
                                taskEnvironment.addToAllTasks(t: currentTask, futureDate: eventTime)

                        
                            }
                        
                            taskAdded = true
                            
                        }
                        else{
                            let currentTask = createTask(eDate: eventTime, name: taskTitle, notify: false, clockTime: clockTime, showTime: false)
                                
                            if (isSameDay(date1: currentTask.time, date2: Date.now)){
                                    taskEnvironment.add(t: currentTask)
                                taskEnvironment.addToAllTasks(t: currentTask, futureDate: eventTime)

                                }
                            else{
                                taskEnvironment.addToAllTasks(t: currentTask, futureDate: eventTime)

                            
                                
                            }
                        
                            taskAdded = true
                            
                        }
                    
            
                
                        taskTitle = " "
                        eventTime = Date.now
                        clockTime = Date.now
                        toNotify = false
                        showTime = false
                        
            
                      
                },
                label: {
                    Text("Add Task")
                        .font(.title2)
                        
                }).alert("Task Added!", isPresented: $taskAdded, actions: {})
                .padding(7.0)
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
                
            }
        Spacer()
        }
            
        }
                    

    func createTask(eDate: Date, name: String, notify: Bool, clockTime: Date, showTime: Bool)-> Task {
    
        
        let newTask = Task(title: name, time: eDate, notify: notify, clockTime: clockTime, showTime: showTime)
        return newTask
        
        
        
    }
                    
    func isSameDay(date1: Date, date2: Date)->Bool{
            let calendar = Calendar.current
                        
        return calendar.isDate(date1, inSameDayAs: date2)
    }

   
}



struct AddTask_Previews: PreviewProvider {
    static var previews: some View {
        AddTask().environmentObject(TodaysTask())
            
    }
}
    
