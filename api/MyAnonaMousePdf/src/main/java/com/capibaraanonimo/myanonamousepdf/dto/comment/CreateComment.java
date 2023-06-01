package com.capibaraanonimo.myanonamousepdf.dto.comment;

import lombok.*;

import javax.validation.constraints.NotEmpty;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CreateComment {
    @NotEmpty(message = "{createComment.text.empty}")
    private String text;
}
