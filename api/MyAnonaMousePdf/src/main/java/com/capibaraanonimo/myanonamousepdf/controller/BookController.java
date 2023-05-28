package com.capibaraanonimo.myanonamousepdf.controller;

import com.capibaraanonimo.myanonamousepdf.dto.book.BookResponse;
import com.capibaraanonimo.myanonamousepdf.dto.book.CreateBook;
import com.capibaraanonimo.myanonamousepdf.dto.book.UpdateBook;
import com.capibaraanonimo.myanonamousepdf.model.User;
import com.capibaraanonimo.myanonamousepdf.search.util.SearchCriteria;
import com.capibaraanonimo.myanonamousepdf.search.util.SearchCriteriaExtractor;
import com.capibaraanonimo.myanonamousepdf.service.BookService;
import com.capibaraanonimo.myanonamousepdf.service.StorageService;
import com.capibaraanonimo.myanonamousepdf.utils.MediaTypeUrlResource;
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

import javax.validation.Valid;
import java.util.List;
import java.util.UUID;

@RestController()
@RequestMapping("/book")
@RequiredArgsConstructor()
public class BookController {
    private final BookService bookService;
    private final StorageService storageService;

    @GetMapping() //TODO personalizar la Page que no se que meterle
    public Page<BookResponse> getAllBooks(@RequestParam(value = "search", defaultValue = "") String search,
                                          @PageableDefault(size = 10, page = 0, sort = {"uploadDate"}, direction = Sort.Direction.DESC) Pageable pageable) {
        List<SearchCriteria> params = SearchCriteriaExtractor.extractSearchCriteriaList(search);
        return bookService.search(params, pageable).map(BookResponse::of);
    }

    @GetMapping("/{id}")
    public BookResponse getBookById(@PathVariable String id) {
        return BookResponse.of(bookService.findById(UUID.fromString(id)));
    }

    @GetMapping("/download/{filename:.+}")
    public ResponseEntity<Resource> getFile(@PathVariable String filename) {
        MediaTypeUrlResource resource = (MediaTypeUrlResource) storageService.loadAsResource(filename);
        if (resource.getType().equals("application/pdf") || resource.getType().equals("application/epub+zip"))
            bookService.addDownload(filename);

        return ResponseEntity.status(HttpStatus.OK)
                .header("Content-Type", resource.getType())
                .body(resource);
    }

    @PostMapping(path = "/upload/json")
    @ResponseStatus(HttpStatus.CREATED)
    public UUID postBookJSon(@RequestBody @Valid CreateBook book, @AuthenticationPrincipal User loggedUser) {
        return bookService.save(book, loggedUser);
    }

    @PostMapping(path = "/upload/file/{id}")
    @ResponseStatus(HttpStatus.OK)
    public BookResponse postBookFile(@PathVariable String id, @RequestPart("file") MultipartFile file) {

        return BookResponse.of(bookService.saveFile(file, UUID.fromString(id)));
    }

    @PutMapping("/edit/{id}")
    public BookResponse putBook(@PathVariable String id, @RequestBody @Valid UpdateBook updateBook) {
        return BookResponse.of(bookService.edit(id, updateBook));
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT) //FIXME hacer que se borre solo por el usuario que lo creo o un admin y que devuelva siempre un no content
    public void deleteBook(@PathVariable String id) {
        bookService.deleteById(UUID.fromString(id));
    }

    @GetMapping("/bookmark/{id}")
    @ResponseStatus(HttpStatus.OK)
    public ResponseEntity<Boolean> isBookBookmarked(@PathVariable String id, @AuthenticationPrincipal User loggedUser) {
        return ResponseEntity.ok().body(bookService.isBookBookmarked(loggedUser, UUID.fromString(id)));
    }

    @PutMapping("/bookmark/{id}")
    public ResponseEntity<Boolean> bookmarkBook(@PathVariable String id, @AuthenticationPrincipal User loggedUser) {
        boolean response = bookService.switchBookmark(loggedUser, UUID.fromString(id));
        return ResponseEntity.ok().body(response);
    }
}