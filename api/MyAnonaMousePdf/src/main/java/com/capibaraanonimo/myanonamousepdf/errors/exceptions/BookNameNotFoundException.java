package com.capibaraanonimo.myanonamousepdf.errors.exceptions;

import java.util.UUID;

public class BookNameNotFoundException extends EntityNotFoundException {
    public BookNameNotFoundException(String name) {
        super(String.format("No se puede encontrar un libro con el nombre \"%s\"", name));
    }
}
