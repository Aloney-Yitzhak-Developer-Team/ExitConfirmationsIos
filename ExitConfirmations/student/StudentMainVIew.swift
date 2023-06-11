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
    let db = Firestore.firestore()
    
    var body: some View {
        VStack{
            
            HStack{
                
                
                
                Text(name)
                    .font(.system(size: 20))
                    .padding(.leading, 25)
                    .onAppear{
                        fetchName()
                    }
                
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
        
        //TODO: fetch all data from realtime database
        
        print(Auth.auth().currentUser!.uid)
        
        Database.database().reference().child("Madrichs").child(Auth.auth().currentUser!.uid)
            .observeSingleEvent(of: .value, with: { snapshot in
//                self.name=(value["name"] ?? "") as String
                if let value = snapshot.value as? [String: String]{
                    self.name = value["name"] ?? "nameee"
                }else{
                    self.name = "didn't get"
                }
//                print("Value \(value)")
            })
        
//        Database.database().reference().child("jj").observeSingleEvent(of: .value, with: { snapshot in
//            self.name = snapshot.value as! String
//        })
        print("Hello")
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
