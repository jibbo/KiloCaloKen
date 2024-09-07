//
//  ContentView.swift
//  KiloCaloKen
//
//  Created by Giovanni De Francesco on 07/08/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @EnvironmentObject private var viewModel: HomeViewModel
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    private let monthFormatter = DateFormatter()
    private let dayFormatter = DateFormatter()
    
    init(){
        self.monthFormatter.dateFormat = "MMM"
        self.dayFormatter.dateFormat = "dd"
    }
    
    
    var body: some View {
        NavigationStack {
            if(horizontalSizeClass == .compact && dynamicTypeSize <= .large){
                VStack {
                    HStack{
                        Text("KiloKen").font(.largeTitle.bold())
                        Spacer()
                        DatePicker(
                            selection: $viewModel.selectedDay,
                            displayedComponents: [.date],
                            label: {  }
                        )
                    }
                    GroupBox(label: Label("Kcal Totali", systemImage: "flame")) {
                        Text(String(format: "%.2f", viewModel.totalKcal))
                    }
                    MacroNutrientsSummaryView()
                    FoodList(viewModel)
                    Button {
                        viewModel.showAddSheet()
                    } label: {
                        Image(systemName: "plus")
                            .padding()
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.accentColor))
                    }
                }
                .padding()
                
                if(viewModel.shouldShowLoading){
                    ProgressView()
                }
            }
            else {
                HStack{
                    VStack{
                        GroupBox(label: Label("Kcal Totali", systemImage: "flame")) {
                            Text(String(format: "%.2f", viewModel.totalKcal))
                        }
                        MacroNutrientsSummaryView()
                        if(viewModel.shouldShowLoading){
                            ProgressView()
                        }
                    }.padding()
                        .navigationTitle("KiloCaloKen")
                        .toolbar{
                            ToolbarItem(placement: .topBarTrailing){
                                Button(action: {}){
                                    Text("puppa")
                                }
                            }
                        }
                    FoodList(viewModel)
                    Button {
                        viewModel.showAddSheet()
                    } label: {
                        Image(systemName: "plus")
                            .padding()
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.accentColor))
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $viewModel.sholdShowAddSheet, content: {
            SearchProductSheetView()
        })
        .sheet(isPresented: $viewModel.shouldShowQuantitySheet, content: {
            QuantitySheetView()
        })
        .sheet(isPresented: $viewModel.shouldShowPickProduct, content: {
            PickProductSheetView()
        })
        .alert(isPresented: $viewModel.shouldShowAlert, content: {
            Alert(title: Text("Couldn't find EAN"))
        })
    }
}

#Preview {
    ContentView()
        .environmentObject(
            HomeViewModel(modelContext: nil)
        )
}
