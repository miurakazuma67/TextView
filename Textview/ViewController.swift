//
//  ViewController.swift
//  Textview
//
//  Created by 三浦　一真 on 2021/06/15.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet private weak var textView: UITextView!
    
    @IBOutlet private weak var textViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.textView.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        textView.backgroundColor = UIColor.cyan
    }
    
    //キーボードが現れたら画面の位置も一緒にあげる
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            } else {
                let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
                self.view.frame.origin.y -= suggestionHeight
            }
        }
    }
    
    //キーボードが隠れたら画面の位置も元に戻す
    @objc func keyboardWillHide() {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //タップでキーボードを隠す
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}

extension ViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.textView.translatesAutoresizingMaskIntoConstraints = true
        self.textView.sizeToFit()
        self.textView.isScrollEnabled = false
        var resizedHeight = self.textView.frame.size.height
        self.textViewHeight.constant = resizedHeight

        self.textView.frame = CGRect(x: (self.view.bounds.width - 240) / 2, y: 50, width: 240, height: resizedHeight)
        
        if resizedHeight > 34 {
            let addingHeight = resizedHeight - 34
            self.textViewHeight.constant += addingHeight
            resizedHeight = 34
        } else if resizedHeight < 34 {
            let subtractingHeight = 34 - resizedHeight
            self.textViewHeight.constant -= subtractingHeight
            resizedHeight = 34
        }
        
    }
    
}
