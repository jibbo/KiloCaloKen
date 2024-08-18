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

struct DaysList: View {
    @State private var last30Days: [Date] = []
    
    private var viewModel: HomeViewModel
    
    private let monthFormatter = DateFormatter()
    private let dayFormatter = DateFormatter()
    
    init(viewModel: HomeViewModel){
        self.viewModel = viewModel
        self.monthFormatter.dateFormat = "MMM"
        self.dayFormatter.dateFormat = "dd"
    }
    
    fileprivate func isSelectedDay(_ item: Date) -> Bool {
        return item.timeIntervalSince1970 == viewModel.selectedDay.timeIntervalSince1970
    }
    
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(last30Days, id: \.timeIntervalSince1970) { item in
                    let fillColor: Color = isSelectedDay(item) ? Color.accentColor.opacity(0.25) : Color.gray.opacity(0.2)
                    VStack {
                        Text(monthFormatter.string(from: item)).bold()
                        Text(dayFormatter.string(from: item))
                    }
                    .padding()
                    .background(
                        Circle().fill(fillColor)
                    )
                    .onTapGesture {
                        viewModel.selectedDay = item
                    }
                    
                }
                .listStyle(.plain)
            }
            .onAppear{
                for i in 0...30 {
                    last30Days.append(Calendar.current.date(byAdding: .day, value: -i, to: Date())!)
                }
                viewModel.selectedDay = last30Days[0]
            }
        }
    }
}

struct MacroNutrientsSummaryView: View{
    @ObservedObject private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View{
        HStack{
            GroupBox(label: Label("CHO", systemImage: "fork.knife")) {
                Text(String(format: "%.2f", viewModel.cho))
            }
            GroupBox(label: Label("PRO", systemImage: "dumbbell")) {
                Text(String(format: "%.2f", viewModel.pro))
            }
            GroupBox(label: Label("FAT", systemImage: "birthday.cake")) {
                Text(String(format: "%.2f", viewModel.fat))
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
        let startOfDay = calendar.startOfDay(for: viewModel.selectedDay)
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
                Text("\(food.brands) - \(food.productName)")
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
                    description:{ Text("Start adding food for this day!")}
                )
            }
        }
        .onAppear(perform: {
            viewModel.updateFoods(foods: todayFoods)
        })
        .onChange(of: todayFoods){
            viewModel.resetMacros()
            viewModel.updateFoods(foods: todayFoods)
        }
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
    @FocusState private var isFocused: Bool
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate func getFormattedMacro(macro: Double?) -> Text {
        return Text(String(format: "%.2f", (macro ?? 0.0) * ((Double(quantity) ?? 0.0)/100)))
    }
    
    var body: some View {
        VStack{
            Text("\(viewModel.lastSearchedFood?.brands ?? "No brand" ) - \(viewModel.lastSearchedFood?.productName ?? "N/A")")
            HStack{
                GroupBox(label: Label("CHO", systemImage: "fork.knife")) {
                    getFormattedMacro(macro: viewModel.lastSearchedFood?.nutriments.carbohydrates100G)
                }
                GroupBox(label: Label("PRO", systemImage: "dumbbell")) {
                    getFormattedMacro(macro: viewModel.lastSearchedFood?.nutriments.proteins100G)
                }
                GroupBox(label: Label("FAT", systemImage: "birthday.cake")) {
                    getFormattedMacro(macro: viewModel.lastSearchedFood?.nutriments.fat100G)
                }
            }
            if(viewModel.lastSearchedFood?.imageFrontThumbUrl != nil){
                AsyncImage(url: URL(string: viewModel.lastSearchedFood!.imageFrontThumbUrl!))
            }
            Spacer()
            TextField("Quantity", text: $quantity).keyboardType(.numberPad).focused($isFocused).onAppear{
                isFocused = true
            }
            Spacer()
            HStack {
                Button("Cancel"){
                    viewModel.shouldShowQuantitySheet = false
                }
                Spacer()
                Button("Add"){
                    viewModel.addFood(quantity: quantity)
                }
            }
        }
        .padding()
    }
}
