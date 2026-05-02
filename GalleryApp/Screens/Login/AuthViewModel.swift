//
//  AuthViewModel.swift
//  GalleryApp
//
//  Created by Swosti Sambit Yadab on 02/05/26.
//

import Foundation
import Combine
import GoogleSignIn
import SwiftData

@MainActor
final class AuthViewModel: ObservableObject {
    
    @Published var isLoggedIn = false
    
    func signIn() async {
        
        guard let rootVC = UIApplication.shared.connectedScenes
                    .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
                    .first?.rootViewController
        else { return }
        
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
            guard let user = result.user.profile else { return }
            print("Logged User Info: \nName: \(user.name)\nEmail: \(user.email)")
            isLoggedIn = true
        } catch {
            print("Error in Google Sign In: ", error.localizedDescription)
        }
    }
    
    func logout(context: ModelContext) {
        clearAllData(context: context)
        GIDSignIn.sharedInstance.signOut()
        isLoggedIn = false
    }
    
    func restoreSession() async {
        do {
            let user = try await GIDSignIn.sharedInstance.restorePreviousSignIn()
            guard let profile = user.profile else { return }
            print("Restored Logged User Info: \nName: \(profile.name)\nEmail: \(profile.email)")
            isLoggedIn = true
        } catch {
            print("Error restoring User: ", error.localizedDescription)
        }
    }
    
    private func clearAllData(context: ModelContext) {
        do {
            let items = try context.fetch(FetchDescriptor<Gallery>())
            for item in items {
                context.delete(item)
            }
            try context.save()
        } catch {
            print("Failed to clear DB:", error)
        }
    }
}
