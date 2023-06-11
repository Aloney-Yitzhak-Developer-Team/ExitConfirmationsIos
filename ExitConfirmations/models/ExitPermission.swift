//
//  ExitConfirmation.swift
//  ExitConfirmations
//
//  Created by Mikhail Maevskiy on 23/05/2023.
//

import Foundation


struct ExitPermission: Identifiable, Codable{
    let id: Int
    let students_names: String
    let students_ids: String
    let madrich_name: String
    let goingTo: String
    let exitTime: String
    let exitDate: String
    let returnTime: String
    let returnDate: String
    let group: String
    var confirmed: Bool
}
