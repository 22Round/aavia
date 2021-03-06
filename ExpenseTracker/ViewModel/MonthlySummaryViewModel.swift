//
//  MonthlySummaryViewModel.swift
//  ExpenseTracker
//
//  Created by Vakhtangi Beridze on 19/6/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Foundation
import CoreData

class MonthlySummaryViewModel: ObservableObject {
    
    @Published var minSelectedDate: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? .init()
    @Published var maxSelectedDate: Date = .init()
    @Published var filteredData: [ExpenseLog] = []
    @Published var listId: UUID = .init()
    
    var startDate: Date?
    var endDate: Date?
    
    func geRangeByDate(startDate: Date, endDate: Date) {
        let request = NSFetchRequest<ExpenseLog>(entityName: "ExpenseLog")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ExpenseLog.date, ascending: false)]
        if let predicate = filter(startDate: startDate, endDate: endDate) {
            request.predicate = predicate
        }
        do {
            try filteredData = CoreDataStack.shared.viewContext.fetch(request)
            listId = UUID()
        } catch {
            print("Error getting data. \(error.localizedDescription)")
        }
    }
    
    private func filter(startDate : Date, endDate: Date) -> NSPredicate? {
        var predicates = [NSPredicate]()
        var dayComponent = DateComponents()
        dayComponent.day = -1
        let dayBeforeStartDate = Calendar.current.date(byAdding: dayComponent, to: startDate)
        let to: NSDate = endDate as NSDate
        guard let from = dayBeforeStartDate as NSDate? else{ return nil }
        
        predicates.append(NSPredicate(format: "(date <= %@)", to))
        predicates.append(NSPredicate(format: "(date >= %@)", from))
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
}
