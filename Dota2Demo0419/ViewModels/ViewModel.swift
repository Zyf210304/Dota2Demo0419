//
//  ViewModel.swift
//  Dota2Demo0419
//
//  Created by 张亚飞 on 2022/4/19.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    
    @Published var hero: Dota2Hero?
    @Published var team: Dota2Team?
    
    let service = NetworkSerview.shared
    
    var cancellable = Set<AnyCancellable>()
    
    init() {
        
        service.fetchData()
            .receive(on: RunLoop.main)
            .sink { completion in
                
                print(completion)
            } receiveValue: {[weak self] (hero, team) in
                self?.hero = hero
                self?.team = team
                print(self?.hero)
                print(self?.team)
            }
            .store(in: &cancellable)
        
        
//        service.fetchHero()
//            .receive(on: RunLoop.main)
//            .sink { completion in
//
//                print(completion)
//            } receiveValue: {[weak self] data in
//                self?.hero = data
//            }
//            .store(in: &cancellable)
//
//
//        service.fetchTeam()
//            .receive(on: RunLoop.main)
//            .sink { completion in
//
//                print(completion)
//            } receiveValue: {[weak self] data in
//                self?.team = data
//            }
//            .store(in: &cancellable)
    }
    
}
