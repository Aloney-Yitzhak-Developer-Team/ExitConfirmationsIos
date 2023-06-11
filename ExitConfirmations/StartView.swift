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
import FirebaseFirestore
import FirebaseFirestoreSwift

struct StartView: View {
    
    @State private var loggedIn = false
    @State private var isLoginBottomSheetRequested = false
    @State private var isRegisterBottomSheetRequested = false
    
    var body: some View {
        if (loggedIn){
            MadrichMainView()
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
                Text("Login")
                    .padding(.bottom, 15)
                    .padding(.top, 15)
                    .padding(.leading, 50)
                    .padding(.trailing, 50)
                    .foregroundColor(.white)
            }.background(Color.blue)
                .cornerRadius(12)
                .sheet(isPresented: $isLoginBottomSheetRequested){
                    LoginBottomSheetView(isPresented: $isLoginBottomSheetRequested,
                        loggedIn: $loggedIn)
                }
            
            Spacer()
        }
        .padding()
        .onAppear{
            Auth.auth().addStateDidChangeListener{ auth, user in
                if user != nil{
                    loggedIn.toggle()
                }
            }
        }
    }
}

struct LoginBottomSheetView: View {
    @Binding var isPresented: Bool
    @Binding var loggedIn : Bool
    @State private var email = ""
    @State private var password = ""
    
    var body : some View{
        content
    }
    
    var content : some View{
        VStack (spacing: 20){
            
            Spacer()
            
            Text("Login")
                .foregroundColor(.black)
                .font(.system(size: 30))
            
            Spacer()
            
            HStack (spacing: 20){
                
                Image("email_icon")
                    .foregroundColor(.gray)
                
                TextField("Email", text: $email)
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
                
                SecureField("Password", text: $password)
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
                Text("Login")
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
                loggedIn = true
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
