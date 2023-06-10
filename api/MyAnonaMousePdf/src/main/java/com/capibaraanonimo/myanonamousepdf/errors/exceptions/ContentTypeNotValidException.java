package com.capibaraanonimo.myanonamousepdf.errors.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(code = HttpStatus.UNSUPPORTED_MEDIA_TYPE, reason = "Content type not valid")
public class ContentTypeNotValidException extends EntityNotFoundException {
    public ContentTypeNotValidException(String contenteType) {
        super(String.format("No se puede subir un archivo %s", contenteType));
    }
}
