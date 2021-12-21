//
//  XMarkButton.swift
//  Crypto
//
//  Created by Aybars Acar on 21/12/2021.
//

import SwiftUI

struct XMarkButton: View {
  
  let onClick: () -> Void
  
  var body: some View {
    Button(action: {
      onClick()
    }, label: {
      Image(systemName: "xmark")
        .font(.headline)
    })
  }
}

struct XMarkButton_Previews: PreviewProvider {
  static var previews: some View {
    XMarkButton { }
  }
}
