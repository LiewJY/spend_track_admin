import 'package:equatable/equatable.dart';

class SpendingCategory extends Equatable {
  const SpendingCategory({
    required this.uid,
    required this.name,
    required this.description,
  });

  final String uid;
  final String? name;
  final String? description;

  @override
  List<Object?> get props => [uid, name, description];
}
