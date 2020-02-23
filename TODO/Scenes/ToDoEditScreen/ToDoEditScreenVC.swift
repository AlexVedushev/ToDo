//
//  ToDoEditScreenVC.swift
//  TODO
//
//  Created by Alexey Vedushev on 22.02.2020.
//  Copyright © 2020 Alexey Vedushev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ToDoEditScreenVC: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var editSaveButton: UIButton!
    @IBOutlet weak var lcTextViewBottom: NSLayoutConstraint!
    
    var viewModel: ToDoEditViewModel!
    
    fileprivate let keyboardObserver = KeyboardObserver()
    fileprivate var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightBarButton = UIBarButtonItem(title: "Удалить", style: .plain, target: self, action: nil)
        rightBarButton.tintColor = UIColor.red
        navigationItem.rightBarButtonItem = rightBarButton
        bindViewModel()
        
        keyboardObserver.didShow
            .bind {[unowned self] (info) in
                UIView.animate(withDuration: 0) {
                    self.lcTextViewBottom.constant = info.frameEnd.height
                }
            }.disposed(by: disposeBag)
    }
    

    fileprivate func bindViewModel() {
        let viewWillAppearDriver = rx.viewWillAppear.asDriver()
        let editSaveButtonTapDriver = editSaveButton.rx.tap.asDriver()
        let deleteTapDriver = navigationItem.rightBarButtonItem!.rx.tap.asDriver()
        let titleDriver = titleTextField.rx
            .controlEvent(.editingDidEnd)
            .map{ [unowned self] in self.titleTextField.text ?? ""}
            .asDriverOnErrorJustComplete()

        let textDriver = textView.rx
            .didChange.debug()
            .map{ [unowned self] in self.textView.text ?? ""}
            .asDriverOnErrorJustComplete()
        
        let input = ToDoEditViewModel.Input(viewWillAppearDriver: viewWillAppearDriver,
                                            editSaveButtonTapDriver: editSaveButtonTapDriver,
                                            deleteTapDriver: deleteTapDriver,
                                            titleDriver: titleDriver,
                                            textdriver: textDriver)
        
        let output = viewModel.transform(input: input)
        
        
        output.titleDriver
            .asObservable()
            .bind(to: titleTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.textDriver
            .asObservable()
            .bind(to: textView.rx.text)
            .disposed(by: disposeBag)
        
        output.editingEnableDriver
            .drive(onNext: {[unowned self] (isEditEnable) in
                self.textView.isEditable = isEditEnable
                self.titleTextField.isUserInteractionEnabled = isEditEnable
                self.titleTextField.borderStyle = isEditEnable ? .bezel : .none
                self.textView.font = isEditEnable ? UIFont.italicSystemFont(ofSize: 14)
                    : UIFont.systemFont(ofSize: 14)
                self.titleTextField.font = isEditEnable ? UIFont.italicSystemFont(ofSize: 14)
                    : UIFont.systemFont(ofSize: 14)
            }).disposed(by: disposeBag)
        
        output.editSaveButtonTitleDriver
            .asObservable()
            .bind(to: editSaveButton.rx.title())
            .disposed(by: disposeBag)
        
        output.saveObservable
            .subscribe()
            .disposed(by: disposeBag)
        
        output.deleteObservable
            .subscribe()
            .disposed(by: disposeBag)
        
        output.titleEditDriver
            .drive()
            .disposed(by: disposeBag)
        
        output.textEditDriver
            .drive()
            .disposed(by: disposeBag)
    }
}


