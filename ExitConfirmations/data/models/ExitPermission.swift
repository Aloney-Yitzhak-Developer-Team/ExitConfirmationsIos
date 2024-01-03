//
//  ExitConfirmation.swift
//  ExitConfirmations
//
//  Created by Mikhail Maevskiy on 23/05/2023.
//

import Foundation


struct ExitPermission: Identifiable, Codable {
    var id: String?
    var status: String = ExitStatus.CREATED
    var destination: String = ""
    var madrich: Madrich?
    var student: Student?
    var exitDT: Date?
    var returnDT: Date?
    var actualReturnDT: Date?
    var confirmation: String?

    func getAsDictionary() -> [String: Any?] {
        var dictionary = [String: Any?]()

        dictionary[CHILD_EXIT_DATE] = exitDT?.getTimeString()
        dictionary[CHILD_EXIT_TIME] = exitDT?.getTimeString()
        dictionary[CHILD_DESTINATION] = destination
        dictionary[CHILD_GROUP] = student?.group
        dictionary[CHILD_MADRICH_ID] = madrich?.id
        dictionary[CHILD_RETURN_DATE] = returnDT?.getDateString()
        dictionary[CHILD_RETURN_TIME] = returnDT?.getTimeString()
        dictionary[CHILD_ACTUAL_RETURN_DATE] = ""
        dictionary[CHILD_ACTUAL_RETURN_TIME] = ""
        dictionary[CHILD_STUDENT_ID] = student?.id
        dictionary[CHILD_STUDENT_NAME] = student?.name
        dictionary[CHILD_CONFIRMATION_LINK] = confirmation
        dictionary[CHILD_STATUS] = status

        return dictionary
    }
}
