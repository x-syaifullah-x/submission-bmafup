sealed class Result<T> {
  const Result._();
}

class ResultSuccess<T> extends Result<T> {
  const ResultSuccess(this.value) : super._();

  final T value;
}

class ResultError<T extends Exception> extends Result<Never> {
  const ResultError(this.exception) : super._();

  final T exception;
}
