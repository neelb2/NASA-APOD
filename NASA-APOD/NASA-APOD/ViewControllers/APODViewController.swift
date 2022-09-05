//
//  APODViewController.swift
//  NASA-APOD
//
//  Created by Neel Bhasin on 05/09/22.
//

import UIKit
import AVKit
import AVFoundation

class APODViewController: UIViewController {
    var viewModel = APODViewModel()
    var titleString: String?
    var picker: UIDatePicker!
    var selectedDate: String?
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var favBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        addDatePicker()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let stringDate = selectedDate ?? formatter.string(from: Date())
        viewModel.getImageFor(stringDate)
        loader.isHidden = false
        self.title = titleString ?? "Today"
        if (titleString == nil) {
            setupNavBar()
        }
        self.favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
        self.favBtn.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        self.titleLbl.textColor = APODColor.sharedInstance.titleColor
        self.dateLbl.textColor = APODColor.sharedInstance.titleColor
        self.descLbl.textColor = APODColor.sharedInstance.titleColor
        self.view.backgroundColor = APODColor.sharedInstance.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.favBtn.isSelected {
            if !APODStoreUtils.sharedInstance.isStoredInFav(self.viewModel.updatedUrl) {
                self.favBtn.isSelected = false
            }
        }
    }
    
    func setupNavBar() {
        let button = UIBarButtonItem.init(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        self.navigationItem.rightBarButtonItem = button
    }
    
    func addDatePicker() {
        let screenBounds = UIScreen.main.bounds
        picker = UIDatePicker()
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.addTarget(self, action: #selector(dueDateChanged(sender:)), for: .valueChanged)
        picker.frame = CGRect(x: 0, y: screenBounds.height - 180, width: screenBounds.width, height: 100)
        picker.maximumDate = Date()
        picker.backgroundColor = APODColor.sharedInstance.pickerColor
        picker.isHidden = true
        self.view.addSubview(picker)
    }

    @objc func searchTapped() {
        picker.date = Date()
        picker.isHidden = false
    }
    
    @objc func dueDateChanged(sender:UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = formatter.string(from: sender.date)
        formatter.dateFormat = "dd MMM yyyy"
        let dateForTitle = formatter.string(from: sender.date)
        picker.isHidden = true
        self.presentedViewController?.dismiss(animated: true)
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "APODViewController") as? APODViewController {
            vc.titleString = dateForTitle
            vc.selectedDate = selectedDate
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func favBtnTapped(_ sender: Any) {
        if self.favBtn.isSelected {
            self.favBtn.isSelected = false
            APODStoreUtils.sharedInstance.removeFromFav(self.viewModel.updatedUrl)
        }else {
            self.favBtn.isSelected = true
            APODStoreUtils.sharedInstance.addToFav(self.viewModel.updatedUrl)
        }
    }
}

extension APODViewController: APODDataFetchDelegate  {
    func fetchSuccessfull() {
        loader.isHidden = true
        if let data = self.viewModel.response {
            favBtn.isHidden = false
            self.dateLbl.text = data.date
            var url: String? = data.url
            if let type = data.mediaType {
                if type == "video" {
                    url = data.thumbnailUrl
                }
            }
            if let url = url {
                loader.isHidden = false
                BaseNetworkManager.dowloadImage(urlString: url, onCompletion: {(data, str) in
                    self.loader.isHidden = true
                    if str == url {
                        self.imgView.image = UIImage(data: data)
                    }else{
                        self.imgView.image = UIImage(systemName: "exclamationmark.icloud")
                    }
                }, OnError: {error in
                    self.loader.isHidden = true
                    self.imgView.image = UIImage(systemName: "exclamationmark.icloud")
                })
            }else {
                if let type = data.mediaType {
                    if type == "video" {
                        self.imgView.image = UIImage(systemName: "video")
                    }
                }
            }
            self.titleLbl.text = data.title
            self.descLbl.text = data.explanation
            APODStoreUtils.sharedInstance.storeLastFetchKey(self.viewModel.updatedUrl)
            if APODStoreUtils.sharedInstance.isStoredInFav(self.viewModel.updatedUrl) {
                self.favBtn.isSelected = true
            }
        }
    }
    
    func fetchFailed() {
        loader.isHidden = true
    }
}

