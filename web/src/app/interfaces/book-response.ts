import {UserResponse} from "./user-response";
import {CommentResponse} from "./comment-response";

export interface BookPage {
  content: BookResponse[]
  pageable: Pageable
  last: boolean
  totalPages: number
  totalElements: number
  size: number
  number: number
  sort: Sort
  first: boolean
  numberOfElements: number
  empty: boolean
}

export interface Pageable {
  sort: Sort
  offset: number
  pageNumber: number
  pageSize: number
  unpaged: boolean
  paged: boolean
}

export interface Sort {
  empty: boolean
  sorted: boolean
  unsorted: boolean
}

export interface BookResponse {
  id: String,
  user: UserResponse,
  amountDownloads: number,
  category: String,
  comment: CommentResponse[],
  vip: boolean,
  book: String,
  image: String,
  title: String,
  author: String,
  description: String,
}
