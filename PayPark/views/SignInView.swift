//
//  ContentView.swift
//  PayPark
//
//  Created by Mikhail on 2020-09-25.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    @EnvironmentObject var userSettings: UserSettings
//    @ObservedObject var userSettings = UserSettings()
    
    @State private var email:String = UserDefaults.standard.string(forKey: "KEY_NAME") ?? ""
    @State private var password: String = UserDefaults.standard.string(forKey: "COM_MIKHAIL_PAYPARK_PASSWORD") ?? ""
    @State private var rememberMe: Bool = UserDefaults.standard.bool(forKey: "REMMEMBER_ME") ?? true
    @State private var selection: Int? = nil
    @State private var invalidLogin: Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                Form{
                    TextField("Email", text: self.$email)
                        .autocapitalization(.none)
                    SecureField("Password", text: self.$password)
                    
                    VStack(alignment: .trailing, spacing: 10){
                        NavigationLink(destination: Text("Password Recovery"), tag: 1, selection: $selection){EmptyView()}
                        NavigationLink(destination: SignUpView(), tag: 2, selection: $selection) {}
                        
                        Toggle(isOn: self.$rememberMe, label: {
                            Text("Remember my credentials")
                        })
                        
                        Button(action: {
                            print("Forgot button clicked")
                            self.selection = 1
                        }){
                            Text("Forgot Password ?")
                                .foregroundColor(Color.blue)
//                            NavigationLink("Forgot Password?", destination: Text("Password Recovery"))
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            print("Create account clicked")
                            self.selection = 2
                        }){
                            Text("New Customer? Create Account")
                                .foregroundColor(Color.blue)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }//VStack
                }//Form
                
                Section{
                    NavigationLink(destination: HomeView(email: self.email), tag: 3, selection: $selection){}
//                    NavigationLink(destination: HomeView(userSettings: self.userSettings, email: self.email), tag: 3, selection: $selection){}
                    
                    
                    Button(action:{
                        print("Sign In Clicked")
                        if (self.isValidData()){
//                            if (self.email == "test" && self.password == "test"){
                            if (self.validateUser()){
                                print("Login Successful")
                                
                                //save login credentials to UserDefault
                                if(self.rememberMe){
                                    //save to UserDefaults
                                    UserDefaults.standard.setValue(self.rememberMe, forKey: "REMMEMBER_ME")
                                    UserDefaults.standard.setValue(self.email, forKey: "KEY_NAME")
                                    UserDefaults.standard.setValue(self.password, forKey: "COM_MIKHAIL_PAYPARK_PASSWORD")
                                    
                                }else{
                                    //remoive from UserDefault
                                    UserDefaults.standard.removeObject(forKey: "KEY_NAME")
                                    UserDefaults.standard.removeObject(forKey: "COM_MIKHAIL_PAYPARK_PASSWORD")
                                }
                                
                                userSettings.userEmail = self.email
                                
                                self.selection = 3
                            }else{
                                print("Incorrect email/password.")
                                self.invalidLogin = true
                            }
                        }
                    }){
                        Text("Sign In")
                            .accentColor(Color.white)
                            .padding()
                            .background(Color(UIColor.darkGray))
                            .cornerRadius(5.0)
                    }
                    .alert(isPresented: self.$invalidLogin){
                        Alert(
                            title: Text("Error"),
                            message: Text("Incorrect Login/Password"),
                            dismissButton: .default(Text("Try Again !"))
                        )
                    }//alert
                }//Section
            }//VStack
            .navigationBarTitle("PayPark", displayMode: .inline)
//            .navigationBarTitle("PayPark", displayMode: .large)
            .navigationBarBackButtonHidden(true)
//            .navigationBarItems(trailing:
//                                    Button(action: {
//                                        print("Settings Clicked")
//                                    }){
////                                        Text("Settings")
////                                        https://sfsymbols.com/
//                                        Image(systemName: "gear")
//                                    })
        }//NavigationView
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(){
            self.userViewModel.getAllUsers()
            for user in self.userViewModel.userList{
                print(#function, "Name: \(user.name ?? "Unkown") Email: \(user.email!) password: \(user.password!) CarPlate: \(user.carPlate ?? "Unknown")")
            }
        }
    }//body
    
    private func isValidData() -> Bool{
        if self.email.isEmpty{
            return false
        }
        
        if self.password.isEmpty{
            return false
        }
        
        return true
    }
    
    private func validateUser() -> Bool{
        self.userViewModel.findUserByEmail(email: self.email)
        
        if (self.userViewModel.loggedInUser != nil){
            if (self.password == self.userViewModel.loggedInUser!.password){
                return true
            }
        }else{
            self.invalidLogin = true
            
            return false
        }
        return false
    }
}//SignInView

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
