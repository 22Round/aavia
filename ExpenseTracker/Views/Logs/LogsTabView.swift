//
//  LogsTabView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct LogsTabView: View {
    
    @State private var searchText : String = ""
    @State private var searchBarHeight: CGFloat = 0
    @State private var sortType = SortType.date
    @State private var sortOrder = SortOrder.descending
    
    @State var selectedCategories: Set<Category> = Set()
    @State var isAddFormPresented: Bool = false
    
    private let context = CoreDataStack.shared.viewContext
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $searchText, keyboardHeight: $searchBarHeight, placeholder: "Search expenses")
                FilterCategoriesView(selectedCategories: $selectedCategories)
                Divider()
                SelectSortOrderView(sortType: $sortType, sortOrder: $sortOrder)
                Divider()
                
                let predicate = ExpenseLog.predicate(with: Array(selectedCategories), searchText: searchText)
                let sort = ExpenseLogSort(sortType: sortType, sortOrder: sortOrder).sortDescriptor
                LogListView(predicate: predicate, sortDescriptor: sort)
                    .environment(\.managedObjectContext, context)
                
            }
            .padding(.bottom, searchBarHeight)
            .sheet(isPresented: $isAddFormPresented) {
                LogFormView(context: CoreDataStack.shared.viewContext)
            }
            .navigationBarItems(trailing: Button(action: addTapped) { Text("Add") })
            .navigationBarTitle("Expense Logs", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func addTapped() {
        isAddFormPresented = true
    }
}
