//
//  ThirdViewController.swift
//  SmartQR48
//
//  Created by 出田和毅 on 2023/09/29.
//

import UIKit

class ThirdViewController: UIViewController {

    let textView = UITextView()
    let fileNameLabel = UILabel()
    let fileOpenButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // viewの背景色
        view.backgroundColor = .white
        // ここに表示させるモーダルをテーブルにできるか？？？？
        
        fileOpenButton.setTitle("File Open", for: .normal)
        fileOpenButton.backgroundColor = UIColor.systemBlue // Use dynamic color
        fileOpenButton.addTarget(self, action: #selector(openTextFileButtonTapped), for: .touchUpInside)
        self.view.addSubview(fileOpenButton)
        // button layout
        fileOpenButton.translatesAutoresizingMaskIntoConstraints = false //Auto Layoutの制御を手動にする
        fileOpenButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true //topからの距離を50に固定
        fileOpenButton.widthAnchor.constraint(equalToConstant: 200).isActive = true //オブジェクトの横幅
        fileOpenButton.heightAnchor.constraint(equalToConstant: 50).isActive = true //オブジェクトの縦幅
        fileOpenButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true //オブジェクトのX座標の中心
    }
    // 取得データ表示ボタンタップ後の処理(ファイルオープン)
    @IBAction func openTextFileButtonTapped(_ sender: Any) {
        let fileName = "QRCodeData.txt"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsPath.appendingPathComponent(fileName)
        
        // ファイルラベル
        fileNameLabel.font = UIFont.systemFont(ofSize: 15) // フォントサイズ
        fileNameLabel.text = "ファイル名を入力" // ここはのちにデータ連動を実装する
        fileNameLabel.textColor = .black
        fileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(fileNameLabel)
        fileNameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        fileNameLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true //オブジェクトの横幅
        fileNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true //オブジェクトの縦幅
        fileNameLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        
        // データファイル
        textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textView)
        textView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 35).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        do {
            let fileContent = try String(contentsOf: fileURL, encoding: .utf8)
            textView.text = fileContent
        } catch {
            print("エラー: \(error)")
        }
    }
}
