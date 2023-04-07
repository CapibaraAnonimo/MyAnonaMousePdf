package com.capibaraanonimo.myanonamousepdf.model;

import lombok.*;
import org.hibernate.annotations.GenericGenerator;
import org.hibernate.annotations.Parameter;
import org.hibernate.validator.constraints.Length;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.UUID;


@Entity
@EntityListeners(AuditingEntityListener.class)
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@Builder
public class Book {
    @Id
    @GeneratedValue(generator = "UUID")
    @GenericGenerator(
            name = "UUID",
            strategy = "org.hibernate.id.UUIDGenerator",
            parameters = {
                    @Parameter(
                            name = "uuid_gen_strategy_class",
                            value = "org.hibernate.id.uuid.CustomVersionOneStrategy"
                    )
            }
    )
    @Column(columnDefinition = "uuid", name = "book_id")
    private UUID id;

    @CreatedDate
    private LocalDateTime uploadDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", foreignKey = @ForeignKey(name = "FK_BOOK_USER"))
    private User uploader;

    @Builder.Default()
    private long amountDownloads = 0;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", foreignKey = @ForeignKey(name = "FK_BOOK_CATEGORY"))
    private Category category;

    @Builder.Default()
    private boolean vip = false;

    private String book, title, author;

    @Length(max = 6000)
    private String description;

    public void incrementDownloads() {
        amountDownloads += 1;
    }

    @PreRemove //TODO comprobar que funciona sin el preremove y borrarlo
    private void preRemove() {
    }
}
