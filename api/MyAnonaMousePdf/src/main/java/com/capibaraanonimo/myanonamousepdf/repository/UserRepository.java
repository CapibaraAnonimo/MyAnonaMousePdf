package com.capibaraanonimo.myanonamousepdf.repository;

import com.capibaraanonimo.myanonamousepdf.model.User;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface UserRepository extends JpaRepository<User, UUID> {
    boolean existsUserByUsername(String username);

    boolean existsUserByEmail(String email);

    Optional<User> findFirstByUsername(String username);

    @EntityGraph("user-with-bookmarks")
    Optional<User> findUserById(UUID id);
}
