//
//  MakeWorkSpaceViewController.swift
//  Sooda4
//
//  Created by 임승섭 on 1/7/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI


class MakeWorkSpaceViewController: BaseViewController {
    
    private let mainView = MakeWorkSpaceView()
    private var viewModel: MakeWorkSpaceViewModel!
    private var disposeBag = DisposeBag()
    
    static func create(with viewModel: MakeWorkSpaceViewModel) -> MakeWorkSpaceViewController {
        let vc = MakeWorkSpaceViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigation()
        setPHPicker()
        bindVM()
    }
    
    func setNavigation() {
        navigationItem.title = "워크스페이스 생성"
        if let sheetPresentationController {
            sheetPresentationController.prefersGrabberVisible = true
        }
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .white
//        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = navigationBarAppearance
    }
    
    func setPHPicker() {
        mainView.clearPickerButton.addTarget(self , action: #selector(pickerButtonClicked), for: .touchUpInside)
    }
    
    func bindVM() {
        // 그냥
        viewModel.imageData
            .subscribe(with: self) { owner , data in
                DispatchQueue.main.async {
                    owner.mainView.updateWorkSpaceImageView(data)
                }
            }
            .disposed(by: disposeBag)
        
        
        // Input Output Pattern
        let input = MakeWorkSpaceViewModel.Input(
            nameText: mainView.nameTextField.rx.text.orEmpty,
            descriptionText: mainView.nameTextField.rx.text.orEmpty,
            completeButtonClicked: mainView.completeButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        output.enabledCompleteButton
            .subscribe(with: self) { owner , value in
                owner.mainView.completeButton.update(value ? .enabled : .disabled)
            }
            .disposed(by: disposeBag)
    }
    
    @objc
    func pickerButtonClicked() {
        self.showPHPicker()
    }
    
    func showPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension MakeWorkSpaceViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        guard let result = results.first else { return }
        
        let itemProvider = result.itemProvider
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image , error  in
                
                guard let image = image as? UIImage else { return }
                
                guard let imageData = image.jpegData(compressionQuality: 0.001) else { return }
                
                self?.viewModel.imageData.onNext(imageData)
            }
        }
        
        picker.dismiss(animated: true)
    }
}
