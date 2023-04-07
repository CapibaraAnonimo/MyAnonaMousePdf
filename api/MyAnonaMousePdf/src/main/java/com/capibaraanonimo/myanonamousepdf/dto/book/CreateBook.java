package com.capibaraanonimo.myanonamousepdf.dto.book;

import com.capibaraanonimo.myanonamousepdf.validation.single.annotations.CategoryExist;
import lombok.*;

import javax.validation.constraints.NotEmpty;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreateBook {
    @CategoryExist(message = "{createBook.category.exist}")
    private UUID category;

    @NotEmpty(message = "{createBook.title.empty}")
    private  String title;

    @NotEmpty(message = "{createBook.author.empty}")
    private String author;

    @NotEmpty(message = "{createBook.description.empty}")
    private String description;
}
