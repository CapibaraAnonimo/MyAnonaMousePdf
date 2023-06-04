package com.capibaraanonimo.myanonamousepdf.errors.exceptions;

public class AdminRequiredException extends RuntimeException {
    public AdminRequiredException(String name) {
        super(String.format("El usuario con el nombre \"%s\" no es Admin", name));
    }
}
