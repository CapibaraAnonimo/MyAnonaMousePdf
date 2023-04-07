package com.capibaraanonimo.myanonamousepdf.dto.book;

import com.capibaraanonimo.myanonamousepdf.dto.user.UserResponse;
import com.capibaraanonimo.myanonamousepdf.model.Book;
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

    protected LocalDateTime uploadDate;

    protected UserResponse uploader;

    protected String category;

    @Builder.Default()
    protected boolean vip = false;

    protected String book, title, author, description;

    public static BookCreatedResponse of(Book book) {
        return BookCreatedResponse.builder()
                .id(book.getId())
                .uploadDate(book.getUploadDate())
                .uploader(UserResponse.fromUser(book.getUploader()))
                .category(book.getCategory().getName())
                .vip(book.isVip())
                .book(book.getBook())
                .title(book.getTitle())
                .author(book.getAuthor())
                .description(book.getDescription())
                .build();
    }
}
