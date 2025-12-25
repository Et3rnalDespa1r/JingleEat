//
//  ChatViewController.swift
//  Project
//
//  Created by Даниил on 21.12.2025.
//
import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            ChristmasBackground()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                            
                            if viewModel.isLoading {
                                HStack {
                                    ProgressView()
                                        .tint(.white)
                                        .padding(10)
                                        .background(Color.white.opacity(0.3))
                                        .clipShape(Circle())
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top, 60)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 16)
                    }
                    .onChange(of: viewModel.messages.count) { _ in
                        if let lastId = viewModel.messages.last?.id {
                            withAnimation {
                                proxy.scrollTo(lastId, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Поле ввода
                HStack(spacing: 10) {
                    TextField("Напиши шефу...", text: $viewModel.inputText)
                        .padding(12)
                        .background(Color.white.opacity(0.9))
                        .foregroundColor(.black)
                        .tint(.black)
                        .cornerRadius(20)
                        .focused($isFocused)
                        .submitLabel(.send)
                        .onSubmit {
                            viewModel.sendMessage()
                        }
                    
                    Button(action: viewModel.sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color(red: 0.11, green: 0.38, blue: 0.19))
                            .clipShape(Circle())
                    }
                    .disabled(viewModel.inputText.isEmpty)
                }
                .padding()
                .background(.ultraThinMaterial)
            }
        }
        .onTapGesture {
            isFocused = false
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isUser { Spacer() }
            
            VStack(alignment: .leading) {
                Text(LocalizedStringKey(message.text))
                    .foregroundColor(message.isUser ? .white : .black)
                    .font(.system(size: 16))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(
                message.isUser
                ? Color(red: 0.11, green: 0.38, blue: 0.19)
                : Color.white.opacity(0.95)
            )
            .clipShape(ChatBubbleShape(isUser: message.isUser))
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            
            if !message.isUser { Spacer() }
        }
    }
}

struct ChatBubbleShape: Shape {
    let isUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        let radius: CGFloat = 20
        
        return Path { path in
            if isUser {
                path.move(to: CGPoint(x: radius, y: 0))
                path.addLine(to: CGPoint(x: width - radius, y: 0))
                path.addArc(center: CGPoint(x: width - radius, y: radius), radius: radius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: width, y: height - radius))
                path.addCurve(to: CGPoint(x: width + 2, y: height),
                              control1: CGPoint(x: width, y: height - 8),
                              control2: CGPoint(x: width + 2, y: height))
                path.addCurve(to: CGPoint(x: width - 10, y: height),
                              control1: CGPoint(x: width - 4, y: height),
                              control2: CGPoint(x: width - 4, y: height))
                path.addLine(to: CGPoint(x: radius, y: height))
                path.addArc(center: CGPoint(x: radius, y: height - radius), radius: radius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: radius))
                path.addArc(center: CGPoint(x: radius, y: radius), radius: radius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
                
            } else {
                path.move(to: CGPoint(x: width - radius, y: 0))
                path.addLine(to: CGPoint(x: radius, y: 0))
                path.addArc(center: CGPoint(x: radius, y: radius), radius: radius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: -180), clockwise: true)
                path.addLine(to: CGPoint(x: 0, y: height - radius))
                path.addCurve(to: CGPoint(x: -2, y: height),
                              control1: CGPoint(x: 0, y: height - 8),
                              control2: CGPoint(x: -2, y: height))
                path.addCurve(to: CGPoint(x: 10, y: height),
                              control1: CGPoint(x: 4, y: height),
                              control2: CGPoint(x: 4, y: height))
                path.addLine(to: CGPoint(x: width - radius, y: height))
                path.addArc(center: CGPoint(x: width - radius, y: height - radius), radius: radius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 0), clockwise: true)
                path.addLine(to: CGPoint(x: width, y: radius))
                path.addArc(center: CGPoint(x: width - radius, y: radius), radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: -90), clockwise: true)
            }
            path.closeSubpath()
        }
    }
}
