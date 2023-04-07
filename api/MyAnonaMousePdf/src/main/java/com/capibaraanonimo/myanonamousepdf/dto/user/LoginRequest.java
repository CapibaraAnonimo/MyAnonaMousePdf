package com.capibaraanonimo.myanonamousepdf.dto.user;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.validation.constraints.NotBlank;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LoginRequest {
    @NotBlank(message = "{loginRequest.username.blank}")
    private String username;

    @NotBlank(message = "{loginRequest.password.blank}")
    private String password;
}
