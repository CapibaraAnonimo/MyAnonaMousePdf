package com.capibaraanonimo.myanonamousepdf.controller;

import com.capibaraanonimo.myanonamousepdf.dto.category.CategoryResponse;
import com.capibaraanonimo.myanonamousepdf.service.CategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RestController()
@RequestMapping("/category")
@RequiredArgsConstructor()
public class CategoryController {
    private final CategoryService categoryService;

    @GetMapping()
    public List<CategoryResponse> getAll() {
        return categoryService.findAllWithBooks();
    }

    @GetMapping("/{id}") //TODO comprobar que va con postgresql
    public CategoryResponse getById(@PathVariable String id) {
        return CategoryResponse.of(categoryService.findById(UUID.fromString(id)));
    }
}
