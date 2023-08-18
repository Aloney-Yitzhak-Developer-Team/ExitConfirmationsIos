//
//  MadrichExitPermissionInfoBS.swift
//  ExitConfirmations
//
//  Created by Mikhail Maevskii on 10/08/2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift

struct CreateExitPermissionBS: View {
    
    @State var exitPermission = ExitPermission()
    @State var currentView = 0
    @ObservedObject var viewModel = CreateExitPermissionBS_viewmodel()
    @State var searchText = ""
    @State var goingTo = ""
    @State var exitDateAndTime = Date.now
    @State var returnDateAndTime = Date.now
    
    var students : [Student]{
        if searchText.isEmpty{
            return viewModel.students
        }else{
            return viewModel.students.filter{$0.name.contains(searchText) || $0.group==searchText}
        }
    }
    
    var body: some View {
        switch currentView{
        case 0:
            permissionTypeChossingView
            
        case 1:
            allStudentsChoosingView
            
        case 2:
            choosingStudentsFromOneGroupView
            
        case 3:
            exitPermissionDataView
            
        case 4:
            successView
            
        default:
            permissionTypeChossingView
        }
    }
    
    var permissionTypeChossingView : some View{
        VStack(spacing: 10){
            Text(NSLocalizedString("for_whom_permission", comment:""))
                .font(.system(size:25))
            
            
            
            Button(action:{
                currentView = 1
            }){
                Text(NSLocalizedString("for_other_group", comment: ""))
                    .font(.system(size:20))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
            }.background(Color("AdditionalColor"))
                .cornerRadius(10)
                .padding(.top, 15)
            
            Button(action:{
                currentView = 2
            }){
                Text(NSLocalizedString("for_this_group", comment: ""))
                    .font(.system(size:20))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
            }.background(Color("AdditionalColor"))
                .cornerRadius(10)
        }
    }

    
    var allStudentsChoosingView : some View{
        VStack{
            
            VStack{
                
                HStack{
                    Button(action:{
                        currentView = 0
                    }){
                        Image(systemName: "arrow.left")
                            
                    }.padding(.leading, 30)
                    
                    Spacer()
                    
                    Text(NSLocalizedString("students_choosing", comment: ""))
                        .font(.system(size:20))
                        .padding(.trailing, 40)
                    
                    Spacer()
                }.padding(.top, 10)
                
                
                NavigationStack{
                    List(students){student in
                        HStack(spacing: 10){
                            Text(student.name)
                            Text(student.group)
                            
                            Spacer()
                            
                            if (student.selected){
                                Image("permission_confirmed_icon")
                            }
                        }.onTapGesture {
                            viewModel.studentSelectionChange(student: student)
                        }
                    }.onAppear{
                        viewModel.loadAllStudents()
                    }
                }.searchable(text: $searchText)
            }
            
            Spacer()
            
            Button(action:{
                if viewModel.students.contains(where: {$0.selected==true}){
                    var students_ids = ""
                    var students_names = ""
                    for student in viewModel.students {
                        if student.selected{
                            if (students_ids.isEmpty){
                                students_ids = student.id
                            }else{
                                students_ids += ",\(student.id)"
                            }
                            
                            if (students_names.isEmpty){
                                students_names = student.name
                            }else{
                                students_names += ",\(student.name)"
                            }
                        }
                    }
                    exitPermission.students_ids = students_ids
                    exitPermission.students_names = students_names
                    
                    currentView=3
                }
            }){Text(NSLocalizedString("continue_t", comment: ""))
                    .font(.system(size:20))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
            }.background(Color("AdditionalColor"))
                .cornerRadius(10)
            
            Spacer()
        }
    }
    
    var choosingStudentsFromOneGroupView : some View{
        VStack{
            
            VStack{
                
                HStack{
                    Button(action:{
                        currentView = 0
                    }){
                        Image(systemName: "arrow.left")
                            
                    }.padding(.leading, 30)
                    
                    Spacer()
                    
                    Text(NSLocalizedString("students_choosing", comment: ""))
                        .font(.system(size:20))
                        .padding(.trailing, 40)
                    
                    Spacer()
                }.padding(.top, 20)
                
                NavigationStack{
                    List(students){student in
                        HStack(spacing: 10){
                            Text(student.name)
                            Text(student.group)
                            
                            Spacer()
                            
                            if (student.selected){
                                Image("permission_confirmed_icon")
                            }
                        }.onTapGesture {
                            viewModel.studentSelectionChange(student: student)
                        }
                    }.onAppear{
                        viewModel.loadStudentsFromOneGroup()
                    }
                }.searchable(text: $searchText)
            }
            
            Spacer()
            
            Button(action:{
                if viewModel.students.contains(where: {$0.selected==true}){
                    var students_ids = ""
                    var students_names = ""
                    for student in viewModel.students {
                        if student.selected{
                            if (students_ids.isEmpty){
                                students_ids = student.id
                            }else{
                                students_ids += ",\(student.id)"
                            }
                            
                            if (students_names.isEmpty){
                                students_names = student.name
                            }else{
                                students_names += ",\(student.name)"
                            }
                        }
                    }
                    exitPermission.students_ids = students_ids
                    exitPermission.students_names = students_names
                    
                    currentView=3
                }
            }){Text(NSLocalizedString("continue_t", comment: ""))
                    .font(.system(size:20))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
            }.background(Color("AdditionalColor"))
                .cornerRadius(10)
            
            Spacer()
        }
    }
    
    var exitPermissionDataView : some View{
        VStack{
            
            VStack{
                
                HStack{
                    Button(action:{
                        currentView = 0
                    }){
                        Image(systemName: "arrow.left")
                            
                    }.padding(.leading, 30)
                    
                    Spacer()
                    
                    Text(NSLocalizedString("exit_permission_details", comment: ""))
                        .font(.system(size:20))
                        .padding(.trailing, 40)
                    
                    Spacer()
                }.padding(.top, 20)
                
                Spacer()
                
                
                VStack(spacing: 15){
                    Spacer()
                    
                    TextField(NSLocalizedString("going_to", comment: ""), text: $goingTo)
                    
                    DatePicker(NSLocalizedString("exit_date", comment: ""), selection: $exitDateAndTime)
                    
                    DatePicker(NSLocalizedString("return_date", comment: ""), selection: $returnDateAndTime)
                    
                    Spacer()
                    
                    Button(action:{
                        //TODO: fill all the info
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd.MM.yyyy"
                        
                        let timeFormatter = DateFormatter()
                        timeFormatter.dateFormat = "HH:mm"
                        
                        var exitPermissionInfo = [String : Any]()
                        exitPermissionInfo["id"] = String(Int(Date().timeIntervalSince1970 * 1000)) //current time in millis
                        exitPermissionInfo["confirmed"] = false
                        exitPermissionInfo["exitDate"] = dateFormatter.string(from: exitDateAndTime)
                        exitPermissionInfo["exitTime"] = timeFormatter.string(from: exitDateAndTime)
                        exitPermissionInfo["goingTo"] = goingTo
                        exitPermissionInfo["group"] = viewModel.getGroups()
                        exitPermissionInfo["madrich_id"] = Auth.auth().currentUser?.uid
                        
                        Database.database().reference().child("Madrichs").child(Auth.auth().currentUser?.uid ?? "").child("name").observeSingleEvent(of: DataEventType.value, with: {snapshot in
                            if let name = snapshot.value as? String{
                                exitPermissionInfo["madrich_name"] = name
                                
                                exitPermissionInfo["returnDate"] = dateFormatter.string(from: returnDateAndTime)
                                exitPermissionInfo["returnTime"] = timeFormatter.string(from: returnDateAndTime)
                                exitPermissionInfo["students_ids"] = exitPermission.students_ids
                                exitPermissionInfo["students_names"] = exitPermission.students_names
                                exitPermissionInfo["confirmationLink"] = exitPermissionInfo["id"]
                                
                                viewModel.setExitPermissionToStudents(exitPermissionId: exitPermissionInfo["id"] as! String)
                                viewModel.setExitPermissionToMadrich(exitPermissionId: exitPermissionInfo["id"] as! String, madrichId: Auth.auth().currentUser?.uid ?? "")
                                
                                Database.database().reference().child("ExitPermissions").child(exitPermissionInfo["id"]as! String).setValue(exitPermissionInfo)
                                
                                currentView = 4
                            }
                        })
                        
                    }){Text(NSLocalizedString("create_permission", comment: ""))
                            .font(.system(size:20))
                            .foregroundColor(.white)
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                    }.background(Color("AdditionalColor"))
                        .cornerRadius(10)
                }.padding(.leading, 15)
                    .padding(.trailing, 15)
                
                Spacer()
            }
            
            Spacer()
        }
    }
    
    var successView : some View{
        VStack{
            Spacer()
            
            Image("permission_confirmed_icon")
            
            Spacer()
            
            Text(NSLocalizedString("exit_permission_created", comment: ""))
                .font(.system(size:20))
            
            Spacer()
        }
    }
    
}

struct CreateExitPermissionBS_Previews: PreviewProvider {
    static var previews: some View {
        CreateExitPermissionBS()
    }
}
