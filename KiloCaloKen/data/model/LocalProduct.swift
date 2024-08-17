//
//  LocalProduct.swift
//  KiloCaloKen
//
//  Created by Giovanni De Francesco on 10/08/24.
//

import Foundation
import SwiftData

@Model
class LocalProduct: Codable {
    let id: Int?
    let nutriments: LocalNutriments
    let productName: String
    let dateAdded: Date
    let quantity: Double
    
    init(id: Int?, nutriments: LocalNutriments, productName: String, dateAdded: Date, quantity: Double) {
        self.id = id
        self.nutriments = nutriments
        self.productName = productName
        self.dateAdded = dateAdded
        self.quantity = quantity
    }
    
    init(from: Product, quantity: Double){
        let nowDate: Date = Date.now
        self.id = nowDate.hashValue
        self.nutriments = LocalNutriments(from: from.nutriments)
        self.productName = from.productName
        self.dateAdded = nowDate
        self.quantity = quantity
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case nutriments
        case productName = "product_name"
        case dateAdded = "date_added"
        case quantity
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.nutriments = try container.decode(LocalNutriments.self, forKey: .nutriments)
        self.productName = try container.decode(String.self, forKey: .productName)
        self.dateAdded = try container.decode(Date.self, forKey: .dateAdded)
        self.quantity = try container.decode(Double.self, forKey: .quantity)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.nutriments, forKey: .nutriments)
        try container.encode(self.productName, forKey: .productName)
        try container.encode(self.dateAdded, forKey: .dateAdded)
        try container.encode(self.quantity, forKey: .quantity)
    }
}

@Model
class LocalNutriments: Codable {
    let carbohydrates: Double?
    let carbohydrates100G: Double?
    let carbohydratesUnit: String?
    let carbohydratesValue: Double?
    let energy: Int?
    let energyKcal: Int?
    let energyKcal100G: Int?
    let energyKcalUnit: String?
    let energyKcalValue: Int?
    let energyKcalValueComputed: Double?
    let energy100G: Int?
    let energyUnit: String?
    let energyValue: Int?
    let fat: Double?
    let fat100G: Double?
    let fatUnit: String?
    let fatValue: Double?
    let fruitsVegetablesLegumesEstimateFromIngredients100G: Int?
    let fruitsVegetablesLegumesEstimateFromIngredientsServing: Int?
    let fruitsVegetablesNutsEstimateFromIngredients100G: Double?
    let fruitsVegetablesNutsEstimateFromIngredientsServing: Double?
    let novaGroup: Int?
    let novaGroup100G: Int?
    let novaGroupServing: Int?
    let nutritionScoreFr: Int?
    let nutritionScoreFr100G: Int?
    let proteins: Double?
    let proteins100G: Double?
    let proteinsUnit: String?
    let proteinsValue:Double?
    let salt: Double?
    let salt100G: Double?
    let saltUnit: String?
    let saltValue: Double?
    let saturatedFat: Double?
    let saturatedFat100G: Double?
    let saturatedFatUnit: String?
    let saturatedFatValue: Double?
    let sodium: Double?
    let sodium100G: Double?
    let sodiumUnit: String?
    let sodiumValue: Double?
    let sugars: Double?
    let sugars100G: Double?
    let sugarsUnit: String?
    let sugarsValue: Double?
    
    init(carbohydrates: Double?, carbohydrates100G: Double?, carbohydratesUnit: String?, carbohydratesValue: Double?, energy: Int?, energyKcal: Int?, energyKcal100G: Int?, energyKcalUnit: String?, energyKcalValue: Int?, energyKcalValueComputed: Double?, energy100G: Int?, energyUnit: String?, energyValue: Int?, fat: Double?, fat100G: Double?, fatUnit: String?, fatValue: Double?, fruitsVegetablesLegumesEstimateFromIngredients100G: Int?, fruitsVegetablesLegumesEstimateFromIngredientsServing: Int?, fruitsVegetablesNutsEstimateFromIngredients100G: Double?, fruitsVegetablesNutsEstimateFromIngredientsServing: Double?, novaGroup: Int?, novaGroup100G: Int?, novaGroupServing: Int?, nutritionScoreFr: Int?, nutritionScoreFr100G: Int?, proteins: Double?, proteins100G: Double?, proteinsUnit: String?, proteinsValue: Double?, salt: Double?, salt100G: Double?, saltUnit: String?, saltValue: Double?, saturatedFat: Double?, saturatedFat100G: Double?, saturatedFatUnit: String?, saturatedFatValue: Double?, sodium: Double?, sodium100G: Double?, sodiumUnit: String?, sodiumValue: Double?, sugars: Double?, sugars100G: Double?, sugarsUnit: String?, sugarsValue: Double?) {
        self.carbohydrates = carbohydrates
        self.carbohydrates100G = carbohydrates100G
        self.carbohydratesUnit = carbohydratesUnit
        self.carbohydratesValue = carbohydratesValue
        self.energy = energy
        self.energyKcal = energyKcal
        self.energyKcal100G = energyKcal100G
        self.energyKcalUnit = energyKcalUnit
        self.energyKcalValue = energyKcalValue
        self.energyKcalValueComputed = energyKcalValueComputed
        self.energy100G = energy100G
        self.energyUnit = energyUnit
        self.energyValue = energyValue
        self.fat = fat
        self.fat100G = fat100G
        self.fatUnit = fatUnit
        self.fatValue = fatValue
        self.fruitsVegetablesLegumesEstimateFromIngredients100G = fruitsVegetablesLegumesEstimateFromIngredients100G
        self.fruitsVegetablesLegumesEstimateFromIngredientsServing = fruitsVegetablesLegumesEstimateFromIngredientsServing
        self.fruitsVegetablesNutsEstimateFromIngredients100G = fruitsVegetablesNutsEstimateFromIngredients100G
        self.fruitsVegetablesNutsEstimateFromIngredientsServing = fruitsVegetablesNutsEstimateFromIngredientsServing
        self.novaGroup = novaGroup
        self.novaGroup100G = novaGroup100G
        self.novaGroupServing = novaGroupServing
        self.nutritionScoreFr = nutritionScoreFr
        self.nutritionScoreFr100G = nutritionScoreFr100G
        self.proteins = proteins
        self.proteins100G = proteins100G
        self.proteinsUnit = proteinsUnit
        self.proteinsValue = proteinsValue
        self.salt = salt
        self.salt100G = salt100G
        self.saltUnit = saltUnit
        self.saltValue = saltValue
        self.saturatedFat = saturatedFat
        self.saturatedFat100G = saturatedFat100G
        self.saturatedFatUnit = saturatedFatUnit
        self.saturatedFatValue = saturatedFatValue
        self.sodium = sodium
        self.sodium100G = sodium100G
        self.sodiumUnit = sodiumUnit
        self.sodiumValue = sodiumValue
        self.sugars = sugars
        self.sugars100G = sugars100G
        self.sugarsUnit = sugarsUnit
        self.sugarsValue = sugarsValue
    }
    
    enum CodingKeys: String, CodingKey {
        case carbohydrates
        case carbohydrates100G = "carbohydrates_100g"
        case carbohydratesUnit = "carbohydrates_unit"
        case carbohydratesValue = "carbohydrates_value"
        case energy
        case energyKcal = "energy-kcal"
        case energyKcal100G = "energy-kcal_100g"
        case energyKcalUnit = "energy-kcal_unit"
        case energyKcalValue = "energy-kcal_value"
        case energyKcalValueComputed = "energy-kcal_value_computed"
        case energy100G = "energy_100g"
        case energyUnit = "energy_unit"
        case energyValue = "energy_value"
        case fat
        case fat100G = "fat_100g"
        case fatUnit = "fat_unit"
        case fatValue = "fat_value"
        case fruitsVegetablesLegumesEstimateFromIngredients100G = "fruits-vegetables-legumes-estimate-from-ingredients_100g"
        case fruitsVegetablesLegumesEstimateFromIngredientsServing = "fruits-vegetables-legumes-estimate-from-ingredients_serving"
        case fruitsVegetablesNutsEstimateFromIngredients100G = "fruits-vegetables-nuts-estimate-from-ingredients_100g"
        case fruitsVegetablesNutsEstimateFromIngredientsServing = "fruits-vegetables-nuts-estimate-from-ingredients_serving"
        case novaGroup = "nova-group"
        case novaGroup100G = "nova-group_100g"
        case novaGroupServing = "nova-group_serving"
        case nutritionScoreFr = "nutrition-score-fr"
        case nutritionScoreFr100G = "nutrition-score-fr_100g"
        case proteins
        case proteins100G = "proteins_100g"
        case proteinsUnit = "proteins_unit"
        case proteinsValue = "proteins_value"
        case salt
        case salt100G = "salt_100g"
        case saltUnit = "salt_unit"
        case saltValue = "salt_value"
        case saturatedFat = "saturated-fat"
        case saturatedFat100G = "saturated-fat_100g"
        case saturatedFatUnit = "saturated-fat_unit"
        case saturatedFatValue = "saturated-fat_value"
        case sodium
        case sodium100G = "sodium_100g"
        case sodiumUnit = "sodium_unit"
        case sodiumValue = "sodium_value"
        case sugars
        case sugars100G = "sugars_100g"
        case sugarsUnit = "sugars_unit"
        case sugarsValue = "sugars_value"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.carbohydrates = try container.decodeIfPresent(Double.self, forKey: .carbohydrates)
        self.carbohydrates100G = try container.decodeIfPresent(Double.self, forKey: .carbohydrates100G)
        self.carbohydratesUnit = try container.decodeIfPresent(String.self, forKey: .carbohydratesUnit)
        self.carbohydratesValue = try container.decodeIfPresent(Double.self, forKey: .carbohydratesValue)
        self.energy = try container.decodeIfPresent(Int.self, forKey: .energy)
        self.energyKcal = try container.decodeIfPresent(Int.self, forKey: .energyKcal)
        self.energyKcal100G = try container.decodeIfPresent(Int.self, forKey: .energyKcal100G)
        self.energyKcalUnit = try container.decodeIfPresent(String.self, forKey: .energyKcalUnit)
        self.energyKcalValue = try container.decodeIfPresent(Int.self, forKey: .energyKcalValue)
        self.energyKcalValueComputed = try container.decodeIfPresent(Double.self, forKey: .energyKcalValueComputed)
        self.energy100G = try container.decodeIfPresent(Int.self, forKey: .energy100G)
        self.energyUnit = try container.decodeIfPresent(String.self, forKey: .energyUnit)
        self.energyValue = try container.decodeIfPresent(Int.self, forKey: .energyValue)
        self.fat = try container.decodeIfPresent(Double.self, forKey: .fat)
        self.fat100G = try container.decodeIfPresent(Double.self, forKey: .fat100G)
        self.fatUnit = try container.decodeIfPresent(String.self, forKey: .fatUnit)
        self.fatValue = try container.decodeIfPresent(Double.self, forKey: .fatValue)
        self.fruitsVegetablesLegumesEstimateFromIngredients100G = try container.decodeIfPresent(Int.self, forKey: .fruitsVegetablesLegumesEstimateFromIngredients100G)
        self.fruitsVegetablesLegumesEstimateFromIngredientsServing = try container.decodeIfPresent(Int.self, forKey: .fruitsVegetablesLegumesEstimateFromIngredientsServing)
        self.fruitsVegetablesNutsEstimateFromIngredients100G = try container.decodeIfPresent(Double.self, forKey: .fruitsVegetablesNutsEstimateFromIngredients100G)
        self.fruitsVegetablesNutsEstimateFromIngredientsServing = try container.decodeIfPresent(Double.self, forKey: .fruitsVegetablesNutsEstimateFromIngredientsServing)
        self.novaGroup = try container.decodeIfPresent(Int.self, forKey: .novaGroup)
        self.novaGroup100G = try container.decodeIfPresent(Int.self, forKey: .novaGroup100G)
        self.novaGroupServing = try container.decodeIfPresent(Int.self, forKey: .novaGroupServing)
        self.nutritionScoreFr = try container.decodeIfPresent(Int.self, forKey: .nutritionScoreFr)
        self.nutritionScoreFr100G = try container.decodeIfPresent(Int.self, forKey: .nutritionScoreFr100G)
        self.proteins = try container.decodeIfPresent(Double.self, forKey: .proteins)
        self.proteins100G = try container.decodeIfPresent(Double.self, forKey: .proteins100G)
        self.proteinsUnit = try container.decodeIfPresent(String.self, forKey: .proteinsUnit)
        self.proteinsValue = try container.decodeIfPresent(Double.self, forKey: .proteinsValue)
        self.salt = try container.decodeIfPresent(Double.self, forKey: .salt)
        self.salt100G = try container.decodeIfPresent(Double.self, forKey: .salt100G)
        self.saltUnit = try container.decodeIfPresent(String.self, forKey: .saltUnit)
        self.saltValue = try container.decodeIfPresent(Double.self, forKey: .saltValue)
        self.saturatedFat = try container.decodeIfPresent(Double.self, forKey: .saturatedFat)
        self.saturatedFat100G = try container.decodeIfPresent(Double.self, forKey: .saturatedFat100G)
        self.saturatedFatUnit = try container.decodeIfPresent(String.self, forKey: .saturatedFatUnit)
        self.saturatedFatValue = try container.decodeIfPresent(Double.self, forKey: .saturatedFatValue)
        self.sodium = try container.decodeIfPresent(Double.self, forKey: .sodium)
        self.sodium100G = try container.decodeIfPresent(Double.self, forKey: .sodium100G)
        self.sodiumUnit = try container.decodeIfPresent(String.self, forKey: .sodiumUnit)
        self.sodiumValue = try container.decodeIfPresent(Double.self, forKey: .sodiumValue)
        self.sugars = try container.decodeIfPresent(Double.self, forKey: .sugars)
        self.sugars100G = try container.decodeIfPresent(Double.self, forKey: .sugars100G)
        self.sugarsUnit = try container.decodeIfPresent(String.self, forKey: .sugarsUnit)
        self.sugarsValue = try container.decodeIfPresent(Double.self, forKey: .sugarsValue)
    }
    
    init(from: Nutriments){
        self.carbohydrates = from.carbohydrates
        self.carbohydrates100G = from.carbohydrates100G
        self.carbohydratesUnit = from.carbohydratesUnit
        self.carbohydratesValue = from.carbohydratesValue
        self.energy = from.energy
        self.energyKcal = from.energyKcal
        self.energyKcal100G = from.energyKcal100G
        self.energyKcalUnit = from.energyKcalUnit
        self.energyKcalValue = from.energyKcalValue
        self.energyKcalValueComputed = from.energyKcalValueComputed
        self.energy100G = from.energy100G
        self.energyUnit = from.energyUnit
        self.energyValue = from.energyValue
        self.fat = from.fat
        self.fat100G = from.fat100G
        self.fatUnit = from.fatUnit
        self.fatValue = from.fatValue
        self.fruitsVegetablesLegumesEstimateFromIngredients100G = from.fruitsVegetablesLegumesEstimateFromIngredients100G
        self.fruitsVegetablesLegumesEstimateFromIngredientsServing = from.fruitsVegetablesLegumesEstimateFromIngredientsServing
        self.fruitsVegetablesNutsEstimateFromIngredients100G = from.fruitsVegetablesNutsEstimateFromIngredients100G
        self.fruitsVegetablesNutsEstimateFromIngredientsServing = from.fruitsVegetablesNutsEstimateFromIngredientsServing
        self.novaGroup = from.novaGroup
        self.novaGroup100G = from.novaGroup100G
        self.novaGroupServing = from.novaGroupServing
        self.nutritionScoreFr = from.nutritionScoreFr
        self.nutritionScoreFr100G = from.nutritionScoreFr100G
        self.proteins = from.proteins
        self.proteins100G = from.proteins100G
        self.proteinsUnit = from.proteinsUnit
        self.proteinsValue = from.proteinsValue
        self.salt = from.salt
        self.salt100G = from.salt100G
        self.saltUnit = from.saltUnit
        self.saltValue = from.saltValue
        self.saturatedFat = from.saturatedFat
        self.saturatedFat100G = from.saturatedFat100G
        self.saturatedFatUnit = from.saturatedFatUnit
        self.saturatedFatValue = from.saturatedFatValue
        self.sodium = from.sodium
        self.sodium100G = from.sodium100G
        self.sodiumUnit = from.sodiumUnit
        self.sodiumValue = from.sodiumValue
        self.sugars = from.sugars
        self.sugars100G = from.sugars100G
        self.sugarsUnit = from.sugarsUnit
        self.sugarsValue = from.sugarsValue
    }
    
    func encode(to encoder: Encoder) throws {
        // TODO: encoding
    }
}

