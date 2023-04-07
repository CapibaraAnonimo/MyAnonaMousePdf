package com.capibaraanonimo.myanonamousepdf.validation.single.validators;

import com.capibaraanonimo.myanonamousepdf.service.UserService;
import com.capibaraanonimo.myanonamousepdf.validation.single.annotations.UserExist;
import org.springframework.beans.factory.annotation.Autowired;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.util.UUID;

public class UserExistValidator implements ConstraintValidator<UserExist, UUID> {
    @Autowired
    private UserService userService;

    @Override
    public boolean isValid(UUID id, ConstraintValidatorContext constraintValidatorContext) {
        return userService.existsById(id);
    }
}
