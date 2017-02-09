//
//  ViewController.swift
//  TipCalculator
//
//  Created by Loc.dx-KeizuDev on 2/3/17.
//  Copyright © 2017 iHunterX. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPopoverPresentationControllerDelegate {
    var userDefault:UserDefaults!
    var numFormatter:NumberFormatter!
    var defaultTipPercent:Int = 20
    var tipPercentageTapStart:Int!
    var minTipPercentage:Int! = 10
    var maxTipPercentage:Int! = 30
    var totalAmountGB:Double! = 0.0

    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var percentLB: UILabel!
    @IBOutlet weak var tipLB: UILabel!
    @IBOutlet weak var totalLB: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        userDefault = UserDefaults()
        if isFirstRun() {
            setupFirstRun()
        }
        loadData()
        initialAnimation()
        initFormatter()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func saveData() {
        userDefault.setValue(defaultTipPercent, forKey: "defaultTipPercentage")
        userDefault.setValue(minTipPercentage, forKey: "minTipPercentage")
        userDefault.setValue(maxTipPercentage, forKey: "maxTipPercentage")
        
        userDefault.synchronize()
    }

    func loadData() {
        defaultTipPercent = userDefault.object(forKey: "defaultTipPercentage") as! Int
        minTipPercentage = userDefault.object(forKey: "minTipPercentage") as! Int
        maxTipPercentage = userDefault.object(forKey: "maxTipPercentage") as! Int
    }
    func initialAnimation(){
        
        self.view.alpha = 0
        UIView.animate(withDuration: 0.5, animations:{
            self.view.alpha = 1
        })
    }
    func setupFirstRun() {
        saveData()
        userDefault.setValue(true, forKey: "firstRun")
        userDefault.synchronize()
    }
    
    func isFirstRun()->Bool {
        if userDefault.object(forKey: "firstRun") != nil {
            return false
        }
        return true;
    }
    
    func initFormatter(){
        numFormatter                    = NumberFormatter()
        numFormatter.numberStyle        = .currency
        numFormatter.locale             = Locale.current
        
        
        let recpt                       = numFormatter.string(from: 0)
        let indx                        = recpt?.index((recpt?.startIndex)!, offsetBy: 1)
        
        amountTF.placeholder            = String(describing: recpt![indx!])
        percentLB.text                  = "\(defaultTipPercent)%"
        tipLB.text                      = numFormatter.string(from: 0)
        totalLB.text                    = numFormatter.string(from: 0)
    }
    
    
    @IBAction func amoutChanged(_ sender: Any) {
        if (amountTF.text == ""){
            tipLB.text      = numFormatter.string(from: 0)
            totalLB.text    = numFormatter.string(from: 0)
            totalAmountGB   = 0.0
            return
        }
        calculateTip(withAmount: amountTF.text!)
    }
    
    func calculateTip(withAmount amount:String) -> Void {
        let billAmount          = Double(amount) ?? 0
        let tip                 = billAmount * Double(defaultTipPercent) / 100
        let totalAmount         = billAmount + tip
        
        tipLB.text              = numFormatter.string(from: NSNumber(value:tip))
        totalLB.text            = numFormatter.string(from: NSNumber(value: totalAmount))
        self.totalAmountGB = totalAmount
    }

    @IBAction func swipeGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.totalLB)
        if (sender.state == .began) {
            print("begin")
            tipPercentageTapStart = defaultTipPercent
        }
        else if (sender.state == .changed) {
            print("change")
            defaultTipPercent       = Int(CGFloat(tipPercentageTapStart) + translation.x / 20)
            if (defaultTipPercent < minTipPercentage) {
                defaultTipPercent = minTipPercentage
            }
            else if (defaultTipPercent > maxTipPercentage) {
                defaultTipPercent = maxTipPercentage
            }
            percentLB.text          = "\(defaultTipPercent)%"
            amoutChanged(self)
        }
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
//        let vc = story
        self.view.endEditing(true)
        let vc = PopoverVC.newVC()
        vc.numFormatter = self.numFormatter
        vc.totalPay     = self.totalAmountGB
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 300, height: 250)
        
        
        // set up the popover presentation controller
        vc.popoverPresentationController?.backgroundColor = UIColor(withString: "DFFFBE")
        vc.popoverPresentationController?.permittedArrowDirections = .any
        vc.popoverPresentationController?.delegate = self
        vc.popoverPresentationController?.sourceView = self.totalLB.superview // button
        vc.popoverPresentationController?.sourceRect = self.totalLB.bounds
        
        present(vc, animated: true, completion: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        saveData()
    }
    
}

