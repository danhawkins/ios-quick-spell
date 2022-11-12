//
//  ContentView.swift
//  Quick Spell
//
//  Created by Danny Hawkins on 12/11/2022.
//

import SwiftUI

struct ContentView: View {
  @State private var unusedLetters = (0..<9).map { _ in Letter() }
  @State private var usedLetters = [Letter]()
  @State private var dictionary = Set<String>()
  
  var body: some View {
    VStack {
      HStack {
        ForEach(usedLetters) { letter in
          LetterView(letter: letter, onTap: remove)
        }
      }
      
      HStack {
        ForEach(unusedLetters) { letter in
          LetterView(letter: letter, onTap: add)
        }
      }
    }
    .padding()
    .onAppear(perform: load)
  }
  
  func load() {
    guard let url = Bundle.main.url(forResource: "dictionary", withExtension: "txt") else { return }
    guard let contents = try? String(contentsOf: url) else { return }
    dictionary = Set(contents.components(separatedBy: .newlines))
  }
  
  func add(_ letter: Letter) {
    guard let index = unusedLetters.firstIndex(of: letter) else { return }
    unusedLetters.remove(at: index)
    usedLetters.append(letter)
  }
  
  func remove(_ letter: Letter) {
    guard let index = usedLetters.firstIndex(of: letter) else { return }
    usedLetters.remove(at: index)
    unusedLetters.append(letter)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().previewInterfaceOrientation(.landscapeLeft)
  }
}
