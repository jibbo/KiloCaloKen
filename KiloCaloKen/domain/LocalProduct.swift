//
//  LocalProduct.swift
//  KiloCaloKen
//
//  Created by Giovanni De Francesco on 10/08/24.
//

import Foundation
import SwiftData

// TODO: this isn't a domain because it is using swiftdata
@Model
class LocalProduct: Codable, Equatable {
    let id: Int?
    let productName: String
    let imageThumbUrl: String?
    let dateAdded: Date
    let quantity: Double // in grams
    let carbohydrates100G: Double
    let energyKcal100G: Double
    let fat100G: Double
    let proteins100G: Double
    
    init(id: Int, productName: String, imageThumbUrl: String?, dateAdded: Date, energy: Double, carbo: Double, proteins: Double, fat: Double, quantity: Double) {
        self.id = id
        self.productName = productName
        self.imageThumbUrl = imageThumbUrl
        self.dateAdded = dateAdded
        self.carbohydrates100G = carbo
        self.energyKcal100G = energy
        self.proteins100G = proteins
        self.fat100G = fat
        self.quantity = quantity
    }
    
    init(from: Product, quantity: Double = 100.0, dateAdded: Date = Date.now){
        self.id = dateAdded.timeIntervalSince1970.hashValue
        self.productName = "\(from.brands ?? "") - \(from.productName)"
        self.imageThumbUrl = from.imageFrontUrl
        self.dateAdded = dateAdded
        self.carbohydrates100G = from.nutriments.carbohydrates100G!
        self.energyKcal100G = Double(from.nutriments.energyKcal100G!)
        self.proteins100G = from.nutriments.proteins100G!
        self.fat100G = from.nutriments.fat100G!
        self.quantity = quantity
    }
    
    init(from: RemoteSearchItem, quantity: Double = 100.0, dateAdded: Date = Date.now){
        self.id = dateAdded.timeIntervalSince1970.hashValue
        self.productName = from.name
        self.imageThumbUrl = nil
        self.dateAdded = dateAdded
        self.carbohydrates100G = from.carbs
        self.energyKcal100G = from.energy
        self.proteins100G = from.proteins
        self.fat100G = from.fat
        self.quantity = quantity
    }
    
    init(from: LocalProduct, quantity: Double = 100.0, dateAdded: Date = Date.now){
        self.id = dateAdded.timeIntervalSince1970.hashValue
        self.productName = from.productName
        self.imageThumbUrl = from.imageThumbUrl
        self.dateAdded = dateAdded
        self.carbohydrates100G = from.carbohydrates100G
        self.energyKcal100G = from.energyKcal100G
        self.proteins100G = from.proteins100G
        self.fat100G = from.fat100G
        self.quantity = quantity
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case carbohydrates100G
        case energyKcal100G
        case fat100G
        case proteins100G
        case productName = "product_name"
        case dateAdded = "date_added"
        case quantity
        case imageThumbUrl = "image_thumb_url"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.carbohydrates100G = try container.decode(Double.self, forKey: .carbohydrates100G)
        self.energyKcal100G = try container.decode(Double.self, forKey: .energyKcal100G)
        self.proteins100G = try container.decode(Double.self, forKey: .proteins100G)
        self.fat100G = try container.decode(Double.self, forKey: .fat100G)
        self.productName = try container.decode(String.self, forKey: .productName)
        self.imageThumbUrl = try container.decode(String.self, forKey: .imageThumbUrl)
        self.dateAdded = try container.decode(Date.self, forKey: .dateAdded)
        self.quantity = try container.decode(Double.self, forKey: .quantity)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.energyKcal100G, forKey: .energyKcal100G)
        try container.encode(self.carbohydrates100G, forKey: .carbohydrates100G)
        try container.encode(self.proteins100G, forKey: .proteins100G)
        try container.encode(self.fat100G, forKey: .fat100G)
        try container.encode(self.productName, forKey: .productName)
        try container.encode(self.imageThumbUrl, forKey: .imageThumbUrl)
        try container.encode(self.dateAdded, forKey: .dateAdded)
        try container.encode(self.quantity, forKey: .quantity)
    }
    
    static func ==(lhs: LocalProduct, rhs: LocalProduct) -> Bool {
        return lhs.id == rhs.id || lhs.productName == rhs.productName
    }
}
