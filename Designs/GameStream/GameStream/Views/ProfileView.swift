//
//  ProfileView.swift
//  GameStream
//
//  Created by Jean Carlos Quejada on 31/01/22.
//

import SwiftUI

struct ProfileView: View {
    private var userData = SaveData()
    @State var userName : String = ""
    
    @State var profileImage : UIImage = UIImage(named: "foto-prueba")!
    
    
    var body: some View {
        
        ZStack{
            
            BackgroundColor()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
            
            VStack{
                
                
                Text("Perfil")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth:.infinity, alignment: .center)
                    .padding()
                
                
                VStack{
                    Image(uiImage: profileImage)
                        .resizable()
                        .aspectRatio( contentMode: .fill)
                        .frame(width: 118.0, height: 118.0)
                        .clipShape(Circle())
                    
                    Text("\(userName)")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth:.infinity, alignment: .center)
                        .padding()
                    
                }.padding(
                    EdgeInsets(top: 16, leading: 0, bottom: 32, trailing: 0)
                )
                
                
                Text("Ajustes")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth:.infinity, alignment: .leading)
                    .padding(.leading, 18)
                SettingsModule()
                Spacer()
                
            }
            
            
        }.onAppear {
            //TODO: dfdsfds
            
            if returnUiImage(name: "fotoPerfil") != nil {
                profileImage = returnUiImage(name: "fotoPerfil")!
            }
            
            
            let data =  userData.getDataStoraged()
            if data.isEmpty == false {
                userName = data[2]
            }
            print("Reviar si hay datos del usuario en el userDefault")
        }
        
        
    }
    
    func returnUiImage(name:String) -> UIImage? {
        
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil,create:false){
            
           return UIImage(
                contentsOfFile: URL(
                    fileURLWithPath: dir.absoluteString
                ).appendingPathComponent(name).path
            )
            
            
        }
        
        return nil
        
    }
    
}


struct SettingsModule : View {
    @State var isToggleOn : Bool = true
    @State var isEditProfileViewActive = false
    var body: some View {
        
        
        VStack(spacing:3.0){
            
            Button {
                print("You have pressed account button")
            } label: {
                HStack {
                    
                    Text("Cuenta")
                        .foregroundColor(.white)
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                    
                }
                .padding()
                
            }
            .background(Color("Blue-gray"))
            .clipShape(RoundedRectangle(cornerRadius: 1.0))
            
            Button {
                print("You have pressed account button")
            } label: {
                HStack {
                    
                    Text("Notificaciones")
                        .foregroundColor(.white)
                    Spacer()
                    
                    Toggle("", isOn: $isToggleOn)
                    
                }
                .padding()
                
            }
            .background(Color("Blue-gray"))
            .clipShape(RoundedRectangle(cornerRadius: 1.0))
            
            Button {
                isEditProfileViewActive = true
            } label: {
                HStack {
                    
                    Text("Editar perfil")
                        .foregroundColor(.white)
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                    
                }
                .padding()
                
            }
            .background(Color("Blue-gray"))
            .clipShape(RoundedRectangle(cornerRadius: 1.0))
            
            
            Button {
                print("You have pressed account button")
            } label: {
                HStack {
                    
                    Text("Califica esta aplicación")
                        .foregroundColor(.white)
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                    
                }
                .padding()
                
            }
            .background(Color("Blue-gray"))
            .clipShape(RoundedRectangle(cornerRadius: 1.0))
            
            
            NavigationLink(isActive: $isEditProfileViewActive) {
                EditProfileView(
                    isEditProfileViewActive: $isEditProfileViewActive
                )
                    
            } label: {
                EmptyView()
            }

            
        }
        
        
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
