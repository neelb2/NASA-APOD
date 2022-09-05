//
//  APODFavItemTableViewCell.swift
//  NASA-APOD
//
//  Created by Neel Bhasin on 05/09/22.
//

import UIKit

protocol FavItemDelegate {
    func removeItem(_ value: String)
}

class APODFavItemTableViewCell: UITableViewCell {

    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var innerBgView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    var viewModel: APODFavViewModel?
    var url: String = ""
    var delegate: FavItemDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        innerBgView.backgroundColor = APODColor.sharedInstance.cellBackgroundColor
        titleLbl.textColor = APODColor.sharedInstance.cellTitleColor
        innerBgView.layer.cornerRadius = 8
        viewModel = APODFavViewModel()
        viewModel?.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    @IBAction func favBtnTap(_ sender: Any) {
        self.delegate?.removeItem(url)
    }
    
    func getData() {
        self.viewModel?.getImageFor(url)
    }
    
}

extension APODFavItemTableViewCell: APODDataFetchDelegate {
    func fetchSuccessfull() {
        if let data = self.viewModel?.response {
            var url: String? = data.url
            if let type = data.mediaType {
                if type == "video" {
                    url = data.thumbnailUrl
                }
            }
            if let url = url {
                BaseNetworkManager.dowloadImage(urlString: url, onCompletion: {(data, str) in
                    if str == url {
                        self.imgView.image = UIImage(data: data)
                    }
                }, OnError: {error in
                    self.imgView.image = UIImage(systemName: "exclamationmark.icloud")
                })
            }else{
                if let type = data.mediaType {
                    if type == "video" {
                        self.imgView.image = UIImage(systemName: "video")
                    }
                }
            }
            self.titleLbl.text = data.date
        }
    }
    
    func fetchFailed() {
        
    }
    
    
}
