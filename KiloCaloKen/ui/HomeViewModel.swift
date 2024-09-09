//
//  HomeViewModel.swift
//  KiloCaloKen
//
//  Created by Giovanni De Francesco on 07/08/24.
//

import Foundation
import SwiftData


final class HomeViewModel: ObservableObject{
    @Published var totalKcal: Int = 0
    @Published var cho: Int = 0
    @Published var pro: Int = 0
    @Published var fat: Int = 0
    @Published var shouldShowAlert = false
    @Published var shouldShowLoading = false
    @Published var sholdShowSearchProductSheet = false
    @Published var shouldShowQuantitySheet = false
    @Published var shouldShowPickProduct = false
    @Published var shouldShowDateSheet = false
    @Published var productToBeAdded: LocalProduct? = nil
    @Published var lastProductsFound: [LocalProduct] = []
    @Published var selectedDay: Date = Date.now
    @Published var searchTerm: String = ""
    
    private let repository: FoodRepository = RemoteRepository()
    private var modelContext: ModelContext?
    
    init(modelContext: ModelContext?) {
        self.modelContext = modelContext
    }
    
    func showAddSheet(){
        self.sholdShowSearchProductSheet = true
        self.lastProductsFound = []
    }
    
    @MainActor
    func scanEan(_ ean: String) async {
        self.shouldShowAlert = false
        self.shouldShowLoading = true
        do{
            productToBeAdded =  try await repository.scanEan(ean)
            self.sholdShowSearchProductSheet = false
            self.shouldShowQuantitySheet = true
            self.shouldShowLoading = false
        }catch{
            self.shouldShowAlert = true
            self.shouldShowLoading = false
        }
    }
    
    @MainActor
    func showFoodPicker() {
        self.sholdShowSearchProductSheet = false
        self.shouldShowPickProduct = true
        self.lastProductsFound = []
    }
    
    @MainActor
    func searchFood(_ searchTerm: String) async {
        if(searchTerm.count>=4) {
            do {
                self.shouldShowLoading = true
                self.lastProductsFound =  try await repository.searchFood(searchTerm)
                self.shouldShowLoading = false
            } catch {
                self.shouldShowPickProduct = false
                self.shouldShowLoading = false
                self.shouldShowAlert = true
            }
        } else {
            self.lastProductsFound = []
        }
    }
    
    func foodSelected(_ food: LocalProduct) {
        self.sholdShowSearchProductSheet = false
        self.shouldShowLoading = false
        self.shouldShowPickProduct = false
        self.productToBeAdded =  food
        self.shouldShowQuantitySheet = true
        self.lastProductsFound = []
    }
    
    func addFood(_ quantity: String) {
        guard self.productToBeAdded != nil else {
            return
        }
        guard let quantityInNumber = Double(quantity) else {
            return
        }
        self.shouldShowLoading = true
        let localFood: LocalProduct = LocalProduct.init(from: productToBeAdded!, quantity: quantityInNumber, dateAdded: selectedDay)
        modelContext?.insert(localFood)
        updateFoods([localFood])
        self.shouldShowQuantitySheet = false
        self.shouldShowLoading = false
        self.productToBeAdded = nil
    }
    
    func deleteFood(food: LocalProduct){
        modelContext?.delete(food)
        removeFood(food)
    }
    
    func updateFoods(_ foods: [LocalProduct]){
        resetMacros()
        for food in foods {
            totalKcal+=Int(food.energyKcal100G * (food.quantity/100))
            cho+=Int((food.carbohydrates100G) * (food.quantity/100))
            pro+=Int((food.proteins100G) * (food.quantity/100))
            fat+=Int((food.fat100G)  * (food.quantity/100))
        }
    }
    
    func removeFood(_ food: LocalProduct){
        totalKcal-=Int(food.energyKcal100G * (food.quantity/100))
        cho-=Int((food.carbohydrates100G) * (food.quantity/100))
        pro-=Int((food.proteins100G) * (food.quantity/100))
        fat-=Int((food.fat100G)  * (food.quantity/100))
    }
    
    private func resetMacros(){
        totalKcal = 0
        cho = 0
        pro = 0
        fat = 0
    }
}
