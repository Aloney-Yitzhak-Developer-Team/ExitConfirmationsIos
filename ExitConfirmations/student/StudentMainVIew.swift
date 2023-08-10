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
    @State private var isUserLoggedIn = true
    
    var body: some View {
        if (!isUserLoggedIn){
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
                        fetchName()
                    }
                
                Spacer()
                
                Button("logout", action: {
                    do{
                        isUserLoggedIn = false
                        try Auth.auth().signOut()
                    }catch let error{
                        print(error.localizedDescription)
                    }
                })
                
                Spacer()
                
                Text("4י")
                    .font(.system(size: 20))
                    .padding(.trailing, 25)
            }
                        
//            List(data){ conf in
//                Text(conf.name)
//            }.onAppear{
//                fetchData()
//            }
        }
    }
    
    func fetchName(){
        Database.database().reference().child("Students").child(Auth.auth().currentUser!.uid)
            .observeSingleEvent(of: .value, with: { snapshot in
//                self.name=(value["name"] ?? "") as String
                if let value = snapshot.value as? [String: String]{
                    self.name = value["name"] ?? "Error getting the name"
                }else{
                    self.name = "Error getting the name"
                }
            })
    }
    
    func fetchData(){
        data.removeAll()
        
    }
}

struct StudentMainView_Previews: PreviewProvider {
    static var previews: some View {
        StudentMainView()
    }
}
