package com.capibaraanonimo.myanonamousepdf.validation.single.annotations;

import com.capibaraanonimo.myanonamousepdf.validation.single.validators.CategoryExistValidator;

import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.*;

@Target({ElementType.METHOD, ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = CategoryExistValidator.class)
@Documented
public @interface CategoryExist {
    String message() default "The category with that id don't exist";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
