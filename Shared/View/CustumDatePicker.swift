//
//  CustumDatePicker.swift
//  calendar (iOS)
//
//  Created by Greta Farkas on 7/24/22.
//

import SwiftUI
import Foundation

struct CustumDatePicker: View {
    
    //upload
    @State var currentDate:Date = Date()
    @State var isDeleted = false
    let samp : [Task] = []
    @EnvironmentObject var taskEnvironment: TodaysTask
    
    
    //Month update on arrow button clicks
    @State var currentMonth:Int = 0
    @State var notifications = NotificationManager()
    @State var formatter = DateFormatter()
    
    var body : some View{
        
            
        VStack(spacing: 35){
            
            //Days..
            
            let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            
            HStack(spacing: 20){
                
                
                VStack(alignment: .leading, spacing: 10){
                    
                    Text(extraData()[0]).font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(extraData()[1])
                        .font(.title.bold())
                }
                .padding(8.0)
                
                Spacer(minLength: 0)
                
                Button{
                    withAnimation{
                        currentMonth -= 1
                    }
                }
            label: {
                
                Image(systemName: "chevron.left").font(.title2)
                
            }
                
                Button{
                    withAnimation{
                        currentMonth += 1
                    }
                }
            label: {
                
                Image(systemName: "chevron.right").font(.title2)
                
            }
            }.padding(.horizontal)
            
            //Day view...
            HStack(spacing: 0){
                
                ForEach(days,id: \.self){day in
                    
                    Text(day)
                        .font(.callout)
                        .fontWeight(.regular)
                        .padding(.horizontal, 5.0)
                        .frame(maxWidth: .infinity)
                }
            }
            
            //Dates
            //Lazy Grid..
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
        
            LazyVGrid(columns: columns, spacing: 10){
                
                ForEach(extractDate()){ value in
                    
                    CardView(value: value, alltasks: taskEnvironment)
                        .background(
                            
                            Capsule()
                                .fill(Color(.red))
                                .padding(.horizontal, 8)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1: 0)
                            
                        )
                        .onTapGesture {
                            currentDate = value.date
                            
                        
    
                        }
                    
                    
                }
            }
            .padding(.horizontal, 10.0)
        
        
            VStack(spacing: 10){
                
                Text("Tasks")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .padding(.trailing, 270.0)
                    .padding(.leading, 5.0)
                    .font(.title)
                   

                
                if let task = taskEnvironment.tasks.first(where: { task in
                
                    
                    return isSameDay(date1: task.taskDate, date2: currentDate)
                    
                }){
                    
                    if (task.taskComing == samp){
                    
                        Text("No Task Found")
                    }else{
                
    
                       
                        ForEach(task.taskComing){ task in
                        
                            VStack(alignment: .leading, spacing: 5){
                                
                                
                        
                                //for custom time
                                if(!task.showTime){
                                    Text("Do Today:").foregroundColor(.white).padding(.leading)
                                }
                                else{
                                   
                                    Text(task.clockTime, style: .time)
                                        .foregroundColor(Color(.white))
                                        .padding(.leading, 10)
                                }
                           
                                    Text(task.title)
                                        .font(.title2.bold())
                                        .foregroundColor(.white)
                                        .padding(.leading, 20)
                                
                                
                                HStack{
                                   
                                    
                                    Button(action: {
                                        
                                        
                                        isDeleted = taskEnvironment.deleteFromAllTasks(t: task, futureDate: task.time)
                                    
                                    
                                        taskEnvironment.deleteATask(t: task)
                                    
                                
                        
                                        
                                    }, label: {
                                        Image(systemName: "trash").foregroundColor(.white).padding(.leading, 340)
                                            .padding(.trailing, 10)
                                        
                                    })
                                    
                                    
                                }
                                
                            
                                    
                            }
                            .padding(.vertical, 10.0)
                            .padding(.horizontal, 4.0)
                           
                            
                            .background(

                                Color.blue
                            
                            ).cornerRadius(10)
                           
                                .padding(5)
                                .padding(.horizontal, 10)
                                .padding(.bottom, -2)
                            
                        }
                        }
                    }
                
                else{
                        Text("No Task Found")
                }
                    
                    
                }
            
           
        }
        
        
        
        .onChange(of: currentMonth){ newValue in
            
            //update Month
            currentDate = getCurrentMonth()

        }
    }
    
    func deleteFromHere(){
        
    }
    
    func dateString(clockTime: Date) -> String{
        
        formatter.dateFormat = "hh: mm"
        let timeStr = formatter.string(from: clockTime)
        return timeStr
    }
    
    func automaticNotification(notification: NotificationManager){
        notification.requestAuthorization()
    }
    
    @ViewBuilder
    func CardView(value: DateValue, alltasks: TodaysTask) -> some View {
        
        VStack{
        
            if value.day != -1{
                
                if let task = alltasks.tasks.first(where: { task in
                
                    
                    return isSameDay(date1: task.taskDate, date2: value.date)
                    
                }){
                    if (task.taskComing != [] && currentDate != Date.now){
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: task.taskDate, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                      
                    
                    Spacer()
                    

                    
                    
                    Circle().fill(isSameDay(date1: task.taskDate, date2: currentDate) ? .white : .red)
                        .frame(width: 8, height: 8)
                    }
                    else{
                        Text("\(value.day)")
                            .font(.title3.bold())
                            .fontWeight(.regular)
                            .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                            .frame(maxWidth: .infinity)
                        
                        Spacer()
                        
                    }
                    
                }
                else{
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .fontWeight(.regular)
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
            }
            
        }
        .padding(.vertical, 10)
        .frame(height: 60, alignment: .top)
    }
    
    //checking date
    func isSameDay(date1: Date, date2: Date)->Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    
    func extraData() -> [String]{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth()-> Date{
        let calendar = Calendar.current

        //get current month date
        guard let currentMonth =  calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else{
            return Date()
        }
        
        return currentMonth
        
    }
    
    func extractDate() -> [DateValue] {
        let calendar = Calendar.current
        
        //getting current month date
        
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue
            in
            
                //getting day
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
            
        }
        
        //adding pffset days to get exact week day
        
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1 {
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
                        
        return days
        
        
    }
}

struct CustumDatePicker_Previews: PreviewProvider {

    static var previews: some View{ CustumDatePicker().environmentObject(TodaysTask())
    
    
    }
    
}

extension Date{
    
    func getAllDates() -> [Date]{
        
        
        let calendar = Calendar.current
        
        //getting start Date
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!

        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        //getting date
        
        return range.compactMap{ day -> Date in
            
            return calendar.date(byAdding: .day, value: day - 1,  to: startDate)!
            
        }
        
    }
}
