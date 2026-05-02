//
//  GalleryAppApp.swift
//  GalleryApp
//
//  Created by Swosti Sambit Yadab on 02/05/26.
//

import SwiftUI
import SwiftData
import GoogleSignIn

@main
struct GalleryApp: App {
    
    @StateObject private var authVM = AuthViewModel()
    
    init() {
        _ = NetworkMonitor.shared
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authVM.isLoggedIn {
                    TabView {
                        GalleryView()
                            .tabItem {
                                Image(systemName: "photo.on.rectangle")
                                Text("Gallery")
                            }
                        
                        ProfileView(vm: authVM)
                            .tabItem {
                                Image(systemName: "person.crop.circle")
                                Text("Profile")
                            }
                    }
                } else {
                    LoginView(vm: authVM)
                }
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
            .task {
                await authVM.restoreSession()
            }
        }
        .modelContainer(for: Gallery.self)
    }
}
