//
//  GroupRepository.swift
//  ExitConfirmations
//
//  Created by Mikhail Maevskii on 03/01/2024.
//

import Foundation
import FirebaseDatabaseSwift
import FirebaseDatabase
import FirebaseCore

struct GroupRepository{
    
    let databaseRef = Database.database().reference()
    let exitPermissionRepository = ExitPermissionRepository()
    let studentRepository = StudentRepository()

        func loadGroupExitPermissions(groupId: String, completion: @escaping ([ExitPermission]) -> Void) {
            let exitPermissionsRef = databaseRef.child(NODE_GROUPS).child(groupId).child(CHILD_EXIT_PERMISSIONS)

            exitPermissionsRef.observeSingleEvent(of: .value) { (snapshot) in
                guard snapshot.exists(),
                      let exitPermissionsStr = snapshot.value as? String else {
                    completion([])
                    return
                }

                exitPermissionRepository.loadExitPermissions(ids: exitPermissionsStr, completion: { (exitPermissions, updatedEpStr) in
                    // Updating the group's exit permissions
                    self.databaseRef.child(NODE_GROUPS).child(groupId).child(CHILD_EXIT_PERMISSIONS).setValue(updatedEpStr)

                    completion(exitPermissions)
                })
            }
        }

        func loadGroupStudents(groupId: String, completion: @escaping ([Student]) -> Void) {
            let studentsRef = databaseRef.child(NODE_GROUPS).child(groupId).child(CHILD_STUDENTS)

            studentsRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard snapshot.exists(),
                      let studentsStr = snapshot.value as? String else {
                    completion([])
                    return
                }

                let studentsIds = studentsStr.components(separatedBy: ",")

                var students = [Student]()
                for studentId in studentsIds {
                    studentRepository.loadStudent(id: studentId) { student in
                        if let student = student {
                            students.append(student)
                        }

                        if students.count == studentsIds.count {
                            completion(students)
                        }
                    }
                }
            })
        }

        func addExitPermissions(exitPermissions: [ExitPermission], groupId: String) {
            let groupExitPermissionsRef = databaseRef.child(NODE_GROUPS).child(groupId).child(CHILD_EXIT_PERMISSIONS)
            
            groupExitPermissionsRef.observeSingleEvent(of: .value, with: {
                (snapshot) in
                
                guard snapshot.exists(),
                      var groupExitPermissionsStr = snapshot.value as? String else {
                    return
                }

                for exitPermission in exitPermissions {
                    exitPermissionRepository.addExitPermission(exitPermission: exitPermission) { id in
                        // Adding exit permission id to group exit permissions
                        groupExitPermissionsStr = groupExitPermissionsStr.addEPId(id:id)

                        // Updating group exit permissions
                        self.databaseRef.child(NODE_GROUPS).child(groupId).child(CHILD_EXIT_PERMISSIONS).setValue(groupExitPermissionsStr)

                        // Adding exit permission for the student
                        if let studentId = exitPermission.student?.id {
                            studentRepository.addExitPermission(studentId: studentId, id: id)
                        }
                    }
                }
            })
        }
}
