//
//  TypingAnimationView.swift
//  TaxiShare_MVP
//
//  Created by Barak Ben Hur on 08/09/2024.
//

import SwiftUI

struct TypingAnimationView: View {
    private let textToType: String
    @State private var animatedText: String
    private let queue: DispatchQueue
    private let main : DispatchQueue
    private let value: Int
    private let animationStage: Int
    private var isStandAlone: Bool { return value == -1 }
    
    init(textToType: String, value: Int, animationStage: Int) {
        self.queue = DispatchQueue.init(label: "work")
        self.main = DispatchQueue.main
        self.textToType = textToType
        self.animatedText = String(repeating: " ", count: textToType.count)
        self.value = value
        self.animationStage = animationStage
    }
    
    init(textToType: String) {
        self.queue = DispatchQueue.init(label: "work")
        self.main = DispatchQueue.main
        self.textToType = textToType
        self.animatedText = String(repeating: " ", count: textToType.count)
        self.value = -1
        self.animationStage = -1
    }
    
    var body: some View {
        let text = Text(animatedText)
            .foregroundStyle(Color(hex: "#343604"))
            .animation(.easeIn(duration: 0.4))
            .font(.caption2.bold().italic().monospaced())
            .font(.title)
        
        if isStandAlone {
            text
                .onAppear { animateText() }
        }
        else {
            text
                .onChange(of: value, animateTextAsPartOfAnimationChain)
        }
    }
    
    func animateTextAsPartOfAnimationChain() {
        guard value == animationStage else { return }
        animatedText = String(repeating: " ", count: textToType.count)
        animateText()
    }
    
    func animateText() {
        let time = isStandAlone ? 0.2 : 0.1
        for (index, character) in textToType.enumerated() {
            queue.asyncAfter(deadline: .now() + Double(index) * time) {
                main.async {
                    animatedText.replace(at: index,
                                         with: character)
                    
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    
                    guard isStandAlone else { return }
                    if index == textToType.count - 1 {
                        queue.asyncAfter(deadline: .now() + 0.8) {
                            main.async {
                                retractText()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func retractText() {
        for (index, _) in textToType.enumerated() {
            let time = index == textToType.count - 1 ? 0.218 : 0.2
            queue.asyncAfter(deadline: .now() + Double(index) * time) {
                main.async {
                    animatedText.replace(at: textToType.count - 1 - index,
                                         with: " ")
                    
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    
                    if index == textToType.count - 1 {
                        queue.asyncAfter(deadline: .now() + 0.8) {
                            main.async {
                                animateText()
                            }
                        }
                    }
                }
            }
        }
    }
}
