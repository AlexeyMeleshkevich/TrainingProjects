//
//  ViewController.swift
//  Names To Faces
//
//  Created by Alexey Meleshkevich on 13.04.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addData))
        collectionView.backgroundColor = UIColor.purple
        // Do any additional setup after loading the view.
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "С.picture", for: indexPath) as? PersonCell else { return UICollectionViewCell() }
        
        let person = people[indexPath.item]
        
        let path = getDocumentDirectory().appendingPathComponent(person.image)
        
        cell.titleLabel.text = person.name
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.contentView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        cell.contentView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 8
        cell.layer.cornerRadius = cell.frame.height/6
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let mainAlert = UIAlertController(title: "Actions", message: nil, preferredStyle: .actionSheet)
        mainAlert.addAction(UIAlertAction(title: "Rename person", style: .default, handler: { [weak self] (_) in
            let alert = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self, weak alert] (_) in
                guard let newName = alert?.textFields?[0].text else { return }
                person.name = newName
                self?.collectionView.reloadData()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        }))
        mainAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { [weak self] (_) in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.reloadData()
        }))
        mainAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(mainAlert, animated: true, completion: nil)
    }
    
    @objc func addData() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.delegate = self
        UIImagePickerController.isSourceTypeAvailable(.camera)
        present(picker, animated: true, completion: nil)
    }

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

