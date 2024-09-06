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
    
    
    var body: some View {
        NavigationStack {
            if(horizontalSizeClass == .compact && dynamicTypeSize <= .large){
                VStack {
                    DaysList()
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
                .navigationTitle("KiloCaloKen")
                
                if(viewModel.shouldShowLoading){
                    ProgressView()
                }
            }
            else {
                HStack{
                    VStack{
                        DaysList()
                        GroupBox(label: Label("Kcal Totali", systemImage: "flame")) {
                            Text(String(format: "%.2f", viewModel.totalKcal))
                        }
                        MacroNutrientsSummaryView()
                        if(viewModel.shouldShowLoading){
                            ProgressView()
                        }
                    }.padding()
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
