//
//  ExitConfirmation.swift
//  ExitConfirmations
//
//  Created by Mikhail Maevskiy on 23/05/2023.
//

import Foundation


struct ExitPermission: Identifiable, Codable{
    let id: String
    let confirmed : Bool
    let exitDate: String
    let exitTime: String
    let goingTo : String
    let group : String
    let madrich_id : String
    let madrich_name : String
    let returnDate : String
    let returnTime : String
    let students_ids : String
    let students_names : String
    let confirmationLink : String
}
