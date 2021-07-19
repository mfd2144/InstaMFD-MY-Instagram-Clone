//
//  CountryCodesView.swift
//  InstaMFD
//
//  Created by Mehmet fatih DOĞAN on 14.07.2021.
//

import UIKit


final class CountryCodesView:UITableViewController{
    var viewModel:CountryCodesViewModel!

    var result:[CountryPresentation]?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "CountryCodeCell", bundle: Bundle.test), forCellReuseIdentifier: "CountryCell")
        tableView.rowHeight = 50
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        result?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.callMorePresentation(index:indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as? CountryCodeCell
        cell?.country = result![indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Singleton.shared.dialCode = result![indexPath.row].code
        navigationController?.popViewController(animated: true)
        
    }
    
}

extension CountryCodesView:CountryCodesViewModelDelegate{
    func handleOutPut(output: Results<Any>) {
        switch output {
        case.failure(let err) :
            addCaution(title: "Caution", message: "Download error \(err.localizedDescription)")
        case.success(let codes):
        guard let codes = codes as? [CountryPresentation] else {return}
            result = codes
        }
        DispatchQueue.main.async { [unowned self] in
            tableView.reloadData()
        }
    }
    
  
    
    
}

