import UIKit
import Photos

class ContentHelper {
    
    // Compartir contenido genérico (texto, imágenes, URLs)
    static func compartirContenido(desde viewController: UIViewController, contenido: [Any]) {
        let activityVC = UIActivityViewController(activityItems: contenido, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = viewController.view // Para iPad
        viewController.present(activityVC, animated: true, completion: nil)
    }
    
    // Guardar imagen en el carrete (álbum de fotos)
    static func guardarImagenEnFotos(_ imagen: UIImage, completion: @escaping (Bool, Error?) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized || status == .limited else {
                completion(false, NSError(domain: "Permisos", code: 1, userInfo: [NSLocalizedDescriptionKey: "Permiso denegado para acceder a Fotos"]))
                return
            }
            UIImageWriteToSavedPhotosAlbum(imagen, nil, nil, nil)
            completion(true, nil)
        }
    }
    
    // Guardar archivo en la app Archivos
    static func guardarArchivo(data: Data, nombreArchivo: String, tipo: String, desde viewController: UIViewController) {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(nombreArchivo).\(tipo)")
        
        do {
            try data.write(to: tempURL)
            let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = viewController.view
            viewController.present(activityVC, animated: true, completion: nil)
        } catch {
            print("Error al guardar el archivo: \(error)")
        }
    }
}
