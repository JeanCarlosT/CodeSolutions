//
//  FAButton2.swift
//  FloatingButton
//
//  Created by Sioma on 30/03/23.
//

import SwiftUI

struct CircularScrollView<Content: View>: View {
    
    let numberOfItems: Int
    let itemSize: CGFloat
    let content: (Int) -> Content
    
    init(numberOfItems: Int, itemSize: CGFloat, @ViewBuilder content: @escaping (Int) -> Content) {
        self.numberOfItems = numberOfItems
        self.itemSize = itemSize
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<numberOfItems,id:\.self) { index in
                    content(index)
                        .frame(width: itemSize, height: itemSize)
                        .position(getPosition(for: index, in: geometry.size))
                }
            }
            .rotationEffect(.degrees(-90))
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
        }
    }
    
    private func getPosition(for index: Int, in size: CGSize) -> CGPoint {
        let angle = Double(index) * 2 * Double.pi / Double(numberOfItems)
        let radius = Double(size.width - itemSize) / 2
        let x = radius * cos(angle)
        let y = radius * sin(angle)
        return CGPoint(x: size.width/2 + CGFloat(x), y: size.height/2 + CGFloat(y))
    }
}





//struct FAButton2: View {
//
//    @State var startAnimation: Bool = false
//
//    @State var optionAnimation: Bool = false
//
//    let offestValue: CGFloat = 55
//
//    let doubleStartAnimation: Double = 0.2
//
//    let optionStartAnimation: Double = 0.25
//
//    var body: some View {
//        ZStack(alignment: .bottomTrailing){
//
//            Color.black
//                .ignoresSafeArea()
//
//            ZStack{
//                ScrollView(.vertical,showsIndicators: false){
//                    VStack{
//                        ForEach(0..<5, id: \.self){ index in
//                            ButtonAction(
//                                animation: $optionAnimation,
//                                systemIcon: "\(index + 1).circle",
//                                size:40,
//                                offset: CGSize(width: 0, height:  offestValue),
//                                backGroundcolor: .white,
//                                foregroundColor: .black,
//                                action: doNothing
//                            )
////                            .offset(y: 40)
//                            .offset(x: shouldShowIndex(index))
//                        }
//                    }
//                }
//                .frame(width: 90,height: 250)
//                .clipped()
//                .background(Color.red)
//                .offset(x: -60,y: 50)
//
////                /// Main button Menú
////                ButtonAction(animation: $startAnimation, action: doNothing)
//            }
//        }
//    }
//
//    func shouldShowIndex(_ index: Int)-> CGFloat{
//        if index % 2 == 0 {
//            return 40
//        }
//        return 0
//    }
//
//    func doNothing(){
//
//    }
//}

struct FAButton2_Previews: PreviewProvider {
    static var previews: some View {
        CircularScrollView(numberOfItems: 10, itemSize: 100) { index in
            Button(action: {
                // Action to perform when button is tapped
            }) {
                Circle()
                    .fill(Color.blue)
                    .overlay(
                        Text("\(index)")
                            .foregroundColor(.white)
                    )
            }
            .buttonStyle(PlainButtonStyle())
        }
//        FAButton2()
//        CircularScrollView()
    }
}
