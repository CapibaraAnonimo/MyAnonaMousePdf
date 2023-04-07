package com.capibaraanonimo.myanonamousepdf.dto.user;

import com.capibaraanonimo.myanonamousepdf.model.User;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@JsonInclude(JsonInclude.Include.NON_NULL) //TODO mirate esto para hacer la herencia de la clase que no te salía
public class JwtUserResponse extends UserResponse {

    private String token;
    private String refreshToken;

    public JwtUserResponse(UserResponse userResponse) {
        id = userResponse.getId();
        userName = userResponse.getUserName();
        fullName = userResponse.getFullName();
        avatar = userResponse.getAvatar();
        createdAt = userResponse.getCreatedAt();
    }

    public static JwtUserResponse of (User user, String token, String refreshToken) {
        JwtUserResponse result = new JwtUserResponse(UserResponse.fromUser(user));
        result.setToken(token);
        result.setRefreshToken(refreshToken);
        return result;

    }

}
