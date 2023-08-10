//
//  MadrichMainView.swift
//  ExitConfirmations
//
//  Created by Mikhail Maevskiy on 23/05/2023.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseDatabase
import FirebaseDatabaseSwift

struct MadrichMainView: View {
    
    @State private var selected = 0
    
    private let db = Database.database()//variable to work with realtime database
    
    @State private var isUserSignedIn = true
    @State private var madrichName = "name"
    @State private var group = "group"
    @State private var permissions: [ExitPermission] = []
    
    var body: some View {
        if (!isUserSignedIn){
            StartView()
        }else{
            content
        }
    }
    
    var content : some View{
        ZStack{
            VStack{
                HStack {
                    Text(madrichName)
                        .font(.system(size:20))
                        .onAppear{
                            fetchMadrichInfo()
                        }
                        .padding(.leading, 20)
                    
                    Spacer()
                    
                    Button("logout", action: {
                        do{
                            isUserSignedIn = false
                            try Auth.auth().signOut()
                        }catch let error{
                            print(error.localizedDescription)
                        }
                        
                    })
                    
                    Spacer()
                    
                
                    
                    Text(group)
                        .font(.system(size:20))
                        .padding(.trailing, 20)
                }
                Divider()
                
                List(self.permissions){ conf in
                    VStack{
                        HStack{
                            
                            if (conf.confirmed){
                                Image("permission_confirmed_icon")
                            }
                            
                            Spacer()
                            
                            VStack{
                                Text(conf.students_names)
                                Text(conf.group)
                            }
                            
                            Spacer()
                            
                            Text("\(conf.exitTime) \(conf.exitDate)")
                        }
                    }
                }.onAppear{
                    fetchStudents()
                }
                
                
                
                Spacer()
            }
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    
                    Button(action:{
                        print("add btn clicked")
                    }){
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding(15)
                    }.background(Color("AdditionalColor"))
                        .clipShape(Circle())
                        .padding(.trailing, 30)
                }.padding(.bottom, 50)
            }
        }.refreshable {
            fetchMadrichInfo()
            fetchStudents()
        }
    }
    
    
    func fetchMadrichInfo(){
        db.reference().child("Madrichs").child(Auth.auth().currentUser?.uid ?? "").observeSingleEvent(of: DataEventType.value, with: { snapshot in
            if let madrichInfo = snapshot.value as? [String:String]{
                if let name = madrichInfo["name"]{
                    madrichName = name
                }
                if let group = madrichInfo["group"]{
                    self.group = group
                }
            }
        })
    }
    
    func fetchStudents() {
        if Auth.auth().currentUser?.uid==nil{
            isUserSignedIn = false
        }
        Database.database().reference().child("Madrichs").child(Auth.auth().currentUser?.uid ?? "").child("exit_permissions").observeSingleEvent(of: DataEventType.value, with: { snapshot1  in
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
                                
                                let confirmed = Bool(data["confirmed"] as? String ?? "false")
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
                                
                                let dateString = "\(returnTime) \(returnDate)"
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "HH:mm dd.MM.yyyy"
                                guard let date = dateFormatter.date(from: dateString) else {
                                    //if the date is in wrong format
                                    
                                    return
                                }

                                let currentDate = Date()

                                let calendar = Calendar.current
                                let oneWeekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: currentDate)!

                                let result = calendar.compare(date, to: oneWeekAgo, toGranularity: .day)
                                if result == .orderedDescending {
                                    //if the date is earlier than one week age
                                    exitPermissions1.append(ExitPermission(id: String(exitPermissionId), confirmed: confirmed ?? false, exitDate:exitDate, exitTime: exitTime, goingTo: goingTo, group: group, madrich_id: madrich_id, madrich_name: madrich_name, returnDate: returnDate, returnTime: returnTime, students_ids: students_ids, students_names: students_names, confirmationLink: confirmationLink))
                                } else {
                                    //if the date is equal or later than one week ago
                                    Database.database().reference().child("ExitPermissions").child(String(exitPermissionId)).removeValue()
                                    
                                    if let index = exitPermissions2.firstIndex(of: exitPermissionId){
                                        exitPermissions2.remove(at: index)
                                    }
                                }
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
                        
                        permissions = exitPermissions1
                    }
                }
                
                
            })
        })
    }
}

struct MadrichMainView_Previews: PreviewProvider {
    static var previews: some View {
        MadrichMainView()
    }
}
