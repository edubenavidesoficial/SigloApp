import Foundation

class SaveHelper {
    func guardarNota(_ nota: Nota, saveAction: (SavedArticle) -> Void) {
        print("Guardando nota: \(nota.titulo)")

        let imagenURL = nota.fotos.first?.url_foto ?? "ejemplo"

        let savedArticle = SavedArticle(
            category: nota.localizador,
            title: nota.titulo,
            author: nota.autor,
            location: nota.ciudad ?? "",
            time: nota.fecha_formato ?? "",
            imageName: imagenURL,
            description: nota.fotos.map { $0.pie_foto ?? "" }.joined(separator: "\n")
        )

        saveAction(savedArticle)
    }
}
