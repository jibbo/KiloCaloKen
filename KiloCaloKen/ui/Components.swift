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
import VisionKit


struct DaysList: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var pastDays: [Date] = []
    
    private let howManyDaysPast = 5
    private let monthFormatter = DateFormatter()
    private let dayFormatter = DateFormatter()
    
    init(){
        self.monthFormatter.dateFormat = "MMM"
        self.dayFormatter.dateFormat = "dd"
    }
    
    fileprivate func isSelectedDay(_ item: Date) -> Bool {
        return item.timeIntervalSince1970 == viewModel.selectedDay.timeIntervalSince1970
    }
    
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(pastDays, id: \.timeIntervalSince1970) { item in
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
                for i in 0...howManyDaysPast {
                    pastDays.append(Calendar.current.date(byAdding: .day, value: -i, to: Date())!)
                }
                viewModel.selectedDay = pastDays[0]
            }
        }
    }
}

struct MacroNutrientsSummaryView: View{
    @EnvironmentObject private var viewModel: HomeViewModel
    
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
    
    init(_ viewModel: HomeViewModel) {
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
                    description:{ Text("Start adding food for this day!")}
                )
            }
        }
        .onAppear(perform: {
            viewModel.updateFoods(todayFoods)
        })
        .onChange(of: todayFoods){
            viewModel.resetMacros()
            viewModel.updateFoods(todayFoods)
        }
    }
}

struct RecentFoodList: View{
    private var viewModel: HomeViewModel
    @Query private var recentFoods: [LocalProduct]
    @State private var uniqueFoods: [LocalProduct] = []
    
    init(_ viewModel: HomeViewModel) {
        self.viewModel = viewModel
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: viewModel.selectedDay)
        
        _recentFoods = Query(
            filter: #Predicate<LocalProduct> {
                $0.dateAdded < startOfDay
            },
            sort: \LocalProduct.dateAdded
        )
    }
    
    var body: some View {
        List {
            ForEach(uniqueFoods, id: \.self){food in
                Button (action: {
                    viewModel.foodSelected(food)
                }){
                    Text(food.productName)
                }.buttonStyle(.plain)
            }
        }
        .listStyle(.plain)
        .background()
        .onAppear{
            recentFoods.forEach{
                let it = $0
                if(!uniqueFoods.contains(it)){
                    uniqueFoods.append(it)
                }
            }
        }
    }
}

struct SearchProductSheetView: View{
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var eanToSearch: String = ""
    
    var scannerAvailable: Bool {
        DataScannerViewController.isSupported &&
        DataScannerViewController.isAvailable
    }
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "magnifyingglass")
                TextField("Type here an EAN if scanning fails", text: $eanToSearch)
                Spacer()
                if(viewModel.shouldShowLoading){
                    ProgressView()
                }
                Button("Search"){
                    Task{
                        await viewModel.scanEan(eanToSearch)
                    }
                }
            }.background().clipShape(RoundedRectangle(cornerRadius:20))
            Spacer()
            CodeScannerView(codeTypes: [.ean13, .ean8, .code128], showViewfinder: true) { response in
                switch response {
                case .success(let result):
                    eanToSearch = result.string
                    Task{
                        await viewModel.scanEan(result.string)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .frame(maxHeight: 300)
            RecentFoodList(viewModel)
            Spacer()
            HStack{
                Spacer()
                Button("I don't have the EAN"){
                    viewModel.sholdShowAddSheet = false
                    viewModel.shouldShowPickProduct = true
                }
            }
            
        }
        .padding()
    }
}

#Preview {
    SearchProductSheetView()
        .environmentObject(
            HomeViewModel(modelContext: nil)
        )
}

struct QuantitySheetView: View{
    
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var quantity: String = "100.0"
    @FocusState private var isFocused: Bool
    
    fileprivate func getFormattedMacro(macro: Double?) -> Text {
        return Text(String(format: "%.2f", (macro ?? 0.0) * ((Double(quantity) ?? 0.0)/100)))
    }
    
    var body: some View {
        VStack{
            Text(viewModel.productToBeAdded?.productName ?? "N/A").font(.title).bold()
            if(viewModel.productToBeAdded?.imageThumbUrl != nil){
                AsyncImage(
                    url: URL(string: viewModel.productToBeAdded!.imageThumbUrl!),
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(.buttonBorder)
                    },
                    placeholder: {
                        ProgressView()
                    })
            }
            GroupBox(label: Label("Kcal", systemImage: "flame")) {
                getFormattedMacro(macro: viewModel.productToBeAdded?.carbohydrates100G)
            }
            HStack{
                GroupBox(label: Label("CHO", systemImage: "fork.knife")) {
                    getFormattedMacro(macro: viewModel.productToBeAdded?.carbohydrates100G)
                }
                GroupBox(label: Label("PRO", systemImage: "dumbbell")) {
                    getFormattedMacro(macro: viewModel.productToBeAdded?.proteins100G)
                }
                GroupBox(label: Label("FAT", systemImage: "birthday.cake")) {
                    getFormattedMacro(macro: viewModel.productToBeAdded?.fat100G)
                }
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
                    viewModel.addFood(quantity)
                }
            }
        }
        .padding()
    }
}

struct PickProductSheetView: View{
    @EnvironmentObject private var viewModel: HomeViewModel
    @State private var searchTerm: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "magnifyingglass")
                TextField("Zucchini", text: $searchTerm)
                    .focused($isFocused).onAppear{
                        isFocused = true
                    }
                    .task(id: searchTerm) {
                        await viewModel.searchFood(searchTerm)
                    }
            }
            Spacer()
            if(viewModel.shouldShowLoading){
                ProgressView()
            }
            List {
                ForEach(viewModel.lastProductsFound, id: \.productName.hashValue){food in
                    Text(food.productName).onTapGesture {
                        viewModel.foodSelected(food)
                    }
                }
            }
            .listStyle(.plain)
            .overlay{
                if viewModel.lastProductsFound.isEmpty{
                    ContentUnavailableView(
                        label: {Label("Search for the food name", systemImage: "list.bullet.rectangle.portrait")},
                        description:{ Text("All the possible foods will appear here")}
                    )
                }
            }
        }
        .padding()
    }
}
