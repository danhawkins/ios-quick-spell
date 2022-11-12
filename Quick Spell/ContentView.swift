//
//  ContentView.swift
//  Quick Spell
//
//  Created by Danny Hawkins on 12/11/2022.
//

import SwiftUI

struct ContentView: View {
  @Namespace private var animation
  
  @State private var unusedLetters = [Letter]()
  @State private var usedLetters = [Letter]()
  @State private var dictionary = Set<String>()
  
  @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  @State private var time = 0
  @State private var score = 0
  @State private var usedWords = Set<String>()
  @State private var isGameOver = false
  
  var body: some View {
    VStack {
      Spacer()
      
      HStack {
        ForEach(usedLetters) { letter in
          LetterView(letter: letter, color: wordIsValid() ? .green : .red, onTap: remove )
            .matchedGeometryEffect(id: letter, in: animation)
        }
      }
      
      Spacer()
      
      HStack {
        ForEach(unusedLetters) { letter in
          LetterView(letter: letter, color: .yellow, onTap: add)
            .matchedGeometryEffect(id: letter, in: animation)
        }
      }
      
      HStack {
        Spacer()
        AnimatingNumberView(title: "Time", value: time)
        Spacer()
        
        Button("Go", action: submit)
          .disabled(wordIsValid() == false)
          .opacity(wordIsValid() ? 1 : 0.33)
          .bold()
        
        Spacer()
        AnimatingNumberView(title: "Score", value: score)
        Spacer()
      }
      .foregroundColor(.white)
      .padding(.vertical, 5)
      .monospacedDigit()
      .font(.title)
    }
    .padding()
    .background(.blue.gradient)
    .onReceive(timer) { _ in
      if time == 0 {
        isGameOver = true
      } else {
        time -= 1
      }
    }
    .onAppear(perform: load)
    .alert("Game over!", isPresented: $isGameOver) {
      Button("Play Again", action: newGame)
    } message: {
      Text("Your score was: \(score).")
    }
  }
  
  func load() {
    guard let url = Bundle.main.url(forResource: "dictionary", withExtension: "txt") else { return }
    guard let contents = try? String(contentsOf: url) else { return }
    dictionary = Set(contents.components(separatedBy: .newlines))
    
    newGame()
  }
  
  func newGame() {
    timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    isGameOver = false
    time = 30
    score = 0
    
    unusedLetters = (0..<9).map { _ in Letter() }
    usedLetters.removeAll()
  }
  
  func submit() {
    guard wordIsValid() else { return }
    
    withAnimation {
      let word = usedLetters.map(\.character).joined().lowercased()
      usedWords.insert(word)
      
      score += usedLetters.count * usedLetters.count
      time += usedLetters.count * 2
      
      unusedLetters.append(contentsOf: (0..<usedLetters.count).map { _ in Letter() })
      usedLetters.removeAll()
    }
  }
  
  func add(_ letter: Letter) {
    guard let index = unusedLetters.firstIndex(of: letter) else { return }

    withAnimation(.spring()) {
      unusedLetters.remove(at: index)
      usedLetters.append(letter)
    }
  }
  
  func remove(_ letter: Letter) {
    guard let index = usedLetters.firstIndex(of: letter) else { return }

    withAnimation(.spring()) {
      usedLetters.remove(at: index)
      unusedLetters.append(letter)
    }
  }
  
  func wordIsValid() -> Bool {
    let word = usedLetters.map(\.character).joined().lowercased()
    guard usedWords.contains(word) == false else { return false }

    return dictionary.contains(word)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().previewInterfaceOrientation(.landscapeLeft)
  }
}
