//
//  ContentView.swift
//  Slide Puzzle
//
//  Created by Sioma on 1/05/23.
//

import SwiftUI

struct ContentView: View {
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
//        GridItem(.flexible()),
//        GridItem(.flexible()),
//        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                LazyVGrid(columns: columns,spacing: 2){
                    ForEach(0..<9){ x in
                        TilePuzzle(
                            width: getWidth(proxy),
                            height: getHeight(proxy),
                            index: x + 1,
                            isHidden: (x + 1) == 9
                        )
                    }
                }
            }
            .frame(height: 300)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(Color.black)
    }
    
    func getWidth(_ proxy: GeometryProxy)->CGFloat{
        return proxy.frame(in: .global).width / CGFloat(columns.count)
    }
    
    func getHeight(_ proxy: GeometryProxy)->CGFloat{
        return proxy.frame(in: .global).height / CGFloat(columns.count)
    }
    
}

struct TilePuzzle: View {
    
    let width: CGFloat
    let height: CGFloat
    let index: Int
    let isHidden: Bool
    
    @State private var offsetX: CGFloat = 0.0
    @State private var offsetY: CGFloat = 0.0
    @GestureState private var isDragging = false
    
    var body: some View{
//        Button {
//
//        } label: {
//
//        }
        Text("\(index)")
            .font(.system(size: 20,weight: .medium))
            .foregroundColor(Color.black)
            .frame(width: width,height: height)
            .background( isHidden ? Color.blue : Color.white)
            .cornerRadius(10)
            .offset(x:offsetX, y:offsetY)
        .gesture(
            DragGesture()
                .updating($isDragging, body: { value, state, _ in
                    state = true
                    onChangedGesture(value: value)
                })
                .onEnded(onEndedGesture)
        )
    }
    
    private func onChangedGesture(value: DragGesture.Value){
        if isDragging {
            DispatchQueue.main.async {
                withAnimation(.linear){
                    self.offsetX = value.translation.width
                    self.offsetY = value.translation.height
                }
            }
        }
    }
    
    private func onEndedGesture(value: DragGesture.Value ){
        withAnimation(.linear){
            self.offsetX = 0
            self.offsetY = 0
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
