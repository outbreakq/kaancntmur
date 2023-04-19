//
//  Notlardao.swift
//  ToDoListApp
//
//  Created by Kaan Cantimur on 17.04.2023.
//

import Foundation


class Notlardao {
    let db:FMDatabase?
    init() {
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let veritabaniURL = URL(fileURLWithPath: hedefYol).appendingPathComponent("todolist.sqlite")
        
        db = FMDatabase(path: veritabaniURL.path)
    }
    func tumNotlarAl() -> [Notlar] {
        var liste = [Notlar]()
        db?.open()
        
        do {
            let rs = try db!.executeQuery("SELECT * FROM yapilacaklar", values: nil)
            while rs.next() {
                let not_id = Int(rs.int(forColumn: "not_id"))
                let not_kendi = rs.string(forColumn: "not_kendi") ?? ""
                let favori = rs.bool(forColumn: "favori")
                let not = Notlar(not_id: not_id, not_kendi: not_kendi, favori: favori)
                liste.append(not)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        db?.close()
        return liste
    }

    func notEkle(not_kendi:String) {
        db?.open()
        
        do {
            try db!.executeUpdate("INSERT INTO yapilacaklar (not_kendi) VALUES (?)", values: [not_kendi])
        }catch {
            print(error.localizedDescription)
        }
        
        db?.close()
    }
 
    
    func notGuncelle(not_id:Int,not_kendi:String) {
    db?.open()
        do {
        try db!.executeUpdate("UPDATE yapilacaklar SET not_kendi = ?  WHERE not_id = ?", values: [not_kendi,not_id])
        }catch {
            print(error.localizedDescription)
        }
    db?.close()
}
    func notSil(not_id:Int) {
        db?.open()
        do {
            try db!.executeUpdate("DELETE FROM yapilacaklar WHERE not_id = ?", values: [not_id])
        }catch {
            print(error.localizedDescription)
        }
        db?.close()
    }
    func favoriDurumGuncelle(not: Notlar) -> Bool {
            db?.open()
            
            let sql = "UPDATE yapilacaklar SET favori = ? WHERE not_id = ?"
        let params = [not.favori , not.not_id ?? 0] as [Any]
            let result = db?.executeUpdate(sql, withArgumentsIn: params)
            
            db?.close()
            
            if let result = result {
                return result
            } else {
                return false
            }
        }

        func favoriNotlarAl() -> [Notlar] {
            var liste = [Notlar]()
            db?.open()

            do {
                let rs = try db!.executeQuery("SELECT * FROM yapilacaklar WHERE favori = 1", values: nil)
                while rs.next() {
                    let not = Notlar(not_id: Int(rs.int(forColumn: "not_id")),
                                     not_kendi: rs.string(forColumn: "not_kendi")!,
                                     favori: rs.bool(forColumn: "favori"))
                    liste.append(not)
                }
            } catch {
                print(error.localizedDescription)
            }

            db?.close()

            return liste
        }
        
        // ...
    }






