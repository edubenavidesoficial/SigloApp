import SwiftUI

struct NewsCommentsSheet: View {
    @Environment(\.dismiss) var dismiss 
    @State private var commentText: String = ""

    struct Comment: Identifiable {
        let id = UUID()
        let username: String
        let handle: String
        let time: String
        let text: String
        var likes: Int
        var dislikes: Int
    }

    @State private var comments: [Comment] = [
        Comment(username: "Pallonon", handle: "@Pallonon", time: "09:06 am, hoy", text: "La pregunta es: ¿Como responderá el gobierno a las personas afectadas?", likes: 2, dislikes: 0),
        Comment(username: "José", handle: "@jose0181", time: "09:15 am, hoy", text: "Van a decir en la mañana que no pasa nada", likes: 0, dislikes: 0),
        Comment(username: "Alex", handle: "@ale1871", time: "09:21 am, hoy", text: "Deberían tener un gran presupuesto para destinarlo a estos desastres", likes: 0, dislikes: 0),
        Comment(username: "Rodrigo", handle: "@rodricger", time: "09:13 am, hoy", text: "Algo tiene Guerrero que siempre los huracanes llegan ahí", likes: 0, dislikes: 0),
        Comment(username: "Pedri", handle: "@spider", time: "09:22 am, hoy", text: "Lo peor de todo es que se espera que otro huracan toque tierra en las costas de Guerrero.", likes: 0, dislikes: 0)
    ]

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Capsule()
                    .frame(width: 40, height: 6)
                    .foregroundColor(Color.gray.opacity(0.4))
                    .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .shadow(radius: 1)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(comments) { comment in
                        CommentRow(comment: comment)
                    }
                }
                .padding()
            }

            VStack {
                HStack {
                    TextField("Escriba su comentario", text: $commentText)
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(25)

                    Button(action: {
                        // Action to submit comment
                        if !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            let newComment = Comment(
                                username: "You",
                                handle: "@you",
                                time: Date().formatted(date: .omitted, time: .shortened),
                                text: commentText,
                                likes: 0,
                                dislikes: 0
                            )
                            comments.insert(newComment, at: 0)
                            commentText = ""
                        }
                    }) {
                        Image(systemName: "paperplane.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.white)
            }
            .shadow(radius: 1)
        }
        .background(Color.white)
    }
}

struct CommentRow: View {
    let comment: NewsCommentsSheet.Comment

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(comment.username.first ?? "U"))
                            .font(.headline)
                            .foregroundColor(.white)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(comment.username)
                            .fontWeight(.bold)
                        Text(comment.handle)
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        Text(comment.time)
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    Text(comment.text)
                        .font(.body)
                }

                Spacer()
            }
            .padding(.bottom, 4)

            HStack {
                Spacer()
                Button(action: {
                    // Action for reply
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrowshape.turn.up.left.fill")
                            .font(.caption)
                        Text("Responder")
                            .font(.caption)
                    }
                    .foregroundColor(.gray)
                }

                Spacer()

                Button(action: {
                    // Action for like
                }) {
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Text("\(comment.likes)")
                    .font(.caption)
                    .foregroundColor(.gray)

                Button(action: {
                    // Action for dislike
                }) {
                    Image(systemName: "hand.thumbsdown.fill")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Text("\(comment.dislikes)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .padding(.horizontal)
        .overlay(
            VStack {
                Spacer()
                Divider()
            }
            .padding(.leading, 20)
        )
    }
}
