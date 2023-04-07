package com.capibaraanonimo.myanonamousepdf.errors.exceptions;

public class ContentTypeNotValidException extends EntityNotFoundException {
    public ContentTypeNotValidException(String contenteType) {
        super(String.format("No se puede subir un archivo %s", contenteType));
    }
}
