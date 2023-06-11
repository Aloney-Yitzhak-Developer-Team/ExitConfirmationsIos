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
    
    private let db = Database.database()//variable to work with firestore
    
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
        let ref = Database.database().reference().child("Madrichs").child(Auth.auth().currentUser?.uid ?? "").child("givenPermissions")
        let ref2 = Database.database().reference().child("Confirmations")
        
        ref.observeSingleEvent(of: DataEventType.value, with: {snapshot in
            if let permissions = snapshot.value as? String{
                let permissionsIds = permissions.components(separatedBy: ",")
                
                for permissionId in permissionsIds{
                    ref2.child(permissionId).observeSingleEvent(of: DataEventType.value, with: {snapshot in
                        if let permissionData = snapshot.value as? [String:Any],
                            let students_names = permissionData["students_names"] as? String,
                        let students_ids = permissionData["students_ids"] as? String,
                        let madrich_name = permissionData["madrich_name"] as? String,
                        let goingTo = permissionData["goingTo"] as? String,
                        let exitTime = permissionData["exitTime"] as? String,
                        let exitDate = permissionData["exitDate"] as? String,
                        let returnTime = permissionData["returnTime"] as? String,
                        let returnDate = permissionData["returnDate"] as? String,
                           let group = permissionData["group"] as? String,
                        let confirmed = permissionData["confirmed"] as? Bool{

                            let exitPermission = ExitPermission(id:1, students_names: students_names, students_ids: students_ids, madrich_name: madrich_name, goingTo: goingTo, exitTime: exitTime, exitDate: exitDate, returnTime: returnTime, returnDate: returnDate, group: group, confirmed: confirmed)
                            self.permissions.append(exitPermission)
                        }
                    })
                }
            }
        })
    }
}

struct MadrichMainView_Previews: PreviewProvider {
    static var previews: some View {
        MadrichMainView()
    }
}
