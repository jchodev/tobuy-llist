import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/models.dart';


abstract class CategoryRepository {
  Future<List<FirestoreCategory>> fetchCategories() ;
  Future<void> addCategory(FirestoreCategory category);
  Future<void> updateCategory(FirestoreCategory category);
  Future<void> deleteCategory(String categoryId);

  Future<FirestoreCategory?> getCategoryById(String id);
  Future<FirestoreCategory> addTask(FirestoreTask task, FirestoreCategory category);
  Future<FirestoreCategory> updateTask(FirestoreTask task, FirestoreCategory category);
  Future<FirestoreCategory> updateTasks(List<FirestoreTask> tasks, FirestoreCategory category);
}


class CategoryRepositoryImpl implements CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<FirestoreCategory>> fetchCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    final categories = snapshot.docs.map((doc) => FirestoreCategory.fromJson(doc.data())).toList();
    categories.forEach((category) => category.tasks.sort((a, b) => a.sortedIndex.compareTo(b.sortedIndex))); // Sort tasks within each category
    return categories;
  }

  @override
  Future<void> addCategory(FirestoreCategory category) async {
    await _firestore.collection('categories')
        .doc(category.id)
        .set(category.toJson());
  }

  Future<void> updateCategory(FirestoreCategory category) async {
    await _firestore
        .collection('categories')
        .doc(category.id)
        .update(category.toJson());
  }

  Future<void> deleteCategory(String categoryId) async {
    await _firestore.collection('categories').doc(categoryId).delete();
  }

  @override
  Future<FirestoreCategory?> getCategoryById(String categoryId) async{
    final docSnapshot = await _firestore.collection('categories').doc(categoryId).get();
    if (docSnapshot.exists) {
      FirestoreCategory category = FirestoreCategory.fromJson(docSnapshot.data()!);
      category.tasks.sort((a, b) => a.sortedIndex.compareTo(b.sortedIndex)); // Sort tasks by sortedIndex
      return category;
    } else {
      return null; // Category not found
    }
  }

  Future<FirestoreCategory> addTask(FirestoreTask task, FirestoreCategory category) async {
    final docRef = _firestore.collection('categories').doc(category.id);
    await _firestore.runTransaction((transaction) async {
      category.tasks.add(task);
      transaction.update(docRef, category.toJson());
    });
    return category;
  }

  @override
  Future<FirestoreCategory> updateTask(FirestoreTask task, FirestoreCategory category) async {
    final docRef = _firestore.collection('categories').doc(category.id);
    await _firestore.runTransaction((transaction) async {
      final index = category.tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        category.tasks[index] = task;
        transaction.update(docRef, category.toJson());
      }
    });
    return category;
  }

  @override
  Future<FirestoreCategory> updateTasks(List<FirestoreTask> tasks, FirestoreCategory category) async{
    final docRef = _firestore.collection('categories').doc(category.id);
    await _firestore.runTransaction((transaction) async {
      category.tasks = tasks;
      transaction.update(docRef, category.toJson());
    });
    return category;
  }
}