//
//  TextRecognitionViewController.swift
//  SmartDoorBellApp
//
//  Created by Rafael Batista on 16/12/2021.
//

import UIKit
import Vision

class TextRecognitionViewController: UIViewController {

    @IBOutlet var sendDataToAugmentedReality: UIButton!
    @IBOutlet var ocrImageView: UIImageView!
    @IBOutlet var loadTextRecognitionIndicator: UIActivityIndicatorView!
    @IBOutlet var textRecogzieView: UITextView!
    
    var imageRecieved: UIImage!
    
    var textRecognitionRequest = VNRecognizeTextRequest(completionHandler: nil)
    
    typealias CardContentField = (name: String, value: String)

    /// The information to fetch from a scanned card.
    struct BusinessCardContents {
        
        var name: String?
        var numbers: String?
        var website: String?
        var address: String?
        var email: String?
        
        func availableContents() -> [CardContentField] {
            var contents = [CardContentField]()
     
            if let name = self.name {
                contents.append(("Name", name))
            }
            if let numbers = self.numbers {
                contents.append(("Number", numbers))
            }
            if let website = self.website {
                contents.append(("Website", website))
            }
            if let address = self.address {
                contents.append(("Address", address))
            }
            if let email = self.email {
                contents.append(("Email", email))
            }
            
            return contents
        }
    }
    
    var contents = BusinessCardContents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
 
        self.ocrImageView.image = imageRecieved
        setUpVisionTextRecognitionRequest(image: imageRecieved!)
        stopAnimating()
        self.dismissKeyboardd()
    }
    
    @IBAction func touchCameraButton(_ sender: Any) {
        setupGallery()
    }
    
    private func startAnimating() {
        self.loadTextRecognitionIndicator.startAnimating()
    }
    
    private func stopAnimating() {
        self.loadTextRecognitionIndicator.stopAnimating()
    }
    
    private func setupGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func setUpVisionTextRecognitionRequest(image: UIImage) {
        
        var textString = ""
       
        //Request
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
               
            if let results = self.textRecognitionRequest.results, !results.isEmpty {
                
                guard let requestResults = request.results as? [VNRecognizedTextObservation] else {fatalError("Recieved Invalid Observation")}
                            
                for result in requestResults {
                    guard let topCandidate = result.topCandidates(1).first else {
                        print("No candidates")
                        continue
                    }
                    textString.append(topCandidate.string + "\n")
                }
                self.parseTextContents(text: textString)
                
                
                
                DispatchQueue.main.async {
                    self.stopAnimating()
                    self.textRecogzieView.text = textString
                }
            } else {
                fatalError("Error empty results")
            }
                
        })
        
        // textRecognitionRequest.customWords = ["custOm"]
         textRecognitionRequest.minimumTextHeight = 0.032
         textRecognitionRequest.recognitionLevel = .accurate
         textRecognitionRequest.usesLanguageCorrection = true
         
         let requests = [textRecognitionRequest]
         
         //handler
         DispatchQueue.global(qos: .userInitiated).async {
             guard let img = image.cgImage else {fatalError("Missing Image")}
         
             let handler = VNImageRequestHandler(cgImage: img, options: [:])
             
             //Process Request
             do {
                 try handler.perform(requests)//Schedules Vision requests to be performed.
             }
             catch {
                 print(error)
             }
     
         }
    }
       
    // MARK: Helper functions
    func parseTextContents(text: String) {
        do {
            // Any line could contain the name on the business card.
            var potentialNames = text.components(separatedBy: .newlines)
            
            // Create an NSDataDetector to parse the text, searching for various fields of interest.
            let detector = try NSDataDetector(types: NSTextCheckingAllTypes)
            let matches = detector.matches(in: text, options: .init(), range: NSRange(location: 0, length: text.count))
            for match in matches {
                let matchStartIdx = text.index(text.startIndex, offsetBy: match.range.location)
                let matchEndIdx = text.index(text.startIndex, offsetBy: match.range.location + match.range.length)
                let matchedString = String(text[matchStartIdx..<matchEndIdx])
                
                // This line has been matched so it doesn't contain the name on the business card.
                while !potentialNames.isEmpty && (matchedString.contains(potentialNames[0]) || potentialNames[0].contains(matchedString)) {
                    potentialNames.remove(at: 0)
                }
                
                switch match.resultType {
                case .address:
                    contents.address = matchedString
                case .phoneNumber:
                    contents.numbers = matchedString
                case .link:
                    if (match.url?.absoluteString.contains("mailto"))! {
                        contents.email = matchedString
                    } else {
                        contents.website = matchedString
                    }
                default:
                    print("\(matchedString) type:\(match.resultType)")
                }
            }
            if !potentialNames.isEmpty {
                // Take the top-most unmatched line to be the person/business name.
                contents.name = potentialNames.first
            }
        } catch {
            print(error)
        }
        
        /*let second: String? = "\n\((self.contents.availableContents()[0]).name): \(self.contents.name)"
        
        return second!*/
    }
    
    @IBAction func sendData(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "arkitView") as! Ocr3DViewController
        
        vc.textFromOcr = self.textRecogzieView.text
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension TextRecognitionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        startAnimating()
        self.textRecogzieView.text = ""
        
        let image = info[UIImagePickerController.InfoKey.originalImage]as? UIImage
        print("ASDADFVVDVSDVSDADADADADDAS \(image!)")
        
        self.ocrImageView.image = image
        
        setUpVisionTextRecognitionRequest(image: image!)
    }
}

extension UIViewController {
func dismissKeyboardd() {
       let tap: UITapGestureRecognizer = UITapGestureRecognizer( target:     self, action:    #selector(UIViewController.dismissKeyboardTouchOutside))
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTouchOutside() {
       view.endEditing(true)
    }
}
