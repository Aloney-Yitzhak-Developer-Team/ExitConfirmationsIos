//
//  StudentsViewModel.swift
//  ExitConfirmations
//
//  Created by Mikhail Maevskii on 14/08/2023.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseDatabase
import FirebaseDatabaseSwift

class CreateExitPermissionBS_viewmodel : ObservableObject{
    @Published var students : [Student] = []
    @Published public var madrichName = ""
    
    func loadAllStudents(){
        students.removeAll()
        Database.database().reference().observeSingleEvent(of: DataEventType.value, with: {snapshot in
            for child in snapshot.childSnapshot(forPath: "Groups").children{
                if let groupSnapshot = child as? DataSnapshot,
                   let groupStudentsStr = groupSnapshot.value as? String{
                    
                    let groupStudents = groupStudentsStr.split(separator: ",")
                    for studentId in groupStudents{
                        if let student_name = snapshot.childSnapshot(forPath: "Students/\(studentId)/name").value as? String {
                            self.students.append(Student(id: String(studentId), name: student_name, group: groupSnapshot.key))
                        }
                    }
                    
                }
            }
        })
    }
    
    func loadStudentsFromOneGroup(){
        students.removeAll()
        Database.database().reference().observeSingleEvent(of: DataEventType.value, with: {snapshot in
            if let group = snapshot.childSnapshot(forPath: "Madrichs").childSnapshot(forPath: Auth.auth().currentUser!.uid).childSnapshot(forPath: "group").value as? String{
                
                print (group)
                
                if let groupStudentsStr = snapshot.childSnapshot(forPath: "Groups/\(group)").value as? String{
                    let groupStudents = groupStudentsStr.split(separator: ",")
                    for studentId in groupStudents{
                        if let student_name = snapshot.childSnapshot(forPath: "Students/\(studentId)/name").value as? String{
                            self.students.append(Student(id: String(studentId), name: student_name, group: group))
                        }
                    }
                }
            }
        })
    }
    
    func studentSelectionChange(student: Student){
        if let index = students.firstIndex(where: {$0.id == student.id}){
            if students[index].selected == false{
                students[index].selected = true
            }else{
                students[index].selected = false
            }
        }
    }
    
    func getGroups() -> String{
        var groups : Set<String> = []
        for student in students{
            groups.insert(student.group)
        }
        var groupsStr = ""
        for grp in groups{
            if (groupsStr.isEmpty){
                groupsStr = grp
            }else{
                groupsStr=",\(grp)"
            }
        }
        
        return groupsStr
    }
    
    public func getMadrichName(){
        Database.database().reference().child("Madrichs").child(Auth.auth().currentUser?.uid ?? "").child("name").observeSingleEvent(of: DataEventType.value, with: {snapshot in
            if let name = snapshot.value as? String{
                self.madrichName = name
            }
        })
    }
    
    public func setExitPermissionToStudents(exitPermissionId: String){
        Database.database().reference().child("Students").observeSingleEvent(of: DataEventType.value, with: {snapshot in
            for student in self.students {
                if var student_exit_permissions = snapshot.childSnapshot(forPath: "\(student.id)/exit_permissions").value as? String{
                    if student_exit_permissions.isEmpty{
                        student_exit_permissions = exitPermissionId
                    }else{
                        student_exit_permissions+=",\(exitPermissionId)"
                    }
                    
                    Database.database().reference().child("Students").child(student.id).child("exit_permissions").setValue(student_exit_permissions)
                }
            }
        })
    }
    
    public func setExitPermissionToMadrich(exitPermissionId: String, madrichId: String){
        Database.database().reference().child("Madrichs").child(madrichId).child("exit_permissions")
            .observeSingleEvent(of: DataEventType.value, with: {snapshot in
                if var madrich_exit_permissions = snapshot.value as? String{
                    if madrich_exit_permissions.isEmpty{
                        madrich_exit_permissions = exitPermissionId
                    }else{
                        madrich_exit_permissions += ",\(exitPermissionId)"
                    }
                    
                    Database.database().reference().child("Madrichs").child(madrichId).child("exit_permissions").setValue(madrich_exit_permissions)
                }
            })
    }
}
