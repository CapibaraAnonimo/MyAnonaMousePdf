package com.capibaraanonimo.myanonamousepdf.dto.user;

import com.capibaraanonimo.myanonamousepdf.validation.multiple.annotations.FieldsValueMatch;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@FieldsValueMatch(field = "newPassword", fieldMatch = "verifyNewPassword", message = "{createUserRequest.password.match}")
public class ChangePasswordRequest {
    private String oldPassword;
    private String newPassword;
    private String verifyNewPassword;
}
