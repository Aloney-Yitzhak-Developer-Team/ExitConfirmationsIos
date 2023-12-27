//
//  ContentView.swift
//  ExitConfirmations
//
//  Created by Mikhail Maevskiy on 23/05/2023.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth

struct StartView: View {
    
    @State private var loggedIn = false
    @State private var accountType = 0
    @State private var isLoginBottomSheetRequested = false
    @State private var isRegisterBottomSheetRequested = false
    
    var body: some View {
        if (loggedIn){
            switch (accountType){
            case 1:
                MadrichMainView()
                
            case 2:
                StudentMainView()
                
            case 3:
                GuardMainView()
                
            default:
                MadrichMainView()
            }
        }else{
            startViewContent
        }
    }
    
    var startViewContent : some View{
        VStack {
            
            Spacer()
            
            Image("aloney_yitzhak_logo")
            
            Spacer()
            
            Button(action: {
                isLoginBottomSheetRequested.toggle()
            }){
                Text(NSLocalizedString("login", comment: ""))
                    .padding(.bottom, 15)
                    .padding(.top, 15)
                    .padding(.leading, 50)
                    .padding(.trailing, 50)
                    .foregroundColor(.white)
            }.background(Color.blue)
                .cornerRadius(12)
                .sheet(isPresented: $isLoginBottomSheetRequested){
                    LoginBottomSheetView(isPresented: $isLoginBottomSheetRequested,
                        loggedIn: $loggedIn, accountType: $accountType)
                }
            
            Spacer()
        }
        .padding()
        .onAppear{
            Auth.auth().addStateDidChangeListener{ auth, user in
                if user != nil{
                    Database.database().reference().child("Students").observeSingleEvent(of: DataEventType.value, with: { snapshot1 in
                        if (snapshot1.hasChild(user?.uid ?? "")){
                            accountType = 2
                            loggedIn.toggle()
                        }else{
                            Database.database().reference().child("Madrichs").observeSingleEvent(of: DataEventType.value, with: { snapshot in
                                if (snapshot.hasChild(user?.uid ?? "")){
                                    accountType = 1
                                    loggedIn.toggle()
                                }else{
                                    Database.database().reference().child("Guards").observeSingleEvent(of: DataEventType.value, with: { snapshot2 in
                                        if (snapshot2.hasChild(user?.uid ?? "")){
                                            accountType = 3
                                            loggedIn.toggle()
                                        }
                                    })
                                }
                            })
                        }
                    })
                    
                }
            }
        }
    }
}

struct LoginBottomSheetView: View {
    @Binding var isPresented: Bool
    @Binding var loggedIn : Bool
    @Binding var accountType: Int
    @State private var email = ""
    @State private var password = ""
    
    var body : some View{
        content
    }
    
    var content : some View{
        VStack (spacing: 20){
            
            Spacer()
            
            Text(NSLocalizedString("login", comment: ""))
                .foregroundColor(.black)
                .font(.system(size: 30))
            
            Spacer()
            
            HStack (spacing: 20){
                
                Image("email_icon")
                    .foregroundColor(.gray)
                
                TextField(NSLocalizedString("email", comment: ""), text: $email)
                    .padding(.leading, 5)
                    .autocapitalization(.none)
                    .textFieldStyle(.automatic)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0, y: 2)
            .padding(.leading, 15)
            .padding(.trailing, 15)
            
            HStack (spacing: 20){
                
                Image("password_icon")
                    .foregroundColor(.gray)
                
                SecureField(NSLocalizedString("password", comment: ""), text: $password)
                    .padding(.leading, 5)
                    .textFieldStyle(.plain)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.5), radius: 2, x: 0, y: 2)
            .padding(.leading, 15)
            .padding(.trailing, 15)
            
            Button(action:{
                login()
            }){
                Text(NSLocalizedString("login", comment: ""))
                    .padding(.bottom, 15)
                    .padding(.top, 15)
                    .padding(.leading, 50)
                    .padding(.trailing, 50)
                    .foregroundColor(.white)
            }.background(Color.blue)
                .cornerRadius(12)
                .padding(.top, 40)
            
            Spacer()
        }
    }
    
    func login(){
        Auth.auth().signIn(withEmail: email, password: password){result, error in
            if (error != nil){
                print ("error: " + error!.localizedDescription)
            }else{
                Database.database().reference().child("Madrichs").observeSingleEvent(of: DataEventType.value, with: { snapshot in
                    if (snapshot.hasChild(Auth.auth().currentUser?.uid ?? "")){
                        accountType = 1
                        loggedIn.toggle()
                    }else{
                        Database.database().reference().child("Students").observeSingleEvent(of: DataEventType.value, with: { snapshot in
                            if (snapshot.hasChild(Auth.auth().currentUser?.uid ?? "")){
                                accountType = 2
                                loggedIn.toggle()
                            }else{
                                Database.database().reference().child("Guards").observeSingleEvent(of: DataEventType.value, with: { snapshot in
                                    if (snapshot.hasChild(Auth.auth().currentUser?.uid ?? "")){
                                        accountType = 3
                                        loggedIn.toggle()
                                    }
                                })
                            }
                        })
                    }
                })
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
