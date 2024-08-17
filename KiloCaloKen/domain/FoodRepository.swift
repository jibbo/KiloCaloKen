//
//  FoodRepository.swift
//  KiloCaloKen
//
//  Created by Giovanni De Francesco on 08/08/24.
//

import Foundation

protocol FoodRepository {
    func getFood(ean: String) async throws -> Product
}
