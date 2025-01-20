//
//  GameView.swift
//  GameStream
//
//  Created by Jean Carlos Quejada Toro on 31/01/22.
//

import SwiftUI
import AVKit
import Kingfisher

struct GameView: View {
    var url:String
    var titulo:String
    var studio:String
    var califacion:String
    var anoPublicacion:String
    var descripcion:String
    var tags:[String]
    var imgsUrl:[String]
    
    
    var body: some View {
        
        ZStack{
            
            BackgroundColor()
            
            
            
            VStack {
                video(url: url)
                    .frame( height: 300)
                
                ScrollView{
                    //información del video
                    VideoInformation(url: url, titulo: titulo, studio: studio, califacion: califacion, anoPublicacion: anoPublicacion, descripcion: descripcion, tags: tags)
                    
                    Gallery(imgsUrl:imgsUrl)
                    
                }.frame(maxWidth:.infinity)
                
            }
            
            
           
            
            
        }
        
        
       
    }
    
}

struct video: View {
    var url : String
    var body : some View{
        let player = AVPlayer(
            url: URL(string: url)!
        )
        VideoPlayer(
            player : player
        ).ignoresSafeArea()
            .onDisappear {
                player.pause()
            }
        
        
    }
}

struct VideoInformation : View {
    var url:String
    var titulo:String
    var studio:String
    var califacion:String
    var anoPublicacion:String
    var descripcion:String
    var tags:[String]
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(titulo)
                .foregroundColor(.white)
                .font(.largeTitle)
                .padding(.leading)
            
            //studio + calificacino + año
            HStack{
                
                Text("\(studio)")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .padding(.top,5)
                    .padding(.leading)
                
                Text("\(califacion)")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .padding(.top,5)
                    .padding(.leading)
                
                Text("\(anoPublicacion)")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .padding(.top,5)
                    .padding(.leading)
                
                
            }
            
          //Descripcion
            
            Text("\(descripcion)")
                .foregroundColor(.white)
                .font(.subheadline)
                .padding(.top,5)
                .padding(.leading)
            
            //Tags
            HStack{
                ForEach(tags,id:\.self){ tag in
                    Text("#\(tag)")
                        .foregroundColor(.white)
                        .font(.subheadline)
                        .padding(.top,5)
                        .padding(.leading)
                    
                }
            }
            
            
        }.frame(maxWidth:.infinity,alignment: .leading)
        
        
    }
    
}

struct Gallery : View {
    
    var imgsUrl:[String]
    
    let formaGrid = [
    
        GridItem(.flexible())
        
    ]
    
    
    var body: some View {
       
        VStack(alignment:.leading){
            
            Text("GALERÍA")
                .foregroundColor(.white)
                .font(.title)
                .padding(.leading)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                LazyHGrid(rows:formaGrid,spacing: 8){
                    ForEach(imgsUrl,id:\.self){ imgs in
                        
                        KFImage(URL(string: imgs))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                        
                    }
                }
                
            }.frame(height:180)
            
            
        }.frame(maxWidth: .infinity ,alignment: .leading)
        
        
    }
    
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(url: "ejemplo.com", titulo: "FirstGame", studio: "Sony", califacion: "E+", anoPublicacion: "2021", descripcion: "Juego de sega genesis publicado en 2021 con más de 40 millones de copias vendidas actualmente", tags: ["mobile","tablet"], imgsUrl: [""])
    }
}
