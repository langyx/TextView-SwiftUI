//
//  ContentView.swift
//  TextView
//
//  Created by Yannis Lang on 13/04/2020.
//  Copyright © 2020 Yannis Lang. All rights reserved.
//

import SwiftUI

extension UIApplication {
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct TextView : UIViewRepresentable {
    
    @Binding var text: String
    @Binding var desiredHeight : CGFloat
    
    var placeholder = ""
    var mainColor = UIColor.white
    var isEditable = true
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        
        let myTextView = UITextView()
        myTextView.delegate = context.coordinator
        
        myTextView.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        myTextView.textColor = mainColor
        myTextView.isEditable = true
        myTextView.isUserInteractionEnabled = true
        myTextView.backgroundColor = UIColor(white: 0, alpha: 0)
        myTextView.isScrollEnabled = true
        myTextView.tintColor = mainColor
        
        if myTextView.text.isEmpty {
            myTextView.text = self.placeholder
        }
        
        return myTextView
    }
    
    func updateUIView(_ uiView:  UITextView, context: Context) {
        
        let newSize = uiView.sizeThatFits(CGSize(width: uiView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        DispatchQueue.main.async {
            self.desiredHeight = newSize.height
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent : TextView
        
        init(_ uiTextView : TextView){
            self.parent = uiTextView
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == self.parent.placeholder {
                textView.text = ""
            }
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
        
    }
}

struct ContentView: View {
    @State private var text = ""
    @State private var desiredHeight : CGFloat = 0
    
    var body: some View {
        VStack {
           // Text("Le text == \(self.text)")
            TextView(text: self.$text, desiredHeight: self.$desiredHeight, placeholder: "my placeholder ...")
                .background(Color.blue)
                .cornerRadius(5)
                .frame(height: self.desiredHeight)
                .padding()
            Spacer()
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
