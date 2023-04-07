package com.capibaraanonimo.myanonamousepdf.validation.single.annotations;

import com.capibaraanonimo.myanonamousepdf.validation.single.validators.UniqueUsernameValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

@Target({ElementType.METHOD, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = UniqueUsernameValidator.class)
@Documented
public @interface UniqueUsername {

    String message() default "The username is already taken or is blank";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

}
