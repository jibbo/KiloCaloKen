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
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
        NavigationStack {
            if(horizontalSizeClass == .compact && verticalSizeClass == .regular){
                VStack {
                    Header()
                    MacroNutrientsSummaryView()
                    FoodSection()
                }.padding()
            }
            else {
                HStack{
                    VStack{
                        Header()
                        MacroNutrientsSummaryView()
                    }
                    FoodSection()
                }
                .padding()
            }
        }
        .sheet(isPresented: $viewModel.sholdShowSearchProductSheet, onDismiss: {
            viewModel.sholdShowSearchProductSheet = false
        }, content: {
            SearchProductSheetView()
        })
        .sheet(isPresented: $viewModel.shouldShowQuantitySheet,onDismiss: {
            viewModel.shouldShowQuantitySheet = false
        }, content: {
            QuantitySheetView()
        })
        .sheet(isPresented: $viewModel.shouldShowPickProduct,onDismiss: {
            viewModel.shouldShowPickProduct = false
        }, content: {
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
