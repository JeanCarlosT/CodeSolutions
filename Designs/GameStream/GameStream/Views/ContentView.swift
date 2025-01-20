//
//  ContentView.swift
//  GameStream
//
//  Created by MacBook Casa on 28/01/22.
//

import SwiftUI

struct BackgroundColor : View{
    var body: some View{
        Color("marine")
            .ignoresSafeArea()
    }
}

struct AppLogo : View {
    var body: some View {
        HStack{
            Image("logo1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25)
            Image("logo2")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
        }
        .padding(.bottom,30)
    }
}

struct LoginAndRegister : View {
    
    @State var isloginActive : Bool = true
    
    var body: some View {
        
        VStack{
            
            //Botones de elección
            HStack{
                Spacer()
                
                Button("INICIA SESIÓN") {
                    isloginActive = true
                }
                .foregroundColor(isloginActive ? .white : .gray)
                
                
                Spacer()
                
                Button("REGISTRATE") {
                    isloginActive = false
                }
                .foregroundColor(isloginActive ? .gray : .white)
                
                
                Spacer()
            }
            
            Spacer(minLength: 42)
            
            //Vista principal
            if isloginActive {
                LoginView()
            }else{
                RegisterView(isloginActive: $isloginActive)
            }
            
        }
        .padding(20)
        
        
    }
}

struct LoginView : View {
    @State var email : String = ""
    
    @State var pass : String = ""
    
    @State var isNavigationActive : Bool = false
    
    @State var isAlertOn : Bool = false
    
    @State var message : String = ""
    
    var body : some View{
        
        
        ScrollView {
            
            VStack(alignment: .leading ){
                
                //Correo
                
                Text( "Correo electrónico")
                    .foregroundColor(Color("Dark-Cian"))
                
                ZStack(alignment: .leading){
                    
                    if email.isEmpty {
                        Text( verbatim:  "ejemplo@gmail.com")
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
                
                
                //Olvidaste tu contraseña
                Text("¿Olvidaste tu contraseña?")
                    .font(.footnote)
                    .foregroundColor(Color("Dark-Cian"))
                    .frame(width: 300,alignment: .trailing)
                    .padding(.bottom)
                
                
                
                //Botón de incio de sesión
                Button {
                    iniciarSession()
                } label: {
                    Text("INICIAR SESIÓN")
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
                
                
                //Inicia sesión con redes sociales
                Text("Inicia sesión con redes sociales")
                    .foregroundColor(.white)
                    .frame(maxWidth:300,alignment: .center)
                    .padding(.vertical, 20)
                
                HStack{
                    
                    Button {
                        print("Facebook")
                    } label: {
                        Text("Facebook")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 3.0)
                            .frame(maxWidth:.infinity ,alignment: .center)
                            .background(Color("Blue-gray"))
                            .clipShape(RoundedRectangle(cornerRadius: 4.0))
                    }
                    
                    Spacer()
                    
                    Button {
                        print("Twitter")
                    } label: {
                        Text("Twitter")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 3.0)
                            .frame(maxWidth:.infinity ,alignment: .center)
                            .background(Color("Blue-gray"))
                            .clipShape(RoundedRectangle(cornerRadius: 4.0))
                        
                    }
                    
                    
                    
                }
                
            }
            .padding(.horizontal,77.0)
            
            NavigationLink(
                destination: HomePage(),
                isActive: $isNavigationActive,
                label:{
                    EmptyView()
                }
            )
            
        }.alert(isPresented: $isAlertOn) {
            Alert(
                title: Text("Error"),
                message: Text("\(message)"),
                dismissButton: .default(Text("Aceptar"))
            )
        }
        
        
    }
    
    func iniciarSession(){
        
        if email.isEmpty || pass.isEmpty {
            message = "Debe llenar todos los campos."
            isAlertOn = true
        }else{
            let saveDataObject = SaveData()
            let result = saveDataObject.validateUserData(correo: email, contrasena: pass)
            if result {
                isNavigationActive = true
            }else{
                message = "Usuario y/o contraseña son incorrectos."
                isAlertOn = true
            }
        }
       
        
       
    }
    
}

struct RegisterView : View {
    @State var name : String = ""
    @State var email : String = ""
    @State var pass : String = ""
    @State var confirmPass : String  = ""
    @State var isAlertOn : Bool = false
    @State var message : String = ""
    @Binding var  isloginActive : Bool
    
    var body : some View {
        
        ScrollView {
            
            //Elije una foto de perfil
            VStack{
                
                Text("Elije una foto de perfil")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Puedes cambiarla o elegirla más adelante")
                    .font(.footnote)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                    .padding(.bottom)
                
                Button {
                    takePicture()
                } label: {
                    ZStack{
                        Image("foto-prueba")
                        Image(systemName: "camera")
                            .foregroundColor(.white)
                    }
                }
                
                
            }
            .alert(isPresented: $isAlertOn) {
                Alert(
                    title: Text("Error"),
                    message: Text("\(message)"),
                    dismissButton: .default(Text("Aceptar"))
                )
            }
            
            VStack(){
                
                //Inputs
                VStack(alignment: .leading ){
                    
                    VStack{
                        //Nombre
                        Text("Nombre*")
                            .foregroundColor(Color("Dark-Cian"))
                            .frame(width: 300,alignment: .leading)
                        
                        ZStack(alignment: .leading){
                            
                            if name.isEmpty {
                                Text(verbatim: "Ingresa tu nombre completo")
                                    .font(.caption)
                                    .foregroundColor(Color.gray)
                                
                            }
                            TextField("", text: $name)
                                .foregroundColor(.white)
                        }
                        Divider()
                            .frame(height:1)
                            .background(Color("Dark-Cian"))
                            .padding(.bottom)
                    }
                    
                    
                    //Correo
                    Text("Correo electrónico*")
                        .foregroundColor(Color.white)
                        .frame(width: 300,alignment: .leading)
                    
                    ZStack(alignment: .leading){
                        
                        if email.isEmpty {
                            Text(verbatim:"ejemplo@gmail.com")
                                .font(.caption)
                                .foregroundColor(Color.gray)
                            
                        }
                        TextField("", text: $email)
                            .foregroundColor(.white)
                    }
                    Divider()
                        .frame(height:1)
                        .background(Color.white)
                        .padding(.bottom)
                    
                    
                    //Contraseña
                    Text("Contraseña*")
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
                    
                    //Confirmar contraseña
                    Text("Confirmar contraseña*")
                        .foregroundColor(.white)
                    
                    
                    ZStack(alignment: .leading){
                        
                        if confirmPass.isEmpty {
                            Text( "Vuelve a escribir tu contraseña")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                        }
                        SecureField("", text: $confirmPass)
                            .foregroundColor(.white)
                    }
                    Divider()
                        .frame(height:1)
                        .background(Color.white)
                        .padding(.bottom)
                }
                
                
                //Botón de incio de sesión
                Button {
                    register()
                } label: {
                    Text("REGISTRATE")
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
                
                
                //Inicia sesión con redes sociales
                Text("Inicia sesión con redes sociales")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity ,alignment: .center)
                    .padding(.vertical, 20)
                
                HStack{
                    
                    Button {
                        print("Facebook")
                    } label: {
                        Text("Facebook")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 3.0)
                            .frame(maxWidth:.infinity ,alignment: .center)
                            .background(Color("Blue-gray"))
                            .clipShape(RoundedRectangle(cornerRadius: 4.0))
                        
                    }
                    
                    Spacer()
                    
                    Button {
                        print("Twitter")
                    } label: {
                        Text("Twitter")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 3.0)
                            .frame(maxWidth:.infinity ,alignment: .center)
                            .background(Color("Blue-gray"))
                            .clipShape(RoundedRectangle(cornerRadius: 4.0))
                        
                    }
                    
                    
                    
                }
                
            }
            .padding(.horizontal,77.0)
            
            
        }
    }
    
    func register(){
        if name.isEmpty || email.isEmpty || pass.isEmpty || confirmPass.isEmpty {
            message = "Debe llenar todos los campos"
            isAlertOn = true
        }else  if pass != confirmPass {
            message = "Las contraseñas no iguales"
            isAlertOn = true
        }else{
            let saveDataObject = SaveData()
            let result = saveDataObject.storageData(
                correo: email,
                contrasena: pass,
                nombre: name
            )
            
            if result {
                isloginActive = true
            }else{
                message = "Problemas al almacenar los datos, intente nuevamente."
                isAlertOn = true
            }
            
            
        }
        
    }
    
}

func takePicture(){
    print("Taking picture")
}

struct ContentView: View {
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Spacer()
                
                BackgroundColor()
                
                VStack{
                    AppLogo()
                    
                    LoginAndRegister()
                }
                
            }
            .navigationBarHidden(true)
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
