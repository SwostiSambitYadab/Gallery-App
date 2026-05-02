//
//  ProfileView.swift
//  GalleryApp
//
//  Created by Swosti Sambit Yadab on 02/05/26.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var vm: AuthViewModel
    @Environment(\.modelContext) private var context
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Profile")
            
            Button("Logout") {
                vm.logout(context: context)
            }
        }
    }
}
