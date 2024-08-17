//
//  ContentView.swift
//  KiloCaloKen
//
//  Created by Giovanni De Francesco on 07/08/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                DaysList(viewModel: viewModel)
                GroupBox(label: Label("Kcal Totali", systemImage: "flame")) {
                    Text(String(format: "%.2f", viewModel.totalKcal))
                }
                MacroNutrientsSummaryView(viewModel: viewModel)
                FoodList(viewModel: viewModel)
                Button("Add") {
                    viewModel.showAddSheet()
                }
            }
            .padding()
            .navigationTitle("KiloCaloKen")
            
            if(viewModel.shouldShowLoading){
                ProgressView()
            }
        }
        .sheet(isPresented: $viewModel.sholdShowAddSheet, content: {
            SearchProductSheetView(viewModel: viewModel)
        })
        .sheet(isPresented: $viewModel.shouldShowQuantitySheet, content: {
            QuantitySheetView(viewModel: viewModel)
        })
        .alert(isPresented: $viewModel.shouldShowAlert, content: {
            Alert(title: Text("Couldn't find EAN"))
        })
    }
}

#Preview {
    ContentView()
}
