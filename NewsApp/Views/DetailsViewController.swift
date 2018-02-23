//
//  DetailsViewController.swift
//  NewsApp
//
//  Created by MACC on 2/3/18.
//  Copyright © 2018 Rami. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var previewImage: Image?
    var newsTitle: String?
    var details: String?
    var section: String?
    var date: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fillNewsData()
    }

    
    private func fillNewsData() {
        previewImageView.image = previewImage
        titleLabel.text = newsTitle
        sectionLabel.text = section
        dateLabel.text = date
        if let detailsText = details {
            detailsLabel.attributedText = NSAttributedString(html: detailsText)
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
/////////////////////////////////////////////////////////////////////////////
extension NSAttributedString {
    internal convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }
        guard let attributedString = try? NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return nil
        }
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .right
        attributedString.addAttributes([.paragraphStyle: paragraph,
                                        NSAttributedStringKey.font: UIFont(name: "Chalkduster", size: 18.0)!], range: NSMakeRange(0, attributedString.string.count))
        self.init(attributedString: attributedString)
    }
}
