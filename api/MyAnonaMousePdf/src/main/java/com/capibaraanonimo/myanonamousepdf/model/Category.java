package com.capibaraanonimo.myanonamousepdf.model;

import lombok.*;
import org.hibernate.annotations.GenericGenerator;
import org.hibernate.annotations.NaturalId;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@EntityListeners(AuditingEntityListener.class)
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@Builder
@NamedEntityGraphs(
        @NamedEntityGraph(name = "category-with-books",
                attributeNodes = {@NamedAttributeNode(value = "categorizedBooks",
                        subgraph = "books-with-user")},
                subgraphs = {@NamedSubgraph(name = "books-with-user",
                        attributeNodes = {@NamedAttributeNode("uploader")
                        })
                })
)
public class Category {
    @Id
    @GeneratedValue(generator = "UUID")
    @GenericGenerator(
            name = "UUID",
            strategy = "org.hibernate.id.UUIDGenerator",
            parameters = {
                    @org.hibernate.annotations.Parameter(
                            name = "uuid_gen_strategy_class",
                            value = "org.hibernate.id.uuid.CustomVersionOneStrategy"
                    )
            }
    )
    @Column(columnDefinition = "uuid", name = "category_id")
    private UUID id;

    @NaturalId()
    @Column(unique = true, updatable = false)
    private String name;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "category")
    @Builder.Default
    private List<Book> categorizedBooks = new ArrayList<>();
}
