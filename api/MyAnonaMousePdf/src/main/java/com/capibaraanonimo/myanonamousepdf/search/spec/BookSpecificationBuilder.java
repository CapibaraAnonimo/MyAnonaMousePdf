package com.capibaraanonimo.myanonamousepdf.search.spec;

import com.capibaraanonimo.myanonamousepdf.model.Book;
import com.capibaraanonimo.myanonamousepdf.search.util.SearchCriteria;

import java.util.List;

public class BookSpecificationBuilder extends GenericSpecificationBuilder<Book> {
    public BookSpecificationBuilder(List<SearchCriteria> params) {
        super(params, Book.class);
    }


    /*private List<SearchCriteria> params;

    public PersonSpecificationBuilder(List<SearchCriteria> params) {
        this.params = params;
    }

    public Specification<Person> build() {

        List<SearchCriteria> checkedParams = params.stream().filter(p -> QueryableEntity.checkQueryParam(Person.class, p.getKey())).collect(Collectors.toList());
        //List<SearchCriteria> checkedParams = params.stream().filter(p -> Person.checkQueryParam(p.getKey())).collect(Collectors.toList());

        if (checkedParams.isEmpty()) {
            return null;
        }

        Specification<Person> result = new PersonSpecification(checkedParams.get(0));

        for(int i = 1; i < checkedParams.size(); i++) {
            result = result.and(new PersonSpecification(checkedParams.get(i)));
        }

        return result;


    }*/


}
