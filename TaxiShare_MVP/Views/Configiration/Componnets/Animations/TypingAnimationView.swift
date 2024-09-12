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
    private let nextAnimtionDaley: Int
    private var isStandAlone: Bool { return value == -1 }
    
    init(textToType: String, value: Int, animationStage: Int, nextAnimtionDaley: Int) {
        self.queue = DispatchQueue.init(label: "work")
        self.main = DispatchQueue.main
        self.textToType = String(textToType.reversed())
        self.animatedText = String(repeating: " ", count: textToType.count)
        self.value = value
        self.animationStage = animationStage
        self.nextAnimtionDaley = nextAnimtionDaley
    }
    
    init(textToType: String) {
        self.queue = DispatchQueue.init(label: "work")
        self.main = DispatchQueue.main
        self.textToType = textToType
        self.animatedText = String(repeating: " ", count: textToType.count)
        self.value = -1
        self.animationStage = -1
        self.nextAnimtionDaley = -1
    }
    
    var body: some View {
        let text = Text(animatedText)
            .foregroundStyle(Color(hex: "#343604"))
            .font(.caption2.bold().italic().monospaced())
        
        if isStandAlone {
            text
                .onAppear { animateText() }
        }
        else {
            text
                .shadow(color: Color(hex: "#444122"),
                        radius: 2,
                        x: value > 4 || value == 3 ? 0 : value > 3 ? -5 : value > 1 ? 5 : 0,
                        y: value > 4 || value == 3 ? 0 : value > 1 ? 5 : 0)
                .onChange(of: value,
                          animateTextAsPartOfAnimationChain)
        }
    }
    
    func animateTextAsPartOfAnimationChain() {
        if value == animationStage {
            animatedText = String(repeating: " ", count: textToType.count)
            animateText()
        }
//        else if value == animationStage + nextAnimtionDaley {
//            retractText()
//        }
    }
    
    func animateText() {
        let time = isStandAlone ? 0.2 : 0.04
        for (index, character) in textToType.enumerated() {
            queue.asyncAfter(deadline: .now() + Double(index) * time) {
                main.async {
                    animatedText.replace(at: textToType.count - 1 - index,
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
            let time: CGFloat = {
                if isStandAlone {
                    let end = index == textToType.count - 1
                    return end ? 0.4 : 0.5
                }
                return 0.08
            }()
            queue.asyncAfter(deadline: .now() + Double(index) * time) {
                main.async {
                    animatedText.replace(at: textToType.count - 1 - index,
                                         with: " ")
                    
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    
                    guard isStandAlone else { return }
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
