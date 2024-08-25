//
//  MedicationVC.swift
//  KidzCorner
//
//  Created by Happy Guleria on 20/08/24.
//

import UIKit

class MedicationVC: UIViewController {
    
//    MARK: OUTLETS
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var dateBtn: UIButton!
    @IBOutlet weak var enterNameTF: UITextField!
    @IBOutlet weak var timeADayTF: UITextField!
    @IBOutlet weak var timeADayBtn: UIButton!
    @IBOutlet weak var additionalTxtVw: UITextView!
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var beforeLunchImgVw: UIImageView!
    @IBOutlet weak var beforeLunchBtn: UIButton!
    @IBOutlet weak var AfterLunchImageVw: UIImageView!
    @IBOutlet weak var AfterLunchBtn: UIButton!
    
    @IBOutlet weak var MedicationCollectionView: UICollectionView!
    @IBOutlet weak var medicationPageControl: UIPageControl!
    
    
    let datePicker = UIDatePicker()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        ImageUpdate()
    }

    
    @IBAction func submitBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SelectLunchType(_ sender: UIButton) {
        if sender.tag == 1 {
            beforeLunchImgVw.image =  UIImage(named: "checkBoxIcon")
            AfterLunchImageVw.image =  UIImage(named: "uncheckedBox 1")
        }else{
            beforeLunchImgVw.image =  UIImage(named: "uncheckedBox 1")
            AfterLunchImageVw.image =  UIImage(named: "checkBoxIcon")
        }
    }
    
    @IBAction func dateSelectBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func timeDaySelectbtn(_ sender: UIButton) {
        
    }
    
//    MARK: FUNCTIONS
    func setupCollectionView() {
        let nib = UINib(nibName: "MedicationListViewCell", bundle: nil)
        MedicationCollectionView.register(nib, forCellWithReuseIdentifier: "MedicationListViewCell")
        MedicationCollectionView.dataSource = self
        MedicationCollectionView.delegate = self
        if let layout = MedicationCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        MedicationCollectionView.isPagingEnabled = true
    }
    
    
    func ImageUpdate(){
        beforeLunchImgVw.image =  UIImage(named: "uncheckedBox 1")
        AfterLunchImageVw.image =  UIImage(named: "uncheckedBox 1")
    }

        
}
extension MedicationVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        medicationPageControl.numberOfPages = 4
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MedicationListViewCell", for: indexPath) as! MedicationListViewCell
        return cell
    }
    
    
}
