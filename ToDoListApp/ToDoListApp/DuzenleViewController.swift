//
//  DuzenleViewController.swift
//  ToDoListApp
//
//  Created by Kaan Cantimur on 17.04.2023.
//

import UIKit

class DuzenleViewController: UIViewController {
    
    @IBOutlet weak var eskinotLabel: UILabel!
    
    
    @IBOutlet weak var eskinotTextField: UITextField!
    
    
    var not:Notlar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let n = not {
            eskinotTextField.text = n.not_kendi
            
            
        }
    }
    
    
    @IBAction func notDuzenle(_ sender: Any) {
      if let n = not, let ad = eskinotTextField.text {
               Notlardao().notGuncelle(not_id: n.not_id!, not_kendi: ad)
               n.not_kendi = ad
           }
    }
}

