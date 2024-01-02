abstract class RepositoryResult<T> {}

// Success case with data
class Success<T> extends RepositoryResult<T> {
  final T data;

  Success(this.data);
}

// Customer error case with a message
class CustomerError extends RepositoryResult<void> {
  final String error;

  CustomerError(this.error);
}

// General failure case with a Throwable
class Failure extends RepositoryResult<void> {
  final dynamic throwable;

  Failure(this.throwable);
}