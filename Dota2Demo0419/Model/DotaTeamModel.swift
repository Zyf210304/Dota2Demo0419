//
//  DotaTeamModel.swift
//  Dota2Demo0419
//
//  Created by 张亚飞 on 2022/4/19.
//

import Foundation

// MARK: - Dota2TeamElement
struct Dota2TeamElement: Codable, Hashable{
    let teamID: Int
    let rating: Double
    let wins, losses, lastMatchTime: Int
    let name, tag: String
    let logoURL: String?

    enum CodingKeys: String, CodingKey {
        case teamID = "team_id"
        case rating, wins, losses
        case lastMatchTime = "last_match_time"
        case name, tag
        case logoURL = "logo_url"
    }
}

typealias Dota2Team = [Dota2TeamElement]
