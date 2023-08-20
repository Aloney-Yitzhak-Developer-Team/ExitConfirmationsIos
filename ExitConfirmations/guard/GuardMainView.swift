//
//  GuardView.swift
//  ExitConfirmations
//
//  Created by Mikhail Maevskii on 06/08/2023.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseDatabase
import FirebaseDatabaseSwift
import CodeScanner

struct GuardMainView: View {
    
    @State var isUserSignedIn = true
    @State var guardName = ""
    @State var group = ""
    @State var isScannerRequested = false
    @State var exitPermissionIdScanned = ""
    @State var exitPermissionId : String = "The qr code is to be scanned"
    
    var body : some View{
        if (!isUserSignedIn){
            StartView()
        }else{
            content
        }
    }
    
    var content: some View {
        ZStack{
            VStack{
                HStack {
                    Text(guardName)
                        .font(.system(size:20))
                        .onAppear{
                            getGuardInfo()
                        }
                        .padding(.leading, 20)
                    
                    Spacer()
                    
                    Button(action: {
                        do{
                            isUserSignedIn = false
                            try Auth.auth().signOut()
                        }catch let error{
                            print(error.localizedDescription)
                        }
                    }){
                        Image(systemName: "rectangle.portrait.and.arrow.forward")
                    }.padding(.trailing, 15)
                }
                Divider()
            }
            VStack{
                Spacer()
                
                HStack{
                    Spacer()
                    
                    Button(action:{
                        isScannerRequested.toggle()
                    }){
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding(15)
                    }.background(Color("AdditionalColor"))
                        .clipShape(Circle())
                        .padding(.trailing, 30)
                        .sheet(isPresented: $isScannerRequested){
                            self.scannerSheet
                        }
                }.padding(.bottom, 50)
            }
        }
    }
    
    var scannerSheet : some View{
        CodeScannerView(
            codeTypes: [.qr],
            completion: {result in
                if case let .success(code)=result{
                    self.exitPermissionId = code.string
                    self.isScannerRequested = false
                }
            })
    }
    
    func getGuardInfo(){
//        Database.database().reference().child("Guards").child(Auth.auth().currentUser?.uid ?? "").observeSingleEvent(of: DataEventType.value, with: { snapshot in
//            if let madrichInfo = snapshot.value as? [String:String]{
//                if let name = madrichInfo["name"]{
//                    guardName = name
//                }
//            }
//        })
        guardName="Guard name"
    }
}


struct GuardView_Previews: PreviewProvider {
    static var previews: some View {
        GuardMainView()
    }
}
