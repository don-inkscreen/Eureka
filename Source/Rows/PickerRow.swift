//  PickerRow.swift
//  Eureka ( https://github.com/xmartlabs/Eureka )
//
//  Copyright (c) 2016 Xmartlabs SRL ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

//MARK: PickerCell

open class PickerCell<T> : Cell<T>, CellType, UIPickerViewDataSource, UIPickerViewDelegate where T: Equatable{
    
    public var picker: UIPickerView
    
    private var pickerRow : _PickerRow<T>? { return row as? _PickerRow<T> }
    
    public required init(style: UITableViewCellStyle, reuseIdentifier: String?){
        self.picker = UIPickerView()
        self.picker.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.picker)
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[picker]-0-|", options: [], metrics: nil, views: ["picker": self.picker]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[picker]-0-|", options: [], metrics: nil, views: ["picker": self.picker]))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func setup() {
        super.setup()
        accessoryType = .none
        editingAccessoryType = .none
        picker.delegate = self
        picker.dataSource = self
    }
    
    deinit {
        picker.delegate = nil
        picker.dataSource = nil
    }
    
    open override func update(){
        super.update()
        textLabel?.text = nil
        detailTextLabel?.text = nil
        picker.reloadAllComponents()
        if let selectedValue = pickerRow?.value, let index = pickerRow?.options.index(of: selectedValue){
            picker.selectRow(index, inComponent: 0, animated: true)
        }
    }
    
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerRow?.options.count ?? 0
    }
    
    open func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = pickerRow?.displayValueFor?(pickerRow?.options[row])
        return NSAttributedString(string: title!, attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
    
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let picker = pickerRow, !picker.options.isEmpty {
            picker.value = picker.options[row]
        }
    }
    
}

//MARK: PickerRow

open class _PickerRow<T> : Row<PickerCell<T>> where T: Equatable{
    
    open var options = [T]()
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

/// A generic row where the user can pick an option from a picker view
public final class PickerRow<T>: _PickerRow<T>, RowType where T: Equatable {
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
