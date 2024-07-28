//
//  TextShimmer.swift
//  Học Từ Mới
//
//  Created by Quyen Dang on 12/12/2023.
//

import SwiftUI

struct TextShimmer: View {
    
    var text: String
    @State var animation = false
    @AppStorage("wordSize2") var wordSize2 = 35.0
    @Binding var values: Bool
    
    var body: some View{
        
        ZStack{
            
            Text(text)
                .font(.system(size: wordSize2, weight: .bold))
                .lineLimit(1)
                .foregroundColor(.primary)
            
            // MultiColor Text....
            
            HStack(spacing: 0){
                
                ForEach(0..<text.count,id: \.self){index in
                    
                    Text(String(text[text.index(text.startIndex, offsetBy: index)]))
                        .font(.system(size: wordSize2, weight: .bold))
                        .foregroundColor(randomColor())
                        .lineLimit(1)
                }
            }
            // Masking For Shimmer Effect...
            .mask(
            
                Rectangle()
                    // For Some More Nice Effect Were Going to use Gradient...
                    .fill(
                    
                        // You can use any Color Here...
                        LinearGradient(gradient: .init(colors: [Color.white.opacity(0.5),Color.white,Color.white.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                    )
                    .rotationEffect(.init(degrees: 70))
                    .padding(20)
                // Moving View Continously...
                // so it will create Shimmer Effect...
                    .offset(x: -100)
                    .offset(x: animation ? 200 : 0)
            )
            .onChange(of: values) { oldValue, newValue in
            
                withAnimation(Animation.linear(duration: 2)){
                    
                    animation.toggle()
                }
            }
        }
    }
    
    // Random Color....
    
    // It's Your Wish yOu can change anything here...
    // or you can also use Array of colors to pick random One....
    
    func randomColor()->Color{
        
        let color = UIColor(red: 1, green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
        
        return Color(color)
    }
}
