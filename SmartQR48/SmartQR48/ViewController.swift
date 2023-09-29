//
//  ViewController.swift
//  SmartQR48
//
//  Created by 出田和毅 on 2023/09/29.
//

import UIKit


class ViewController: UIViewController, UITextFieldDelegate {
    
    // UIButton
    let cameraButton = UIButton()
    let fileButton = UIButton()
    let clearButton = UIButton()
    
    // 画面構築
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // viewの背景色
        view.backgroundColor = .white
        
        // Create UIButton for Camera
        cameraButton.setTitle("camera", for: .normal)
        cameraButton.backgroundColor = UIColor.systemBlue
        cameraButton.addTarget(self, action: #selector(cameraButtonPressed), for: .touchUpInside)
        self.view.addSubview(cameraButton)
        // button layout
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        cameraButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cameraButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        
        // Create UIButton for File
        fileButton.setTitle("file", for: .normal)
        fileButton.backgroundColor = UIColor.systemBlue
        fileButton.addTarget(self, action: #selector(fileButtonPressed), for: .touchUpInside)
        self.view.addSubview(fileButton)
        // button layout
        fileButton.translatesAutoresizingMaskIntoConstraints = false //Auto Layoutの制御を手動にする
        fileButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true //topからの距離を50に固定
        fileButton.widthAnchor.constraint(equalToConstant: 200).isActive = true //オブジェクトの横幅
        fileButton.heightAnchor.constraint(equalToConstant: 50).isActive = true //オブジェクトの縦幅
        fileButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true //オブジェクトのX座標の中心
        
        
        // Create UIButton for Data Clear
        clearButton.setTitle("clear", for: .normal)
        clearButton.backgroundColor = UIColor.systemBlue
        clearButton.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        self.view.addSubview(clearButton)
        // button layout
        clearButton.translatesAutoresizingMaskIntoConstraints = false //Auto Layoutの制御を手動にする
        clearButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 350).isActive = true //topからの距離を50に固定
        clearButton.widthAnchor.constraint(equalToConstant: 200).isActive = true //オブジェクトの横幅
        clearButton.heightAnchor.constraint(equalToConstant: 50).isActive = true //オブジェクトの縦幅
        clearButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        
    }
    
    // カメラボタンが押された際の挙動を記述
    @objc func cameraButtonPressed() {
        // インスタンス化
        let secondViewController = SecondViewController()
        // self.present(secondViewController, animated: true, completion: nil)
        navigationController?.pushViewController(secondViewController, animated: true)
    }
    // ファイルボタンが押された際の挙動を記述
    @objc func fileButtonPressed() {
        // インスタンス化
        let thirdViewController = ThirdViewController()
        // self.present(thirdViewController, animated: true, completion: nil)
        navigationController?.pushViewController(thirdViewController, animated: true)

    }
    // ファイルデータ消去
    @objc func clearButtonPressed() {
        clearQRCodeData()
    }

}

// 現在、ホーム画面に設置した二つのボタンはどちらもモーダル遷移にて子ビューを表示するように設定されている。
// 本当はnavigation遷移あるいはフルモーダルで作りたいので、余裕ができたら作り直す。

// 拡張機能：テキストファイルに格納したデータの消去
extension ViewController {
    func clearQRCodeData() {
        let fileName = "QRCodeData.txt"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsPath.appendingPathComponent(fileName)

        do {
            try "".write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("エラー: \(error)")
        }
    }
}

