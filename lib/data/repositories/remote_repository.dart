import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import '../../config/constants.dart';
import '../../core/errors/failures.dart';
import '../../data/models/agent_event.dart';
import '../../data/models/ai_model.dart';
import '../../data/models/change_preview.dart';
import '../../data/models/conversation.dart';
import '../../data/models/file_item.dart';
import '../../data/models/file_reference.dart';
import '../../data/models/git_file_status.dart';
import '../../data/models/image_attachment.dart';
import '../../data/models/line_change.dart';
import '../../data/models/message.dart';
import '../../data/models/server_config.dart';
import '../../data/models/terminal_session.dart';
import '../../data/models/workspace.dart';
import '../../services/api_service.dart';
import '../../services/notification_service.dart';
import '../../services/sse_service.dart';

class RemoteRepository {
  final ApiService _apiService;
  final SseService _sseService;

  RemoteRepository(this._apiService, this._sseService);

  // Configuration
  void configure(String url, String apiKey) {
    _apiService.configure(url, apiKey);
    _sseService.configure(url, apiKey);
  }

  bool get isConfigured => _apiService.isConfigured;

  Future<ServerConfig> testConnection() async {
    if (!_apiService.isConfigured) {
      return ServerConfig.empty().copyWith(
        error: 'Not configured',
      );
    }

    try {
      final success = await _apiService.testConnection();
      if (success) {
        final config = await _apiService.get(ApiEndpoints.config);
        return ServerConfig(
          url: _apiService.baseUrl!,
          apiKey: _apiService.apiKey!,
          isConnected: true,
        );
      }
      return ServerConfig(
        url: _apiService.baseUrl!,
        apiKey: _apiService.apiKey!,
        isConnected: false,
        error: 'Connection failed',
      );
    } on Failure catch (e) {
      return ServerConfig(
        url: _apiService.baseUrl!,
        apiKey: _apiService.apiKey!,
        isConnected: false,
        error: e.message,
      );
    }
  }

  // Agent Operations
  Future<Conversation> createConversation({
    String? conversationId,
    String? model,
    String? provider,
    String? workingDirectory,
    String? mode,
  }) async {
    if (kDebugMode) {
      debugPrint('[RemoteRepository] createConversation called: conversationId=$conversationId, model=$model, provider=$provider, workingDirectory=$workingDirectory, mode=$mode');
    }

    try {
      final id = conversationId ?? DateTime.now().millisecondsSinceEpoch.toString();
      final response = await _apiService.post(
        ApiEndpoints.createConversation,
        data: {
          'conversationId': id,
          if (model != null) 'model': model,
          if (provider != null) 'provider': provider,
          if (workingDirectory != null) 'workingDirectory': workingDirectory,
          if (mode != null) 'mode': mode,
        },
      );

      if (kDebugMode) {
        debugPrint('[RemoteRepository] createConversation response: success=${response['success']}, error=${response['error']}');
      }

      if (response['success'] == true) {
        return Conversation(
          id: id,
          model: model,
          provider: provider,
          mode: mode,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
      throw ServerFailure(response['error'] ?? 'Failed to create conversation');
    } on Failure {
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[RemoteRepository] createConversation exception: $e');
      }
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<void> sendMessage(
    String conversationId,
    String message, {
    String? workingDirectory,
    List<FileReference>? fileReferences,
    List<ImageAttachment>? images,
  }) async {
    if (kDebugMode) {
      debugPrint('[RemoteRepository] sendMessage called: conversationId=$conversationId, workingDirectory=$workingDirectory, fileReferences=${fileReferences?.length ?? 0}, images=${images?.length ?? 0}');
    }

    try {
      final data = <String, dynamic>{
        'conversationId': conversationId,
        'message': message,
        if (workingDirectory != null) 'workingDirectory': workingDirectory,
        if (fileReferences != null && fileReferences.isNotEmpty)
          'fileReferences': fileReferences.map((ref) => {
            'path': ref.path,
            'name': ref.name,
            'type': ref.isDirectory ? 'directory' : 'file',
            if (ref.content != null) 'content': ref.content,
            if (ref.size != null) 'size': ref.size,
          }).toList(),
        if (images != null && images.isNotEmpty)
          'images': images.map((img) => {
            'type': 'base64',
            'mediaType': img.mediaType,
            'data': img.base64Data,
          }).toList(),
      };

      final response = await _apiService.post(
        ApiEndpoints.sendMessage,
        data: data,
      );

      if (kDebugMode) {
        debugPrint('[RemoteRepository] sendMessage response: success=${response['success']}, error=${response['error']}');
      }

      if (response['success'] != true) {
        throw ServerFailure(response['error'] ?? 'Failed to send message');
      }
    } on Failure {
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[RemoteRepository] sendMessage exception: $e');
      }
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<void> abortConversation(String conversationId) async {
    try {
      await _apiService.post(
        ApiEndpoints.abort,
        data: {'conversationId': conversationId},
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<void> closeConversation(String conversationId) async {
    try {
      await _apiService.post(
        ApiEndpoints.closeConversation,
        data: {'conversationId': conversationId},
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<List<String>> getActiveConversations() async {
    try {
      final response = await _apiService.get(ApiEndpoints.conversations);
      final conversations = response['conversations'] as List<dynamic>?;
      return conversations?.cast<String>() ?? [];
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  void connectToAgentEvents(
    String conversationId, {
    required Function(AgentEvent) onEvent,
    Function(Failure)? onError,
    VoidCallback? onConnect,
    VoidCallback? onDisconnect,
    VoidCallback? onMissedEvents,
  }) {
    _sseService.connectToAgentEvents(
      conversationId,
      onEvent: onEvent,
      onError: onError,
      onConnect: onConnect,
      onDisconnect: onDisconnect,
      onMissedEvents: onMissedEvents,
    );
  }

  void disconnectFromAgentEvents() {
    _sseService.disconnect();
  }

  Future<void> respondToPermission(
    String toolId,
    String decision, // 'allow', 'deny', 'allowAlways'
  ) async {
    try {
      await _apiService.post(
        ApiEndpoints.respondPermission,
        data: {
          'toolId': toolId,
          'decision': decision,
        },
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<void> respondToUserInput(
    String requestId,
    String response,
    bool cancelled,
  ) async {
    try {
      await _apiService.post(
        ApiEndpoints.respondUserInput,
        data: {
          'requestId': requestId,
          'response': response,
          'cancelled': cancelled,
        },
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  // Message Modification Operations

  Future<void> switchModel(String conversationId, String model, String provider) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.switchModel,
        data: {
          'conversationId': conversationId,
          'model': model,
          'provider': provider,
        },
      );

      if (response['success'] != true) {
        throw ServerFailure(response['error'] ?? 'Failed to switch model');
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<void> setMode(String conversationId, String mode) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.setMode,
        data: {
          'conversationId': conversationId,
          'mode': mode,
        },
      );

      if (response['success'] != true) {
        throw ServerFailure(response['error'] ?? 'Failed to set mode');
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<void> truncateMessages(String conversationId, int messageIndex) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.truncateMessages,
        data: {
          'conversationId': conversationId,
          'messageIndex': messageIndex,
        },
      );

      if (response['success'] != true) {
        throw ServerFailure(response['error'] ?? 'Failed to truncate messages');
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<void> gitReset(String workingDirectory, String commit) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.gitReset,
        data: {
          'workingDirectory': workingDirectory,
          'commit': commit,
        },
      );

      if (response['success'] != true) {
        throw ServerFailure(response['error'] ?? 'Failed to reset files');
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  // Git Operations

  /// Fetch git diff for a specific file
  /// Returns structured line change information
  Future<GitDiffResponse> fetchGitDiff(String filePath, {bool staged = false, String? workspaceId}) async {
    try {
      final queryParameters = <String, dynamic>{
        'path': filePath,
        'staged': staged.toString(),
      };
      if (workspaceId != null) {
        queryParameters['workspaceId'] = workspaceId;
      }

      final response = await _apiService.get(
        ApiEndpoints.gitDiff,
        queryParameters: queryParameters,
      );

      return GitDiffResponse.fromJson(response);
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Fetch git status for a directory
  /// Returns a map of filenames to their git status
  Future<GitDirectoryStatus> fetchGitStatus(String directoryPath, {String? workspaceId}) async {
    try {
      final queryParameters = <String, dynamic>{
        'path': directoryPath,
      };
      if (workspaceId != null) {
        queryParameters['workspaceId'] = workspaceId;
      }

      final response = await _apiService.get(
        ApiEndpoints.gitStatus,
        queryParameters: queryParameters,
      );

      // Debug logging
      if (kDebugMode) {
        print('[GitStatus] Response for "$directoryPath": $response');
      }

      return GitDirectoryStatus.fromJson(response);
    } on Failure catch (e) {
      // If the request fails, return a non-git status
      if (kDebugMode) {
        print('[GitStatus] Failure for "$directoryPath": $e');
      }
      return const GitDirectoryStatus.notGit();
    } catch (e) {
      // Return non-git status on any error
      if (kDebugMode) {
        print('[GitStatus] Error for "$directoryPath": $e');
      }
      return const GitDirectoryStatus.notGit();
    }
  }

  // File Operations
  Future<String> readFile(String path) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.readFile,
        queryParameters: {'path': path},
      );
      return response['content'] as String? ?? '';
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<void> writeFile(String path, String content) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.writeFile,
        data: {
          'path': path,
          'content': content,
        },
      );

      if (response['success'] != true) {
        throw ServerFailure(response['error'] ?? 'Failed to write file');
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<void> editFile(String path, String oldString, String newString) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.editFile,
        data: {
          'path': path,
          'oldString': oldString,
          'newString': newString,
        },
      );

      if (response['success'] != true) {
        throw ServerFailure(response['error'] ?? 'Failed to edit file');
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<List<FileItem>> listFiles(String path) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.listFiles,
        queryParameters: {'path': path},
      );

      final files = response['files'] as List<dynamic>? ?? [];
      return files
          .map((f) => FileItem.fromApiResponse(f as Map<String, dynamic>))
          .toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<void> createDirectory(String path) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.mkdir,
        data: {'path': path},
      );

      if (response['success'] != true) {
        throw ServerFailure(response['error'] ?? 'Failed to create directory');
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Search for files recursively by pattern (e.g. '*.apk')
  Future<List<SearchResultFile>> searchFiles(String pattern, {int maxResults = 100, String? workspaceId}) async {
    try {
      if (kDebugMode) {
        debugPrint('[RemoteRepository] searchFiles: pattern=$pattern, maxResults=$maxResults, workspaceId=$workspaceId');
      }
      final queryParameters = <String, String>{
        'pattern': pattern,
        'maxResults': maxResults.toString(),
        if (workspaceId != null) 'workspaceId': workspaceId,
      };
      final response = await _apiService.get(
        ApiEndpoints.searchFiles,
        queryParameters: queryParameters,
      );

      if (kDebugMode) {
        debugPrint('[RemoteRepository] searchFiles response: cwd=${response['cwd']}, files=${(response['files'] as List?)?.length ?? 0}');
      }
      final files = response['files'] as List<dynamic>? ?? [];
      final result = files.map((f) {
        final m = f as Map<String, dynamic>;
        return SearchResultFile(
          name: m['name'] as String? ?? '',
          path: m['path'] as String? ?? '',
          relativePath: m['relativePath'] as String? ?? '',
          size: m['size'] as int? ?? 0,
        );
      }).toList();
      if (kDebugMode) {
        for (final f in result) {
          debugPrint('[RemoteRepository] searchFiles result: ${f.relativePath} (${f.sizeFormatted})');
        }
      }
      return result;
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Delete a file or directory
  Future<void> deleteFile(String path) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.deleteFile,
        data: {'path': path},
      );

      if (response['success'] != true) {
        throw ServerFailure(response['error'] ?? 'Failed to delete');
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  // Terminal Operations
  Future<TerminalSession> createTerminal({
    String? id,
    String? cwd,
    int cols = 80,
    int rows = 24,
  }) async {
    try {
      final terminalId = id ?? DateTime.now().millisecondsSinceEpoch.toString();
      final response = await _apiService.post(
        ApiEndpoints.createTerminal,
        data: {
          'id': terminalId,
          'cwd': cwd,
          'cols': cols,
          'rows': rows,
        },
      );

      if (response['success'] == true) {
        return TerminalSession(
          id: terminalId,
          cols: cols,
          rows: rows,
          cwd: cwd,
          createdAt: DateTime.now(),
        );
      }
      throw ServerFailure(response['error'] ?? 'Failed to create terminal');
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<void> writeToTerminal(String id, String data) async {
    try {
      await _apiService.post(
        ApiEndpoints.writeTerminal,
        data: {
          'id': id,
          'data': data,
        },
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<void> resizeTerminal(String id, int cols, int rows) async {
    try {
      await _apiService.post(
        ApiEndpoints.resizeTerminal,
        data: {
          'id': id,
          'cols': cols,
          'rows': rows,
        },
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<void> destroyTerminal(String id) async {
    try {
      await _apiService.post(
        ApiEndpoints.destroyTerminal,
        data: {'id': id},
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  void connectToTerminal(
    String terminalId, {
    required Function(AgentEvent) onEvent,
    Function(Failure)? onError,
    VoidCallback? onConnect,
    VoidCallback? onDisconnect,
  }) {
    _sseService.connectToTerminal(
      terminalId,
      onEvent: onEvent,
      onError: onError,
      onConnect: onConnect,
      onDisconnect: onDisconnect,
    );
  }

  void disconnectFromTerminal() {
    _sseService.disconnect();
  }

  // Workspace Operations

  Future<List<Workspace>> fetchWorkspaces() async {
    try {
      final response = await _apiService.get(ApiEndpoints.workspaces);
      if (kDebugMode) {
        debugPrint('[RemoteRepository:fetchWorkspaces] Raw response: $response');
      }
      final list = response['workspaces'] as List<dynamic>? ?? [];
      if (kDebugMode) {
        debugPrint('[RemoteRepository:fetchWorkspaces] Workspaces count: ${list.length}');
        if (list.isNotEmpty) {
          debugPrint('[RemoteRepository:fetchWorkspaces] First workspace raw: ${list.first}');
        }
      }
      final workspaces = list
          .map((w) {
            try {
              return Workspace.fromJson(w as Map<String, dynamic>);
            } catch (e) {
              if (kDebugMode) {
                debugPrint('[RemoteRepository:fetchWorkspaces] Failed to parse workspace: $w');
                debugPrint('[RemoteRepository:fetchWorkspaces] Parse error: $e');
              }
              rethrow;
            }
          })
          .toList();
      if (kDebugMode) {
        debugPrint('[RemoteRepository:fetchWorkspaces] Parsed ${workspaces.length} workspaces');
      }
      return workspaces;
    } on Failure {
      rethrow;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[RemoteRepository:fetchWorkspaces] Error: $e');
        debugPrint('[RemoteRepository:fetchWorkspaces] StackTrace: $stackTrace');
      }
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<Workspace?> getWorkspace(String sharedId) async {
    try {
      final response = await _apiService.get(
        '${ApiEndpoints.workspaces}/$sharedId',
      );
      final data = response['workspace'] as Map<String, dynamic>?;
      if (data == null) return null;
      return Workspace.fromJson(data);
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<Workspace?> getActiveWorkspace() async {
    try {
      final workspaces = await fetchWorkspaces();
      return workspaces.where((w) => w.isActive).firstOrNull;
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<Workspace?> switchWorkspace(String sharedId) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.activeWorkspace,
        data: {'workspaceId': sharedId},
      );
      if (response['success'] != true) {
        throw ServerFailure(response['error'] ?? 'Failed to switch workspace');
      }
      // Re-fetch the workspace to get its full data
      return await getWorkspace(sharedId);
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<List<WorkspaceFolder>> getWorkspaceFolders(String sharedId) async {
    try {
      final workspace = await getWorkspace(sharedId);
      return workspace?.folders ?? [];
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Create a single-folder project (no workspace file, standalone).
  Future<Workspace> createProject(String folderPath, {String? name}) async {
    if (kDebugMode) {
      debugPrint('[RemoteRepository:createProject] folderPath=$folderPath, name=$name');
    }
    try {
      final response = await _apiService.post(
        ApiEndpoints.projects,
        data: {
          'folderPath': folderPath,
          if (name != null && name.isNotEmpty) 'name': name,
        },
      );
      if (kDebugMode) debugPrint('[RemoteRepository:createProject] Response: $response');
      if (response['success'] != true) {
        throw ServerFailure(response['error'] ?? 'Failed to create project');
      }
      final workspace = Workspace.fromJson(response['workspace'] as Map<String, dynamic>);
      if (kDebugMode) {
        debugPrint('[RemoteRepository:createProject] Created: sharedId=${workspace.sharedId}, name=${workspace.name}');
      }
      return workspace;
    } on Failure {
      rethrow;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[RemoteRepository:createProject] Error: $e\n$stackTrace');
      }
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Create a new multi-folder workspace.
  Future<Workspace> createWorkspace(String name, List<String> folders) async {
    if (kDebugMode) {
      debugPrint('[RemoteRepository:createWorkspace] name=$name, folders=$folders');
    }
    try {
      final response = await _apiService.post(
        ApiEndpoints.workspaces,
        data: {'name': name, 'folders': folders},
      );
      if (kDebugMode) debugPrint('[RemoteRepository:createWorkspace] Response: $response');
      if (response['success'] != true) {
        throw ServerFailure(response['error'] ?? 'Failed to create workspace');
      }
      final workspace = Workspace.fromJson(response['workspace'] as Map<String, dynamic>);
      if (kDebugMode) {
        debugPrint('[RemoteRepository:createWorkspace] Created: sharedId=${workspace.sharedId}, name=${workspace.name}');
      }
      return workspace;
    } on Failure {
      rethrow;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[RemoteRepository:createWorkspace] Error: $e\n$stackTrace');
      }
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Remove a workspace from the shared list.
  Future<void> deleteWorkspace(String sharedId) async {
    if (kDebugMode) debugPrint('[RemoteRepository:deleteWorkspace] sharedId=$sharedId');
    try {
      final response = await _apiService.delete(
        '${ApiEndpoints.workspaces}/$sharedId',
      );
      if (kDebugMode) debugPrint('[RemoteRepository:deleteWorkspace] Response: $response');
      if (response['success'] != true) {
        throw ServerFailure(response['error'] ?? 'Failed to delete workspace');
      }
      if (kDebugMode) debugPrint('[RemoteRepository:deleteWorkspace] Deleted: $sharedId');
    } on Failure {
      rethrow;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[RemoteRepository:deleteWorkspace] Error: $e\n$stackTrace');
      }
      throw UnexpectedFailure(e.toString());
    }
  }

  // Chat History Operations

  Future<List<ConversationSummary>> fetchChatList(String workspaceId) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.listChats,
        queryParameters: {'workspaceId': workspaceId},
      );
      final list = response['conversations'] as List<dynamic>? ?? [];
      if (kDebugMode && list.isNotEmpty) {
        debugPrint('[RemoteRepository:fetchChatList] First item raw: ${list.first}');
      }
      return list
          .map((c) => ConversationSummary.fromJson(_normalizeConversationData(c as Map<String, dynamic>)))
          .toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<Conversation?> loadConversation(
    String workspaceId,
    String conversationId,
  ) async {
    if (kDebugMode) {
      debugPrint('[RemoteRepository:load] Loading conversation: workspaceId=$workspaceId, conversationId=$conversationId');
    }
    try {
      final endpoint = '${ApiEndpoints.loadChat}/$conversationId';
      if (kDebugMode) {
        debugPrint('[RemoteRepository:load] Calling API endpoint: $endpoint');
      }
      final response = await _apiService.get(
        endpoint,
        queryParameters: {'workspaceId': workspaceId},
      );
      if (kDebugMode) {
        debugPrint('[RemoteRepository:load] API response received: ${response.keys.toList()}');
        debugPrint('[RemoteRepository:load] Response conversation field: ${response['conversation'] != null ? 'present' : 'null'}');
        if (response['error'] != null) {
          debugPrint('[RemoteRepository:load] Response error: ${response['error']}');
        }
      }
      final data = response['conversation'] as Map<String, dynamic>?;
      if (data == null) {
        if (kDebugMode) {
          debugPrint('[RemoteRepository:load] No conversation data found in response');
        }
        return null;
      }
      final conversation = Conversation.fromJson(_normalizeConversationData(data));
      if (kDebugMode) {
        debugPrint('[RemoteRepository:load] Conversation parsed successfully: id=${conversation.id}, messages=${conversation.messages.length}');
      }
      return conversation;
    } on Failure {
      if (kDebugMode) {
        debugPrint('[RemoteRepository:load] Failure occurred during loadConversation');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[RemoteRepository:load] Exception during loadConversation: $e');
      }
      throw UnexpectedFailure(e.toString());
    }
  }

  // Tool Operations
  Future<List<Map<String, dynamic>>> listTools() async {
    try {
      final response = await _apiService.get(ApiEndpoints.listTools);
      return (response['tools'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  Future<Map<String, dynamic>> executeTool(
    String toolName,
    Map<String, dynamic> input,
  ) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.executeTool,
        data: {
          'toolName': toolName,
          'input': input,
        },
      );
      return response;
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  // Model Operations - Fetch available models from desktop server
  Future<List<AIModel>> fetchAvailableModels() async {
    try {
      final response = await _apiService.get(ApiEndpoints.models);
      final list = response['models'] as List<dynamic>? ?? [];
      return list
          .map((m) => AIModel.fromJson(m as Map<String, dynamic>))
          .toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  // Provider Operations - Fetch providers with their models from desktop server
  Future<List<AIProvider>> fetchProviders() async {
    try {
      final response = await _apiService.get(ApiEndpoints.providers);
      final list = response['providers'] as List<dynamic>? ?? [];

      // Convert provider data to AIProvider objects
      final providers = <AIProvider>[];
      for (final providerData in list) {
        final provider = providerData as Map<String, dynamic>;
        final providerName = provider['name'] as String? ?? 'Unknown';
        final isAvailable = provider['available'] as bool? ?? false;
        final modelIds = (provider['models'] as List<dynamic>?)?.cast<String>() ?? [];

        // Fetch full model details and match with IDs
        final allModels = await fetchAvailableModels();
        final providerModels = allModels
            .where((m) => m.provider == providerName || modelIds.contains(m.id))
            .toList();

        providers.add(AIProvider(
          id: providerName.toLowerCase(),
          name: _providerDisplayName(providerName),
          models: providerModels,
          isAvailable: isAvailable,
        ));
      }
      return providers;
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Normalizes raw API conversation/summary data to match the types expected
  /// by the freezed-generated fromJson methods:
  /// - id: server may return int → convert to String
  /// - messageCount: server may return String → convert to int
  /// - createdAt/updatedAt: server returns int (ms since epoch) → convert to ISO8601 String
  /// - error: server may return List<content blocks> → convert to String
  /// - messages: normalize each message's content and error fields
  Map<String, dynamic> _normalizeConversationData(Map<String, dynamic> raw) {
    final data = Map<String, dynamic>.from(raw);
    // Convert int id to String
    if (data['id'] is int) {
      data['id'] = data['id'].toString();
    }
    // Convert String messageCount to int
    if (data['messageCount'] is String) {
      data['messageCount'] = int.tryParse(data['messageCount'] as String) ?? 0;
    }
    // Convert int timestamps (ms since epoch) to ISO8601 strings
    if (data['createdAt'] is int) {
      data['createdAt'] = DateTime.fromMillisecondsSinceEpoch(data['createdAt'] as int).toIso8601String();
    }
    if (data['updatedAt'] is int) {
      data['updatedAt'] = DateTime.fromMillisecondsSinceEpoch(data['updatedAt'] as int).toIso8601String();
    }
    // Convert error from List<content blocks> to String if needed
    if (data['error'] is List) {
      data['error'] = _extractTextFromContentBlocks(data['error'] as List);
    }
    // Normalize messages
    if (data['messages'] is List) {
      data['messages'] = (data['messages'] as List).map((msg) {
        if (msg is Map<String, dynamic>) {
          return _normalizeMessageData(msg);
        }
        return msg;
      }).toList();
    }
    return data;
  }

  /// Normalizes message data to handle Anthropic-style content block arrays.
  ///
  /// Anthropic messages store content as a list of typed blocks:
  ///   - text blocks:        { "type": "text",       "text": "..." }
  ///   - tool_use blocks:    { "type": "tool_use",   "id": "...", "name": "...", "input": {...} }
  ///   - tool_result blocks: { "type": "tool_result","toolUseId":"...", "content": "..." }
  ///   - thinking blocks:    { "type": "thinking",   "thinking": "..." }
  ///
  /// We detect the dominant block type and set the message `type` field accordingly
  /// so that `_buildTimeline` can group tool messages correctly, and extract the
  /// human-readable text for display.
  Map<String, dynamic> _normalizeMessageData(Map<String, dynamic> raw) {
    final data = Map<String, dynamic>.from(raw);

    if (data['content'] is List) {
      final blocks = data['content'] as List;
      final blockTypes = blocks
          .whereType<Map<String, dynamic>>()
          .map((b) => b['type'] as String? ?? '')
          .toSet();

      final hasText = blockTypes.contains('text');
      final hasToolUse = blockTypes.contains('tool_use');
      final hasToolResult = blockTypes.contains('tool_result');

      if (hasToolUse && !hasText) {
        // Pure tool_use message — mark as toolCall so _buildTimeline groups it
        data['type'] = 'toolCall';
        // Build a display string from the tool names
        final names = blocks
            .whereType<Map<String, dynamic>>()
            .where((b) => b['type'] == 'tool_use')
            .map((b) => b['name'] as String? ?? 'tool')
            .join(', ');
        data['content'] = 'Using $names...';
      } else if (hasToolResult && !hasText) {
        // Pure tool_result message — mark as toolResult
        data['type'] = 'toolResult';
        // Extract result text from the `content` field on each block
        data['content'] = blocks
            .whereType<Map<String, dynamic>>()
            .where((b) => b['type'] == 'tool_result')
            .map((b) {
              final c = b['content'];
              if (c is String) return c;
              if (c is List) return _extractTextFromContentBlocks(c);
              return '';
            })
            .join('\n');
      } else {
        // Text (possibly mixed with thinking blocks) — extract visible text only
        data['content'] = _extractTextFromContentBlocks(blocks);
      }
    }

    // Convert error from List<content blocks> to String if needed
    if (data['error'] is List) {
      data['error'] = _extractTextFromContentBlocks(data['error'] as List);
    }
    return data;
  }

  /// Extracts text from content blocks that carry a `text` field
  /// (i.e., `{type: 'text', text: '...'}` blocks; thinking/tool blocks are skipped).
  String _extractTextFromContentBlocks(List<dynamic> blocks) {
    return blocks
        .whereType<Map<String, dynamic>>()
        .map((block) => block['text'] as String? ?? '')
        .join();
  }

  String _providerDisplayName(String providerId) {
    switch (providerId.toLowerCase()) {
      case 'anthropic':
        return 'Anthropic';
      case 'openai':
        return 'OpenAI';
      case 'google':
        return 'Google';
      case 'mistral':
        return 'Mistral';
      case 'groq':
        return 'Groq';
      case 'xai':
        return 'xAI';
      case 'moonshot':
        return 'Moonshot';
      case 'together':
        return 'Together AI';
      case 'ollama':
        return 'Ollama';
      case 'lmstudio':
        return 'LM Studio';
      default:
        return providerId.substring(0, 1).toUpperCase() + providerId.substring(1);
    }
  }

  // Proxy Operations

  /// Fetch list of registered proxy ports
  Future<ProxyListResponse> fetchProxyList() async {
    try {
      final response = await _apiService.get(ApiEndpoints.proxyList);
      final enabled = response['enabled'] as bool? ?? false;
      final portsRaw = response['ports'] as List<dynamic>? ?? [];
      final ports = portsRaw.map((p) {
        final m = p as Map<String, dynamic>;
        return ProxyPort(
          port: m['port'] as int,
          name: m['name'] as String? ?? 'localhost:${m['port']}',
          registeredAt: DateTime.fromMillisecondsSinceEpoch(m['registeredAt'] as int? ?? 0),
        );
      }).toList();
      return ProxyListResponse(enabled: enabled, ports: ports);
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Register a port for proxying
  Future<void> registerProxyPort(int port, {String? name}) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.proxyRegister,
        data: {'port': port, if (name != null) 'name': name},
      );
      if (response['success'] != true) {
        throw ServerFailure(response['error'] ?? 'Failed to register proxy port');
      }
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Unregister a proxy port
  Future<void> unregisterProxyPort(int port) async {
    try {
      await _apiService.delete('${ApiEndpoints.proxyBase}/$port');
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Scan for available localhost services on common dev ports
  Future<ProxyScanResponse> scanForServices() async {
    try {
      final response = await _apiService.get(ApiEndpoints.proxyScan);
      final enabled = response['enabled'] as bool? ?? false;
      final availableRaw = response['available'] as List<dynamic>? ?? [];
      final available = availableRaw.map((p) {
        final m = p as Map<String, dynamic>;
        return AvailableService(
          port: m['port'] as int,
          name: m['name'] as String? ?? 'localhost:${m['port']}',
        );
      }).toList();
      return ProxyScanResponse(enabled: enabled, available: available);
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Build a full URL for accessing a proxied localhost service
  String getProxyUrl(int port, {String path = '/'}) {
    final base = _apiService.baseUrl ?? '';
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '$base${ApiEndpoints.proxyBase}/$port/$cleanPath';
  }

  /// Get headers needed for authenticated requests (for Dio.download or WebView).
  /// [path] must be the full path+query as it will appear in req.originalUrl,
  /// e.g. "/api/files/download?path=foo%2Fbar.apk&workspaceId=xyz"
  Map<String, String> getProxyHeaders({String method = 'GET', String path = '/'}) {
    final apiKey = _apiService.apiKey;
    if (apiKey == null) return {};

    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    // Signing string must exactly match server: "METHOD\nPATH_WITH_QUERY\nTIMESTAMP"
    // Ensure path starts with /
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final signingString = '$method\n$normalizedPath\n$timestamp';
    final hmac = Hmac(sha256, utf8.encode(apiKey));
    final signature = hmac.convert(utf8.encode(signingString)).toString();

    return {
      'X-API-Key': apiKey,
      'X-Timestamp': timestamp,
      'X-Signature': signature,
    };
  }

  // ADB / Device Management Operations

  /// List connected ADB devices
  Future<List<AdbDevice>> fetchAdbDevices() async {
    try {
      final response = await _apiService.get(ApiEndpoints.adbDevices);
      final devicesRaw = response['devices'] as List<dynamic>? ?? [];
      return devicesRaw.map((d) {
        final m = d as Map<String, dynamic>;
        return AdbDevice(
          id: m['id'] as String,
          state: m['state'] as String,
          model: m['model'] as String?,
          product: m['product'] as String?,
        );
      }).toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Install APK on a device
  Future<AdbCommandResult> installApk(String filePath, {String? deviceId, String? workspaceId}) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.adbInstall,
        data: {
          'filePath': filePath,
          if (deviceId != null) 'deviceId': deviceId,
          if (workspaceId != null) 'workspaceId': workspaceId,
        },
      );
      return AdbCommandResult(
        success: response['success'] as bool? ?? false,
        stdout: response['stdout'] as String? ?? '',
        stderr: response['stderr'] as String? ?? '',
        packageName: response['packageName'] as String?,
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Launch an app on a device
  Future<AdbCommandResult> launchApp(String packageName, {String? activityName, String? deviceId}) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.adbLaunch,
        data: {
          'packageName': packageName,
          if (activityName != null) 'activityName': activityName,
          if (deviceId != null) 'deviceId': deviceId,
        },
      );
      return AdbCommandResult(
        success: response['success'] as bool? ?? false,
        stdout: response['stdout'] as String? ?? '',
        stderr: response['stderr'] as String? ?? '',
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Pair a device for wireless ADB debugging
  Future<AdbCommandResult> wirelessPair(String ip, int port, String pairingCode) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.adbWirelessPair,
        data: {
          'ip': ip,
          'port': port,
          'pairingCode': pairingCode,
        },
      );
      return AdbCommandResult(
        success: response['success'] as bool? ?? false,
        stdout: response['stdout'] as String? ?? '',
        stderr: response['stderr'] as String? ?? '',
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Get the download URL for a binary file (e.g. APK).
  /// Pass [workspaceId] so the server resolves the relative path in the correct workspace.
  String getDownloadUrl(String filePath, {String? workspaceId}) {
    final base = _apiService.baseUrl ?? '';
    final wsParam = workspaceId != null ? '&workspaceId=${Uri.encodeComponent(workspaceId)}' : '';
    return '$base${ApiEndpoints.downloadFile}?path=${Uri.encodeComponent(filePath)}$wsParam';
  }

  // iOS / Device Management Operations

  /// List connected iOS devices (physical devices only, macOS host required)
  Future<List<IosDevice>> fetchIosDevices() async {
    try {
      final response = await _apiService.get(ApiEndpoints.iosDevices);
      final devicesRaw = response['devices'] as List<dynamic>? ?? [];
      return devicesRaw.map((d) {
        final m = d as Map<String, dynamic>;
        return IosDevice(
          udid: m['udid'] as String? ?? '',
          name: m['name'] as String? ?? 'Unknown Device',
          osVersion: m['osVersion'] as String? ?? '',
          type: m['type'] as String? ?? 'physical',
        );
      }).toList();
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Install an IPA on a connected iOS device via ios-deploy or ideviceinstaller
  Future<AdbCommandResult> installIpa(String filePath, {String? deviceId, String? workspaceId}) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.iosInstall,
        data: {
          'filePath': filePath,
          if (deviceId != null) 'deviceId': deviceId,
          if (workspaceId != null) 'workspaceId': workspaceId,
        },
      );
      return AdbCommandResult(
        success: response['success'] as bool? ?? false,
        stdout: response['stdout'] as String? ?? '',
        stderr: response['stderr'] as String? ?? '',
      );
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  // Change Review API Methods

  /// Enable or disable change review mode
  Future<bool> setChangeReviewEnabled(bool enabled) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.setChangeReview,
        data: {'enabled': enabled},
      );
      return response['success'] as bool? ?? false;
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Get change review status
  Future<bool> getChangeReviewStatus() async {
    try {
      final response = await _apiService.get(ApiEndpoints.changeReviewStatus);
      return response['enabled'] as bool? ?? false;
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Get pending changes for a conversation
  Future<PendingChangesResponse> getPendingChanges(String conversationId) async {
    try {
      final response = await _apiService.get(
        '${ApiEndpoints.pendingChanges}?conversationId=$conversationId',
      );
      return PendingChangesResponse.fromJson(response);
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Respond to a change review request (accept or reject a specific change)
  Future<ChangeReviewResponse> respondToChangeReview({
    required String conversationId,
    required String messageId,
    required String toolCallId,
    required String decision, // 'accept' or 'reject'
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.respondToChange,
        data: {
          'conversationId': conversationId,
          'messageId': messageId,
          'toolCallId': toolCallId,
          'decision': decision,
        },
      );
      return ChangeReviewResponse.fromJson(response);
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Accept all pending changes for a conversation
  Future<AcceptAllChangesResponse> acceptAllChanges(String conversationId) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.acceptAllChanges,
        data: {'conversationId': conversationId},
      );
      return AcceptAllChangesResponse.fromJson(response);
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  /// Reject all pending changes for a conversation
  Future<RejectAllChangesResponse> rejectAllChanges({
    required String conversationId,
    required String messageId,
  }) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.rejectAllChanges,
        data: {
          'conversationId': conversationId,
          'messageId': messageId,
        },
      );
      return RejectAllChangesResponse.fromJson(response);
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnexpectedFailure(e.toString());
    }
  }

  void dispose() {
    _sseService.dispose();
  }

  /// Notify the underlying services that the app has been backgrounded
  void notifyBackgrounded() {
    _sseService.onAppBackgrounded();
  }

  /// Notify the underlying services that the app has resumed from background
  void notifyResumed() {
    _sseService.onAppResumed();
  }

  /// Get the last event timestamp for missed event detection
  DateTime? get lastEventTimestamp => _sseService.lastEventTimestamp;

  /// Request sync of missed events since the given timestamp
  void requestSync(DateTime? since) {
    _sseService.requestSync(since);
  }

  /// Request notification permissions from the device
  /// This should be called after user connects to server
  Future<bool> requestNotificationPermissions() async {
    try {
      // Import notification service and request permissions
      final notificationService = NotificationService();
      return await notificationService.requestPermissions();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[RemoteRepository] Error requesting notification permissions: $e');
      }
      return false;
    }
  }
}

// Data classes for proxy and ADB operations

class ProxyPort {
  final int port;
  final String name;
  final DateTime registeredAt;

  const ProxyPort({required this.port, required this.name, required this.registeredAt});
}

class ProxyListResponse {
  final bool enabled;
  final List<ProxyPort> ports;

  const ProxyListResponse({required this.enabled, required this.ports});
}

/// An available localhost service discovered by scanning
class AvailableService {
  final int port;
  final String name;

  const AvailableService({required this.port, required this.name});
}

/// Response from scanning for available localhost services
class ProxyScanResponse {
  final bool enabled;
  final List<AvailableService> available;

  const ProxyScanResponse({required this.enabled, required this.available});
}

class AdbDevice {
  final String id;
  final String state;
  final String? model;
  final String? product;

  const AdbDevice({required this.id, required this.state, this.model, this.product});

  bool get isOnline => state == 'device';
  String get displayName => model ?? product ?? id;
}

class AdbCommandResult {
  final bool success;
  final String stdout;
  final String stderr;
  final String? packageName;

  const AdbCommandResult({
    required this.success,
    required this.stdout,
    required this.stderr,
    this.packageName,
  });
}

class SearchResultFile {
  final String name;
  final String path;
  final String relativePath;
  final int size;

  const SearchResultFile({
    required this.name,
    required this.path,
    required this.relativePath,
    required this.size,
  });

  String get sizeFormatted {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class IosDevice {
  final String udid;
  final String name;
  final String osVersion;
  final String type; // 'physical' or 'simulator'

  const IosDevice({
    required this.udid,
    required this.name,
    required this.osVersion,
    required this.type,
  });

  bool get isPhysical => type == 'physical';
  String get displayName => name;
  String get subtitle => 'iOS $osVersion  •  ${isPhysical ? "Physical" : "Simulator"}';
}
