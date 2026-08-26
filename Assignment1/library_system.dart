class Book {
  String title = "";
  String author = "";
  bool isAvailable = true;

  Book(this.title, this.author);

  void displayBook() {
    print("$title by $author");
    print("Available: $isAvailable");
  }
}

class Library {
  String name;
  List<Book> books = [];

  Library(this.name);

  void addBook(Book book) {
    books.add(book);
  }

  void showBooks() {
    print("\n--- $name ---");
    for (var book in books) {
      book.displayBook();
    }
  }

  void borrowBook(String title) {
    for (var book in books) {
      if (book.title == title && book.isAvailable) {
        book.isAvailable = false;
        print("\nYou borrowed $title");
        return;
      }
    }
    print("\n$title is not available");
  }
}

void main() {
  Library library = Library("Central Library");

  Book book1 = Book("The Three-Body Problem", "Cixin Liu");
  Book book2 = Book("Blindsight", "Peter Watts");

  library.addBook(book1);
  library.addBook(book2);

  library.showBooks();

  library.borrowBook("Blindsight");

  library.showBooks();
}
