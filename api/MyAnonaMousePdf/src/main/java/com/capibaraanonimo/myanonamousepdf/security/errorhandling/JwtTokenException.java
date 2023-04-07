package com.capibaraanonimo.myanonamousepdf.security.errorhandling;

public class JwtTokenException extends RuntimeException {

    public JwtTokenException(String msg) {
        super(msg);
    }


}
