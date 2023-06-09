package com.capibaraanonimo.myanonamousepdf.errors.exceptions;

import org.springframework.security.core.AuthenticationException;

public class UserDisabledException extends AuthenticationException  {
    public UserDisabledException(String msg) {
        super(msg);
    }

    public UserDisabledException(String msg, Throwable cause) {
        super(msg, cause);
    }
}
