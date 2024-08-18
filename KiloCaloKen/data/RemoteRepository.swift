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
    
    func scanEan(_ ean: String) async throws -> LocalProduct {
        let productSearch = try await foodService.scanEan(ean)
        if(productSearch.product != nil){
            return LocalProduct.init(from: productSearch.product!)
        }else{
            throw Errors.InvalidResponse
        }
    }
    
    func searchFood(_ productName: String) async throws -> [LocalProduct] {
        let productSearch = try await foodService.searchProduct(productName)
        return productSearch.map {
            LocalProduct.init(from: $0)
        }
    }
}
