class Book {
  String title = "";
  String author = "";
  String genre = "";

  Book(this.title, this.author, this.genre);

  void displayBook() {
    print("Book Title: $title");
    print("Book Author: $author");
    print("Book Genre: $genre");
  }
}

void task2() {
  Book book0 = Book("The Three-Body Problem", "Cixin Liu", "Sci-Fi");
  Book book1 = Book("Blindsight", "Peter Watts", "Sci-Fi");

  book0.displayBook();
  print("------------------");
  book1.displayBook();
}

void main(){
  task2();
}
