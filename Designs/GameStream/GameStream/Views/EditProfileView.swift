//
//  EditProfileView.swift
//  GameStream
//
//  Created by MacBook Casa on 31/01/22.
//

import SwiftUI

struct EditProfileView: View {
    @Binding var isEditProfileViewActive:Bool
    
    @State var profileImage:Image? = Image("foto-prueba")
    
    @State var isCameraActive:Bool = false
    
    @State var isActionSheetActive: Bool = false
    
    @State var isGalleryOn:Bool = false
    
    
    var body: some View {
        
        ZStack {
            BackgroundColor()
            ScrollView {
                
                //Elije una foto de perfil
                VStack{
                    Text("Editar Perfil")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth:.infinity, alignment: .center)
                        .padding()
                    
                    Button {
                        takePicture()
                    } label: {
                        ZStack{
                            
                            profileImage
                                .sheet(isPresented: $isCameraActive) {
                                    SUImagePickerView(
                                        sourceType: isGalleryOn ?  .photoLibrary : .camera,
                                        image: self.$profileImage,
                                        isPresented: self.$isCameraActive)
                                }
                            
                            Image(systemName: "camera")
                                .foregroundColor(.white)
                        }
                    }
                    
                    
                }.actionSheet(isPresented: $isActionSheetActive) {
                    ActionSheet(
                        title: Text("Elección de acción"),
                        message: Text("¿Cámara o album de galleria? "),
                        buttons: [
                            .default(Text("Cámara"), action: {
                                isGalleryOn = false
                                isCameraActive = true
                            }),
                            .default(Text("Galeria"), action: {
                                isGalleryOn = true
                                isCameraActive = true
                            })
                        ]
                    )
                }
                
                ModuloEditar(isEditProfileViewActive: $isEditProfileViewActive)
                
                
                
            }
        }
    }
    
    func takePicture(){
        isActionSheetActive = true
    }
    
    
    
    
    
}

struct ModuloEditar : View{
    @Binding var isEditProfileViewActive:Bool
    @State var email : String = ""
    @State var pass : String = ""
    @State var name : String  = ""
    @State var isAlertOn : Bool = false
    @State var message : String = ""
    
    var body: some View {
        
        VStack(alignment:.leading) {
            //Correo
            Text("Correo electrónico")
                .foregroundColor(Color("Dark-Cian"))
                .frame(width: 300,alignment: .leading)
            
            ZStack(alignment: .leading){
                
                if email.isEmpty {
                    Text(verbatim: "ejemplo@gmail.com")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                    
                }
                TextField("", text: $email)
                    .foregroundColor(.white)
            }
            Divider()
                .frame(height:1)
                .background(Color("Dark-Cian"))
                .padding(.bottom)
            
            
            //Contraseña
            Text("Contraseña")
                .foregroundColor(.white)
            
            ZStack(alignment: .leading){
                
                if pass.isEmpty {
                    Text( "Escribe tu contraseña")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                }
                SecureField("", text: $pass)
                    .foregroundColor(.white)
            }
            Divider()
                .frame(height:1)
                .background(Color.white)
                .padding(.bottom)
            
            
            //Nombre
            Text("Nombre ")
                .foregroundColor(.white)
            
            
            ZStack(alignment: .leading){
                
                if name.isEmpty {
                    Text( "Ingresa el nombre de usuario")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                }
                TextField("", text: $name)
                    .foregroundColor(.white)
            }
            Divider()
                .frame(height:1)
                .background(Color.white)
                .padding(.bottom)
            
            
            //Botón de incio de sesión
            Button {
                actualizarDatos()
            } label: {
                Text("Actualizar datos")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame( maxWidth: .infinity,  alignment: .center)
                    .padding(
                        EdgeInsets(
                            top: 11,
                            leading: 18,
                            bottom: 11,
                            trailing: 18
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(
                                Color("Dark-Cian"), lineWidth: 1.0)
                            .shadow(color: .white, radius: 6)
                    )
            }
            
            
            
            
            
        }
        .padding(.horizontal,42.0)
        .alert(isPresented: $isAlertOn) {
            Alert(
                title: Text("Error"),
                message: Text(message),
                dismissButton: .default(Text("Aceptar"))
            )
        }
        
    }
    
    func actualizarDatos(){
        
        if email.isEmpty || pass.isEmpty || name.isEmpty {
            message = "Debe llenar todos los campos"
            isAlertOn = true
        }else{
            let objetoActualizar = SaveData()
            let resultado =  objetoActualizar.storageData(
                correo: email,
                contrasena: pass,
                nombre: name
            )
            
            if resultado {
                isEditProfileViewActive = false
            }else{
                message = "hubo un error al momento de guardar, intente nuevamente."
                isAlertOn = true
            }
            
            
        }
        
        
    }
    
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(isEditProfileViewActive: .constant(true))
    }
}
