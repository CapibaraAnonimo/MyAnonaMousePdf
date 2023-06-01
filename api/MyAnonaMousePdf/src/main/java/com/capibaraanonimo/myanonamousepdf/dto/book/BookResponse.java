package com.capibaraanonimo.myanonamousepdf.dto.book;

import com.capibaraanonimo.myanonamousepdf.dto.comment.CommentResponse;
import com.capibaraanonimo.myanonamousepdf.dto.user.UserResponse;
import com.capibaraanonimo.myanonamousepdf.model.Book;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BookResponse { //FIXME no pilla lo heredado "extends BookCreatedResponse"
    private UUID id;

    @JsonFormat(pattern = "dd-MM-yyyy HH:mm")
    private LocalDateTime uploadDate;

    private UserResponse uploader;

    private long amountDownloads;

    private String category;

    private List<CommentResponse> comment;

    @Builder.Default()
    private boolean vip = false;

    private String book, title, author, description;

    public static BookResponse of(Book book) {
        return BookResponse.builder()
                .id(book.getId())
                .uploadDate(book.getUploadDate())
                .uploader(UserResponse.fromUser(book.getUploader()))
                .amountDownloads(book.getAmountDownloads())
                .category(book.getCategory().getName())
                .vip(book.isVip())
                .book(book.getBook())
                .title(book.getTitle())
                .author(book.getAuthor())
                .description(book.getDescription())
                .comment(book.getComments().stream().map(CommentResponse::of).toList())
                .build();
    }
}
