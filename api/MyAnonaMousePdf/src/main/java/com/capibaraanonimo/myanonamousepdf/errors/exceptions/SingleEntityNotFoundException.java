package com.capibaraanonimo.myanonamousepdf.errors.exceptions;

import java.util.UUID;

public class SingleEntityNotFoundException extends EntityNotFoundException {

    public SingleEntityNotFoundException(UUID id, Class clazz) {
        super(String.format("No se puede encontrar una entidad del tipo %s con ID: %s", clazz.getName(), id));
    }
}
