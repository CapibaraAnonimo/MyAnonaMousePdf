package com.capibaraanonimo.myanonamousepdf.dto.user;

import com.capibaraanonimo.myanonamousepdf.validation.multiple.annotations.FieldsValueMatch;
import com.capibaraanonimo.myanonamousepdf.validation.single.annotations.UniqueEmail;
import com.capibaraanonimo.myanonamousepdf.validation.single.annotations.UniqueUsername;
import lombok.*;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldsValueMatch(field = "password", fieldMatch = "verifyPassword", message = "{createUserRequest.password.match}")
public class CreateUserRequest {

    @UniqueUsername(message = "{createUserRequest.username.unique}")
    private String username;

    @NotBlank(message = "{createUserRequest.password.blank}") //TODO pon una validación decente de contraseña máquina
    private String password;

    private String verifyPassword;

    @Email(message = "{createUserRequest.email.email}")
    @UniqueEmail(message = "{createUserRequest.email.unique}")
    private String email;

    private String avatar;

    @NotBlank(message = "{createUserRequest.fullName.blank}")
    private String fullName;

}
