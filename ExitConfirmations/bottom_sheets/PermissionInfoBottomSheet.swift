//
//  PermissionInfoBottomSheet.swift
//  ExitConfirmations
//
//  Created by Mikhail Maevskii on 17/08/2023.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct PermissionInfoBottomSheet: View {
    
    let exitPermission: ExitPermission
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @State var uiImage = UIImage()
    
    var body: some View {
        VStack{
            
            Spacer()
            
            Text(NSLocalizedString("students", comment: "") + ": " + exitPermission.students_names)
                .font(.system(size:20))
            
            Text(NSLocalizedString("madrich", comment: "") + ": " + exitPermission.madrich_name)
            
            Text(NSLocalizedString("exit_date", comment: "") + ": " + exitPermission.exitDate + " " + exitPermission.exitTime)
                .padding(.top, 2)
            
            Text(NSLocalizedString("return_date", comment: "") + ": " + exitPermission.returnDate + " " + exitPermission.returnTime).padding(.top, 2)
            
            Text(NSLocalizedString("going_to", comment: "") + ": " + exitPermission.goingTo).padding(.top, 2)
            
            Text(NSLocalizedString("group", comment: "") + ": " + exitPermission.group).padding(.top, 2)
            
            Spacer()
            
            Image(uiImage: uiImage)
                .onAppear{
                    uiImage = generateQRCode(from: exitPermission.confirmationLink)
                }
            
            
            Spacer()
            
        }
    }
    
    func generateQRCode(from string: String) -> UIImage{
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage{
            let transform = CGAffineTransform(scaleX: 7, y: 7)
            let largerImage = outputImage.transformed(by: transform)
            if let cgimg = context.createCGImage(largerImage, from: largerImage.extent){
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct PermissionInfoBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        PermissionInfoBottomSheet(exitPermission: ExitPermission(id: "1", confirmed: false, exitDate: "12.12.2012", exitTime: "12:33", goingTo: "Samara", group: "4i", madrich_id: "madrich_id", madrich_name: "Madrich name", returnDate: "13.12.2012", returnTime: "12:34", students_ids: "12, 13", students_names: "Misha,Kostya", confirmationLink: "12345"))
    }
}
