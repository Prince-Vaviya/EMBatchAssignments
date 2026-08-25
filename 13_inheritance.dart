class Library {
  String lName = "";

  Library(this.lName);

  String libraryName() {
    return (lName);
  }
}

class Book extends Library {
  String title = "";
  String author = "";
  String genre = "";

  Book(String lName, this.title, this.author, this.genre) : super(lName);

  void displayBook() {
    print("Book Title: $title");
    print("Book Author: $author");
    print("Book Genre: $genre");
  }

  void readBook() {
    print("$title is a great book :)");
  }
}

void task4() {
  Library l1 = Library("My Library");
  Book book0 = Book(
    l1.libraryName(),
    "The Three-Body Problem",
    "Cixin Liu",
    "Sci-Fi",
  );
  Book book1 = Book(l1.libraryName(), "Blindsight", "Peter Watts", "Sci-Fi");

  book0.readBook();
  print("------------------");
  print("------------------");

  book0.displayBook();
  print("------------------");
  book1.displayBook();
}

void main() {
  task4();
}
