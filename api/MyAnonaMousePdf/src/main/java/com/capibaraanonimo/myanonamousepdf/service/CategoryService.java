package com.capibaraanonimo.myanonamousepdf.service;

import com.capibaraanonimo.myanonamousepdf.dto.category.CategoryResponse;
import com.capibaraanonimo.myanonamousepdf.errors.exceptions.ListEntityNotFoundException;
import com.capibaraanonimo.myanonamousepdf.errors.exceptions.SingleEntityNotFoundException;
import com.capibaraanonimo.myanonamousepdf.model.Category;
import com.capibaraanonimo.myanonamousepdf.repository.BookRepository;
import com.capibaraanonimo.myanonamousepdf.repository.CategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RequiredArgsConstructor
@Service
public class CategoryService {
    private final CategoryRepository categoryRepository;
    private final BookRepository bookRepository;

    public boolean existsById(UUID id) {
        return categoryRepository.existsById(id);
    }

    public Category findById(UUID id) {
        Optional<Category> category = categoryRepository.findById(id);
        if (category.isPresent())
            return category.get();
        throw new SingleEntityNotFoundException(id, Category.class);
    }

    public List<Category> findAll() {
        List<Category> categories = categoryRepository.findAll();
        if (categories.isEmpty()) {
            throw new ListEntityNotFoundException(Category.class);
        }
        return categories;
    }

    @Transactional
    public List<CategoryResponse> findAllWithBooks() {
        List<Category> categories = categoryRepository.findAllWithBooks();
        if (categories.isEmpty()) {
            throw new ListEntityNotFoundException(Category.class);
        }

        return categories.stream().map(CategoryResponse::of).toList();
    }
}
