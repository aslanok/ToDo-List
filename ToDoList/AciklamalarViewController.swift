//
//  AciklamalarViewController.swift
//  ToDoList
//
//  Created by MacBook on 20.03.2022.
//

import UIKit

class AciklamalarViewController: UIViewController {
    var aciklama : String = ""
    var masterVC : ViewController?
    
    @IBOutlet weak var lblEtkinlikAciklama: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblEtkinlikAciklama.text = aciklama
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        masterVC?.etkinlikAciklamasi = lblEtkinlikAciklama.text
        lblEtkinlikAciklama.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lblEtkinlikAciklama.becomeFirstResponder()
    }
    
    func setAciklama(a : String){
        aciklama = a
        if isViewLoaded{
            lblEtkinlikAciklama.text = aciklama
        }
    }
    
}
