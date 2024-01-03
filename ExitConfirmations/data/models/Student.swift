//
//  Student.swift
//  ExitConfirmations
//
//  Created by Mikhail Maevskii on 12/08/2023.
//

import Foundation

struct Student : Identifiable, Codable{
    let id: String
    let name: String
    let group: String
    let profileImageUrl: String
}
