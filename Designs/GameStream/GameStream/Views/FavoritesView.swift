//
//  FavoritesView.swift
//  GameStream
//
//  Created by MacBook Casa on 31/01/22.
//

import SwiftUI
import AVKit

struct FavoritesView: View {
    
    @ObservedObject var allTheVideoGames = ViewModel()
    
    var body: some View {
        ZStack{
            BackgroundColor().ignoresSafeArea()
            
            VStack{
                Text("Favoritos")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom,9.0)
                
                
                ScrollView{
                    
                    ForEach(allTheVideoGames.gamesInfo,id:\.self){ game in
                        let player = AVPlayer(url: URL(string: game.videosUrls.mobile)!
                        )
                        VStack(spacing:0) {
                            
                            VideoPlayer(player: player)
                                .frame(height:300)
                                .onDisappear {
                                    player.pause()
                            }
                            
                            Text("\(game.title)")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity,alignment: .leading)
                                .background(Color("Blue-gray"))
                                .clipShape(RoundedRectangle(cornerRadius: 3.0))
                            
                            
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                    
                }.padding(.bottom, 8)
                
                
                
            }.padding(.horizontal,6)
            
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
