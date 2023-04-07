package com.capibaraanonimo.myanonamousepdf.security.jwt.refresh;

import com.capibaraanonimo.myanonamousepdf.security.errorhandling.JwtTokenException;

public class RefreshTokenException extends JwtTokenException {

    public RefreshTokenException(String msg) {
        super(msg);
    }

}
