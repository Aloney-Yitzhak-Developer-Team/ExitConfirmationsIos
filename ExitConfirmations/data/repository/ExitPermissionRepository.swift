//
//  ExitPermissionRepository.swift
//  ExitConfirmations
//
//  Created by Mikhail Maevskii on 03/01/2024.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift

struct ExitPermissionRepository{
    let databaseRef = Database.database().reference()
    func loadExitPermission(id: String, completion: @escaping (ExitPermission?) -> Void) {
        let exitPermissionRef = databaseRef.child(NODE_EP).child(id)
        
        exitPermissionRef.observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot.exists(),
                  let exitPermissionSnapshot = snapshot.value as? [String: Any] else {
                completion(nil)
                return
            }
            
            let id = id
            let status = (exitPermissionSnapshot[CHILD_STATUS] as? String) ?? ExitStatus.CREATED
            let destination = (exitPermissionSnapshot[CHILD_DESTINATION] as? String) ?? ""
            let group = (exitPermissionSnapshot[CHILD_GROUP] as? String) ?? ""
            
            guard let madrichId = exitPermissionSnapshot[CHILD_MADRICH_ID] as? String,
                  let studentId = exitPermissionSnapshot[CHILD_STUDENT_ID] as? String,
                  let exitDate = exitPermissionSnapshot[CHILD_EXIT_DATE] as? String,
                  let exitTime = exitPermissionSnapshot[CHILD_EXIT_TIME] as? String,
                  let returnDate = exitPermissionSnapshot[CHILD_RETURN_DATE] as? String,
                  let returnTime = exitPermissionSnapshot[CHILD_RETURN_TIME] as? String,
                  let confirmationLink = exitPermissionSnapshot[CHILD_CONFIRMATION_LINK] as? String else {
                completion(nil)
                return
            }
            
            let madrich = // Call a method to load Madrich using madrichId
            let student = // Call a method to load Student using studentId
            
            let exitDate = exitPermissionSnapshot[CHILD_EXIT_DATE] as? String
            let exitTime = exitPermissionSnapshot[CHILD_EXIT_TIME] as? String
            let exitDT = "\(exitDate) \(exitTime)".toDate()
            
            let returnDate = exitPermissionSnapshot[CHILD_RETURN_DATE] as? String
            let returnTime = exitPermissionSnapshot[CHILD_RETURN_TIME] as? String
            let returnDT = "\(returnDate) \(returnTime)".toDate()
            
            let actualReturnDate = exitPermissionSnapshot[CHILD_ACTUAL_RETURN_DATE] as? String
            let actualReturnTime = exitPermissionSnapshot[CHILD_ACTUAL_RETURN_TIME] as? String
            let actualReturnDT = "\(actualReturnDate) \(actualReturnTime)".toDate()
            
            var exitPermission = ExitPermission(
                id: id,
                status: status,
                destination: destination,
                madrich: madrich,
                student: student,
                exitDT: exitDT,
                returnDT: returnDT,
                actualReturnDT: actualReturnDT,
                confirmation: confirmationLink
            )
            
            // If exit permission is outdated, remove it
            if exitPermission.isOutdated() {
                exitPermissionRef.removeValue()
                completion(nil)
            } else {
                completion(exitPermission)
            }
        }
    }
    
    func loadExitPermissions(ids: String, completion: @escaping ([ExitPermission], String) -> Void) {
        let exitPermissionsIds = ids.split(separator: ",")
        var currentExitPermissionsStr = ids
        
        var exitPermissions = [ExitPermission]()
        for id in exitPermissionsIds {
            loadExitPermission(id: String(id)) { (exitPermission) in
                if let exitPermission = exitPermission {
                    exitPermissions.append(exitPermission)
                } else {
                    currentExitPermissionsStr = currentExitPermissionsStr.removeEPId(String(id))
                }
                
                if exitPermissions.count == exitPermissionsIds.count {
                    completion(exitPermissions, currentExitPermissionsStr)
                }
            }
        }
    }
    
    func addExitPermission(exitPermission: ExitPermission, onSuccess: @escaping (String) -> Void) {
        let key = databaseRef.child("ExitPermissions").childByAutoId().key
        exitPermission.confirmation = key
        exitPermission.id = key ?? ""
        
        if let key = key {
            databaseRef.child("ExitPermissions").child(key).setValue(exitPermission.getAsDictionary()) { (error, _) in
                if error == nil {
                    onSuccess(key)
                }
            }
        }
    }
    
    func updateStatus(
        exitPermissionId: String,
        guardId: String,
        status: String,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping () -> Void
    ) {
        switch status {
        case ExitStatus.EXIT_CONFIRMED:
            var newData = [String: Any]()
            newData[CHILD_STATUS] = ExitStatus.EXIT_CONFIRMED
            newData[CHILD_CONFIRMATION_LINK] = "\(exitPermissionId)+"
            
            databaseRef.child("ExitPermissions").child(exitPermissionId).updateChildValues(newData) { (error, _) in
                if error == nil {
                    // Use DispatchGroup to handle the nested asynchronous operation
                    let dispatchGroup = DispatchGroup()
                    dispatchGroup.enter()
                    
                    guardRepository.get().addExitPermission(guardId: guardId, exitPermissionId: exitPermissionId) {
                        dispatchGroup.leave()
                    }
                    
                    dispatchGroup.notify(queue: .main) {
                        onSuccess()
                    }
                }
            }
            
        case ExitStatus.RETURN_CONFIRMED:
            let currentDate = Date()
            var actualReturnInfo = [String: Any]()
            actualReturnInfo[CHILD_ACTUAL_RETURN_DATE] = currentDate.getDateString()
            actualReturnInfo[CHILD_ACTUAL_RETURN_TIME] = currentDate.getTimeString()
            actualReturnInfo[CHILD_STATUS] = ExitStatus.RETURN_CONFIRMED
            
            databaseRef.child("ExitPermissions").child(exitPermissionId).updateChildValues(actualReturnInfo) { (error, _) in
                if error == nil {
                    onSuccess()
                } else {
                    onFailure()
                }
            }
            
        default:
            break
        }
    }
}
