//
//  ViewController.swift
//  ToDoList
//
//  Created by MacBook on 19.03.2022.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
        
    
    @IBOutlet weak var table: UITableView!
    var yapilacakListesi : [String] = []
    var fileURL : URL!
    var sayac : Int = 0
    var selectedRow : Int = -1
    var etkinlikDetay : [String] = []
    
    var etkinlikAciklamasi : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.dataSource = self
        table.delegate = self
        
        //edit button
        /*
        let editButton = editButtonItem
        editButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItems?.append(editButton)
         */
        
        let baseURL = try! FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        
        fileURL = baseURL.appendingPathComponent("Etkinlikler.txt")
        print(fileURL!)
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedRow == -1 {
            return
        }
        if etkinlikAciklamasi == "" {
            etkinlikDetay.remove(at: selectedRow)
            yapilacakListesi.remove(at: selectedRow)
        } else if etkinlikAciklamasi == etkinlikDetay[selectedRow] {
            return
        } else {
            etkinlikDetay[selectedRow] = etkinlikAciklamasi
        }
        
        saveData()
        table.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.centerTitle() //Only this VC's title will be centered
    }
    
    
    @IBAction func btnAddClicked(_ sender: UIBarButtonItem) {
        if table.isEditing == true {
            return
        }
        
        let alert = UIAlertController(title: "Etkinlik Ekle", message: "Yapaca????n??z Etkinli??i Giriniz", preferredStyle: UIAlertController.Style.alert)
        
        //alttaki sat??r sayesinde textfield olu??turduk
        alert.addTextField(configurationHandler: { txtEtkinlikAdi in
            txtEtkinlikAdi.placeholder = "Etkinlik Adi"
        })
        
        //burda bizim textField'?? ele al??yoruz
        let actionAdd = UIAlertAction(title: "Ekle", style: UIAlertAction.Style.default, handler: { action in
            let firstTextField = alert.textFields![0] as UITextField
            self.etkinlikEkle(etkinlikAdi: firstTextField.text!)
        })
        
        let actionCancel = UIAlertAction(title: "??ptal", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(actionAdd)
        alert.addAction(actionCancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func centerTitle(){
        for navItem in(self.navigationController?.navigationBar.subviews)! {
                for itemSubView in navItem.subviews {
                    if let largeLabel = itemSubView as? UILabel {
                    largeLabel.center = CGPoint(x: navItem.bounds.width/2, y: navItem.bounds.height/2)
                    return;
                }
            }
        }
    }
     
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yapilacakListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell : UITableViewCell = UITableViewCell()
        //alttaki sat??r biz storyboard ??zerindne yapt??????m??z i??in sa??land??
        let cell : UITableViewCell = table.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = yapilacakListesi[indexPath.row]
        return cell
    }
    
    func etkinlikEkle(etkinlikAdi : String){
        //let etkinlikAdi : String = "\(sayac). Yeni Etkinlik"
        sayac += 1
        yapilacakListesi.insert(etkinlikAdi, at: yapilacakListesi.count)
        etkinlikDetay.insert("Girilmedi", at: 0)
        let indexPath : IndexPath = IndexPath(row: 0, section: 0)
        //tabloya ekleme
        table.insertRows(at: [indexPath], with: UITableView.RowAnimation.left)
        saveData()
        table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        performSegue(withIdentifier: "goAciklamalar", sender: self)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //listeden siliyor
            yapilacakListesi.remove(at: indexPath.row)
            etkinlikDetay.remove(at: indexPath.row)
            //tablodan siliyor
            table.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
            saveData()
        }
    }
    
    func saveData(){
        UserDefaults.standard.set(yapilacakListesi, forKey: "kay??tEtkinlik")
        UserDefaults.standard.set(etkinlikDetay, forKey: "etkinlikDetay")
        /*
        let veriler = NSArray(array: yapilacakListesi)
        do {
            try veriler.write(to: fileURL)
        } catch {
            print("Dosya yazilirken hata olu??tu")
        }
         */
    }
    
    func loadData(){
        if let loadedData : [String] = UserDefaults.standard.value(forKey: "kay??tEtkinlik") as? [String] {
            yapilacakListesi = loadedData
        }
        
        if let aciklamalar : [String] = UserDefaults.standard.value(forKey: "etkinlikDetay") as? [String] {
            etkinlikDetay = aciklamalar
        }
        table.reloadData()
        /*
        if let loadedData : [String] = NSArray(contentsOf: fileURL) as? [String] {
            yapilacakListesi = loadedData
            table.reloadData()
        }
         */
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Etkinlik se??ilen : \(yapilacakListesi[indexPath.row])")
        performSegue(withIdentifier: "goAciklamalar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let aciklamalarVC : AciklamalarViewController = segue.destination as! AciklamalarViewController
        selectedRow = table.indexPathForSelectedRow!.row
        aciklamalarVC.setAciklama(a: etkinlikDetay[selectedRow])
        aciklamalarVC.masterVC = self
    }
    

}

