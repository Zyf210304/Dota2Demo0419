//
//  NetworksService.swift
//  Dota2Demo0419
//
//  Created by 张亚飞 on 2022/4/19.
//

import Foundation
import Combine

enum DotaError: Error {
    
    case someError
}

class NetworkSerview {
    
    static let shared = NetworkSerview()
    private init(){}
    
    var cancellale = Set<AnyCancellable>()
    
//    public func fetchData(completion: @escaping(Result<(Dota2Hero, Dota2Team), Never>) -> Void) {
//
//        let zipPublisher = Publishers.Zip(self.fetchHero(), self.fetchTeam())
//        zipPublisher
//            .sink { items in
//                completion(.success(items))
//            }
//            .store(in: &cancellale)
//
//    }
    
    public func fetchData() -> AnyPublisher<(Dota2Hero, Dota2Team), Error> {
        
        Future<(Dota2Hero, Dota2Team), Error> { [weak self] promise in
            
            if let self = self {
                
                let zipPubulisher = Publishers.Zip(self.fetchHero(), self.fetchTeam())
                
                zipPubulisher
                    .sink { complation in
                        
                        switch complation {
                            
                        case .finished:
                            print("finish")
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    } receiveValue: { items in
                        
                        promise(.success(items))
                    }
                    .store(in: &self.cancellale)

            } else {
                
                promise(.failure(DotaError.someError))
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    func fetchHero() -> AnyPublisher<Dota2Hero, Never> {
        
        let url = URL(string: "https://api.opendota.com/api/heroStats")
        
        guard let url = url else {
            
            return Just([]).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .print("_fenchHero_")
            .filter{($0.response as! HTTPURLResponse).statusCode == 200}
            .map{ $0.data }
            .decode(type: Dota2Hero.self, decoder: JSONDecoder())
            .catch { _ in
                
                Just([])
            }
            .eraseToAnyPublisher()
    }
    
    func fetchTeam()-> AnyPublisher<Dota2Team, Never> {
        
        let url = URL(string: "https://api.opendota.com/api/teams")
        
        guard let url = url else {
            
            return Just([]).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .print("_fenchTeam_")
            .filter{($0.response as! HTTPURLResponse).statusCode == 200}
            .map{ $0.data }
            .decode(type: Dota2Team.self, decoder: JSONDecoder())
            .catch { _ in
                
                Just([])
            }
            .eraseToAnyPublisher()
    }
    
}
