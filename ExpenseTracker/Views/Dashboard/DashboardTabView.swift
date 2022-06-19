//
//  DashboardTabView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct DashboardTabView: View {
    
    @StateObject private var viewModel: DashboardViewModel = .init()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 4) {
                if viewModel.totalExpenses != nil {
                    Text("Total expenses")
                        .font(.headline)
                    if viewModel.totalExpenses != nil {
                        Text(viewModel.totalExpenses!.formattedCurrencyText(currencySymbol: viewModel.currencySign))
                            .font(.largeTitle)
                    }
                }
            }
            
            if viewModel.categoriesSum != nil {
                
                if viewModel.totalExpenses != nil && viewModel.totalExpenses! > 0 {
                    PieChartView(
                        data: viewModel.categoriesSum!.map { ($0.sum, $0.category.color) },
                        style: Styles.pieChartStyleOne,
                        form: CGSize(width: 300, height: 240),
                        dropShadow: false
                    )
                    
                    HStack {
                        Text("Currency")
                        Picker(selection: $viewModel.currencyType, label: Text("Change to")) {
                            ForEach(CurrencyType.allCases) { type in
                                Image(systemName: type == .usd ? "dollarsign.circle" : "eurosign.circle")
                                    .tag(type)
                            }
                        }
                        .onChange(of: viewModel.currencyType){ value in
                            if value == .euro {
                                viewModel.updateCurrency()
                            } else {
                                viewModel.currencyRate = 1
                                viewModel.fetchTotalSums(rate: 1)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 130)
                        Spacer()
                    }
                    .padding()
                }
                
                Divider()

                if let list = viewModel.categoriesSum {
                    List {
                        Text("Breakdown").font(.headline)
                        ForEach(list) {
                            CategoryRowView(category: $0.category, sum: $0.sum, currencyType: $0.currencyType)
                        }
                    }
                    .background(Color.customColor(red: 218, green: 213, blue: 245).ignoresSafeArea())
                    .onAppear {
                        UITableView.appearance().backgroundColor = .clear
                    }
                }
            }
            if viewModel.totalExpenses == nil && viewModel.categoriesSum == nil {
                Spacer()
                Text("No expenses data\nPlease add your expenses from the logs tab")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding(.horizontal)
                Spacer()
            }
        }
        .background(Color.customColor(red: 218, green: 223, blue: 245).ignoresSafeArea())
        .overlay(
            ZStack {
                if viewModel.isLoading {
                    Color.black.opacity(0.1).ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(3)
                }
            }
        )
        .onAppear { viewModel.fetchTotalSums(rate: viewModel.currencyRate)}
        .padding(.top)
    }
}
