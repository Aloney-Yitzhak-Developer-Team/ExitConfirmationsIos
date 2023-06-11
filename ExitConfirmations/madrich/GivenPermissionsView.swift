//
//  GivenPermissionsView.swift
//  ExitConfirmations
//
//  Created by Mikhail Maevskiy on 25/05/2023.
//

import SwiftUI

struct GivenPermissionsView: View {
    
    @State private var allPermissions : [ExitPermission] = []
    
    var body: some View {
        List(allPermissions){ permission in
            HStack{
                VStack{
                    Text("ל: " + permission.goingTo)
                }
                
                Spacer()
                VStack(spacing: 5){
                    Text("זמן יציאה: " + permission.exitTime)
                    Text("זמן החזרה: " + permission.returnTime)
                }
            }
            
        }.onAppear{
            loadAllPermission()
        }
    }
     
    func loadAllPermission(){
        allPermissions.removeAll()
        
        let madrich_name = "דאשה"
//        allPermissions.append(ExitConfirmation(id: "1", student_name: "maxim", student_id: "didi", madrich_id: "akdm", madrich_name: madrich_name, goingTo: "אשקלון", exitTime: "12:55", returnTime: "15:55", group: "4i", confirmed: false))
    }
}

struct GivenPermissionsView_Previews: PreviewProvider {
    static var previews: some View {
        GivenPermissionsView()
    }
}
