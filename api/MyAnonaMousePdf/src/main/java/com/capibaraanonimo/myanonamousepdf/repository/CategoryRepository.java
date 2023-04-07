package com.capibaraanonimo.myanonamousepdf.repository;

import com.capibaraanonimo.myanonamousepdf.model.Category;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.UUID;

public interface CategoryRepository extends JpaRepository<Category, UUID> {
    @EntityGraph("category-with-books")
    @Query("""
            select c
            from Category c
            """)
    List<Category> findAllWithBooks();
}
