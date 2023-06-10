package com.capibaraanonimo.myanonamousepdf.errors.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

import java.util.UUID;

@ResponseStatus(code = HttpStatus.NOT_FOUND, reason = "Entity not found")
public class SingleEntityNotFoundException extends EntityNotFoundException {

    public SingleEntityNotFoundException(UUID id, Class clazz) {
        super(String.format("No se puede encontrar una entidad del tipo %s con ID: %s", clazz.getName(), id));
    }
}
