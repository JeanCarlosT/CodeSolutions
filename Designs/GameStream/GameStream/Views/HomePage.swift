//
//  HomePage.swift
//  GameStream
//
//  Created by MacBook Casa on 28/01/22.
//

import SwiftUI

import AVKit

struct HomePage: View {
    
    @State var tagSelected : Int = 2
    
    init() {
        UITabBar.appearance().barTintColor = UIColor(Color("TabBar-color"))
        UITabBar.appearance().isTranslucent = true
    }
    
    var body: some View {
        
        TabView(selection: $tagSelected) {
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Perfil")
                }
                .tag(0)
            
           GamesView()
                .tabItem {
                    Image(systemName: "gamecontroller")
                    Text("Juegos")
                }
                .tag(1)
            
            HomeScreen()
                .font(.system(size: 30,weight: .bold,design: .rounded))
                .tabItem {
                    Image(systemName: "house")
                    Text("Inicio")
                }
                .tag(2)
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favoritos")
                }
                .tag(3)
        }
        .accentColor(Color.white)
        
        
    }
    
    
}

struct HomeScreen : View {

    var body: some View{
        
        ZStack{
            //Background
            BackgroundColor()
            
            VStack{
                
                //Logo
                HStack{
                    Image("logo1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25)
                    Image("logo2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150)
                }.padding(.horizontal,30)
                
                SubmoduleHome()
                
                Spacer()
                
            }.padding(.horizontal,18)
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
        
        
    }
    
    
}

struct SubmoduleHome : View {
    
    @State var searchText : String = ""
    
    @State var isPlayerActive = false
    
    @State var isGameInfoEmpty: Bool = false
    
    @State var counter : Int = 1
    
    @ObservedObject var gameFind = SearchGame()
    
    @State var isGameviewActive:Bool = false
    
    @State var url:String = ""
    @State var titulo:String = ""
    @State var studio:String = ""
    @State var califacion:String = ""
    @State var anoPublicacion:String = ""
    @State var descripcion:String = ""
    @State var tags:[String] = [""]
    @State var imgsUrl:[String] = [""]
    
    
    
    var body: some View {
        
        
        
        VStack {
            
            //Buscador
            HStack{
                
                Button(action:{
                    
                    searchFunction(by: searchText)
                    
                },label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 18))
                        .foregroundColor(searchText.isEmpty ? Color.yellow : Color("Dark-Cian") )
                }).alert(isPresented: $isGameInfoEmpty){
                    Alert(
                        title: Text("Error"),
                        message: Text("No se encontro el juego"),
                        dismissButton: .default(Text("Entendido"))
                    )
                }
                
                
                
                
                
                ZStack(alignment: .leading){
                    
                    if searchText.isEmpty {
                        Text("Buscar un video")
                            .font(.system(size: 18))
                            .foregroundColor(Color("search-gray"))
                    }
                    TextField("", text: $searchText)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                    
                }
                
                
            }.padding([.top,.leading,.bottom],11.0)
                .background(Color("Blue-gray"))
                .clipShape(Capsule())
            
            
            Text("LOS MÁS POPULARES")
                .font(.title3)
                .foregroundColor(.white)
                .bold()
                .frame(minWidth: 0,  maxWidth: .infinity, alignment: .leading)
                .padding(.top)
            
            
            ZStack{
                
                //Imagen de fondo
                
                Button {
                    searchFunction(by: "The Witcher 3")
                    
                } label: {
                    VStack(spacing:0){
                        
                        Image("The Witcher 3")
                            .resizable()
                            .scaledToFit()
                        
                        Text("The Witcher 3 : Wild Hunt")
                            .font(.subheadline)
                            .frame(minWidth: 0,  maxWidth: .infinity, alignment: .leading)
                            .background(Color("Blue-gray"))
                    }
                }
                
                
                //Icono de reproduccion
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 42, height: 42)
                
                
                
                
                
            }
            .frame(minWidth: 0,  maxWidth: .infinity, alignment: .center)
            .padding(.vertical)
            
            
            Text("CATEGORÍAS SUGERIDAS PARA TI")
                .font(.title3)
                .foregroundColor(.white)
                .bold()
                .frame(minWidth: 0,  maxWidth: .infinity, alignment: .leading)
                .padding(.top)
            
            ScrollView (.horizontal,showsIndicators: false){
                
                HStack{
                    //FPS CATEGOY
                    Button {
                        print("Category one")
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("Blue-gray"))
                                .frame(width: 160, height: 90)
                            VStack {
                                Image("FPS")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 42, height: 42)
                                Text("FPS")
                                    .bold()
                                    .foregroundColor(Color("Dark-Cian"))
                            }
                        }
                    }
                    
                    
                    //RPG CATEGORY
                    Button {
                        print("Category two")
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("Blue-gray"))
                                .frame(width: 160, height: 90)
                            VStack {
                                Image("RPG")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 42, height: 42)
                                Text("RPG")
                                    .bold()
                                    .foregroundColor(Color("Dark-Cian"))
                            }
                        }
                    }
                    
                    //openworld CATEGORY
                    Button {
                        print("Category three")
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("Blue-gray"))
                                .frame(width: 160, height: 90)
                            VStack {
                                Image("OpenWorld")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 42, height: 42)
                                Text("OW")
                                    .bold()
                                    .foregroundColor(Color("Dark-Cian"))
                            }
                        }
                    }
                    
                    
                }
                
            }
            
            
            Text("RECOMENDADOS PARA TI")
                .font(.title3)
                .foregroundColor(.white)
                .bold()
                .frame(minWidth: 0,  maxWidth: .infinity, alignment: .leading)
                .padding(.top)
            
            
            ScrollView(.horizontal, showsIndicators: false){
                
                HStack{
                    
                    
                    //Firts game
                    Button {
                        searchFunction(by: "Abzu")
                    } label: {
                        Image("Abzu")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 240, height: 135)
                        
                    }
                    //second game
                    Button {
                        searchFunction(by: "Crash Bandicoot")
                        
                    } label: {
                        Image("Crash Bandicoot")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 240, height: 135)
                        
                    }
                    
                    //third game
                    Button {
                        searchFunction(by: "Cuphead")
                        
                    } label: {
                        Image("Cuphead")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 240, height: 135)
                        
                    }
                    
                    //four game
                    Button {
                        searchFunction(by: "DEATH STRANDING")
                        
                    } label: {
                        Image("DEATH STRANDING")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 240, height: 135)
                        
                    }
                    
                    //Five game
                    Button {
                        searchFunction(by: "Grand Theft Auto V")
                        
                    } label: {
                        Image("Grand Theft Auto V")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 240, height: 135)
                        
                    }
                    
                    //Six game
                    Button {
                        searchFunction(by: "Hades")
                        
                    } label: {
                        Image("Hades")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 240, height: 135)
                        
                    }
                    
                    
                    
                }
                
            }
            
            
            
        }
        
        
        NavigationLink(isActive: $isGameviewActive) {
            GameView(url: url, titulo: titulo, studio: studio, califacion: califacion, anoPublicacion: anoPublicacion, descripcion: descripcion, tags: tags, imgsUrl: imgsUrl)
        } label: {
            EmptyView()
        }
        
       
        
        
        
    }
    
    func searchFunction(by gameName:String){
        gameFind.searchGame(by: gameName)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3 ) {
            print("Cantidad E: \(gameFind.searchInfo.count)")
            
            if gameFind.searchInfo.count == 0 {
                isGameInfoEmpty = true
            }else{
                url = gameFind.searchInfo[0].videosUrls.mobile
                titulo =  gameFind.searchInfo[0].title
                studio = gameFind.searchInfo[0].studio
                califacion = gameFind.searchInfo[0].contentRaiting
                anoPublicacion = gameFind.searchInfo[0].publicationYear
                descripcion = gameFind.searchInfo[0].description
                tags = gameFind.searchInfo[0].tags
                imgsUrl = gameFind.searchInfo[0].galleryImages
                
                isGameviewActive = true
                
            }
            
        }
        
        
        
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
