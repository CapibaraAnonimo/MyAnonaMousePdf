package com.capibaraanonimo.myanonamousepdf.dto.category;

import com.capibaraanonimo.myanonamousepdf.dto.book.BookResponse;
import com.capibaraanonimo.myanonamousepdf.model.Category;
import lombok.*;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CategoryResponse {
    private UUID id;


    private String name;

    private List<BookResponse> categorizedBooks = new ArrayList<>();

    public static CategoryResponse of(Category category) {
        return CategoryResponse.builder()
                .id(category.getId())
                .name(category.getName())
                .categorizedBooks(category.getCategorizedBooks().stream().map(BookResponse::of).toList())
                .build();
    }
}
