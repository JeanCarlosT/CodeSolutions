//
//  GamesView.swift
//  GameStream
//
//  Created by MacBook Casa on 29/01/22.
//

import SwiftUI

import Kingfisher


struct GamesView: View {
    
    @ObservedObject var allVideoGames = ViewModel()
    
    @State var gameViewIsActive : Bool = false
    
    @State var url:String = ""
    @State var titulo:String = ""
    @State var studio:String = ""
    @State var califacion:String = ""
    @State var anoPublicacion:String = ""
    @State var descripcion:String = ""
    @State var tags:[String] = [""]
    @State var imgsUrl:[String] = [""]
    
    let formaGrid = [
        GridItem(.flexible()),
        GridItem(.flexible())
        
    ]
    
    
    
    var body: some View {
        
        ZStack{
            
            BackgroundColor()
            
            //Contenido
            VStack{
                //Titulo
                Text("Juegos")
                    .font(.title2)
                    .foregroundColor(.white)
                    .bold()
                    .padding(
                        EdgeInsets(
                            top: 16,
                            leading: 0,
                            bottom: 64,
                            trailing: 0
                        )
                    )
                
                
                //Lazy V Grid
                LazyVGrid(columns: formaGrid,spacing: 8){

                    ForEach(allVideoGames.gamesInfo,id: \.self) { juego in

                        Button {
                            url = juego.videosUrls.mobile
                            titulo = juego.title
                            studio = juego.studio
                            califacion = juego.contentRaiting
                            anoPublicacion = juego.publicationYear
                            descripcion = juego.description
                            tags = juego.tags
                            imgsUrl = juego.galleryImages

                            print("This is the game pressed : \(titulo)")

                            gameViewIsActive = true


                        } label: {
                            KFImage(URL(string:"\(juego.galleryImages[0])")!)
                                .resizable()
                                .aspectRatio( contentMode: .fit)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .padding(.bottom,12)

                        }


                    }

                }

                
                
                
                
                
                
                
            }
            
            NavigationLink(
                isActive: $gameViewIsActive
            ) {
                GameView(url: url, titulo: titulo, studio: studio, califacion: califacion, anoPublicacion: anoPublicacion, descripcion: descripcion, tags: tags, imgsUrl: imgsUrl)
                } label: {
                    EmptyView()
                }

        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
//            print("Primer elemento del json: \(allVideoGames.gamesInfo[0])")
//            print("Tituñpdeñ primer video  juego del json :  \(allVideoGames.gamesInfo[0].title)")
        }
        
        
        
        
    }
}

struct GamesView_Previews: PreviewProvider {
    static var previews: some View {
        GamesView()
    }
}
