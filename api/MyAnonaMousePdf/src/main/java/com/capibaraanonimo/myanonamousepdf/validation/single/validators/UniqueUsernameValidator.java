package com.capibaraanonimo.myanonamousepdf.validation.single.validators;

import com.capibaraanonimo.myanonamousepdf.service.UserService;
import com.capibaraanonimo.myanonamousepdf.validation.single.annotations.UniqueUsername;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class UniqueUsernameValidator implements ConstraintValidator<UniqueUsername, String> {

    @Autowired
    private UserService userService;

    @Override
    public boolean isValid(String s, ConstraintValidatorContext constraintValidatorContext) {
        return StringUtils.hasText(s) && !userService.userNameExists(s);
    }
}