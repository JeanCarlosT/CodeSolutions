//
//  LoginRegisterView.swift
//  financialapp
//
//  Created by Sioma on 26/03/22.
//

import SwiftUI

struct LoginRegisterView: View {
    
    @StateObject var loginVm : LoginViewModel = LoginViewModel()
    
    @State var id : String = ""
    
    @FocusState var focus : Bool
    
    var body: some View {
        ZStack{
            background
                .ignoresSafeArea(.keyboard, edges: .all)
            
            content
                
                
            if loginVm.isLoading {
                loadingView
            }
            
            NavigationLink(
                isActive: $loginVm.navigate,
                destination: {
                    ContentView(user : loginVm.userLogged)
                },
                label: {EmptyView()}
            )
            
        }
        .alert(isPresented: $loginVm.showAlert){
            Alert(
                title: Text("Error"),
                message: Text("Ha ocurrido un error"),
                dismissButton: .cancel()
            )
        }
        .ignoresSafeArea(.keyboard, edges: .all)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                focus = true
            }
        }
    }
    
    var background : some View{
        VStack{
            HStack{
                Circle()
                    .fill(Color("loginColor2"))
                    .frame(width: 300, height: 300)
                    .offset(x: -80, y: -110)
                Circle()
                    .fill(Color("loginColor"))
                    .frame(width: 300, height: 300)
                    .offset(x: -200, y: -200)
            }
            
            Spacer()
            
            HStack{
                Circle()
                    .fill(Color("loginColor"))
                    .frame(width: 300, height: 300)
                    .offset(x: 250, y: 200)
                Circle()
                    .fill(Color("loginColor2"))
                    .frame(width: 300, height: 300)
                    .offset(x: 40, y: 70)
            }
        }
        .frame( maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
    
    var sign_in_button : some View{
        Button {
            Task{
               await loginVm.login(user_id: id)
            }
        } label: {
            Image(systemName: "arrow.right")
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame( width: 40 , height: 40 )
                .background(Color("signInColor"))
                .clipShape(Circle())
        }

    }
    
    var content  : some View{
        VStack(alignment:.leading,spacing: 20){
            Spacer()
            Text("Login")
                .font(.system(size:25,weight:.semibold))
                .foregroundColor(.gray)
            HStack{
                Spacer(minLength: 50)
                Image(systemName: "person")
                    .font(.system(size: 30))
                    .foregroundColor(.gray)
                TextField("Identificación", text: $id)
                    .focused($focus)
                    .foregroundColor(.black)
                    .frame( height: 70 )
                    .overlay(alignment: .trailing, content: {
                        sign_in_button
                    })
            }
            .frame(width: .getScreenWidth - 50, height: 70)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(color: Color("grayColor"), radius: 5, x: 2, y: 2)
            .offset(x: -50)
            Spacer()
        }
    }
    
    var loadingView : some View{
        VStack{
            Spacer()
            ProgressView()
                .font(.system(size: 40))
                .progressViewStyle(.circular)
            Spacer()
        }
        .ignoresSafeArea()
    }
    
}

struct LoginRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        LoginRegisterView()
    }
}
