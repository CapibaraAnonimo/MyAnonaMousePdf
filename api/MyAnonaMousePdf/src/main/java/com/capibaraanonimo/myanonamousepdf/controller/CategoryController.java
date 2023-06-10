package com.capibaraanonimo.myanonamousepdf.controller;

import com.capibaraanonimo.myanonamousepdf.dto.category.CategoryResponse;
import com.capibaraanonimo.myanonamousepdf.dto.comment.CommentResponse;
import com.capibaraanonimo.myanonamousepdf.errors.exceptions.SingleEntityNotFoundException;
import com.capibaraanonimo.myanonamousepdf.service.CategoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
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

    @Operation(summary = "Devuelve todas las categorías")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se devuelven todas las  categorías",
                    content = {
                            @Content(mediaType = "application/json",
                                    array = @ArraySchema(schema = @Schema(implementation = CategoryResponse.class)))
                    })
    })
    @GetMapping()
    public List<CategoryResponse> getAll() {
        return categoryService.findAllWithBooks();
    }


    @Operation(summary = "Devuelve la categoría con el id indicado")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200",
                    description = "Se ha encontrado la categoría con el id indicado",
                    content = {
                            @Content(mediaType = "application/json",
                                    array = @ArraySchema(schema = @Schema(implementation = CommentResponse.class)))
                    }),
            @ApiResponse(responseCode = "404",
                    description = "No se ha encontrado una categoría con el id indicado",
                    content = @Content(schema = @Schema(implementation = SingleEntityNotFoundException.class)))
    })
    @Parameter(description = "Id de la categoría que quieres sus comentarios", name = "id", required = true)
    @GetMapping("/{id}") //TODO comprobar que va con postgresql
    public CategoryResponse getById(@PathVariable String id) {
        return CategoryResponse.of(categoryService.findById(UUID.fromString(id)));
    }
}
