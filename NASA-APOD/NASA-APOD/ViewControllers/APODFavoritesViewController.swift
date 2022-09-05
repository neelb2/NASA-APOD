//
//  APODFavoritesViewController.swift
//  NASA-APOD
//
//  Created by Neel Bhasin on 05/09/22.
//

import UIKit

class APODFavoritesViewController: UIViewController {
    @IBOutlet weak var favTableView: UITableView!
    var storedData = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = APODColor.sharedInstance.backgroundColor
        self.favTableView.dataSource = self
        self.favTableView.delegate = self
        self.favTableView.register(UINib(nibName: "APODFavItemTableViewCell", bundle: nil), forCellReuseIdentifier: "APODFavItemTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavs()
    }
    
    func fetchFavs() {
        if let favs = APODStoreUtils.sharedInstance.getFavs() {
            storedData = favs
            self.favTableView.reloadData()
        }
    }
}

extension APODFavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "APODFavItemTableViewCell", for: indexPath) as? APODFavItemTableViewCell {
            cell.url = storedData[indexPath.row]
            cell.getData()
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

extension APODFavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let string = storedData[indexPath.row]
        var date = ""
        if let queryPath = URLComponents(string: string){
            if let item = queryPath.queryItems {
                for i in item {
                    if i.name == "date" {
                        date = i.value ?? ""
                    }
                }
            }
        }
        if date != "" {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "APODViewController") as? APODViewController {
                vc.titleString = date
                vc.selectedDate = date
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension APODFavoritesViewController: FavItemDelegate {
    func removeItem(_ value: String) {
        APODStoreUtils.sharedInstance.removeFromFav(value)
        fetchFavs()
    }
}
