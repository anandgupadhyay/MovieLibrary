//
//  NewSigningScreen.swift
//  MovieLibrary_SwiftUI
//
//  Created by Anand Upadhyay on 13/08/25.
//

import SwiftUI

struct NewSignInView: View {
    @State private var inputText: String = ""
    @State private var selectedCountryCode: String = "+1"
    @State private var isPhoneInput: Bool = true
    @State private var isFocused: Bool = false
    
    // Sample country codes for the dropdown
    let countryCodes = ["+1", "+44", "+91", "+81", "+86"]
    
    // Determine input type based on the first character
    private func updateInputType() {
        if inputText.isEmpty {
            isPhoneInput = true
        } else if let firstChar = inputText.first {
            isPhoneInput = firstChar.isNumber
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("Sign In")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            // Input Field with Floating Label
            ZStack(alignment: .leading) {
                // Background and Underline
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(isFocused ? Color.blue : Color.gray)
                        .frame(height: 2)
                }
                .frame(height: 50)
                
                HStack {
                    if isPhoneInput {
                        // Country Code Picker
                        Picker("Country Code", selection: $selectedCountryCode) {
                            ForEach(countryCodes, id: \.self) { code in
                                Text(code).tag(code)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.black)
                        .padding(.leading, 10)
                        .frame(width: 80)
                        
                        // Separator
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 1, height: 30)
                    }
                    
                    // Text Field with Floating Label
                    ZStack(alignment: .leading) {
                        // Placeholder
                        Text(isPhoneInput ? "Phone number" : "Email or phone number")
                            .font(.system(size: (inputText.isEmpty && !isFocused) ? 16 : 12))
                            .foregroundColor(.gray)
                            .offset(y: (inputText.isEmpty && !isFocused) ? 0 : -20)
                            .animation(.easeInOut(duration: 0.2), value: inputText.isEmpty && !isFocused)
                            .padding(.leading, isPhoneInput ? 10 : 15)
                        
                        // Text Field
                        TextField("", text: $inputText, onEditingChanged: { editing in
                            withAnimation {
                                isFocused = editing
                            }
                        })
                            .padding(.leading, isPhoneInput ? 10 : 15)
                            .padding(.trailing, 15)
                            .keyboardType(isPhoneInput ? .phonePad : .emailAddress)
                            .autocapitalization(.none)
                            .onChange(of: inputText) { _ in
                                updateInputType()
                            }
                    }
                }
            }
            .padding(.horizontal)
            
            // Display current input type (for debugging/demo)
            Text(isPhoneInput ? "Phone Input Mode" : "Email Input Mode")
                .font(.caption)
                .foregroundColor(.gray)
            
            // Sign In Button
            Button(action: {
                // Handle sign-in logic here
                print("Sign in with: \(isPhoneInput ? selectedCountryCode + inputText : inputText)")
            }) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
    }
}

struct NewSignInView_Previews: PreviewProvider {
    static var previews: some View {
        NewSignInView()
    }
}
