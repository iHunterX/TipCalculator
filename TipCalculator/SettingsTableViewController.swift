//
//  SettingsTableViewController.swift
//  TipCalculator
//
//  Created by Loc.dx-KeizuDev on 2/8/17.
//  Copyright © 2017 iHunterX. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    var userDefault:UserDefaults!
    var defaultTipPercentage:Int!
    var minTipPercentage:Int!
    var maxTipPercentage:Int!
    
    @IBOutlet weak var defaultTF: UITextField!
    @IBOutlet weak var minTF: UITextField!
    @IBOutlet weak var maxTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDefault = UserDefaults()
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        defaultTipPercentage = userDefault.object(forKey: "defaultTipPercentage") as! Int
        minTipPercentage = userDefault.object(forKey: "minTipPercentage") as! Int
        maxTipPercentage = userDefault.object(forKey: "maxTipPercentage") as! Int

        
        defaultTF.text = String(defaultTipPercentage)
        minTF.text = String(minTipPercentage)
        maxTF.text = String(maxTipPercentage)
    }
    
    
    func saveData() {
        userDefault.setValue(defaultTipPercentage, forKey: "defaultTipPercentage")
        userDefault.setValue(minTipPercentage, forKey: "minTipPercentage")
        userDefault.setValue(maxTipPercentage, forKey: "maxTipPercentage")
        userDefault.synchronize()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


    @IBAction func onDidEnd(_ sender: Any) {
        
        if defaultTF.text == "" {
            defaultTF.text = "0"
        }
        
        if minTF.text == "" {
            minTF.text = "0"
        }
        
        if maxTF.text == "" {
            maxTF.text = "100"
        }
        
        defaultTipPercentage = Int(defaultTF.text!)
        minTipPercentage = Int(minTF.text!)
        maxTipPercentage = Int(maxTF.text!)
        
        if (defaultTipPercentage < minTipPercentage) {
            defaultTipPercentage = minTipPercentage
        }
        if (defaultTipPercentage > maxTipPercentage) {
            defaultTipPercentage = maxTipPercentage
        }
        if (minTipPercentage < 0) {
            minTipPercentage = 0
        }
        if (minTipPercentage > maxTipPercentage) {
            minTipPercentage = maxTipPercentage
        }
        if (maxTipPercentage > 100) {
            maxTipPercentage = 100
        }
        if (maxTipPercentage < minTipPercentage) {
            maxTipPercentage = minTipPercentage
        }
        defaultTF.text = String(defaultTipPercentage)
        minTF.text = String(minTipPercentage)
        maxTF.text = String(maxTipPercentage)

    }
}
