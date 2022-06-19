//
//  MonthlySummaryTabView.swift
//  ExpenseTracker
//
//  Created by Vakhtangi Beridze on 19/6/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct MonthlySummaryTabView: View {
    @ObservedObject private var viewModel: MonthlySummaryViewModel = .init()
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Select Filter Range")
                        .font(.headline)
                    HStack {
                        Text("From:")
                        DatePicker(
                            "Pick a date",
                            selection: $viewModel.minSelectedDate,
                            displayedComponents: [.date])
                        Spacer()
                        Text("to:")
                        DatePicker(
                            "Pick a date",
                            selection: $viewModel.maxSelectedDate,
                            displayedComponents: [.date])
                        Spacer()
                    }
                    HStack {
                        Button {
                            viewModel.geRangeByDate(startDate: viewModel.minSelectedDate, endDate: viewModel.maxSelectedDate)
                        } label: {
                            Text("Submit changes")
                        }
                        .font(.headline)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(10)
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                Divider()
                List {
                    ForEach(viewModel.filteredData) { (log: ExpenseLog) in
                        LogListCellView(log: log)
                    }
                }
                .id(viewModel.listId)
                .background(Color.customColor(red: 238, green: 92, blue: 41).ignoresSafeArea())
                .onAppear {
                    UITableView.appearance().backgroundColor = .clear
                }
                .overlay(noDataWarning, alignment: .center)
            }
            .navigationBarTitle("Monthly Summary", displayMode: .inline)
            .labelsHidden()
            .onAppear {
                viewModel.geRangeByDate(startDate: viewModel.minSelectedDate, endDate: viewModel.maxSelectedDate)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    @ViewBuilder
    private var noDataWarning: some View {
        if viewModel.filteredData.isEmpty {
            Text("Filter data is empty")
                .multilineTextAlignment(.center)
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 50)
        } else {
            EmptyView()
        }
    }
}
