//
//  AddImageDB.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 4.08.2021.
//

import UIKit


final class AddImageDBView:UITableViewController{
    //MARK: - Properties
    var viewModel:AddImageDBViewModel!
    let backGroundView = UIView()
    var imageContainer:ImageContainer?{
        didSet{
            tableView.reloadData()
        }
    }
    //MARK: - View Properties
    
    lazy var shareBarButton:UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareButtonPressed))
        return button
    }()
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .white
        backGroundView.backgroundColor = .white
        tableView.bounces = false
    title = "New Post"
        tableView.isSpringLoaded = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(AddImageTopCell.self, forCellReuseIdentifier: AddImageTopCell.identifier)
        navigationItem.rightBarButtonItem = shareBarButton
     
        tableView.separatorColor = .clear
        
        
    }
    //MARK: - Tableview Delegate and Data
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell  = tableView.dequeueReusableCell(withIdentifier: AddImageTopCell.identifier, for: indexPath) as? AddImageTopCell
            cell?.setCell(delegate: self, image: (imageContainer?.images)!)
            cell?.backgroundColor = .white
            cell?.layer.addBorder(edge: .bottom, color: .gray, thickness: 1)
            cell?.selectedBackgroundView = backGroundView
            return cell ?? UITableViewCell()
        case 1:
    
            return setCell(text: "Tag People", indexPath: indexPath)
        case 2:
            return setCell(text: "Add Location", indexPath: indexPath)
        default:
           fatalError()
        }
        

        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 120.0
        }else {
            return 50.0
        }
    }
    
    
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddImageTopCell{
            cell.textView.resignFirstResponder()
        }
        switch indexPath.row{
        case 1:
            //Tag friends
            break
        case 2:
            //add location
            break
        default:
            break
            
        }
        
        
    }
    
    
    
    
    //MARK: - Methods
    
    private func setCell(text:String,indexPath:IndexPath)->UITableViewCell{
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .white
        cell.textLabel?.text = text
        cell.layer.addBorder(edge: .bottom, color: .gray, thickness: 1)
        cell.selectedBackgroundView = backGroundView
        cell.accessoryType = .disclosureIndicator
        cell.tintColor = .black
        cell.textLabel?.textColor = .black
        return cell
    }
    
    @objc private func shareButtonPressed(sender: UIBarButtonItem){
        if sender.title == "Ok"{
      
            (tableView.cellForRow(at:IndexPath(row: 0, section: 0)) as? AddImageTopCell)?.textView.endEditing(true)
        }else{
            guard let imageContainer = imageContainer else {return}
            viewModel.saveToDB(image: imageContainer)
        }
      
    }
}

extension AddImageDBView:AddImageDBViewModelDelegate{
    func handleOutputs(_ output: AddImageDBViewModelOutputs) {
        switch output {
        case .anyErrorOccured(let caution):
            addCaution(title: "Caution", message: caution)
        case.isLoading(let loading):
            loading ? Animator.sharedInstance.showAnimation() : Animator.sharedInstance.hideAnimation()
        case .loadImage(let _imageContainer):
            imageContainer = _imageContainer
        }
    }
    
    
}


extension AddImageDBView:UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        shareBarButton.title = "Ok"
        navigationItem.hidesBackButton = true
        title = nil
        if textView.text == addImagePlaceHolder{
            textView.text = ""
            textView.textColor = .black
        }
     
    }
   
    
    func textViewDidEndEditing(_ textView: UITextView) {
        shareBarButton.title = "Share"
        imageContainer?.comment = textView.text
        navigationItem.hidesBackButton = false
        title = "New Post"
        if textView.text == ""{
            textView.text = addImagePlaceHolder
            textView.textColor = .lightGray
        }
     
    }
  
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.count >= 100{
            textView.endEditing(true)
            textView.resignFirstResponder()
            addCaution(title:"Caution" , message: "Reach maximum character number")
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.endEditing(true)
        return true
    }
    
    
  
}
