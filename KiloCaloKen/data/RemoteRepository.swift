//
//  RemoteRepository.swift
//  KiloCaloKen
//
//  Created by Giovanni De Francesco on 08/08/24.
//

import Foundation

final class RemoteRepository: FoodRepository {
    // TODO: injection
    let foodService = OpenFoodFactApiService()
    
    func getFood(ean: String) async throws -> Product {
        let productSearch = try await foodService.scanProduct(ean: ean)
        // TODO: map to domain model
        if(productSearch.product != nil){
            return productSearch.product!
        }else{
            throw Errors.InvalidResponse
        }
    }
}
