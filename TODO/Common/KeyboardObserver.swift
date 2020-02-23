//
//  KeyboardObserver.swift
//  TODO
//
//  Created by Alexey Vedushev on 23.02.2020.
//  Copyright © 2020 Alexey Vedushev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public final class KeyboardObserver {
    
    public struct KeyboardInfo {

        public let frameBegin: CGRect
        public let frameEnd: CGRect
        
        init(notification: Notification) {
            let frameEnd = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let frameBegin = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
            self.frameBegin = frameBegin!
            self.frameEnd = frameEnd!
        }
    }
    
    public let willChangeFrame = PublishSubject<KeyboardInfo>()
    public let didChangeFrame = PublishSubject<KeyboardInfo>()
    
    public let willShow = PublishSubject<KeyboardInfo>()
    public let didShow = PublishSubject<KeyboardInfo>()
    public let willHide = PublishSubject<KeyboardInfo>()
    public let didHide = PublishSubject<KeyboardInfo>()
    
    public init() {
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillChangeFrameNotification)
            .map { KeyboardInfo(notification: $0) }
            .bind(to: self.willChangeFrame)
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardDidChangeFrameNotification)
            .map { KeyboardInfo(notification: $0) }
            .bind(to: self.didChangeFrame)
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .map { KeyboardInfo(notification: $0) }
            .bind(to: self.willShow)
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardDidShowNotification)
            .map { KeyboardInfo(notification: $0) }
            .bind(to: self.didShow)
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .map { KeyboardInfo(notification: $0) }
            .bind(to: self.willHide)
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardDidHideNotification)
            .map { KeyboardInfo(notification: $0) }
            .bind(to: self.didHide)
            .disposed(by: self.disposeBag)
    }
    
    private let disposeBag = DisposeBag()
}
