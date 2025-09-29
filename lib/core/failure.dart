import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class AuthFailure extends Failure {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

class NetworkFailure extends Failure {}

class ValidationFailure extends Failure {
  final String message;

  const ValidationFailure(this.message);

  @override
  List<Object> get props => [message];
}