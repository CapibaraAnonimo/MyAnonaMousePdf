package com.capibaraanonimo.myanonamousepdf.controller;

import com.capibaraanonimo.myanonamousepdf.dto.book.BookResponse;
import com.capibaraanonimo.myanonamousepdf.dto.user.*;
import com.capibaraanonimo.myanonamousepdf.errors.exceptions.*;
import com.capibaraanonimo.myanonamousepdf.model.Roles;
import com.capibaraanonimo.myanonamousepdf.model.User;
import com.capibaraanonimo.myanonamousepdf.security.jwt.access.JwtProvider;
import com.capibaraanonimo.myanonamousepdf.security.jwt.refresh.RefreshToken;
import com.capibaraanonimo.myanonamousepdf.security.jwt.refresh.RefreshTokenException;
import com.capibaraanonimo.myanonamousepdf.security.jwt.refresh.RefreshTokenRequest;
import com.capibaraanonimo.myanonamousepdf.security.jwt.refresh.RefreshTokenService;
import com.capibaraanonimo.myanonamousepdf.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import javax.validation.ConstraintViolationException;
import javax.validation.Valid;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class UserController {
    private final UserService userService;
    private final AuthenticationManager authManager;
    private final JwtProvider jwtProvider;
    private final RefreshTokenService refreshTokenService;

    @Operation(summary = "Refresca los tokens")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se han creado nuevos tokens",
                    content = {
                            @Content(mediaType = "application/json", schema = @Schema(implementation = JwtUserResponse.class))
                    }),
            @ApiResponse(responseCode = "403",
                    description = "El token de refresco ha caducado",
                    content = @Content(schema = @Schema(implementation = RefreshTokenException.class))),
            @ApiResponse(responseCode = "403",
                    description = "No se ha encontrado el token de refresco",
                    content = @Content(schema = @Schema(implementation = RefreshTokenException.class)))
    })
    @PostMapping("/refreshtoken")
    public ResponseEntity<?> refreshToken(@RequestBody RefreshTokenRequest refreshTokenRequest) {
        String refreshToken = refreshTokenRequest.getRefreshToken();

        return refreshTokenService.findByToken(refreshToken)
                .map(refreshTokenService::verify)
                .map(RefreshToken::getUser)
                .map(user -> {
                    String token = jwtProvider.generateToken(user);
                    refreshTokenService.deleteByUser(user);
                    RefreshToken refreshToken2 = refreshTokenService.createRefreshToken(user);
                    return ResponseEntity.status(HttpStatus.CREATED)
                            .body(JwtUserResponse.builder()
                                    .token(token)
                                    .refreshToken(refreshToken2.getToken())
                                    .build());
                })
                .orElseThrow(() -> new RefreshTokenException("Refresh token not found"));

    }

    @Operation(summary = "Crea un usuario")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha creado el usuario",
                    content = {
                            @Content(mediaType = "application/json", schema = @Schema(implementation = UserResponse.class))
                    }),
            @ApiResponse(responseCode = "400",
                    description = "Errores de validación",
                    content = @Content(schema = @Schema(implementation = RefreshTokenException.class)))
    })
    @PostMapping("/auth/register")
    public ResponseEntity<UserResponse> createUserWithUserRole(@RequestBody @Valid CreateUserRequest createUserRequest) {
        return ResponseEntity.status(HttpStatus.CREATED).body(UserResponse.fromUser(userService.createUserWithUserRole(createUserRequest)));
    }

    // Más adelante podemos manejar la seguridad de acceso a esta petición

    @Operation(summary = "Crea un usuario admin",
            description = "Crea un usuario administrador, solo puede crearlo un administrador")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha creado el usuario como administrador",
                    content = {
                            @Content(mediaType = "application/json", schema = @Schema(implementation = UserResponse.class))
                    }),
            @ApiResponse(responseCode = "400",
                    description = "Los datos no son validos",
                    content = @Content(schema = @Schema(implementation = Exception.class))),
            @ApiResponse(responseCode = "403",
                    description = "No eres admin",
                    content = @Content(schema = @Schema(implementation = Exception.class)))
    })
    @PostMapping("/auth/register/admin")
    public ResponseEntity<UserResponse> createUserWithAdminRole(@RequestBody @Valid CreateUserRequest createUserRequest) {
        return ResponseEntity.status(HttpStatus.CREATED).body(UserResponse.fromUser(userService.createUserWithAdminRole(createUserRequest)));
    }

    @Operation(summary = "Inicia sesión")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Has iniciado sesión",
                    content = {
                            @Content(mediaType = "application/json", schema = @Schema(implementation = JwtUserResponse.class))
                    }),
            @ApiResponse(responseCode = "400",
                    description = "Los datos no son validos",
                    content = @Content(schema = @Schema(implementation = Exception.class))),
            @ApiResponse(responseCode = "401",
                    description = "Usuario inexistente",
                    content = @Content(schema = @Schema(implementation = Exception.class))),
            @ApiResponse(responseCode = "401",
                    description = "Credenciales erróneos",
                    content = @Content(schema = @Schema(implementation = Exception.class))),
            @ApiResponse(responseCode = "401",
                    description = "Usuario deshabilitado",
                    content = @Content(schema = @Schema(implementation = UserDisabledException.class)))
    })
    @PostMapping("/auth/login")
    public ResponseEntity<JwtUserResponse> login(@RequestBody @Valid LoginRequest loginRequest) {
        return loginMethod(loginRequest, null);
    }

    @Operation(summary = "Inicia sesión como administrador")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Has iniciado sesión como administrador",
                    content = {
                            @Content(mediaType = "application/json", schema = @Schema(implementation = JwtUserResponse.class))
                    }),
            @ApiResponse(responseCode = "400",
                    description = "Los datos no son validos",
                    content = @Content(schema = @Schema(implementation = Exception.class))),
            @ApiResponse(responseCode = "401",
                    description = "Usuario no es admin",
                    content = @Content(schema = @Schema(implementation = AdminRequiredException.class))),
            @ApiResponse(responseCode = "401",
                    description = "Usuario inexistente",
                    content = @Content(schema = @Schema(implementation = Exception.class))),
            @ApiResponse(responseCode = "401",
                    description = "Credenciales erróneos",
                    content = @Content(schema = @Schema(implementation = Exception.class)))
    })
    @PostMapping("/auth/login/admin")
    public ResponseEntity<JwtUserResponse> loginAdmin(@RequestBody @Valid LoginRequest loginRequest) {
        return loginMethod(loginRequest, Roles.ADMIN);
    }

    @Operation(summary = "Cambia la contraseña")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha cambiado la contraseña",
                    content = {
                            @Content(mediaType = "application/json", schema = @Schema(implementation = UserResponse.class))
                    }),
            @ApiResponse(responseCode = "400",
                    description = "Las contraseñas no coinciden",
                    content = @Content(schema = @Schema(implementation = ConstraintViolationException.class))),
            @ApiResponse(responseCode = "400",
                    description = "La contraseña actual no coincide",
                    content = @Content(schema = @Schema(implementation = Exception.class)))
    })
    @PutMapping("/user/changePassword")
    public ResponseEntity<UserResponse> changePassword(@RequestBody @Valid ChangePasswordRequest changePasswordRequest,
                                                       @AuthenticationPrincipal User loggedUser) {
        // Este código es mejorable.
        // La validación de la contraseña nueva se puede hacer con un validador.
        // La gestión de errores se puede hacer con excepciones propias
        try {
            if (userService.passwordMatch(loggedUser, changePasswordRequest.getOldPassword())) {
                Optional<User> modified = userService.editPassword(loggedUser.getId(), changePasswordRequest.getNewPassword());
                if (modified.isPresent())
                    return ResponseEntity.ok(UserResponse.fromUser(modified.get()));
            } else {
                // Lo ideal es que esto se gestionara de forma centralizada
                // Se puede ver cómo hacerlo en la formación sobre Validación con Spring Boot
                // y la formación sobre Gestión de Errores con Spring Boot
                throw new RuntimeException();
            }
        } catch (RuntimeException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Password Data Error");
        }

        return null;
    }

    @Operation(summary = "Devuelve el usuario actual")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se devuelve el usuario actual",
                    content = {
                            @Content(mediaType = "application/json", schema = @Schema(implementation = UserResponse.class))
                    })
    })
    @GetMapping("/me")
    public UserResponse getMe(@AuthenticationPrincipal User loggedUser) {
        return UserResponse.fromUser(loggedUser);
    }

    @Operation(summary = "Deshabilita el usuario con el id indicado")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha deshabilitado el usuario con el id indicado",
                    content = {
                            @Content(mediaType = "application/json", schema = @Schema(implementation = UserResponse.class))
                    }),
            @ApiResponse(responseCode = "404",
                    description = "Usuario no encontrado",
                    content = @Content(schema = @Schema(implementation = SingleEntityNotFoundException.class)))
    })
    @PutMapping("/admin/disable/{id}")
    public UserResponse disableAccount(@PathVariable String id) {
        return UserResponse.fromUser(userService.disable(UUID.fromString(id)));
    }

    @Operation(summary = "Habilita el usuario con el id indicado")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha habilitado el usuario con el id indicado",
                    content = {
                            @Content(mediaType = "application/json", schema = @Schema(implementation = UserResponse.class))
                    }),
            @ApiResponse(responseCode = "404",
                    description = "Usuario no encontrado",
                    content = @Content(schema = @Schema(implementation = SingleEntityNotFoundException.class)))
    })
    @PutMapping("/admin/enable/{id}")
    public UserResponse enableAccount(@PathVariable String id) {
        return UserResponse.fromUser(userService.enable(UUID.fromString(id)));
    }

    @Operation(summary = "Devuelve todos los usuarios")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se han devuelve todos los usuarios",
                    content = {
                            @Content(mediaType = "application/json",
                                    array = @ArraySchema(schema = @Schema(implementation = UserResponse.class)))
                    })
    })
    @GetMapping("user")
    @ResponseStatus(HttpStatus.OK)
    public List<UserResponse> getAllUsers() {
        return userService.findAll().stream().map(UserResponse::fromUser).toList();
    }

    @Operation(summary = "Devuelve todos los libros del usuarios actual")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se han devuelto todos los libros",
                    content = {
                            @Content(mediaType = "application/json",
                                    array = @ArraySchema(schema = @Schema(implementation = BookResponse.class)))
                    }),
            @ApiResponse(responseCode = "404",
                    description = "El usuario no tiene libros",
                    content = @Content(schema = @Schema(implementation = ListEntityNotFoundException.class)))
    })
    @GetMapping("/me/books")
    public List<BookResponse> getOwnBooks(@AuthenticationPrincipal User loggedUser) {
        return userService.findOwnBooks(loggedUser.getId()).stream().map(BookResponse::of).toList();
    }

    @Operation(summary = "Devuelve todos los libros guardados del usuarios actual")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se han devuelto todos los libros guardados",
                    content = {
                            @Content(mediaType = "application/json",
                                    array = @ArraySchema(schema = @Schema(implementation = BookResponse.class)))
                    }),
            @ApiResponse(responseCode = "404",
                    description = "El usuario no tiene libros guardados",
                    content = @Content(schema = @Schema(implementation = ListEntityNotFoundException.class)))
    })
    @GetMapping("/bookmarks")
    public List<BookResponse> getBookmarks(@AuthenticationPrincipal User loggedUser) {
        return userService.findBookmarks(loggedUser.getId()).stream().map(BookResponse::of).toList();
    }

    @Operation(summary = "Actualiza la foto de perfil del usuario")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha cambiado la foto de perfil",
                    content = {
                            @Content(mediaType = "application/json",
                                    array = @ArraySchema(schema = @Schema(implementation = UserResponse.class)))
                    }),
            @ApiResponse(responseCode = "404",
                    description = "El tipo de archivo no está soportado",
                    content = @Content(schema = @Schema(implementation = ContentTypeNotValidException.class))),
            @ApiResponse(responseCode = "415",
                    description = "El tipo de archivo no está soportado",
                    content = @Content(schema = @Schema(implementation = ContentTypeNotValidException.class)))
    })
    @PutMapping("me/avatar")
    @ResponseStatus(HttpStatus.OK)
    public UserResponse editAvatar(@RequestPart("file") MultipartFile file, @AuthenticationPrincipal User loggedUser) {
        return UserResponse.fromUser(userService.editAvatar(file, loggedUser));
    }

    /**
     * Hace login
     *
     * @param loginRequest Objeto con el nombre y contraseña del usuario
     * @param role         Rol que debe tener el usuario para poder logearse
     * @return ResponseEntity del DTO para usuarios con tokens
     */
    public ResponseEntity<JwtUserResponse> loginMethod(LoginRequest loginRequest, Roles role) {
        // Realizamos la autenticación

        Authentication authentication =
                authManager.authenticate(
                        new UsernamePasswordAuthenticationToken(
                                loginRequest.getUsername(),
                                loginRequest.getPassword()
                        )
                );

        // Una vez realizada, la guardamos en el contexto de seguridad
        SecurityContextHolder.getContext().setAuthentication(authentication);

        // Devolvemos una respuesta adecuada
        String token = jwtProvider.generateToken(authentication);

        User user = (User) authentication.getPrincipal();

        if (role == null || user.getRoles().contains(role)) {
            // Eliminamos el token (si existe) antes de crearlo, ya que cada usuario debería tener solamente un token de refresco simultáneo
            refreshTokenService.deleteByUser(user);
            RefreshToken refreshToken = refreshTokenService.createRefreshToken(user);

            return ResponseEntity.status(HttpStatus.OK)
                    .body(JwtUserResponse.of(user, token, refreshToken.getToken()));
        } else
            throw new AdminRequiredException(user.getUsername());
    }
}
