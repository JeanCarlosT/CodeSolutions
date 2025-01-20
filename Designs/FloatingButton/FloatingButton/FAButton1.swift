//
//  FAButton1.swift
//  FloatingButton
//
//  Created by Sioma on 28/03/23.
//

import SwiftUI

struct FAButton1: View {
    @State var startAnimation: Bool = false
    
    @State var optionAnimation: Bool = false
    
    let offestValue: CGFloat = 55
    
    let doubleStartAnimation: Double = 0.2
    
    let optionStartAnimation: Double = 0.25
    
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            
            Color.black
                .ignoresSafeArea()
            
            ZStack{
                
                ///Opción 1
                ButtonAction(
                    animation: $optionAnimation,
                    systemIcon: "1.circle",
                    size:40,
                    offset: CGSize(width: 0, height:  offestValue),
                    backGroundcolor: .white,
                    foregroundColor: .black,
                    action: doNothing
                )
                
                ButtonAction(
                    animation: $optionAnimation,
                    systemIcon: "2.circle",
                    size:40,
                    offset: CGSize(width: -offestValue, height: 0),
                    backGroundcolor: .white,
                    foregroundColor: .black,
                    action: doNothing
                )
                
                ButtonAction(
                    animation: $optionAnimation,
                    systemIcon: "3.circle",
                    size:40,
                    offset: CGSize(width: 0, height: -offestValue),
                    backGroundcolor: .white,
                    foregroundColor: .black,
                    action: doNothing
                )
                
                
                /// Main button Menú
                ButtonAction(animation: $startAnimation, action: validateAction)
            }
        }
        
    }
    
    func doNothing(){ }
    
    func validateAction(){
        if startAnimation == false {
            withAnimation(.easeOut(duration: doubleStartAnimation)){
                self.startAnimation = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + doubleStartAnimation){
                withAnimation(.easeOut(duration: optionStartAnimation)){
                    self.optionAnimation = true
                }
            }
        }else{
            withAnimation(.easeOut(duration: optionStartAnimation)){
                self.optionAnimation = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + optionStartAnimation){
                withAnimation(.easeOut(duration: doubleStartAnimation)){
                    self.startAnimation = false
                }
            }
        }
    }
}

struct FAButton1_Previews: PreviewProvider {
    static var previews: some View {
        FAButton1()
    }
}

struct ButtonAction: View {
    
    @Binding var animation: Bool
    
    var systemIcon: String
    
    var size: CGFloat
    
    var offset: CGSize
    
    var backGroundcolor: Color
    
    var foregroundColor: Color
    
    var action: () -> ()
    
    init(
        animation: Binding<Bool>,
        systemIcon: String = "plus",
        size: CGFloat = 50,
        offset: CGSize = CGSize.zero,
        backGroundcolor: Color = .blue,
        foregroundColor: Color = .white,
        action: @escaping () -> Void) {
            self._animation = animation
            self.systemIcon = systemIcon
            self.size = size
            self.offset = offset
            self.backGroundcolor = backGroundcolor
            self.foregroundColor = foregroundColor
            self.action = action
        }
    
    var body: some View {
        HStack{
            Image(systemName: systemIcon)
                .foregroundColor(foregroundColor)
                .rotationEffect(.degrees(animation && (offset == .zero) ? 45: 0))
        }
        .frame(width: size,height: size,alignment: .center)
        .clipShape(Circle())
        .background(backGroundcolor)
        .clipShape(Circle())
        .padding()
        .padding(.trailing,15)
        .offset(animation ? offset : .zero)
        .onTapGesture {
            action()
        }
    }
}

