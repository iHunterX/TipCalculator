//
//  PopoverVC.swift
//  TipCalculator
//
//  Created by Loc.dx-KeizuDev on 2/3/17.
//  Copyright © 2017 iHunterX. All rights reserved.
//

import UIKit

class PopoverVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    static let identifier = "PopoverVC"
    let maxNum:Int! = 99
    var totalPay:Double!
    var numFormatter:NumberFormatter!
    
    @IBOutlet weak var splitsVille: UILabel!
    
    @IBOutlet weak var numPicker: UIPickerView!
    
    
    
    var numOfPeoplePicker:[String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        initNumList()
        numPicker.delegate      = self
        numPicker.dataSource    = self

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.backgroundColor = UIColor.clear
        splitsVille.text = numFormatter.string(from: NSNumber(value: totalPay))
        
    }
    func initNumList(){
        numOfPeoplePicker = [String]()
        
        for i in 1 ... maxNum{
            numOfPeoplePicker.append(String(describing: i))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    class func newVC() -> PopoverVC {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyBoard.instantiateViewController(withIdentifier: identifier) as! PopoverVC
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numOfPeoplePicker.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numOfPeoplePicker[row]) Person(s)"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let numberOfPeople = row + 1
        let totalAmountPerPeople = totalPay / Double(numberOfPeople)
        splitsVille.text = numFormatter.string(from: NSNumber(value: totalAmountPerPeople))
    }
}
