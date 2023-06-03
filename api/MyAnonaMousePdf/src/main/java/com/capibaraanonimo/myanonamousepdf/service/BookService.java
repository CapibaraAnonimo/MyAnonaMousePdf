package com.capibaraanonimo.myanonamousepdf.service;

import com.aspose.pdf.Document;
import com.aspose.pdf.devices.JpegDevice;
import com.aspose.pdf.devices.Resolution;
import com.capibaraanonimo.myanonamousepdf.dto.book.CreateBook;
import com.capibaraanonimo.myanonamousepdf.dto.book.UpdateBook;
import com.capibaraanonimo.myanonamousepdf.dto.comment.CommentResponse;
import com.capibaraanonimo.myanonamousepdf.dto.comment.CreateComment;
import com.capibaraanonimo.myanonamousepdf.errors.exceptions.BookNameNotFoundException;
import com.capibaraanonimo.myanonamousepdf.errors.exceptions.ContentTypeNotValidException;
import com.capibaraanonimo.myanonamousepdf.errors.exceptions.ListEntityNotFoundException;
import com.capibaraanonimo.myanonamousepdf.errors.exceptions.SingleEntityNotFoundException;
import com.capibaraanonimo.myanonamousepdf.model.Book;
import com.capibaraanonimo.myanonamousepdf.model.Comment;
import com.capibaraanonimo.myanonamousepdf.model.User;
import com.capibaraanonimo.myanonamousepdf.repository.BookRepository;
import com.capibaraanonimo.myanonamousepdf.repository.CommentRepository;
import com.capibaraanonimo.myanonamousepdf.repository.UserRepository;
import com.capibaraanonimo.myanonamousepdf.search.spec.BookSpecificationBuilder;
import com.capibaraanonimo.myanonamousepdf.search.util.SearchCriteria;
import lombok.RequiredArgsConstructor;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.support.StandardMultipartHttpServletRequest;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class BookService {
    private final BookRepository bookRepository;
    private final UserRepository userRepository;
    private final CommentRepository commentRepository;
    private final UserService userService;
    private final CategoryService categoryService;
    private final StorageService storageService;

    public List<Book> findAll() {
        List<Book> books = bookRepository.findAll();
        if (books.isEmpty()) {
            throw new ListEntityNotFoundException(Book.class);
        }
        return books;
    }

    public UUID save(CreateBook book, User user) {
        return bookRepository.save(
                Book.builder()
                        .uploader(user)
                        .category(categoryService.findById(UUID.fromString(book.getCategory())))
                        .book("")
                        .title(book.getTitle())
                        .author(book.getAuthor())
                        .description(book.getDescription())
                        .build()).getId();
    }

    public Book saveFile(MultipartFile file, UUID id) throws IOException { //FIXME no tengo claro ese posible null pointer
        if (!(file.getContentType().equals("application/pdf") || file.getContentType().equals("application/epub+zip")))
            throw new ContentTypeNotValidException(file.getContentType());

        String filename = storageService.store(file);

        // For complete examples and data files, please go to https://github.com/aspose-pdf/Aspose.Pdf-for-Java
        // Open document
        Document pdfDocument = new Document("./uploads/" + filename);

        // Loop through all the pages of PDF file
        // Create stream object to save the output image
        java.io.OutputStream imageStream = new java.io.FileOutputStream("./uploads/" + filename.substring(0, filename.length() - 3) + "jpg");
        System.out.println("./uploads/" + filename.substring(0, filename.length() - 3) + "jpg");


        // Create Resolution object
        Resolution resolution = new Resolution(300);
        // Create JpegDevice object where second argument indicates the quality of resultant image
        JpegDevice jpegDevice = new JpegDevice(resolution, 100);
        // Convert a particular page and save the image to stream
        jpegDevice.process(pdfDocument.getPages().get_Item(1), imageStream);

        // Close the stream
        imageStream.close();

        Optional<Book> optionalBook = bookRepository.findById(id);
        Book book;

        if (optionalBook.isPresent()) {
            book = optionalBook.get();
            book.setImage(filename.substring(0, filename.length() - 3) + "jpg");
            save(book);
        }
        else
            throw new SingleEntityNotFoundException(id, Book.class);
        book.setBook(filename);
        return book;
    }

    public String saveThumbnail(String file) throws IOException { //TODO ver si se puede hacer esto para el TFG
        /*PDDocument document = PDDocument.load(new File(file));
        PDFRenderer pdfRenderer = new PDFRenderer(document);

        BufferedImage bim = pdfRenderer.renderImageWithDPI(0, 300, ImageType.RGB);
        // suffix in filename will be used as the file format
        storageService.store(ImageIOUtil.writeImage(bim, file + "-" + "thumbnail" + ".jpeg", 300));
        document.close();*/
        return "";
    }

    public void save(Book book) {
        bookRepository.save(book);
    }

    public Book findById(UUID id) {
        Optional<Book> bookOptional = bookRepository.findById(id);
        if (bookOptional.isEmpty())
            throw new SingleEntityNotFoundException(id, Book.class);
        return bookOptional.get();
    }

    public Page<Book> search(List<SearchCriteria> params, Pageable pageable) { //TODO poner el search para que busque sin importar las mayúsculas
        BookSpecificationBuilder personSpecificationBuilder = new BookSpecificationBuilder(params);
        Specification<Book> spec = personSpecificationBuilder.build();
        Page<Book> books = bookRepository.findAll(spec, pageable);

        if (books.isEmpty())
            throw new ListEntityNotFoundException(Book.class);
        return books;
    }

    public void addDownload(String name) {
        Optional<Book> optionalBook = bookRepository.findBookByBook(name);
        if (optionalBook.isPresent()) {
            Book book = optionalBook.get();
            book.incrementDownloads();
            this.save(book);
        } else
            throw new BookNameNotFoundException(name);
    }

    public void deleteById(UUID id) { //FIXME devuelve un 401 si no existe la entidad que buscas
        bookRepository.deleteById(id);
    }

    public Book edit(String id, UpdateBook updateBook) {
        Optional<Book> bookOpt = bookRepository.findById(UUID.fromString(id));
        if (bookOpt.isEmpty())
            throw new SingleEntityNotFoundException(UUID.fromString(id), Book.class);
        Book book = bookOpt.get();
        book.setCategory(categoryService.findById(UUID.fromString(updateBook.getCategory())));
        book.setVip(updateBook.isVip());
        book.setTitle(updateBook.getTitle());
        book.setAuthor(updateBook.getAuthor());
        book.setDescription(updateBook.getDescription());
        return bookRepository.save(book);
    }

    public boolean switchBookmark(User loggedUser, UUID id) {
        Book book = findById(id);
        Optional<User> user = userRepository.findUserById(loggedUser.getId());
        if (user.isEmpty())
            throw new SingleEntityNotFoundException(loggedUser.getId(), User.class);
        List<Book> bookmarks = user.get().getBookmarks();
        if (bookmarks.contains(book)) {
            bookmarks.remove(book);
            userService.save(loggedUser);
            return false;
        } else {
            bookmarks.add(book);
            userService.save(loggedUser);
            return true;
        }
    }

    public boolean isBookBookmarked(User loggedUser, UUID id) {
        Book book = findById(id);
        Optional<User> user = userRepository.findUserById(loggedUser.getId());
        if (user.isEmpty())
            throw new SingleEntityNotFoundException(loggedUser.getId(), User.class);
        List<Book> bookmarks = user.get().getBookmarks();
        return bookmarks.contains(book);
    }

    public List<CommentResponse> addComment(UUID bookId, CreateComment comment, User loggedUser) {
        Book book = findById(bookId);
        List<Comment> comments = book.getComments();
        Comment newComment = Comment.builder().text(comment.getText()).user(loggedUser).build();
        commentRepository.save(newComment);
        comments.add(newComment);
        book.setComments(comments);
        bookRepository.save(book);
        return comments.stream().map(CommentResponse::of).toList();
        //return CommentResponse.of(newComment);
    }

    public List<CommentResponse> getAllComments(UUID bookId) {
        Book book = findById(bookId);

        return book.getComments().stream().map(CommentResponse::of).toList();
    }
}
