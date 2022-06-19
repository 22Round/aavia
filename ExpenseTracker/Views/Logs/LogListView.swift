//
//  LogListView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct LogListView: View {
    
    @State var logToEdit: ExpenseLog?
    
    @Environment(\.managedObjectContext)
    var context: NSManagedObjectContext
    
    @FetchRequest(
        entity: ExpenseLog.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ExpenseLog.date, ascending: false)
        ]
    )
    private var result: FetchedResults<ExpenseLog>
    
    init(predicate: NSPredicate?, sortDescriptor: NSSortDescriptor) {
        let fetchRequest = NSFetchRequest<ExpenseLog>(entityName: "ExpenseLog")
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        _result = FetchRequest(fetchRequest: fetchRequest)
    }
    
    var body: some View {
        List {
            ForEach(result) { (log: ExpenseLog) in
                LogListCellView(log: log) {
                    logToEdit = log
                }
            }
               
            .onDelete(perform: onDelete)
            .sheet(item: $logToEdit, onDismiss: {
                self.logToEdit = nil
            }) { (log: ExpenseLog) in
                LogFormView(
                    logToEdit: log,
                    context: self.context,
                    name: log.name ?? "",
                    note: log.note ?? "",
                    amount: log.amount?.doubleValue ?? 0,
                    category: Category(rawValue: log.category ?? "") ?? .food,
                    date: log.date ?? Date()
                )
            }
        }
        .background(Color.customColor(red: 183, green: 252, blue: 152).ignoresSafeArea())
        .onAppear {
            UITableView.appearance().backgroundColor = .clear
        }
        .overlay(noDataWarning, alignment: .center)
    }
    
    private func onDelete(with indexSet: IndexSet) {
        indexSet.forEach { index in
            let log = result[index]
            context.delete(log)
        }
        try? context.saveContext()
    }
    
    @ViewBuilder
    private var noDataWarning: some View {
        if result.isEmpty {
            Text("Expenses data is empty")
                .multilineTextAlignment(.center)
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 50)
        } else {
            EmptyView()
        }
    }
}

struct LogListView_Previews: PreviewProvider {
    static var previews: some View {
        let stack = CoreDataStack(containerName: "ExpenseTracker")
        let sortDescriptor = ExpenseLogSort(sortType: .date, sortOrder: .descending).sortDescriptor
        return LogListView(predicate: nil, sortDescriptor: sortDescriptor)
            .environment(\.managedObjectContext, stack.viewContext)
    }
}
