package com.capibaraanonimo.myanonamousepdf.validation.single.validators;

import com.capibaraanonimo.myanonamousepdf.service.CategoryService;
import com.capibaraanonimo.myanonamousepdf.validation.single.annotations.CategoryExist;
import org.springframework.beans.factory.annotation.Autowired;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.util.UUID;

public class CategoryExistValidator implements ConstraintValidator<CategoryExist, String> {
    @Autowired
    private CategoryService categoryService;

    @Override
    public boolean isValid(String id, ConstraintValidatorContext constraintValidatorContext) {
        return categoryService.existsById(UUID.fromString(id));
    }
}
