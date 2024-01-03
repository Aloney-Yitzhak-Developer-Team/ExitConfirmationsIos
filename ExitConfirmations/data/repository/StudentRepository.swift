//
//  StudentRepository.swift
//  ExitConfirmations
//
//  Created by Mikhail Maevskii on 03/01/2024.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct StudentRepository{
    
    let exitPermissionRepository = ExitPermissionRepository()
    
    func loadStudent (id: String, completion: @escaping (Student?) -> Void){
        let studentRef = databaseRef.child(NODE_STUDENTS).child(id)
        
        studentRef.observeSingleEvent(of: .value, with: {(snapshot) in
            guard snapshot.exists(),
                  let studentSnapshot = snapshot.value as? [String: Any] else{
                      completion(nil)
                      return
                  }
            
            let id = id
            
            guard let name = studentSnapshot[CHILD_NAME] as? String,
            let group = studentSnapshot[CHILD_GROUP] as? String,
            let profileImageUrl = studentSnapshot[CHILD_PROFILE_IMAGE] as? String
            else{
                completion(nil)
                return
            }
            
            let student = Student(id: id, name: name, group: group, profileImageUrl: profileImageUrl)
            
            completion(student)
            return
            
        })
    }
    
    func loadAllStudents(completion: @escaping ([Student]) -> Void) {
        let studentsRef = databaseRef.child(NODE_STUDENTS)

        studentsRef.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists() else {
                completion([])
                return
            }

            var students = [Student]()

            for case let childSnapshot as DataSnapshot in snapshot.children {
                self.loadStudent(id: childSnapshot.key) { (student) in
                    if let student = student {
                        students.append(student)
                    }

                    if students.count == snapshot.childrenCount {
                        completion(students)
                    }
                }
            }
        }
    }
    
    func addExitPermission(studentId: String, id: String){
        let studentEpRef = databaseRef.child(NODE_STUDENTS).child(studentId).child(CHILD_EXIT_PERMISSIONS)
        
        studentEpRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if var studentExitPermissions = snapshot.value as? String{
                studentExitPermissions = studentExitPermissions.addEPId(id: id)
                
                studentEpRef.setValue(studentExitPermissions)
            }
        })
    }
    
    func loadExitPermissions(studentId: String, completion: @escaping ([ExitPermission]) -> Void){
        let studentsRef = databaseRef.child(NODE_STUDENTS).child(studentId).child(CHILD_EXIT_PERMISSIONS)

            studentsRef.observeSingleEvent(of: .value) { (snapshot) in
                guard snapshot.exists() else {
                    completion([])
                    return
                }

                let exitPermissionsStr = snapshot.value as? String ?? ""
                exitPermissionRepository.loadExitPermissions(ids: exitPermissionsStr, completion: { (personalExitPermissions, updatedEpIds) in
                    
                    studentsRef.setValue(updatedEpIds)
                    
                    completion(personalExitPermissions)
                })
            }
    }
}
