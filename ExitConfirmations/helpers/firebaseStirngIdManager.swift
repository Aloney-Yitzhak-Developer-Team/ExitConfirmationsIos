//
//  firebaseStirngIdManager.swift
//  ExitConfirmations
//
//  Created by Mikhail Maevskii on 03/01/2024.
//

import Foundation

extension String {
    func removeEPId(id: String) -> String {
        var ids = self.components(separatedBy: ",")
        ids.removeAll { $0 == id }

        return buildString(ids: ids)
    }

    func addEPId(id: String) -> String {
        if self.isEmpty {
            return id
        } else {
            return "\(self),\(id)"
        }
    }

    private func buildString(ids: [String]) -> String {
        return ids.joined(separator: ",")
    }
}
