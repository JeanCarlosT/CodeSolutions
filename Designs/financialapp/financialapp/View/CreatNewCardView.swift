//
//  CreatNewCardView.swift
//  financialapp
//
//  Created by Sioma on 26/03/22.
//

import SwiftUI
import Combine

struct CreatNewCardView: View {
    
    var userLogged : User
    
    @StateObject var projectVm  = ProjectViewModel()
    
    @State var bg_color_selected : Int = 0
    
    @State var cardType_selected : CreditCardType = .Joven
    
    @State var numberOfcircles : Int = 0
    
    @Environment(\.presentationMode) private var presentation
    
    var body: some View {
        ZStack {
            Form{
                cardSection
                backgroundColor
                cardType
                //            backgroundCircles
                saveButton
            }
            .alert(isPresented: $projectVm.showAlert){
                Alert(
                    title: Text("Error"),
                    message: Text("Ha ocurrido un error."),
                    dismissButton: .cancel()
                )
            }
            
            if projectVm.isLoading {
                VStack{
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                    Spacer()
                }
            }
            
        }
    }
    
    var cardSection : some View{
        Section("Card"){
            CreditCard(
                index: 0,
                swipedCardCounter: .constant(0),
                card: projectVm.card,
                user: userLogged,
                showNumber: true
            )
                .frame(
                    width: CGFloat.getScreenWidth - 60,
                    height: 200
                )
        }
    }
    
    var backgroundColor : some View{
        Section("Background"){
            ScrollView(.horizontal,showsIndicators: false){
                HStack{
                    ForEach(projectVm.colors.indices){ x in
                        Circle()
                            .fill(Color(projectVm.colors[x]))
                            .frame(width: 20, height: 20)
                            .shadow(
                                color: bg_color_selected == x ? Color("grayColor") : Color.white ,
                                radius: 4, x: 2, y: 2
                            )
                            .overlay(
                                Image(systemName: "checkmark.circle")
                                    .font(.system(size: 18))
                                    .foregroundColor( bg_color_selected == x ? .white : Color(projectVm.colors[x]) )
                                
                            )
                            .onTapGesture {
                                withAnimation {
                                    bg_color_selected = x
                                    projectVm.card.background_color =  projectVm.colors[x]
                                }
                            }
                        
                    }
                }.padding()
            }
        }
    }
    
    var cardType : some View{
        Section("Card type"){
            Picker("card type", selection: $cardType_selected){
                ForEach(CreditCardType.allCases,id:\.self) { type in
                    Text(type.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: cardType_selected) { newValue in
                cardType_selected = newValue
                projectVm.change_money(cardType: cardType_selected )
                projectVm.card.tipo_tarjeta = cardType_selected.rawValue
            }
        }
    }
    
    var backgroundCircles : some View{
        Section("Circles"){
            Picker("How many circles do you want?", selection: $numberOfcircles){
                ForEach(0..<6) { i in
                    Text("\(i)")
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: numberOfcircles) { newValue in
                withAnimation {
                    projectVm.removeCircle()
                    projectVm.addCircles(newValue)
                }
            }
        }
    }
    
    var saveButton : some View{
        Section{
            Button {
                Task{
                  let result =   await projectVm.create_card(user_id: userLogged.identificacion)
                    if result {
                        DispatchQueue.main.async {
                            self.presentation.wrappedValue.dismiss()
                        }
                    }
                }
               
            } label: {
                Text("Save new card")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .font(.system(size: 20,weight: .medium))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
        }.listRowBackground(Color.clear)
    }
    
}

