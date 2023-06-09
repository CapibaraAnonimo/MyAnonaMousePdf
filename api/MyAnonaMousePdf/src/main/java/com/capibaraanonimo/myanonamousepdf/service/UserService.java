package com.capibaraanonimo.myanonamousepdf.service;

import com.capibaraanonimo.myanonamousepdf.dto.user.CreateUserRequest;
import com.capibaraanonimo.myanonamousepdf.errors.exceptions.ContentTypeNotValidException;
import com.capibaraanonimo.myanonamousepdf.errors.exceptions.ListEntityNotFoundException;
import com.capibaraanonimo.myanonamousepdf.errors.exceptions.SingleEntityNotFoundException;
import com.capibaraanonimo.myanonamousepdf.model.Book;
import com.capibaraanonimo.myanonamousepdf.model.Roles;
import com.capibaraanonimo.myanonamousepdf.model.User;
import com.capibaraanonimo.myanonamousepdf.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.EnumSet;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserService {
    private final PasswordEncoder passwordEncoder;
    private final UserRepository userRepository;
    private final StorageService storageService;

    public User save(User user) {
        return userRepository.save(user);
    }

    public boolean userNameExists(String user) {
        return userRepository.existsUserByUsername(user);
    }

    public boolean emailExists(String email) {
        return userRepository.existsUserByEmail(email);
    }

    public boolean existsById(UUID id) {
        return userRepository.existsById(id);
    }

    public User findById(UUID userId) {
        Optional<User> optionalUser = userRepository.findById(userId);
        if (optionalUser.isPresent())
            return optionalUser.get();
        else
            throw new SingleEntityNotFoundException(userId, User.class);
    }

    public List<User> findAll() {
        return userRepository.findAll();
    }

    public User findByUsername(String username) {
        Optional<User> optionalUser = userRepository.findFirstByUsername(username);
        if (optionalUser.isPresent())
            return optionalUser.get();
        throw new UsernameNotFoundException("No user with username: " + username);
    }

    public User createUser(CreateUserRequest createUserRequest, EnumSet<Roles> roles) {
        User user = User.builder()
                .username(createUserRequest.getUsername())
                .password(passwordEncoder.encode(createUserRequest.getPassword()))
                .avatar(createUserRequest.getAvatar())
                .fullName(createUserRequest.getFullName())
                .avatar("avatar.jpg")
                .roles(roles)
                .build();

        return userRepository.save(user);
    }

    public User createUserWithUserRole(CreateUserRequest createUserRequest) {
        return createUser(createUserRequest, EnumSet.of(Roles.USER));
    }

    public User createUserWithAdminRole(CreateUserRequest createUserRequest) {
        return createUser(createUserRequest, EnumSet.of(Roles.ADMIN));
    }

    public boolean passwordMatch(User user, String clearPassword) {
        return passwordEncoder.matches(clearPassword, user.getPassword());
    }

    public Optional<User> editPassword(UUID userId, String newPassword) {

        // Aquí no se realizan comprobaciones de seguridad. Tan solo se modifica

        return userRepository.findById(userId)
                .map(u -> {
                    u.setPassword(passwordEncoder.encode(newPassword));
                    return userRepository.save(u);
                }).or(() -> Optional.empty());
    }

    public User disable(UUID id) {
        User user = findById(id);
        user.setEnabled(false);
        save(user);
        return user;
    }

    public User enable(UUID id) {
        User user = findById(id);
        user.setEnabled(true);
        save(user);
        return user;
    }

    public List<Book> findOwnBooks(UUID id) {
        Optional<User> user = userRepository.findUserById(id);
        if (user.isEmpty()) {
            throw new SingleEntityNotFoundException(id, User.class);
        }
        List<Book> books = user.get().getUploadedBooks();
        if (books.isEmpty())
            throw new ListEntityNotFoundException(Book.class);
        return books;
    }

    public List<Book> findBookmarks(UUID id) {
        Optional<User> user = userRepository.findUserById(id);
        if (user.isEmpty()) {
            throw new SingleEntityNotFoundException(id, User.class);
        }
        List<Book> books = user.get().getBookmarks();
        if (books.isEmpty())
            throw new ListEntityNotFoundException(Book.class);
        return books;
    }

    public User editAvatar(MultipartFile file, User loggedUser) {
        if (!(file.getContentType().contains("image")))
            throw new ContentTypeNotValidException(file.getContentType());
        Optional<User> optionalUser = userRepository.findUserById(loggedUser.getId());
        User user = optionalUser.orElseThrow(() -> new SingleEntityNotFoundException(loggedUser.getId(), User.class));
        String filename = storageService.store(file);
        user.setAvatar(filename);
        userRepository.save(user);
        return user;
    }
}
