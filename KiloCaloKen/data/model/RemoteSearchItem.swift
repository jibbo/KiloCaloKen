//
//  RemoteSearch.swift
//  KiloCaloKen
//
//  Created by Giovanni De Francesco on 18/08/24.
//

import Foundation

struct RemoteSearchItem: Codable {
    let name: String
    let energy: Double
    let proteins: Double
    let fat: Double
    let carbs: Double
    
    enum CodingKeys: String, CodingKey {
        case name
        case energy
        case proteins
        case fat
        case carbs
    }
}
