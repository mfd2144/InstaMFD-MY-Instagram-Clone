//
//  SelectAlbumView.swift
//  mock
//
//  Created by Mehmet fatih DOĞAN on 28.07.2021.
//

import UIKit

final class SelectAlbumView:UITableViewController{
    var viewModel:SelectAlbumViewModel!
    var albums = Array<AlbumCollection>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SelectAlbumViewCell.self, forCellReuseIdentifier: SelectAlbumViewCell.identifier)
        tableView.backgroundColor = .black
        viewModel.delegate = self
        viewModel.loadAlbums()
        tableView.rowHeight = 120
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectAlbumViewCell.identifier, for: indexPath) as? SelectAlbumViewCell
        
        cell?.cell(album: albums[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectAnAlbum(   albums[indexPath.row])
     
        navigationController?.popViewController(animated: true)
    }
    
}

extension SelectAlbumView:SelectAlbumViewModelDelegate{
    func handleOutputs(_ outputs: SelectAlbumOutputs) {
        switch outputs {
        case .albumData(let data):
            albums = data
            DispatchQueue.main.async {[unowned self] in
                tableView.reloadData()
            }
            
        }
    }
}


final class SelectAlbumViewCell:UITableViewCell{
    
    private let albumImage :UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        return imageV
    }()
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    static let identifier = "SelectAlbumViewCellIdentifier"
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        setCell()
    }
    
    private func setCell(){
        backgroundColor = .black
        addSubview(albumImage)
        addSubview(label)
        
        albumImage.putSubviewAt(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: nil, topDis: 10, bottomDis: -10, leadingDis: 20, trailingDis: 0, heightFloat: nil, widthFloat: 100, heightDimension: nil, widthDimension: nil )
        
        label.putSubviewAt(top: topAnchor, bottom: bottomAnchor, leading: albumImage.trailingAnchor, trailing: nil, topDis: 20, bottomDis: -20, leadingDis: 20, trailingDis: 0, heightFloat: nil, widthFloat: 200, heightDimension: nil, widthDimension: nil)
    }
    
    
    func cell(album:AlbumCollection){
        if album.lastImage == nil{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                album.getLastImage(size: CGSize.init(width: 300, height: 300)) { [unowned  self] (image) in
                    albumImage.image = image
                    if let count = album.count{
                    label.text = "\(album.name)(\(String(describing: count)))"
                    }
                }
            })
        }else{
            albumImage.image = album.lastImage
            if let count = album.count{
            label.text = "\(album.name)(\(String(describing: count)))"
            }
        }
    }
    
}
