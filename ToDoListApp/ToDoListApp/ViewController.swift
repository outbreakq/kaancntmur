//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Kaan Cantimur on 17.04.2023.
//

import UIKit

class ViewController: UIViewController {
 
    
    @IBOutlet weak var notTableView: UITableView!
    
    var notlarListe = [Notlar]()

    override func viewDidLoad() {
        super.viewDidLoad()
     
   
        veriTabaniKopyala()


        notTableView.delegate = self
        notTableView.dataSource = self
      
    


    }
        override func viewWillAppear(_ animated: Bool) {
            notlarListe = Notlardao().tumNotlarAl()
              notTableView.reloadData()
        }
      
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indeks = sender as? Int
        
        
            if segue.identifier == "toNotDetay" {
                      let gidilecekVC = segue.destination as! DuzenleViewController
                      gidilecekVC.not = notlarListe[indeks!]
                  }
        
    }
    
    func veriTabaniKopyala() {
        let bundleYoluZor = Bundle.main.path(forResource: "todolist", ofType: ".sqlite")
        let hedefYolZor = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManagerZor = FileManager.default
        let kopyalanacakYerZor = URL(fileURLWithPath: hedefYolZor).appendingPathComponent("todolist.sqlite")
        if fileManagerZor.fileExists(atPath: kopyalanacakYerZor.path) {
            print("veritabani zaten var.2")
        } else {
                do {

                    try fileManagerZor.copyItem(atPath: bundleYoluZor!, toPath: kopyalanacakYerZor.path)
                    
                }catch {

                    print(error)
        }
    }
        
    }
    
    @IBAction func notEkle(_ sender: Any) {
        let alertController = UIAlertController(title: "Not Ekle", message: "Notunuzu daha sonra düzenleyebilirsiniz", preferredStyle: .alert)
            alertController.addTextField { textfield in
                textfield.placeholder = "Yazınız"
        
            }
        let IptalAction = UIAlertAction(title: "İptal", style: .destructive) { action in
            print("iptal tıklandı")
           
        }
            
            let kaydetAction = UIAlertAction(title: "Kaydet", style: .cancel) { action in
                print("kaydet tıklandı")
                if let notText = alertController.textFields?.first?.text {
                    let not = Notlar(not_id: 0, not_kendi: notText,favori: false)
                    
                    // Veritabanına kaydet
                    let dao = Notlardao()
                    dao.notEkle(not_kendi: notText )
                    
                    // Notları listeye ekle ve tabloyu yenile
                    self.notlarListe.append(not)
                    self.notTableView.reloadData()
                }
            }
            alertController.addAction(kaydetAction)
        alertController.addAction(IptalAction)
            self.present(alertController, animated: true)
        
        
}
    // Favori düğmesi tıklandığında çağrılan işlev
    @objc func favoriButtonTapped(_ sender: UIButton) {
        
        
        let index = sender.tag
        notlarListe[index].favori = !notlarListe[index].favori
        
        // Favori durumuna göre düğme görünümünü güncelle
        let image = notlarListe[index].favori ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        sender.setImage(image, for: .normal)
        sender.tintColor = notlarListe[index].favori ? UIColor.systemYellow : UIColor.systemGray
        
        // Veritabanında favori durumunu güncelle
        let dao = Notlardao()
        dao.favoriDurumGuncelle(not: notlarListe[index])
      //  dao.favoriNotlarAl()
        
    }
}
extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notlarListe.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let not = notlarListe[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "notHucre", for: indexPath) as! NotlarTableViewCell
        cell.notLabel.text = not.not_kendi
        
        // Favori düğmesi
                let favoriButton = UIButton(type: .system)
                favoriButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
                favoriButton.tintColor = not.favori ? UIColor.systemYellow : UIColor.systemGray
                favoriButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                favoriButton.addTarget(self, action: #selector(favoriButtonTapped(_:)), for: .touchUpInside)
                favoriButton.tag = indexPath.row // Bu hücredeki notun indeksini etiket olarak belirle

                cell.accessoryView = favoriButton
        
      
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toNotDetay", sender: indexPath.row)
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let silAction = UITableViewRowAction(style: .default, title: "Sil", handler: {
                (action:UITableViewRowAction,indexPath:IndexPath) -> Void in
                let not = self.notlarListe[indexPath.row]
                Notlardao().notSil(not_id: not.not_id!)
                self.notlarListe.remove(at: indexPath.row)
                self.notTableView.deleteRows(at: [indexPath], with: .automatic)
            })
            return [silAction]
}
}
