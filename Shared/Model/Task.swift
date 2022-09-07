//
//  Task.swift
//  calendar (iOS)
//
//  Created by Greta Farkas on 7/26/22.
//

import SwiftUI
import Foundation

struct Task: Identifiable, Codable, Equatable{
    //uploa
    var id = UUID().uuidString
    var title: String
    var time: Date = Date()
    var notify: Bool
    var clockTime: Date = Date()
    var showTime: Bool

}

struct TaskData: Identifiable, Codable{
    var id = UUID().uuidString
    var taskComing: [Task]
    var taskDate: Date
    
    mutating func addToTC(t: Task){
    
        var copyOf: [Task] = taskComing
        copyOf.append(t)
        taskComing = copyOf
    
    
    }
    
    mutating func deleteTask(t: Task){
        var count = 0
        var flag = false
        var index = 0
        
        for task in taskComing{
            
            if (task.title == t.title && task.time == t.time){
                flag = true
                index = count
            }
            count += 1
        }
        
        if flag == true{
            taskComing.remove(at: index)
        }
    }
    
}



class TodaysTask: ObservableObject{
    


  

    
    @Published var tasks: [TaskData] = [] {

        
        didSet{
            saveTasks()
        }
    }
    
    
    @Published var todaysTasks: [Task] = []
                                            
    let tasksKey : String = "tasks_lists"

    
    
    init(){
        getTasks()
        newToday()
    }
    
    func getTasks(){
        
        guard let data = UserDefaults.standard.data(forKey: tasksKey) else{return}
        guard let savedItems = try? JSONDecoder().decode([TaskData].self, from: data)else{return}
        self.tasks = savedItems
    
    }
    
    func add(t: Task){
        
        todaysTasks.append(t)
    }
    
   
    func isSameDay(date1: Date, date2: Date)->Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func newToday(){
        
        for td in tasks {
            
            if (self.isSameDay(date1: td.taskDate, date2: Date.now)){
                todaysTasks = td.taskComing
            }
        
        }
    }
    
    func deleteATask(t: Task) -> Bool{
        
        var count = 0
        var index = 0
        var flag = false
        
        if isSameDay(date1: t.time, date2: Date.now) {
            
            for task in todaysTasks {
                
                if t.title == task.title{
                    flag = true
                    index = count
                    
                }
                
                count += 1
            }
        }
        if flag == true{
            
            todaysTasks.remove(at: index)
            return true
        }
        else{
            return false
        }
        
        

    }
    
    func addToAllTasks(t: Task, futureDate: Date){

        
        let calendar = Calendar.current
        
        var foundFlag = false
        var count = 0
        var index = 0
        
        for td in tasks {
            
            
            if  calendar.isDate(futureDate, inSameDayAs: td.taskDate) == true{
                
                index = count
                foundFlag = true
               
            }
            count += 1
        }
            
        if (foundFlag == true){
            
            tasks[index].addToTC(t: t)
        
        
        }
        
        else{
            
            let newTD: TaskData = TaskData(taskComing: [t], taskDate: futureDate)
            tasks.append(newTD)
            
        }
        
    }

    func deleteFromAllTasks(t: Task, futureDate: Date) -> Bool{

        
        let calendar = Calendar.current
        var foundFlag = false
        var count = 0
        var index = 0
        for td in tasks {
            
            
            if  calendar.isDate(futureDate, inSameDayAs: td.taskDate) == true{
                
                index = count
                foundFlag = true
               
            }
            count += 1
        }
        
            
        if (foundFlag == true){
            
                tasks[index].deleteTask(t: t)
                return true
                
            
            
            }
        else{
            return false
        }
        
        
        }

    
    func saveTasks(){
        
        if let encodedData = try? JSONEncoder().encode(tasks){
            UserDefaults.standard.set(encodedData, forKey: tasksKey)
        }
    }
   
    
}

    



