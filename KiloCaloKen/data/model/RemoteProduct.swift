// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let productSearch = try? JSONDecoder().decode(ProductSearch.self, from: jsonData)

import Foundation

// MARK: - RemoteProduct
struct RemoteProduct: Codable {
    let code: String
    let product: Product?
    let status: String?
    let statusVerbose: String?

    enum CodingKeys: String, CodingKey {
        case code, product, status
        case statusVerbose = "status_verbose"
    }
}

// MARK: - Product
struct Product: Codable {
    let nutriments: Nutriments
    let productName: String
    let brands: String
    let imageFrontUrl: String?

    enum CodingKeys: String, CodingKey {
        case nutriments, brands
        case productName = "product_name"
        case imageFrontUrl = "image_front_url"
    }
}

// MARK: - Nutriments
struct Nutriments: Codable {
    let carbohydrates, carbohydrates100G: Double?
    let carbohydratesUnit: String?
    let carbohydratesValue: Double?
    let energy, energyKcal, energyKcal100G: Int?
    let energyKcalUnit: String?
    let energyKcalValue: Int?
    let energyKcalValueComputed: Double?
    let energy100G: Int?
    let energyUnit: String?
    let energyValue: Int?
    let fat, fat100G: Double?
    let fatUnit: String?
    let fatValue: Double?
    let fruitsVegetablesLegumesEstimateFromIngredients100G, fruitsVegetablesLegumesEstimateFromIngredientsServing: Int?
    let fruitsVegetablesNutsEstimateFromIngredients100G, fruitsVegetablesNutsEstimateFromIngredientsServing: Double?
    let novaGroup, novaGroup100G, novaGroupServing, nutritionScoreFr: Int?
    let nutritionScoreFr100G: Int?
    let proteins, proteins100G: Double?
    let proteinsUnit: String?
    let proteinsValue, salt, salt100G: Double?
    let saltUnit: String?
    let saltValue, saturatedFat, saturatedFat100G: Double?
    let saturatedFatUnit: String?
    let saturatedFatValue, sodium, sodium100G: Double?
    let sodiumUnit: String?
    let sodiumValue, sugars, sugars100G: Double?
    let sugarsUnit: String?
    let sugarsValue: Double?

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
}
