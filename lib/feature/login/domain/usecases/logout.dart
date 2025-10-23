import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import 'package:ua/core/failure.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}
