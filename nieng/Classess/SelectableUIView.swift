//
//  SelectableUIView.swift
//  nieng
//
//  Created by Quyen Dang on 09/11/2023.
//

import Foundation
import SwiftUI

private class SelectableUIView: UIView {

    var text: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    func setup() {
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.showMenu)))
    }

    @objc func showMenu(_ recognizer: UILongPressGestureRecognizer) {
        becomeFirstResponder()

        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.showMenu(from: self, rect: frame)
        }
    }

    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        board.string = text

        UIMenuController.shared.hideMenu()
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy)
    }

}

struct SelectableView: UIViewRepresentable {

    var text: String

    func makeUIView(context: Context) -> UIView {
        let view = SelectableUIView()
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let view = uiView as? SelectableUIView else {
            return
        }
        view.text = text
    }
}

struct SelectableContainer<Content: View>: View {

    private let content: () -> Content
    private var text: String

    public init(text: String, @ViewBuilder content: @escaping () -> Content) {
        self.text = text
        self.content = content
    }

    public var body: some View {
        ZStack {
            content()
            SelectableView(text: text)
                .layoutPriority(-1)
        }
    }

}

struct SelectableText: View {
    private var text: String

    public init(_ text: String) {
        self.text = text
    }

    public var body: some View {
        ZStack {
            Text(text)
            SelectableView(text: text)
                .layoutPriority(-1)
        }
    }
}
