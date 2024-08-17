//
//  Components.swift
//  KiloCaloKen
//
//  Created by Giovanni De Francesco on 10/08/24.
//

import Foundation
import SwiftUI
import SwiftData
import CodeScanner

struct MacroNutrientsSummaryView: View{
    @ObservedObject private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View{HStack{
        GroupBox(label: Label("CHO", systemImage: "fork.knife")) {
            Text(String(viewModel.cho))
        }
        GroupBox(label: Label("PRO", systemImage: "dumbbell")) {
            Text(String(viewModel.pro))
        }
        GroupBox(label: Label("FAT", systemImage: "birthday.cake")) {
            Text(String(viewModel.fat))
        }
    }
    }
}

struct FoodList: View{
    private var viewModel: HomeViewModel
    @Query var todayFoods: [LocalProduct]
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        _todayFoods = Query(
            filter: #Predicate<LocalProduct> {
                $0.dateAdded >= startOfDay && $0.dateAdded < endOfDay
            },
            sort: \LocalProduct.dateAdded
        )
    }
    
    var body: some View {
        List {
            ForEach(todayFoods, id: \.self){food in
                Text(food.productName)
            }
            .onDelete(perform: { indexSet in
                for index in indexSet{
                    viewModel.deleteFood(food: todayFoods[index])
                }
            })
        }
        .listStyle(.plain)
        .background()
        .overlay{
            if todayFoods.isEmpty{
                ContentUnavailableView(
                    label: {Label("No food yet", systemImage: "list.bullet.rectangle.portrait")},
                    description:{ Text("Start adding food you ate today!")}
                )
            }
        }
        .onAppear(perform: {
            viewModel.updateFoods(foods: todayFoods)
        })
    }
}

struct SearchProductSheetView: View{
    private var viewModel: HomeViewModel
    
    @State private var eanToSearch: String = "8001300551027"
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {VStack{
        CodeScannerView(codeTypes: [.ean13, .ean8]) { response in
            switch response {
            case .success(let result):
                Task{
                    await viewModel.searchEan(ean: result.string)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        TextField("EAN", text: $eanToSearch)
        Button("Search"){
            Task{
                await viewModel.searchEan(ean: eanToSearch)
            }
        }
    }
    .padding()
    }
}

struct QuantitySheetView: View{
    private var viewModel: HomeViewModel
    
    @State private var quantity: String = "100.0"
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {VStack{
        TextField("Quantity", text: $quantity)
        Button("Add"){
            viewModel.addFood(quantity: Double(quantity) ?? 100.0)
        }
    }
    .padding()
    }
}
