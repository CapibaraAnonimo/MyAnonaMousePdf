package com.capibaraanonimo.myanonamousepdf.errors.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(code = HttpStatus.UNAUTHORIZED, reason = "User is not admin")
public class AdminRequiredException extends RuntimeException {
    public AdminRequiredException(String name) {
        super(String.format("El usuario con el nombre \"%s\" no es Admin", name));
    }
}
