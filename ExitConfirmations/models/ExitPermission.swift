//
//  ExitConfirmation.swift
//  ExitConfirmations
//
//  Created by Mikhail Maevskiy on 23/05/2023.
//

import Foundation


struct ExitPermission: Identifiable, Codable{
    var id = ""
    var confirmed = false
    var exitDate = ""
    var exitTime = ""
    var goingTo = ""
    var group = ""
    var madrich_id = ""
    var madrich_name = ""
    var returnDate = ""
    var returnTime = ""
    var students_ids = ""
    var students_names = ""
    var confirmationLink = ""
}
