import {BookResponse} from "./book-response";

export interface CategoryResponse {
  id: String;
  name: String;
  categorizedBooks: BookResponse[];
}
