import 'package:firebase_database/firebase_database.dart';
import 'package:reading_buddy/model/Book.dart';

class DatabaseSvc {
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  void deleteDB(Book book) {
    final bookKeyRef = FirebaseDatabase.instance
        .ref()
        .child('bookshelf/userId/${book.bookKey}');

    bookKeyRef.remove();
  }

  void updateDB(Book book) {
    final bookData = {
      'imgUrl': book.imgUrl,
    };

    final bookKeyRef = FirebaseDatabase.instance
        .ref()
        .child('bookshelf/userId/${book.bookKey}');

    bookKeyRef.update(bookData).then((_) {
      print('Data update successful');
    }).catchError((error) {
      print('Data update failed');
    });
  }

  Future<void> writeDB(Book book) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref('bookshelf/userId/${book.bookKey}');

    await ref.set({
      'name': book.name,
      'imgUrl': book.imgUrl,
      'bookKey': book.bookKey,
    }).then((_) {
      print('Data write successful');
    }).catchError((error) {
      print('Data write failed');
    });
  }

  void readDB(void Function(List<Book> newBooks) updateUIWithBooks) {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('bookshelf/userId');
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;

      if (data == null || data is! Map<dynamic, dynamic>) {
        print('no data');
        return;
      }

      final books = <Book>[];
      for (final key in data.keys) {
        final bookValue = data[key];
        final book = Book.fromMap(bookValue);
      }

      updateUIWithBooks(books);
    });
  }
}