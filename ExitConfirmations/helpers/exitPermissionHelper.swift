//
//  exitPermissionHelper.swift
//  ExitConfirmations
//
//  Created by Mikhail Maevskii on 03/01/2024.
//

import Foundation

extension ExitPermission {
    func isOutdated() -> Bool {
        var calendar = Calendar.current

        // Calculate a week earlier date
        if let weekEarlierDate = calendar.date(byAdding: .weekOfYear, value: -1, to: Date()) {
            guard let returnDate = self.returnDT else {
                // Assuming the exit permission is outdated if return date is not set
                return true
            }

            return weekEarlierDate > returnDate
        }

        // Handle error or return default value
        return false
    }
}

