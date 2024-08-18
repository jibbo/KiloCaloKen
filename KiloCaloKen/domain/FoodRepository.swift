//
//  FoodRepository.swift
//  KiloCaloKen
//
//  Created by Giovanni De Francesco on 08/08/24.
//

import Foundation

protocol FoodRepository {
    func scanEan(_ ean: String) async throws -> LocalProduct
    func searchFood(_ productName: String) async throws -> [LocalProduct]
}
