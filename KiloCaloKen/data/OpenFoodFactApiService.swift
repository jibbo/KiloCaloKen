//
//  OpenFoodFactApiService.swift
//  KiloCaloKen
//
//  Created by Giovanni De Francesco on 08/08/24.
//

import Foundation

final class OpenFoodFactApiService {
    let apiUrl = "https://it.openfoodfacts.net/api/v3/"
    
    func scanEan(_ ean: String) async throws -> RemoteProduct {
        let encodedEan = ean.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let foodFilters = "?fields=product_name,brands,image_front_url,nutriments"
        let innerUrl = apiUrl+"product/"+encodedEan+foodFilters
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
    
    func searchProduct(_ productName: String) async throws -> [RemoteSearchItem] {
        let encodedProdName = productName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let innerUrl = "https://script.google.com/macros/s/AKfycbzLeqiQ-trJU2gvfSOxJwd5dJ-JDJ3R3na2L3vQpCMSE1FTyli_HeTNgPCXTJMXmZl9/exec?filter="+encodedProdName
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
            return try decoder.decode([RemoteSearchItem].self, from: data)
        } catch(let error) {
            print(error)
            throw Errors.InvalidParse
        }
    }
    
    func bigSearchProduct(_ productName: String) async throws -> RemoteBigSearch {
        let encodedProdName = productName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let innerUrl = "https://it.openfoodfacts.org/cgi/search.pl?search_terms="+encodedProdName+"&search_simple=1&action=process&json=1&fields=product_name,brands,image_front_url,nutriments"
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
            return try decoder.decode(RemoteBigSearch.self, from: data)
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
