package com.capibaraanonimo.myanonamousepdf.dto.book;

import com.capibaraanonimo.myanonamousepdf.dto.user.UserResponse;
import com.capibaraanonimo.myanonamousepdf.model.Book;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BookCreatedResponse {
    public UUID id;

    @JsonFormat(pattern = "dd-MM-yyyy HH:mm")
    protected LocalDateTime uploadDate;

    protected UserResponse uploader;

    protected String category;

    @Builder.Default()
    protected boolean vip = false;

    protected String book, image, title, author, description;

    public static BookCreatedResponse of(Book book) {
        return BookCreatedResponse.builder()
                .id(book.getId())
                .uploadDate(book.getUploadDate())
                .uploader(UserResponse.fromUser(book.getUploader()))
                .category(book.getCategory().getName())
                .vip(book.isVip())
                .book(book.getBook())
                .image(book.getImage())
                .title(book.getTitle())
                .author(book.getAuthor())
                .description(book.getDescription())
                .build();
    }
}
