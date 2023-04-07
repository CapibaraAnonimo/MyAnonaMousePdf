package com.capibaraanonimo.myanonamousepdf.dto.user;

import com.capibaraanonimo.myanonamousepdf.model.User;
import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.*;
import lombok.experimental.SuperBuilder;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class UserResponse {

    protected String id;
    protected String userName, avatar, fullName;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy HH:mm:ss")
    protected LocalDateTime createdAt;


    public static UserResponse fromUser(User user) {

        return UserResponse.builder()
                .id(user.getId().toString())
                .userName(user.getUsername())
                .avatar(user.getAvatar())
                .fullName(user.getFullName())
                .createdAt(user.getCreationDate())
                .build();
    }

}