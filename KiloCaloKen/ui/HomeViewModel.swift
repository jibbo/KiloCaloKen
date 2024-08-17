//
//  HomeViewModel.swift
//  KiloCaloKen
//
//  Created by Giovanni De Francesco on 07/08/24.
//

import Foundation
import SwiftData


final class HomeViewModel: ObservableObject{
    @Published var totalKcal: Double = 0
    @Published var cho: Double = 0
    @Published var pro: Double = 0
    @Published var fat: Double = 0
    @Published var shouldShowAlert = false
    @Published var shouldShowLoading = false
    @Published var sholdShowAddSheet = false
    @Published var shouldShowQuantitySheet = false
    @Published var lastSearchedFood: Product? = nil
    
    private let repository: FoodRepository = RemoteRepository()
    private var modelContext: ModelContext?
    
    init(modelContext: ModelContext?) {
        self.modelContext = modelContext
    }
    
    func showAddSheet(){
        self.sholdShowAddSheet = true
    }
    
    @MainActor
    func searchEan(ean: String) async {
        self.sholdShowAddSheet = false
        self.shouldShowAlert = false
        self.shouldShowLoading = true
        do{
            lastSearchedFood =  try await repository.getFood(ean: ean)
            self.shouldShowQuantitySheet = true
            self.shouldShowLoading = false
        }catch{
            self.shouldShowAlert = true
            self.shouldShowLoading = false
        }
    }
    
    @MainActor
    func addFood(quantity: Double) {
        guard self.lastSearchedFood != nil else {
            return
        }
        self.shouldShowLoading = true
        let localFood: LocalProduct = LocalProduct.init(from: lastSearchedFood!, quantity: quantity)
        modelContext?.insert(localFood)
        updateFoods(foods: [localFood])
        self.shouldShowQuantitySheet = false
        self.shouldShowLoading = false
    }
    
    func deleteFood(food: LocalProduct){
        modelContext?.delete(food)
        removeFood(food: food)
    }
    
    func updateFoods(foods: [LocalProduct]){
        for food in foods {
            totalKcal+=Double(food.nutriments.energyKcal100G ?? 0) * food.quantity/100
            cho+=((food.nutriments.carbohydrates100G ?? 0.0) * (food.quantity/100))
            pro+=((food.nutriments.proteins100G ?? 0.0) * (food.quantity/100))
            fat+=((food.nutriments.fat100G ?? 0.0)  * (food.quantity/100))
        }
    }
    
    func removeFood(food: LocalProduct){
        totalKcal-=Double(food.nutriments.energyKcal100G ?? 0) * (food.quantity/100)
        cho-=((food.nutriments.carbohydrates100G ?? 0.0) * (food.quantity/100))
        pro-=((food.nutriments.proteins100G ?? 0.0) * (food.quantity/100))
        fat-=((food.nutriments.fat100G ?? 0.0)  * (food.quantity/100))
    }
}
