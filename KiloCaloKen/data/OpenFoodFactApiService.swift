//
//  OpenFoodFactApiService.swift
//  KiloCaloKen
//
//  Created by Giovanni De Francesco on 08/08/24.
//

import Foundation

// TODO: replace with AlamoFire
final class OpenFoodFactApiService {
    let apiUrl = "https://it.openfoodfacts.net/api/v3/"
    
    func scanProduct(ean: String) async throws -> RemoteProduct {
        let foodFilters = "?fields=product_name,brands,image_front_url,nutriments"
        let innerUrl = apiUrl+"product/"+ean+foodFilters
        print(innerUrl)
        guard let url = URL(string: innerUrl) else {
            throw Errors.InvalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw Errors.InvalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(RemoteProduct.self, from: data)
        } catch(let error) {
            print(error)
            throw Errors.InvalidParse
        }
    }
}

enum Errors: LocalizedError {
    case InvalidURL
    case InvalidResponse
    case InvalidParse
}
