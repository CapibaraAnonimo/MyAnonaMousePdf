package com.capibaraanonimo.myanonamousepdf.dto.comment;

import com.capibaraanonimo.myanonamousepdf.model.Comment;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CommentResponse {
    private UUID id;

    private String text;

    @JsonFormat(pattern = "dd-MM-yyyy HH:mm")
    private LocalDateTime commentDate;

    private String username;

    public static CommentResponse of(Comment comment) {
        return CommentResponse.builder()
                .id(comment.getId())
                .text(comment.getText())
                .commentDate(comment.getCommentDate())
                .username(comment.getUser().getUsername())
                .build();
    }
}
