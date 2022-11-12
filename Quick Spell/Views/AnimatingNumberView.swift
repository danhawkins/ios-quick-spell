//
//  AnimatingNumberView.swift
//  Quick Spell
//
//  Created by Danny Hawkins on 12/11/2022.
//

import SwiftUI

struct AnimatingNumberView: View, Animatable {
  var title: String
  var value: Int
  
  var animatableData: Double {
    get { Double(value) }
    set { value = Int(newValue) }
  }
  
  var body: some View {
    Text("\(title): \(value)")
  }
}

struct AnimatingNumberView_Previews: PreviewProvider {
  static var previews: some View {
    AnimatingNumberView(title: "Test", value: 10)
  }
}
