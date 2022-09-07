//
//  SetUpofTasks.swift
//  calendar (iOS)
//
//  Created by Greta Farkas on 8/13/22.
//

import SwiftUI
import Foundation

struct SetUpofTasks: View {
    //upload
    @EnvironmentObject var taskEnvironment: TodaysTask


    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false){
        
        VStack{
            
            Text("Today's Tasks:").font(.title).bold().padding(.top, 20.0).padding(.bottom, 5.0)
            
            
            
            List{
                
                
        
                ForEach(taskEnvironment.todaysTasks){ task in
        
              
                    
            
                        VStack(alignment: .leading){
                            if(!task.showTime){
                                Text("Do Today:").foregroundColor(.white)
                            }
                            else{
                                
                                Text(task.clockTime, style: .time)
                                
                
                                    .foregroundColor(.white)
                                
                            }
                                Text("\(task.title)").font(.title2).foregroundColor(Color.white).bold()
                                
                        }
                        .listRowBackground(Color.blue).scaledToFill().accentColor(.white)
                    
                        
                    
                }.padding()
                
            }
        }
        }
            
        
        
        
    }
    
    
    func dateString(clockTime: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        let timeStr = formatter.string(from: clockTime)
        return timeStr
    }
            
        


}



struct SetUpofTasks_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView{

            SetUpofTasks().environmentObject(TodaysTask())
    
            
        }
        
    }
}
