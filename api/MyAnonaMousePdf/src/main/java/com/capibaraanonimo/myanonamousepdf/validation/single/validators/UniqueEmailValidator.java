package com.capibaraanonimo.myanonamousepdf.validation.single.validators;

import com.capibaraanonimo.myanonamousepdf.service.UserService;
import com.capibaraanonimo.myanonamousepdf.validation.single.annotations.UniqueEmail;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

public class UniqueEmailValidator implements ConstraintValidator<UniqueEmail, String> {

    @Autowired
    private UserService userService;

    @Override
    public boolean isValid(String s, ConstraintValidatorContext constraintValidatorContext) {
        return StringUtils.hasText(s) && !userService.emailExists(s);
    }
}
