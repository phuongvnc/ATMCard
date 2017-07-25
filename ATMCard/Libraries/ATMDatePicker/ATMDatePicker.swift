//
//  ATMDatePicker.swift
//  ATMCard
//
//  Created by framgia on 5/16/17.
//  Copyright © 2017 Vo Nguyen Chi Phuong. All rights reserved.
//

import UIKit


@objc protocol ATMDatePickerDelegate: class {
    func datePicker(datePicker: ATMDatePicker, didSelectDate date: Date)
    func datePicker(datePicker: ATMDatePicker, selectDoneDate date: Date)
    @objc optional func datePickerSelectCancel(datePicker: ATMDatePicker)
}

class ATMDatePicker: UIView {


    fileprivate var heightDatePicker: CGFloat = 216
    fileprivate var heightToolbar: CGFloat = 44
    fileprivate var heightView: CGFloat = 260
    var datePicker: UIDatePicker!
    var dateToolbar: UIToolbar!
    weak var delegate: ATMDatePickerDelegate?




    var datePickerMode: UIDatePickerMode! {
        didSet {
            if datePicker != nil {
                datePicker.datePickerMode = datePickerMode
            }
        }
    }

    var date: Date?

    override init(frame: CGRect) {
        super.init(frame: frame)
        datePickerMode = UIDatePickerMode.dateAndTime
        setup()
    }

    convenience init(mode: UIDatePickerMode) {
        self.init()
        datePickerMode = mode
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setup() {
        // DatePicker
        backgroundColor = UIColor.clear
        let mainRect = UIScreen.main.bounds
        datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: mainRect.width, height: 216))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.date = date ?? Date()
        datePicker.addTarget(self, action: #selector(didChangeValueDate), for: .valueChanged)

        // ToolBar
        dateToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: mainRect.width, height: heightToolbar))
        dateToolbar.barStyle = .default
        dateToolbar.isTranslucent = true
        dateToolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        dateToolbar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didSelectDone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didSelectCancel))
        dateToolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        dateToolbar.isUserInteractionEnabled = true

        frame = CGRect(x: 0, y: 0, width: mainRect.width, height: heightView)
        addSubview(dateToolbar)
        addSubview(datePicker)
    }

    @objc private func didSelectDone() {
        delegate?.datePicker(datePicker: self,
                             selectDoneDate: datePicker.date)
    }

    @objc private func didSelectCancel() {
        delegate?.datePickerSelectCancel?(datePicker: self)
    }

    @objc private func didChangeValueDate() {
        delegate?.datePicker(datePicker: self,
                             didSelectDate: datePicker.date)
    }

    func show(inView view: UIView, animated: Bool = true) {
        if let superView = superview, view == superView {
            return
        }
        backgroundColor = UIColor.clear
        datePicker.frame = CGRect(x: 0,
                                  y: heightView,
                                  width: view.frame.width,
                                  height: heightDatePicker)
        dateToolbar.frame = CGRect(x: 0,
                                   y: heightView,
                                   width: view.frame.width,
                                   height: heightToolbar)
        frame = CGRect(x: 0, y: view.frame.height - heightView, width: view.frame.width, height: heightView)
        view.addSubview(self)
        let pickerDuration = animated ? 0.4 : 0
        let toolbarDuration = animated ? 0.6 : 0
        UIView.animate(withDuration: pickerDuration, animations: {
            self.datePicker.frame = CGRect(x: 0,
                                           y: self.heightToolbar,
                                           width: view.frame.width,
                                           height: self.heightDatePicker)

        })

        UIView.animate(withDuration: toolbarDuration, animations: {
            self.dateToolbar.frame = CGRect(x: 0,
                                            y: 0,
                                            width: view.frame.width,
                                            height: self.heightToolbar)

        })


    }

    func hide(animated: Bool = true) {
        guard let view = self.superview else {
            return
        }
        let duration = animated ? 0.4 : 0
        UIView.animate(withDuration: duration, animations: {
            self.dateToolbar.frame = CGRect(x: 0,
                                            y: self.heightView,
                                            width: view.frame.width,
                                            height: self.heightToolbar)

        }) { (completed) in
            UIView.animate(withDuration: duration , animations: {
                self.datePicker.frame = CGRect(x: 0,
                                               y: self.heightView,
                                               width: view.frame.width,
                                               height: self.heightDatePicker)
            }) { (completed) in
                self.removeFromSuperview()
            }
        }
        
    }
    
    
}
