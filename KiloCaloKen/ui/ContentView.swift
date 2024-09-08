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
    
    private let monthFormatter = DateFormatter()
    private let dayFormatter = DateFormatter()
    
    init(){
        self.monthFormatter.dateFormat = "MMM"
        self.dayFormatter.dateFormat = "dd"
    }
    
    
    fileprivate func Header() -> HStack<TupleView<(Text, Spacer, DatePicker<EmptyView>)>> {
        return HStack{
            Text("KiloKen").font(.largeTitle.bold())
            Spacer()
            DatePicker(
                selection: $viewModel.selectedDay,
                displayedComponents: [.date],
                label: {  }
            )
        }
    }
    
    fileprivate func FoodSection() -> ZStack<TupleView<(FoodList, Button<some View>)>> {
        return ZStack(alignment: .bottomTrailing){
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
    
    var body: some View {
        NavigationStack {
            if(horizontalSizeClass == .compact && verticalSizeClass == .regular){
                VStack {
                    Header()
                    GroupBox(label: Label("Kcal Totali", systemImage: "flame")) {
                        Text(String(format: "%.2f", viewModel.totalKcal))
                    }
                    MacroNutrientsSummaryView()
                    FoodSection()
                }.padding()
            }
            else {
                HStack{
                    VStack{
                        Header()
                        GroupBox(label: Label("Kcal Totali", systemImage: "flame")) {
                            Text(String(format: "%.2f", viewModel.totalKcal))
                        }
                        MacroNutrientsSummaryView()
                    }
                    FoodSection()
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
