//
//  home.swift
//  calendar (iOS)
//
//  Created by Greta Farkas on 7/24/22.
//

import SwiftUI
import Foundation

struct Home: View{
    
    @State var currentDate: Date = Date()
    @EnvironmentObject var taskEnvironment: TodaysTask
    //upload
    
    var body: some View{
        
    
        let tab2 = SetUpofTasks()
        let tab1 = CustumDatePicker()
        let tab3 = AddTask()

        TabView{
        
            ScrollView(.vertical, showsIndicators: false){
                
                VStack(spacing: 20){
                    
                    //custom date picker...
                    
                    tab1
                }
                .padding(.vertical)
            }.tabItem{

                Label("Calendar", systemImage: "calendar")
            
                    
            }
            tab2
                .tabItem {
                    Label("Today", systemImage: "checkmark")
                    
                }
            
                tab3.tabItem{
                    Label("Add Task", systemImage: "plus.app")
                }
        
            
        .safeAreaInset(edge: .bottom) {
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom)
      
    
        }
        
    }
}

  
struct Home_Previews: PreviewProvider {
    
    static var previews: some View {
        Home().environmentObject(TodaysTask())
    
    
    }
}

