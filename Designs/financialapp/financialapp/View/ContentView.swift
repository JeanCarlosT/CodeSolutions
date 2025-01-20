//
//  ContentView.swift
//  financialapp
//
//  Created by Sioma on 7/03/22.
//

import SwiftUI

struct ContentView: View {
    
    var userLogged : User
    
    @StateObject var homeVm : HomeViewModel = HomeViewModel()
    
    @State var cardSelected : Card = Card(
        tarjeta_id: "",
        background_color: "",
        numero: "",
        monto: "",
        fecha_vencimiento: "",
        codigo_seguridad: "",
        tipo_tarjeta: "",
        persona_id: "",
        offset: 0.0,
        colors: []
    )
    
    @State var index_selected : Int = 0
    
    @Environment(\.presentationMode) private var presentationMode
    
    @Namespace var cardHeroAnimation
    
    @State var isSheetActive : Bool = false{
        willSet{
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.focus = .monto
                }
            }
        }
    }
    
    @State var destination : String = ""
    
    @State var amount : String = ""
    
    @FocusState var focus : FocusableField?
    
    init(user : User){
        self.userLogged = user
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading){
                ///app bar
                appBar
                
                ///Tarjetas del usuario
                paintCards
                
                //Return cards
                returnCards
                
                Spacer()
                
                //Transacciones
                //            Transactions()
            }
            .navigationTitle("My personal account")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar(content: {
                ToolbarItem(placement: .navigation) {
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack(spacing:5){
                            Image(systemName:"chevron.left")
                            Text("Salir")
                        }
                        .font(.system(size: 18,weight:.medium))
                    }
                    
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink(destination: CreatNewCardView(userLogged: userLogged)){
                        HStack(spacing:0){
                            Image(systemName: "plus")
                                .font(.system(size: 15))
                                .foregroundColor(Color("Morado"))
                            Text("Add")
                                .font(.system(size: 15))
                                .foregroundColor(Color("Morado"))
                        }
                    }
                }
            })
            .padding(.vertical)
            .background(Color.gray.opacity(0.03))
            .blur(radius: homeVm.showCardDetail ? 30 : 0)
            .sheet(isPresented: $isSheetActive, onDismiss: onDismiss) {
                sheetModalView
            }
            .alert(isPresented: $homeVm.showAlert){
                Alert(
                    title: Text("Error"),
                    message: Text("Ha ocurrido un error."),
                    dismissButton: .cancel()
                )
            }
            
            if homeVm.showCardDetail {
                cardDetail
            }
            
            if homeVm.isLoading {
                loadingView
            }
            
            
        }
        .onAppear {
            homeVm.initialize(user_id: userLogged.identificacion)
        }
        .onDisappear {
            for index in homeVm.creditCards.indices.reversed(){
                withAnimation {
                    homeVm.creditCards[index].offset = 0.0
                    homeVm.swipedCardCounter = 0
                }
            }
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
    
    var appBar: some View{
        HStack{
            //MARK: name
            VStack(alignment:.leading){
                Text("Welcome!")
                    .font(.system(size: 12, weight: .heavy))
                    .foregroundColor(.gray)
                Text(userLogged.nombre)
                    .font(.system(size: 15, weight: .heavy))
                    .foregroundColor(.primary)
            }
            Spacer()
            //MARK: photo
            Image(systemName: "applelogo")
                .foregroundColor(Color("Morado"))
                .padding(4)
                .background(
                    Circle()
                        .strokeBorder(Color.primary,lineWidth: 1)
                )
        }
        .padding(30)
    }
    
    var cardDetail : some View{
        VStack(spacing:5){
            //MARK: Tarjeta selecionada por el usuario
            CreditCard(
                index: 0,
                swipedCardCounter: .constant(0),
                card: cardSelected,
                user: userLogged,
                showNumber: true
            )
                .frame(
                    width: getWidth(index: 0),
                    height: getHeight(index: 0) - 10
                )
                .matchedGeometryEffect(id: "CARD_HERO \(index_selected)", in: cardHeroAnimation)
            
            //MARK: servicios
            servicios
            
            //MARK: transaciones por tarjeta seleccionada
            if homeVm.transactions.count > 0 {
                transacciones
            }else{
                Spacer()
            }
           
            
            
            //MARK: Close button
            Button {
                withAnimation {
                    homeVm.showCardDetail = false
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 18,weight: .bold))
                    .foregroundColor(Color.white)
                    .padding()
                    .background(Color.secondary)
                    .clipShape(Circle())
            }
            
        }
        .padding(10)
        .frame(maxWidth: .infinity , maxHeight: .infinity)
        .background(Color.white.opacity(0.3))
    }
    
    var servicios: some View{
        VStack(alignment:.leading){
            Text("Servicios")
                .font(.system(size: 12, weight: .heavy))
                .foregroundColor(.gray)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    ForEach(ServicesAllows.allCases,id:\.rawValue) { service in
                        Button {
                            isSheetActive = true
                            homeVm.service = service
                        } label: {
                            VStack{
                                Image(systemName: "creditcard.fill")
                                Text(service.rawValue)
                                    .font(.system(size: 15,weight:.medium))
                                    .lineLimit(3)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(width: 150, height: 70)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .shadow(color: Color("grayColor"), radius: 4, x: 2, y: 2)
                            
                        }
                        
                    }
                    
                }
                .padding(.vertical)
                
            }
        }
        .padding()
    }
    
    var sheetModalView : some View{
        VStack{
            Text(homeVm.service.rawValue)
                .font(.system(size: 25, weight: .semibold))
                .foregroundColor(.accentColor)
            Form{
                Section("origin product"){
                    Text(homeVm.cardNumber(cardSelected.numero))
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.gray)
                }
                Section("Amount"){
                    TextField("", text: $amount){
                        focus = .destination
                    }
                    .focused($focus, equals: .monto)
                    .submitLabel(.next)
                }
                Section("destination product"){
                    TextField("",text: $destination){
                        saveTransaction()
                    }
                    .focused($focus, equals: .destination)
                    .submitLabel(.done)
                }
                Button {
                    saveTransaction()
                } label: {
                    Text("Create transaction")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .font(.system(size: 20,weight: .medium))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .listRowBackground(Color.clear)
            }
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                focus = .monto
            }
        })
        .padding()
        
    }
    
    var transacciones: some View{
        VStack(alignment:.leading){
            Text("Transacciones")
                .font(.system(size: 12, weight: .heavy))
                .foregroundColor(.gray)
            List(homeVm.transactions.indices){ x in
                TransactionItem(transaction: homeVm.transactions[x])
                    .listRowBackground(Color.white)
                    .listRowSeparator(.hidden)
            }
            .background(Color.white)
            .listStyle(.plain)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color("grayColor"), radius: 10, x: 2, y: 2)
        }
        .padding()
    }
    
    var paintCards : some View{
        HStack{
            ZStack(alignment:Alignment(horizontal: .leading, vertical: .top)){
                
                ForEach(homeVm.creditCards.indices.reversed(), id:\.self){ i in
                    HStack{
                        Spacer()
                        CreditCard(
                            index: i,
                            swipedCardCounter: $homeVm.swipedCardCounter,
                            card: homeVm.creditCards[i],
                            user: userLogged
                        )
                        
                            .onTapGesture {
                                withAnimation { homeVm.transactions.removeAll()}
                                self.homeVm.getCard_transaction(tarjeta_id: self.homeVm.creditCards[i].tarjeta_id )
                                index_selected = i
                                cardSelected = homeVm.creditCards[i]
                                withAnimation { homeVm.showCardDetail = true }
                            }
                        //Hero animation
                            .matchedGeometryEffect(id: "CARD_HERO \(i)", in: cardHeroAnimation)
                        
                            .frame(
                                width: getWidth(index: i - homeVm.swipedCardCounter),
                                height: getHeight(index: i - homeVm.swipedCardCounter)
                            )
                        
                            .offset(
                                x: CreditCard.cardOffsetX(index: i - homeVm.swipedCardCounter),
                                y:-CreditCard.cardOffsetY(index: i - homeVm.swipedCardCounter)
                            )
                        
                        
                        Spacer()
                    }
                    .frame(height: 300)
                    .offset(
                        x: homeVm.creditCards[i].offset,
                        y: homeVm.creditCards[i].offset
                    )
                    .rotationEffect(.degrees(angleByCard(index: i)))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged({ value in
                                onChanged(value: value, index: i)
                            })
                            .onEnded({ value in
                                onEnded(value: value, index: i)
                            })
                    )
                }
            }
            .frame(width: .getScreenWidth, height: 250)
            
        }
    }
    
    var returnCards : some View{
        //Regresar tarjetas
        Button {
            for index in homeVm.creditCards.indices.reversed(){
                withAnimation {
                    homeVm.creditCards[index].offset = 0.0
                    homeVm.swipedCardCounter = 0
                }
            }
        } label: {
            VStack(alignment: .center){
                Spacer()
                Image(systemName: "arrow.right")
                    .font(.system(size: 50))
                    .foregroundColor(Color("Morado"))
                    .padding(4)
                    .frame(width: 70 , height: 70)
                    .background(
                        Circle()
                            .strokeBorder(Color.gray,lineWidth: 1)
                    )
                
                Text("Return cards")
                    .font(.caption)
                Spacer()
                
            }
            .padding(5)
            .frame(maxWidth: .infinity)
        }
    }
    
    func string_CGFloat(_ str : String)->CGFloat{
        if let n = NumberFormatter().number(from: str) {
            let f = CGFloat(truncating: n)
            return f
        }else{
            return CGFloat.random(in: 0.0..<40.0)
        }
    }
    
    func onChanged(value : DragGesture.Value, index : Int){
        //Sólo movimiento hacia arriba
        if value.translation.height < 0 {
            homeVm.creditCards[index].offset = value.translation.height
        }
    }
    
    func onEnded(value : DragGesture.Value, index : Int){
        withAnimation {
            if value.translation.height < -100 {
                homeVm.creditCards[index].offset = -500.0
                homeVm.swipedCardCounter += 1
            }else{
                homeVm.creditCards[index].offset = 0.0
            }
        }
    }
    
    func angleByCard(index : Int)->Double {
        withAnimation {
            let offset = homeVm.creditCards[index].offset
            let minimumValue = CGFloat(-30)
            if offset == 0.0{
                return 0.0
            }else if offset >= minimumValue {
                return  Double(offset)
            }
            return minimumValue
        }
    }
    
    func getWidth(index: Int)->CGFloat {
        let boxWidth = CGFloat.getScreenWidth - 60
        let cardWidth = index <= 3 ? CGFloat(index) * 30 : 60
        return boxWidth - cardWidth
    }
    
    func getHeight(index: Int)->CGFloat {
        let boxHeight = CGFloat(200)
        let cardHeight = index <= 3 ? CGFloat(index) * 20 : 40
        return boxHeight - cardHeight
    }
    
    func onDismiss(){
        
    }
    
    func saveTransaction(){
        print("Saving new account")
    }
}


struct TransactionItem:View{
    var transaction : TransactionModel
    var body: some View{
        VStack {
            HStack{
                VStack(alignment:.leading){
                    Text(transaction.tipo_transaccion)
                        .foregroundColor(.black)
                        .font(.system(size: 15, weight: .regular))
                        .frame(width: 200, height: 60,alignment:.leading)
                        .lineLimit(2)
                        
                }
                Spacer()
                VStack(alignment:.leading){
                    Text( convertDoubleToCurrency( Double(transaction.monto) ?? 0.0 ))
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.red)
                    Text(transaction.created_at)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                }
            }
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame( height: 1)
        }
        .padding(.horizontal,5)
    }
    
    func convertDoubleToCurrency(_ amount : Double)->String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.string(from: NSNumber(value: amount)) ?? "0.0"
    }
    
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


extension CGFloat {
    static var getScreenWidth : CGFloat {
        UIScreen.main.bounds.size.width
    }
    static var getScreenHeight : CGFloat {
        UIScreen.main.bounds.size.height
    }
}


struct RotateViewModifier : ViewModifier{
    func body(content: Content) -> some View {
        content.foregroundColor(Color.red)
    }
}
