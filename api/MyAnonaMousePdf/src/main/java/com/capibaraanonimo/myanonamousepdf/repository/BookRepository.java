package com.capibaraanonimo.myanonamousepdf.repository;

import com.capibaraanonimo.myanonamousepdf.model.Book;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.Optional;
import java.util.UUID;

public interface BookRepository extends JpaRepository<Book, UUID>, JpaSpecificationExecutor<Book> {
    Optional<Book> findBookByBook(String book);
}
