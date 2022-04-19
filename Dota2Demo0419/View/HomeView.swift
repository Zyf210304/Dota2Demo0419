//
//  HomeView.swift
//  Dota2Demo0419
//
//  Created by 张亚飞 on 2022/4/19.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var vm = ViewModel()
    var body: some View {
       
        ZStack {
            
            if vm.hero == nil || vm.team == nil {
                
                
            } else {
                
                TabView {
                    
                    HeroView()
                        .environmentObject(vm)
                        .tabItem{
                            
                            Text("英雄")
                        }
                    
                    TeamView()
                        .environmentObject(vm)
                        .tabItem{
                            
                            Text("战队")
                        }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
