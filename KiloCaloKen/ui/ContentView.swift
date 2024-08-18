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
                DaysList(viewModel)
                GroupBox(label: Label("Kcal Totali", systemImage: "flame")) {
                    Text(String(format: "%.2f", viewModel.totalKcal))
                }
                MacroNutrientsSummaryView(viewModel)
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
        .sheet(isPresented: $viewModel.sholdShowAddSheet, content: {
            SearchProductSheetView(viewModel)
        })
        .sheet(isPresented: $viewModel.shouldShowQuantitySheet, content: {
            QuantitySheetView(viewModel)
        })
        .sheet(isPresented: $viewModel.shouldShowPickProduct, content: {
            PickProductSheetView(viewModel)
        })
        .alert(isPresented: $viewModel.shouldShowAlert, content: {
            Alert(title: Text("Couldn't find EAN"))
        })
    }
}

#Preview {
    ContentView()
}
