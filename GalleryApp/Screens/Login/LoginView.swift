//
//  LoginView.swift
//  GalleryApp
//
//  Created by Rahul Kiumar on 02/05/26.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var vm: AuthViewModel
    
    var body: some View {
        VStack {
            Button("Login with Google") {
                Task {
                    await vm.signIn()
                }
            }
        }
    }
}
