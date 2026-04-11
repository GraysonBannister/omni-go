import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/errors/failures.dart';
import '../../data/models/file_item.dart';
import '../../data/repositories/remote_repository.dart';
import 'server_provider.dart';

final filesControllerProvider = StateNotifierProvider<FilesController, AsyncValue<List<FileItem>>>((ref) {
  return FilesController(ref);
});

final selectedFileProvider = StateProvider<FileItem?>((ref) => null);

final fileContentProvider = StateNotifierProvider<FileContentNotifier, AsyncValue<String>>((ref) {
  return FileContentNotifier(ref);
});

final currentDirectoryProvider = StateProvider<String>((ref) => '.');

class FilesController extends StateNotifier<AsyncValue<List<FileItem>>> {
  final Ref _ref;
  RemoteRepository? _repository;

  FilesController(this._ref) : super(const AsyncValue.loading());

  Future<void> loadDirectory(String path) async {
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      _repository = repo;
      state = const AsyncValue.loading();
      final files = await repo.listFiles(path);
      state = AsyncValue.data(files);
    } on Failure catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refresh() async {
    final currentDir = _ref.read(currentDirectoryProvider);
    await loadDirectory(currentDir);
  }

  Future<String> readFile(String path) async {
    try {
      final repo = _repository ?? _ref.read(remoteRepositoryProvider);
      return await repo!.readFile(path);
    } on Failure {
      rethrow;
    } catch (e) {
      throw const ServerFailure('Not connected to server');
    }
  }

  Future<void> writeFile(String path, String content) async {
    try {
      final repo = _repository ?? _ref.read(remoteRepositoryProvider);
      await repo!.writeFile(path, content);
    } on Failure {
      rethrow;
    } catch (e) {
      throw const ServerFailure('Not connected to server');
    }
  }

  Future<void> editFile(String path, String oldString, String newString) async {
    try {
      final repo = _repository ?? _ref.read(remoteRepositoryProvider);
      await repo!.editFile(path, oldString, newString);
    } on Failure {
      rethrow;
    } catch (e) {
      throw const ServerFailure('Not connected to server');
    }
  }

  Future<void> createDirectory(String path) async {
    try {
      final repo = _repository ?? _ref.read(remoteRepositoryProvider);
      await repo!.createDirectory(path);
      await refresh();
    } on Failure {
      rethrow;
    } catch (e) {
      throw const ServerFailure('Not connected to server');
    }
  }
}

class FileContentNotifier extends StateNotifier<AsyncValue<String>> {
  final Ref _ref;

  FileContentNotifier(this._ref) : super(const AsyncValue.data(''));

  Future<void> load(String path) async {
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      state = const AsyncValue.loading();
      final content = await repo.readFile(path);
      state = AsyncValue.data(content);
    } on Failure catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> save(String path, String content) async {
    try {
      final repo = _ref.read(remoteRepositoryProvider);
      await repo.writeFile(path, content);
      state = AsyncValue.data(content);
    } on Failure catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
