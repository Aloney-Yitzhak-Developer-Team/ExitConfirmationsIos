//
//  MainActivity.swift
//  ExitConfirmations
//
//  Created by Mikhail Maevskiy on 23/05/2023.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct StudentMainView: View {
    
    @State private var data: [ExitPermission] = []
    @State private var name = "Mikhail"
    @State private var isUserSignedIn = true
    @State private var permissions: [ExitPermission] = []
    
    var body: some View {
        if (!isUserSignedIn){
            StartView()
        }else{
            content
        }
    }
    
    var content: some View{
        VStack{
            
            HStack{
                Text(name)
                    .font(.system(size: 20))
                    .padding(.leading, 25)
                    .onAppear{
                        fetchStudentInfo()
                    }
                
                Spacer()
                
                Text(NSLocalizedString("student", comment: ""))
                    .font(.system(size: 20))
                    .padding(.trailing, 25)
            }
                        
            NavigationStack{
                List(self.permissions){ conf in
                    NavigationLink(destination: PermissionInfoBottomSheet(exitPermission: conf)){
                        VStack{
                            HStack{
                                
                                if (conf.confirmed){
                                    Image("permission_confirmed_icon")
                                }
                                
                                Spacer()
                                
                                
                                VStack{
                                    Text(conf.students_names)
                                        .foregroundStyle(Color.black)
                                    Text(conf.group)
                                        .foregroundStyle(Color.black)
                                }
                                
                                Spacer()
                                
                                Text("\(conf.exitTime) \(conf.exitDate)")
                                    .foregroundStyle(Color.black)
                                
                            }
                        }
                    }
                }.onAppear{
                    fetchExitPermissions()
                }
            }
        }.refreshable {
            fetchStudentInfo()
            fetchExitPermissions()
            
        }
    }
    
    func fetchStudentInfo(){
        Database.database().reference().child("Students").child(Auth.auth().currentUser!.uid)
            .observeSingleEvent(of: .value, with: { snapshot in
                if let value = snapshot.value as? [String: String]{
                    self.name = value["name"] ?? "Error getting the name"
                }else{
                    self.name = "Error getting the name"
                }
            })
    }
    
    func fetchExitPermissions() {
        
        if Auth.auth().currentUser?.uid==nil{
            isUserSignedIn = false
        }
        Database.database().reference().child("Students").child(Auth.auth().currentUser?.uid ?? "").child("exit_permissions").observeSingleEvent(of: DataEventType.value, with: { snapshot1  in
            Database.database().reference().observeSingleEvent(of: DataEventType.value, with: { snapshot in
                guard snapshot.hasChild("ExitPermissions") else {
                    return
                }
                
                if let exit_permissions = snapshot1.value as? String{
                    if exit_permissions.isEmpty{
                        return
                    }
                    else{
                        var exitPermissions1 : Array<ExitPermission> = Array()
                        var exitPermissions2 : Array<Substring> = exit_permissions.split(separator: ",")
                        
                        for exitPermissionId in exitPermissions2{
                            if (!snapshot.childSnapshot(forPath: "ExitPermissions").childSnapshot(forPath: String(exitPermissionId)).exists()){
                                if let index = exitPermissions2.firstIndex(of: exitPermissionId){
                                    exitPermissions2.remove(at: index)
                                }
                                continue
                            }
                            
                            if let data = snapshot.childSnapshot(forPath:"ExitPermissions").childSnapshot(forPath: String(exitPermissionId)).value as? [String: Any]{
                                
                                let confirmed = data["confirmed"] as? Bool ?? false
                                let exitDate = String(data["exitDate"] as? String ?? "false")
                                let exitTime = String(data["exitTime"] as? String ?? "false")
                                let goingTo = String(data["goingTo"] as? String ?? "false")
                                let group = String(data["group"] as? String ?? "false")
                                let madrich_id = String(data["madrich_id"] as? String ?? "false")
                                let madrich_name = String(data["madrich_name"] as? String ?? "false")
                                let returnDate = String(data["returnDate"] as? String ?? "false")
                                let returnTime = String(data["returnTime"] as? String ?? "false")
                                let students_ids = String(data["students_ids"] as? String ?? "false")
                                let students_names = String(data["students_names"] as? String ?? "false")
                                let confirmationLink = String(data["confirmationLink"] as? String ?? "false")
                                
                                //if the date is earlier than one week age
                                exitPermissions1.append(ExitPermission(id: String(exitPermissionId), confirmed: confirmed, exitDate:exitDate, exitTime: exitTime, goingTo: goingTo, group: group, madrich_id: madrich_id, madrich_name: madrich_name, returnDate: returnDate, returnTime: returnTime, students_ids: students_ids, students_names: students_names, confirmationLink: confirmationLink))
                            }
                        }
                        var madrichExitPermissions = ""
                        for exitPermissionId in exitPermissions2 {
                            if madrichExitPermissions.isEmpty{
                                madrichExitPermissions = String(exitPermissionId)
                            }else{
                                madrichExitPermissions += ",\(exitPermissionId)"
                            }
                        }
                        Database.database().reference().child("Madrichs").child(Auth.auth().currentUser?.uid ?? "").child("exit_permissions").setValue(madrichExitPermissions)
                        
                        exitPermissions1.reverse()
                        
                        permissions = exitPermissions1
                    }
                }
                
                
            })
        })
    }
}

struct StudentMainView_Previews: PreviewProvider {
    static var previews: some View {
        StudentMainView()
    }
}
