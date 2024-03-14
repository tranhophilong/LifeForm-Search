//
//  LifeFormDetailViewController.swift
//  Life-FormSearch
//
//  Created by Long Tran on 12/03/2024.
//

import UIKit

class LifeFormDetailViewController: UIViewController {

    let idLifeForm: Int
    
    @IBOutlet weak var linkLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var phylumLabel: UILabel!
    @IBOutlet weak var kingdomLabel: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
    @IBOutlet weak var nameAccordingToLabel: UILabel!
    @IBOutlet weak var nameCreatorLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    required init?(coder: NSCoder, idLifeForm: Int) {
        self.idLifeForm = idLifeForm
        super.init(coder: coder)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameCreatorLabel.text = ""
        linkLabel.text = ""
        nameAccordingToLabel.text = ""
        scientificNameLabel.text =  ""
        kingdomLabel.text =  ""
        phylumLabel.text =  ""
        classLabel.text =  ""
        orderLabel.text =  ""
        imageView.image = UIImage(systemName: "photo.on.rectangle")

        Task{
            do{
                let detailLifeForm = try await LifeFormController.shared.fetchDetailLifeForm(for: idLifeForm)
                let urlImage =  detailLifeForm.dataObjects?.first?.eolMediaURL
                let taxonId = detailLifeForm.taxonConcepts.first!.identifier
                async let ancestors =  LifeFormController.shared.fetchAncestors(for: taxonId)
                                
                if let urlImage = urlImage{
                   async let image = try  LifeFormController.shared.fetchImage(for: urlImage)
                
                    imageView.image = try await image
                }
                
                try await updateUI(with: detailLifeForm, and: ancestors)
                
                
            }catch{
                print(error)
            }
        }
    }
    
    func updateUI(with detailLifeForm: DetailLifeform, and ancestors: AncestorsDict){
        
        
        
        nameCreatorLabel.text = detailLifeForm.dataObjects?.first?.rightsHolder ?? detailLifeForm.dataObjects?.first?.agents.first?.fullName ?? "Name creator not found"
        linkLabel.text = detailLifeForm.dataObjects?.first?.license ?? " License not found"
        nameAccordingToLabel.text = detailLifeForm.taxonConcepts.first?.nameAccordingTo ?? ""
        scientificNameLabel.text = detailLifeForm.taxonConcepts.first?.scientificName ?? ""
        kingdomLabel.text = ancestors["kingdom"] ?? ""
        phylumLabel.text = ancestors["phylum"] ?? ""
        classLabel.text = ancestors["class"] ?? ""
        orderLabel.text = ancestors["order"] ?? ""
    
    }
  
}
