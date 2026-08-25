class Book {
  String title = "";
  String author = "";
  String genre = "";

  void displayBook() {
    print("Book Title: $title");
    print("Book Author: $author");
    print("Book Genre: $genre");
  }
}

void task1() {
  Book book = Book();

  book.title = "The Three-Body Problem";
  book.author = "Cixin Liu";
  book.genre = "Sci-Fi";
}

void main() {
  task1();
}
