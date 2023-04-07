package com.capibaraanonimo.myanonamousepdf.validation.single.annotations;

import com.capibaraanonimo.myanonamousepdf.validation.single.validators.UserExistValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

@Target({ElementType.METHOD, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = UserExistValidator.class)
@Documented
public @interface UserExist {
    String message() default "The user with that id don't exist";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
