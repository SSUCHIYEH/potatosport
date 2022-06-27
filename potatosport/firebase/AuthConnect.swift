//
//  AuthConnect.swift
//  potatosport
//
//  Created by ruby0926 on 2022/6/21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase
import FirebaseDatabaseSwift

class AppAuthViewModel: ObservableObject{
    
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignIn:Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email:String,password:String){
        auth.signIn(withEmail: email, password: password) { [weak self]result, error in
            guard result != nil,error == nil else{ return }
            
            //Success
            DispatchQueue.main.async {
                self?.signedIn = true
            }
          }
    }
    func signOut(){
        do {
            self.signedIn.toggle()
            try auth.signOut()
        } catch let error as NSError {
          print("Error signing out: %@", error)
        }
    }
}
