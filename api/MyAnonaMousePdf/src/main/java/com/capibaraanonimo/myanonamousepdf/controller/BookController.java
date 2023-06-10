package com.capibaraanonimo.myanonamousepdf.controller;

import com.capibaraanonimo.myanonamousepdf.dto.book.BookResponse;
import com.capibaraanonimo.myanonamousepdf.dto.book.CreateBook;
import com.capibaraanonimo.myanonamousepdf.dto.book.UpdateBook;
import com.capibaraanonimo.myanonamousepdf.dto.comment.CommentResponse;
import com.capibaraanonimo.myanonamousepdf.dto.comment.CreateComment;
import com.capibaraanonimo.myanonamousepdf.errors.exceptions.*;
import com.capibaraanonimo.myanonamousepdf.model.User;
import com.capibaraanonimo.myanonamousepdf.search.util.SearchCriteria;
import com.capibaraanonimo.myanonamousepdf.search.util.SearchCriteriaExtractor;
import com.capibaraanonimo.myanonamousepdf.service.BookService;
import com.capibaraanonimo.myanonamousepdf.service.StorageService;
import com.capibaraanonimo.myanonamousepdf.utils.MediaTypeUrlResource;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.validation.ConstraintViolationException;
import javax.validation.Valid;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@RestController()
@RequestMapping("/book")
@RequiredArgsConstructor()
public class BookController {
    private final BookService bookService;
    private final StorageService storageService;

    @Operation(summary = "Obtiene todos los platos o en caso de hacer una búsqueda devuelve los libros acordes")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se han encontrado libros",
                    content = {
                            @Content(mediaType = "application/json", schema = @Schema(implementation = Page.class))
                    }),
            @ApiResponse(responseCode = "404",
                    description = "No hay libros que coincidan con la request",
                    content = @Content(schema = @Schema(implementation = ListEntityNotFoundException.class)))
    })
    @GetMapping() //TODO personalizar la Page que no se que meterle
    public Page<BookResponse> getAllBooks(@RequestParam(value = "search", defaultValue = "") String search,
                                          @PageableDefault(size = 10, page = 0, sort = {"uploadDate"}, direction = Sort.Direction.DESC) Pageable pageable) {
        List<SearchCriteria> params = SearchCriteriaExtractor.extractSearchCriteriaList(search);
        return bookService.search(params, pageable).map(BookResponse::of);
    }

    @Operation(summary = "Obtiene un el libro que coincida con el id especificado")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha encontrado el libro con el id especificado",
                    content = {
                            @Content(mediaType = "application/json", schema = @Schema(implementation = BookResponse.class))
                    }),
            @ApiResponse(responseCode = "404",
                    description = "No hay libros con el id indicado",
                    content = @Content(schema = @Schema(implementation = SingleEntityNotFoundException.class)))
    })
    @Parameter(description = "Id del libro a buscar", name = "id", required = true)
    @GetMapping("/{id}")
    public BookResponse getBookById(@PathVariable String id) {
        return BookResponse.of(bookService.findById(UUID.fromString(id)));
    }


    @Operation(summary = "Descarga el archivo indicado")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha encontrado el archivo indicado",
                    content = {
                            @Content(mediaType = "application/pdf", schema = @Schema(implementation = Resource.class)),
                            @Content(mediaType = "application/epub+zip", schema = @Schema(implementation = Resource.class)),
                            @Content(mediaType = "image/jpeg", schema = @Schema(implementation = Resource.class)),
                            @Content(mediaType = "image/png", schema = @Schema(implementation = Resource.class))
                    }),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado el archivo indicado",
                    content = @Content(schema = @Schema(implementation = StorageException.class)))
    })
    @Parameter(description = "Nombre con extensión del archivo", name = "filename", required = true)
    @GetMapping("/download/{filename:.+}")
    public ResponseEntity<Resource> getFile(@PathVariable String filename) {
        MediaTypeUrlResource resource = (MediaTypeUrlResource) storageService.loadAsResource(filename);
        if (resource.getType().equals("application/pdf") || resource.getType().equals("application/epub+zip"))
            bookService.addDownload(filename);

        return ResponseEntity.status(HttpStatus.OK)
                .header("Content-Type", resource.getType())
                .body(resource);
    }

    @Operation(summary = "Sube los datos de un nuevo libro",
            description = "Sube los datos de un nuevo libro para acto seguido si la respuesta es positiva enviar el archivo en la dirección \"/upload/file/{id}\"")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha creado el nuevo libro en la base de datos, puedes proceder a la subida del archivo",
                    content = {
                            @Content(mediaType = "application/json", schema = @Schema(implementation = UUID.class))
                    }),
            @ApiResponse(responseCode = "400",
                    description = "Los datos enviados no son validos",
                    content = @Content(schema = @Schema(implementation = ConstraintViolationException.class)))
    })
    @PostMapping(path = "/upload/json")
    @ResponseStatus(HttpStatus.CREATED)
    public UUID postBookJSon(@RequestBody @Valid CreateBook book, @AuthenticationPrincipal User loggedUser) {
        return bookService.save(book, loggedUser);
    }

    @Operation(summary = "Sube el archivo de un libro",
            description = "Sube el archivo de un libro después de haber creado el libro en la base de datos con la request \"/upload/json\"")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha subido el archivo correctamente",
                    content = {
                            @Content(mediaType = "application/json", schema = @Schema(implementation = BookResponse.class))
                    }),
            @ApiResponse(responseCode = "415",
                    description = "El archivo subido no tiene el conte type adecuado",
                    content = @Content(schema = @Schema(implementation = ContentTypeNotValidException.class))),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado el id indicado",
                    content = @Content(schema = @Schema(implementation = ContentTypeNotValidException.class)))
    })
    @Parameter(description = "Id del libro al que le quieres subir el archivo", name = "id", required = true)
    @PostMapping(path = "/upload/file/{id}")
    @ResponseStatus(HttpStatus.OK)
    public BookResponse postBookFile(@PathVariable String id, @RequestPart("file") MultipartFile file) throws IOException {

        return BookResponse.of(bookService.saveFile(file, UUID.fromString(id)));
    }

    @Operation(summary = "Edita el libro con el id especificado")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha editado el libro correctamente",
                    content = {
                            @Content(mediaType = "application/json", schema = @Schema(implementation = BookResponse.class))
                    }),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado un libro con el id indicado",
                    content = @Content(schema = @Schema(implementation = SingleEntityNotFoundException.class)))
    })
    @Parameter(description = "Id del libro que quieres editar", name = "id", required = true)
    @PutMapping("/edit/{id}")
    public BookResponse putBook(@PathVariable String id, @RequestBody @Valid UpdateBook updateBook) {
        return BookResponse.of(bookService.edit(id, updateBook));
    }

    @Operation(summary = "Elimina el libro con el id indicado")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204",
                    description = "Se ha eliminado el libro correctamente"),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado un libro con el id indicado",
                    content = @Content(schema = @Schema(implementation = SingleEntityNotFoundException.class)))
    })
    @Parameter(description = "Id del libro que quieres eliminar", name = "id", required = true)
    @DeleteMapping("/{id}")
    public ResponseEntity deleteBook(@PathVariable String id, @AuthenticationPrincipal User loggedUser) {
        return bookService.deleteById(UUID.fromString(id), loggedUser) ?
                ResponseEntity.noContent().build() : ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
    }

    @Operation(summary = "Mira si el libro está en bookmarks",
            description = "Comprueba si el libro con el id indicado está en bookmarks del usuario actual, devuelve true si lo está y false en caso contrario")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "El libro se ha encontrado y se ha comprobado si está en bookmarks",
                    content = {
                            @Content(mediaType = "application/json", schema = @Schema(implementation = boolean.class))
                    }),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado un libro con el id indicado",
                    content = @Content(schema = @Schema(implementation = SingleEntityNotFoundException.class)))
    })
    @Parameter(description = "Id del libro que quieres comprobar", name = "id", required = true)
    @GetMapping("/bookmark/{id}")
    @ResponseStatus(HttpStatus.OK)
    public ResponseEntity<Boolean> isBookBookmarked(@PathVariable String id, @AuthenticationPrincipal User loggedUser) {
        return ResponseEntity.ok().body(bookService.isBookBookmarked(loggedUser, UUID.fromString(id)));
    }

    @Operation(summary = "Pone o quita el libro de bookmarks",
            description = "Pone o quita el libro de bookmarks dependiendo de si el libro estaba o no en bookmarks")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "El libro se ha añadido o quitado de bookmarks",
                    content = {
                            @Content(mediaType = "application/json", schema = @Schema(implementation = boolean.class))
                    }),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado un libro con el id indicado",
                    content = @Content(schema = @Schema(implementation = SingleEntityNotFoundException.class)))
    })
    @Parameter(description = "Id del libro que quieres cambiar", name = "id", required = true)
    @PutMapping("/bookmark/{id}")
    public ResponseEntity<Boolean> bookmarkBook(@PathVariable String id, @AuthenticationPrincipal User loggedUser) {
        boolean response = bookService.switchBookmark(loggedUser, UUID.fromString(id));
        return ResponseEntity.ok().body(response);
    }

    @Operation(summary = "Añade un comentario al libro con el id indicado")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha creado el comentario correctamente",
                    content = {
                            @Content(mediaType = "application/json",
                                    array = @ArraySchema(schema = @Schema(implementation = CommentResponse.class)))
                    }),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado un libro con el id indicado",
                    content = @Content(schema = @Schema(implementation = SingleEntityNotFoundException.class))),
            @ApiResponse(responseCode = "400",
                    description = "Los datos enviados no son validos",
                    content = @Content(schema = @Schema(implementation = ConstraintViolationException.class)))
    })
    @Parameter(description = "Id del libro que quieres comentar", name = "bookId", required = true)
    @PostMapping(path = "/{bookId}/comment")
    @ResponseStatus(HttpStatus.CREATED)
    public List<CommentResponse> postComment(@PathVariable String bookId, @RequestBody @Valid CreateComment comment, @AuthenticationPrincipal User loggedUser) {
        return bookService.addComment(UUID.fromString(bookId), comment, loggedUser);
    }

    @Operation(summary = "Devuelve todos los comentarios del libro con el id indicado")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201",
                    description = "Se ha encontrado el libro y tiene comentarios",
                    content = {
                            @Content(mediaType = "application/json",
                                    array = @ArraySchema(schema = @Schema(implementation = CommentResponse.class)))
                    }),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado un libro con el id indicado",
                    content = @Content(schema = @Schema(implementation = SingleEntityNotFoundException.class)))
    })
    @Parameter(description = "Id del libro que quieres sus comentarios", name = "bookId", required = true)
    @GetMapping(path = "/{bookId}/comment")
    @ResponseStatus(HttpStatus.CREATED)
    public List<CommentResponse> getAllComments(@PathVariable String bookId, @AuthenticationPrincipal User loggedUser) {
        return bookService.getAllComments(UUID.fromString(bookId));
    }
}