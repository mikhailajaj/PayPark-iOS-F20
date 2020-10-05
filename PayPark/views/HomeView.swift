//
//  HomeView.swift
//  PayPark
//
//  Created by Jigisha Patel on 2020-09-21.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var selection:Int? = nil

    var email: String = ""
        var body: some View {
//        Text("Hello, \(self.userSettings.userEmail)")
            ZStack(alignment:.bottom){
                List{
                    //parking data displayed
                }
                //Add new Parking
                Button(action:{
                        print("Add Parking")
                    }
                ){
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 50,height: 50)
                        .foregroundColor(Color(red: 155/255, green: 100/255, blue: 255/255))
                        .shadow(color:.orange , radius: 1, x: 1, y: 1)
                }
            }
            NavigationLink(destination: SignInView(), tag:1, selection:$selection){}
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Menu{
                        Button("Delete Account",action: self.deleteAccount)
                        Button("Edit profile", action:self.editProfile)
                        Button("Sing Out", action: self.signOut)
                    }label:{
                        Image(systemName: "gear")
                    }
                }//ToolBarItem
            }
                .navigationBarBackButtonHidden(true)
                .navigationBarTitle("PayPark")
    }
    private func editProfile(){
        self.userViewModel.loggedInUser?.carPlate = "SHER210"
        self.userViewModel.loggedInUser?.name = "Sheridan"
        self.userViewModel.updateUser()
    }
    private func signOut(){
        self.selection = 1
        self.presentationMode.wrappedValue.dismiss()
    }
    private func deleteAccount(){
        self.userViewModel.deleteUser()
        self.selection = 1
        self.presentationMode.wrappedValue.dismiss()
        UserDefaults.standard.removeObject(forKey: "KEY_NAME")
        UserDefaults.standard.removeObject(forKey: "COM_MIKHAIL_PAYPARK_PASSWORD")
        UserDefaults.standard.removeObject(forKey: "REMMEMBER_ME")
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
