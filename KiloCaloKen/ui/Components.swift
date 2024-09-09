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

struct Header: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        HStack{
            Text("KiloKen").font(.largeTitle.bold())
            Spacer()
            DatePicker(
                selection: $viewModel.selectedDay,
                displayedComponents: [.date],
                label: {  }
            ).labelsHidden()
        }
    }
}

struct MacroNutrientsSummaryView: View{
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View{
        VStack{
            GroupBox(label: Label("Kcal Totali", systemImage: "flame")) {
                Text(String(format: "%.2f", viewModel.totalKcal))
            }
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
}

struct FoodSection: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            FoodList(viewModel)
            Button {
                viewModel.showAddSheet()
            } label: {
                Image(systemName: "plus")
                    .padding()
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.accentColor))
                    .imageScale(.large)
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
                Button(action:{
                    viewModel.foodSelected(food)
                }){
                    Text(food.productName)
                }
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
            viewModel.updateFoods(todayFoods)
        }
    }
}

struct RecentFoodList: View{
    @Environment(\.modelContext) private var modelContext: ModelContext
    @State private var uniqueFoods: [LocalProduct] = []
    
    private var descriptor: FetchDescriptor<LocalProduct>
    @State private var recentFoods: [LocalProduct] = []
    
    private var viewModel: HomeViewModel
    init(_ viewModel: HomeViewModel) {
        self.viewModel = viewModel
        
        self.descriptor = FetchDescriptor(
            sortBy: [SortDescriptor(\LocalProduct.dateAdded)]
        )
        descriptor.fetchLimit = 20
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
            do{
                recentFoods = try modelContext.fetch(descriptor)
            }catch {
                recentFoods = []
            }
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
            }
            .padding()
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
                    viewModel.sholdShowSearchProductSheet = false
                    viewModel.shouldShowPickProduct = true
                }
            }
            
        }
        .padding()
    }
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
                    Button(action: {
                        viewModel.foodSelected(food)
                    }){
                        Text(food.productName)
                    }.buttonStyle(.plain)
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
// NOTES kept only to remember custom backgrounds
//            VStack {
//                Text(monthFormatter.string(from: viewModel.selectedDay)).bold()
//                Text(dayFormatter.string(from: viewModel.selectedDay))
//            }
//            .padding()
//            .background(
//                Circle().fill(Color.gray.opacity(0.2))
//            )
