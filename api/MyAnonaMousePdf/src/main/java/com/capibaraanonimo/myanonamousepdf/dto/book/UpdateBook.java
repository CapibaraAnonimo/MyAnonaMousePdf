package com.capibaraanonimo.myanonamousepdf.dto.book;

import com.capibaraanonimo.myanonamousepdf.model.Book;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UpdateBook {
    protected String category;

    @Builder.Default()
    protected boolean vip = false;

    protected String title, author, description;

    public static UpdateBook of(Book book) {
        return UpdateBook.builder()
                .category(book.getCategory().getName())
                .vip(book.isVip())
                .title(book.getTitle())
                .author(book.getAuthor())
                .description(book.getDescription())
                .build();
    }
}
