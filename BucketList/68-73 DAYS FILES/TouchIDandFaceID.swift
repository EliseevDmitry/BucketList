//
//  TouchIDandFaceID.swift
//  BucketList
//
//  Created by Dmitriy Eliseev on 22.07.2024.
//
//Targets -> Info -> Privacy - Face ID Usage Description (текст - зачем нам использовать это)
import LocalAuthentication
import SwiftUI

struct TouchIDandFaceID: View {
    //MARK: - PROPERTIES
    @State private var isUnlocked = false
    //MARK: - BODY
    var body: some View {
        VStack{
            if isUnlocked {
                Text("Unlocked")
            } else {
                Text("Locked")
            }
        }
        .onAppear(perform: authenticate)
    }
    func authenticate(){
        let context = LAContext()
        var error: NSError?
        //проверка - возможна ли технически AuthenticationWithBiometrics
        //&error - наследие Objective-C
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "We need to unlock your data"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    //authenticated successfully
                    isUnlocked = true
                } else {
                    //there was a problem
                }
            }
        } else {
            //no biometrics
        }
    }
}

//MARK: - PREVIEW
#Preview {
    TouchIDandFaceID()
}
