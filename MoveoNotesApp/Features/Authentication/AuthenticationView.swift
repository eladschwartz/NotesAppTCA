//
//  AuthenticationView.swift
//  MoveoNotesApp
//
//  Created by elad on 02/07/2025.
//

import SwiftUI
import ComposableArchitecture

struct AuthenticationView: View {
    @Bindable var store: StoreOf<AuthenticationFeature>
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20){
                IconView()
                LoginTextFields(store: store)
                SigninSignupButton(store: store)
                DontHaveAccountView(store: store)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .alert(
                "Error",
                isPresented: .constant(store.errorMessage != nil),
                actions: {
                    Button("OK") {
                        store.send(.dismissError)
                    }
                },
                message: {
                    if let errorMessage = store.errorMessage {
                        Text(errorMessage)
                    }
                }
            )
        }
    }
}

//MARK: IconView
struct IconView : View {
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 8) {
                Image(systemName: "map.circle")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text("Moveo Notes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding()
        }
    }
}

//MARK: LoginTextFields
struct LoginTextFields : View {
    @Bindable var store: StoreOf<AuthenticationFeature>
    
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Email Address")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color(UIColor.label))
                
                TextField("Enter your email", text: $store.email.sending(\.emailChanged))
                    .textFieldStyle(CustomTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color(UIColor.label))
                
                SecureField("Enter your password", text: $store.password.sending(\.passwordChanged))
                    .textFieldStyle(CustomTextFieldStyle())
                    .autocapitalization(.none)
            }
        }
        .padding(.horizontal)
    }
}


//MARK: SigninSignupButton
struct SigninSignupButton : View {
    @Bindable var store: StoreOf<AuthenticationFeature>
    
    var body: some View {
        Button {
            if store.isLoginMode {
                store.send(.loginTapped)
            } else {
                store.send(.signupTapped)
            }
        } label: {
            HStack {
                if store.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                }
               
                Text(store.isLoginMode ? "Sign In" : "Sign Up")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 28).fill(Color(.blue))
            )
            .foregroundColor(.white)
            .cornerRadius(10)
            
        }
        .disabled(store.email.isEmpty || store.password.isEmpty || store.isLoading)
        .padding(.horizontal)
    }
}

//MARK: DontHaveAccountView
struct DontHaveAccountView : View {
    @Bindable var store: StoreOf<AuthenticationFeature>
    
    var body: some View {
        Button {
            store.send(.toggleMode)
        } label: {
            Text(store.isLoginMode ? "Don't have an account? Sign Up" : "Already have an account? Sign In")
                .font(.footnote)
                .foregroundColor(.blue)
        }
        
        Spacer()
    }
}


struct CustomTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 15)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Color(.secondarySystemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
                            .stroke(colorScheme == .dark ? Color.gray.opacity(0.3) : Color(.systemGray4), lineWidth: 1)
                    )
            )
            .font(.system(size: 16))
    }
}

#Preview {
    AuthenticationView(store:  Store(initialState: AuthenticationFeature.State(), reducer: {
        AuthenticationFeature()
    }))
}
