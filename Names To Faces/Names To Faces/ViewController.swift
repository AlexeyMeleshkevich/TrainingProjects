//
//  ViewController.swift
//  Names To Faces
//
//  Created by Alexey Meleshkevich on 13.04.2020.
//  Copyright © 2020 Alexey Meleshkevich. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UICollectionViewController {
    
    var people = [Person]() {
        didSet(person) {
            self.collectionView.reloadData()
        }
    }
    let button = UIButton(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addData))
        collectionView.backgroundColor = UIColor.purple
        setSaveButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.coreDataManager.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            people = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setSaveButton() {
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = 15
        button.setTitle("Сохранить", for: .normal)
        
        UIView.animate(withDuration: 1) {
            NSLayoutConstraint.activate([
                self.button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 5),
                self.button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -5),
                self.button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10),
                self.button.heightAnchor.constraint(equalToConstant: 80)
            ])
            self.button.layoutIfNeeded()
        }
        
        button.addTarget(self, action: #selector(saveData), for: .touchUpInside)
    }
    
    @objc func saveData() {
        if !validateData() {
            return
        }
        if !validateDataFields() {
            return
        }
        
        if let contex = (UIApplication.shared.delegate as? AppDelegate)?.coreDataManager.persistentContainer.viewContext {
            let entity = NSEntityDescription.entity(forEntityName: "Person", in: contex)
            for i in 0..<people.count {
                let taskObject = NSManagedObject(entity: entity!, insertInto: contex) as! Person
                taskObject.name = people[i].name
                taskObject.image = people[i].image
                
                do {
                    try contex.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func saveData2(data: (String?, Data)) {
        if let contex = (UIApplication.shared.delegate as? AppDelegate)?.coreDataManager.persistentContainer.viewContext {
            let entity = NSEntityDescription.entity(forEntityName: "Person", in: contex)
            for i in 0..<people.count {
                let taskObject = NSManagedObject(entity: entity!, insertInto: contex) as! Person
                
                taskObject.name = people[i].name
                taskObject.image = people[i].image
                
                do {
                    try contex.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func validateData() -> Bool {
        if people.count == 0 {
            let alert = UIAlertController(title: "Добавьте пользователей", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func validateDataFields() -> Bool {
        for i in 0..<collectionView.numberOfItems(inSection: 0) {
            let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as? PersonCell
            if cell?.imageView == nil {
                return false
            }
            if (cell?.titleLabel.text!.isEmpty)! || cell?.titleLabel.text == "Unknown" {
                let alert = UIAlertController(title: "Введите имя в ячейке \(i + 1)", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return false
            }
        }
        return true
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
        
        cell.titleLabel.text = person.name
        cell.imageView.image = UIImage(data: person.image!)
        
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
            
            
            guard let personToDelete = self?.people[indexPath.row] else { return }
            self?.detelePerson(person: personToDelete)
            
        }))
        mainAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(mainAlert, animated: true, completion: nil)
    }
    
    func detelePerson(person: Person) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.coreDataManager.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
        
        context.delete(person)
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
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
        
        let imageData = image.jpegData(compressionQuality: 1)
        
        if let contex = (UIApplication.shared.delegate as? AppDelegate)?.coreDataManager.persistentContainer.viewContext {
            let entity = NSEntityDescription.entity(forEntityName: "Person", in: contex)
            let person = Person(entity: entity!, insertInto: contex)
            person.name = "Unknown"
            person.image = imageData
            people.append(person)
            collectionView.reloadData()
            dismiss(animated: true, completion: nil)
        }
    }
    
}

