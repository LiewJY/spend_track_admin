
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/category.dart';

class CardRepository {
    //firestore instance
    //todo change
  final ref = FirebaseFirestore.instance.collection('categories').withConverter(
      fromFirestore: SpendingCategory.fromFirestore,
      toFirestore: (SpendingCategory cat, _) => cat.toFirestore());
  
}