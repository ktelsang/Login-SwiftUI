//
//  ContentView.swift
//  LoginSwiftUI
//
//  Created by kavyashree SHRIPAD HEGDE on 16/11/21.
//

import SwiftUI

let backgroundColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0)
let brownColor = Color(red: 135.0/255.0, green: 48.0/255.0, blue: 23.0/255.0)
let whiteColor = Color(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0)

class TextValidator: ObservableObject {
    @Published var text = ""
}

class SecureFieldValidator: ObservableObject {
    @Published var text = ""
}

struct ContentView: View {
    
    @ObservedObject var textValidator = TextValidator()
    @ObservedObject var secureFieldValidator = SecureFieldValidator()
    @State private var userName: String = ""
    @State var password: String = ""
    @State var userNameValid = true
    @State var passwordValid = true
    @State var showPassword = false
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            
            Image("logo", bundle: .main)
                .frame(width: 200, height: 100)
                .padding(.top, 100)
                .scaledToFit()
            
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.secondary)
                    .padding(.leading)
                TextField("", text: $textValidator.text)
                    .onChange(of: textValidator.text, perform: { newValue in
                        if textFieldValidatorUserName(self.textValidator.text) {
                            userNameValid = true
                        } else {
                            userNameValid = false
                             self.userName = ""
                        }
                    })
                .autocapitalization(.none)
                .padding()
                .cornerRadius(15.0)
            }
            .background(whiteColor)
            .overlay(RoundedRectangle(cornerRadius: 4.0).stroke(userNameValid ? brownColor : .gray, lineWidth: 1))
            .overlay(
                Label("Username", image: "")
                    .background(whiteColor)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.leading)
                    .padding(.top, -10)
                    
                ,
                alignment: .topLeading
            )
            .padding(.bottom, -20)
            .padding()
            
            if !userNameValid {
                Label("Username can not have spaces and upper case alphabet", image: "")
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
            }
            
      
            HStack {
                Spacer()
                Image(systemName: "key")
                    .foregroundColor(.secondary)
                    .padding(.leading)
                if !showPassword {
                    SecureField("", text: $secureFieldValidator.text)
                        .onChange(of: secureFieldValidator.text, perform: { newValue in
                            if textFieldValidatorPassword(secureFieldValidator.text) {
                                passwordValid = true
                                password = secureFieldValidator.text
                            } else {
                               passwordValid = false
                                self.password = ""
                            }
                        })
                        .padding()
                        .cornerRadius(15.0)
                } else {
                    TextField("", text: $secureFieldValidator.text)
                        .onChange(of: secureFieldValidator.text, perform: { newValue in
                            if textFieldValidatorPassword(secureFieldValidator.text) {
                                passwordValid = true
                                password = secureFieldValidator.text
                            } else {
                               passwordValid = false
                                self.password = ""
                            }
                        })
                        .padding()
                        .cornerRadius(15.0)
                }
                
                Button(action: {
                    self.showPassword.toggle()
                    }, label: {
                        ZStack(alignment: .trailing) {
                            
                            Image(systemName: self.showPassword ? "eye.slash.fill" : "eye.fill")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(brownColor)
                        }
                    })
                    .padding(.trailing, 10)

            }
            .autocapitalization(.none)
            .background(whiteColor)
            .overlay(RoundedRectangle(cornerRadius: 4.0).stroke(passwordValid ? brownColor : .gray, lineWidth: 1))
            .overlay(
                Label("Password", image: "")
                    .background(whiteColor)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.leading)
                    .padding(.top, -10)
                    
                ,
                alignment: .topLeading
            )
            .padding()
            if !passwordValid {
                Label("Password should have 8 characters, 1 number, 1 upper case alphabet, 1 lower case alphabet", image: "")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.trailing, 10)
                    .padding(.leading, 10)
                    .padding(.top, -20)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            
            HStack {
                Spacer()
                Button("Forgotten password?") {
                    //Action
                }
                .font(.footnote)
                .foregroundColor(brownColor)
                .padding(.bottom, 70)
                .padding(.trailing, 10)
            }
            
            if #available(iOS 15.0, *) {
                Button("LOGIN") {
                    if !textValidator.text.isEmpty && !secureFieldValidator.text.isEmpty {
                        showingAlert = true
                    }
                }.alert("Login Successfull", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
                }
                
                .frame(width: 280, height: 40)
                .background(brownColor)
                .cornerRadius(10.0)
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold, design: .default))
                .padding(.bottom, 10)
            } else {
                // Fallback on earlier versions
            }
            
            HStack {
                Label("Don't have an account?", image: "")
                    .foregroundColor(.gray)
                    .font(.footnote)
                Button("Sign Up") {
                    
                }
                .foregroundColor(brownColor)
                .font(.footnote)
                .padding(.leading, -5)
            }
            .fixedSize(horizontal: true, vertical: false)
            Spacer()
        }.padding([.leading, .trailing])
    }
}

func textFieldValidatorUserName(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
       let userNameFormat = "[a-z]{2,64}"
        let userNamePredicate = NSPredicate(format:"SELF MATCHES %@", userNameFormat)
        return userNamePredicate.evaluate(with: string)
}

func textFieldValidatorPassword(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
       let passwordFormat = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{8}$"
        let passwordPredicate = NSPredicate(format:"SELF MATCHES %@", passwordFormat)
        return passwordPredicate.evaluate(with: string)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
