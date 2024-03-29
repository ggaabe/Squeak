//
//  SwiftRecognitionViewController.swift
//  ClarifaiApiDemo
//

import UIKit

/**
 * This view controller performs recognition using the Clarifai API.
 */
class SwiftRecognitionViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private struct Constants {
        // IMPORTANT NOTE: you should replace these keys with your own App ID and secret.
        // These can be obtained at https://developer.clarifai.com/applications
        static let AppID = "sM3FcXiT4_CkI5AueAPfOWRxlrdZih8-spmpQbGE"
        static let AppSecret = "rzaj5hpCAygNjqQyQa-THDYGhPLUF4eNpU44cBU4"

        // Custom Training (Alpha): to predict against a custom concept (instead of the standard
        // tag model), set this to be the name of the concept you wish to predict against. You must
        // have previously trained this concept using the same app ID and secret as above. For more
        // info on custom training, see https://github.com/Clarifai/hackathon
        static let ConceptName: String? = "cleanWaterScratchedSlide"
        static let ConceptNamespace = "default"
    }

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!

    private var client : ClarifaiClient {
        get {
            let c = ClarifaiClient(appID: Constants.AppID, appSecret: Constants.AppSecret)
            // Uncomment this to request embeddings. Contact us to enable embeddings for your app:
            // c.enableEmbed = true
            return c
        }
    }

    @IBAction func buttonPressed(sender: UIButton) {
        // Show a UIImagePickerController to let the user pick an image from their library.
        let picker = UIImagePickerController()
        //picker.sourceType = .PhotoLibrary
        picker.sourceType = .Camera
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // The user picked an image. Send it Clarifai for recognition.
            imageView.image = image
            textView.backgroundColor = UIColor.whiteColor()
            textView.textColor = UIColor.blackColor()
            textView.text = "Recognizing..."
            button.enabled = false
            recognizeImage(image)
        }
    }

    private func recognizeImage(image: UIImage!) {
        // Scale down the image. This step is optional. However, sending large images over the
        // network is slow and does not significantly improve recognition performance.
        let size = CGSizeMake(320, 320 * image.size.height / image.size.width)
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
       // let context = UIGraphicsGetCurrentContext()
        UIGraphicsEndImageContext()

        // Encode as a JPEG.
        let jpeg = UIImageJPEGRepresentation(scaledImage, 0.9)!

        if (Constants.ConceptName == nil) {
            // Standard Recognition: Send the JPEG to Clarifai for standard image tagging.
            client.recognizeJpegs([jpeg], completion: { (results: [ClarifaiResult]?, error: NSError?) in
                if (error != nil) {
                    print("Error: \(error)\n")
                    self.textView.text = "Sorry, there was an error recognizing your image."
                } else {
                    self.textView.text = "Tags:\n" + results![0].tags.joinWithSeparator(", ")
                }
                self.button.enabled = true
            })
        } else {
            // Custom Training: Send the JPEG to Clarifai for prediction against a custom model.
            client.predictJpegs([jpeg], conceptNamespace: Constants.ConceptNamespace, conceptName: Constants.ConceptName, completion: { (results: [ClarifaiPredictionResult]?, error: NSError?) in
                if (error != nil) {
                    print("Error: \(error)\n")
                    self.textView.text = "Sorry, there was an error running prediction on your image."
                } else {
                    self.textView.text = "Prediction score for \(Constants.ConceptName!):\n\(results![0].score)"
                }
                //let waterMessage = CGRect(x: size.width,y: size.height, width: size.width, height: 30)
                self.textView.textColor = UIColor.whiteColor()
                self.textView.font = UIFont(name: "Verdana", size: 25)
                print(results![0].score)
                if(results![0].score < 0.4){
                   // self.view.addSubview(waterMessage)
                   // CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
                    self.textView.backgroundColor = UIColor.redColor()
                    
                    self.textView.text = "CONTAMINATED: DO NOT DRINK"
                }else{
                   // CGContextSetFillColorWithColor(context, UIColor.greenColor().CGColor)
                    self.textView.backgroundColor = UIColor.greenColor()
                    self.textView.text = "CLEAN!"
                }
               // CGContextAddRect(context, waterMessage)
                
                self.button.enabled = true
            })
        }
    }
}
