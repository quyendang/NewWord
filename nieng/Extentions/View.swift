//
//  View.swift
//  nieng
//
//  Created by Quyen Dang on 06/08/2023.
//

import Foundation
import Combine
import SwiftUI

struct KeyboardAdaptive: ViewModifier {
    @State private var bottomPadding: CGFloat = 0

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.bottom, self.bottomPadding)
                .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                    let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
                    let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
                    self.bottomPadding = max(0, focusedTextInputBottom - keyboardTop - geometry.safeAreaInsets.bottom)
                }
        }
        .animation(.spring())
    }
}

extension View {
    
    func keyboardAdaptive() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive())
    }
    
    
    func isVisible(
        isVisible : Bool,
        transition : AnyTransition = .opacity
    ) -> some View{
        modifier(
            IsVisibleModifier(
                isVisible: isVisible,
                transition: transition
            )
        )
    }
    @ViewBuilder
    func applyIf<T: View>(_ condition: Bool, apply: (Self) -> T) -> some View {
        if condition {
            apply(self)
        } else {
            self
        }
    }
    
    func shadowedStyle() -> some View {
        self
            .shadow(color: .black.opacity(0.08), radius: 2, x: 0, y: 0)
            .shadow(color: .black.opacity(0.16), radius: 24, x: 0, y: 0)
    }
    
//    func emptyState<EmptyContent>(_ isEmpty: Bool,
//                                  emptyContent: @escaping () -> EmptyContent) -> some View where EmptyContent: View {
//        modifier(EmptyStateViewModifier(isEmpty: isEmpty, emptyContent: emptyContent))
//    }
//
//    func customBackground(color: Color = .background) -> some View {
//        self.background(RoundedRectangle(cornerRadius: 8).fill(color))
//    }
}
struct IsVisibleModifier : ViewModifier{
    
    var isVisible : Bool
    // the transition will add a custom animation while displaying the
    // view.
    var transition : AnyTransition
    
    func body(content: Content) -> some View {
        ZStack{
            if isVisible{
                content
                    .transition(transition)
            }
        }
    }
}
//
//
//struct EmptyStateViewModifier<EmptyContent>: ViewModifier where EmptyContent: View {
//    var isEmpty: Bool
//    let emptyContent: () -> EmptyContent
//    
//    func body(content: Content) -> some View {
//        if isEmpty {
//            emptyContent()
//        }
//        else {
//            content
//        }
//    }
//}
