class ApiEndpoints {
  static const String status = '/api/status';
  static const String config = '/api/config';
  
  // Agent endpoints
  static const String createConversation = '/api/agent/create-conversation';
  static const String sendMessage = '/api/agent/send-message';
  static const String abort = '/api/agent/abort';
  static const String closeConversation = '/api/agent/close-conversation';
  static const String conversations = '/api/agent/conversations';
  static const String events = '/api/agent/events';
  static const String respondPermission = '/api/agent/respond-permission';
  static const String respondUserInput = '/api/agent/respond-user-input';
  
  // File endpoints
  static const String readFile = '/api/files/read';
  static const String writeFile = '/api/files/write';
  static const String editFile = '/api/files/edit';
  static const String listFiles = '/api/files/list';
  static const String mkdir = '/api/files/mkdir';
  
  // Terminal endpoints
  static const String createTerminal = '/api/terminal/create';
  static const String writeTerminal = '/api/terminal/write';
  static const String resizeTerminal = '/api/terminal/resize';
  static const String destroyTerminal = '/api/terminal/destroy';
  static const String terminalStream = '/api/terminal/stream';
  
  // Tool endpoints
  static const String listTools = '/api/tools/list';
  static const String executeTool = '/api/tools/execute';

  // Workspace endpoints
  static const String workspaces = '/api/workspaces';
  static const String activeWorkspace = '/api/workspaces/active';
  static const String projects = '/api/projects';

  // Chat history endpoints
  static const String listChats = '/api/chat/list';
  static const String loadChat = '/api/chat/load';

  // Message modification endpoints
  static const String truncateMessages = '/api/agent/truncate-messages';
  static const String gitReset = '/api/git/reset';
  static const String gitDiff = '/api/git/diff';
  static const String gitStatus = '/api/git/status';
  static const String setMode = '/api/agent/set-mode';
  static const String switchModel = '/api/agent/switch-model';

  // Model endpoints
  static const String models = '/api/models';
  static const String providers = '/api/providers';

  // Proxy endpoints (reverse proxy to host localhost services)
  static const String proxyList = '/api/proxy/list';
  static const String proxyRegister = '/api/proxy/register';
  static const String proxyScan = '/api/proxy/scan';
  static const String proxyBase = '/api/proxy';

  // ADB / device management endpoints
  static const String adbDevices = '/api/adb/devices';
  static const String adbInstall = '/api/adb/install';
  static const String adbLaunch = '/api/adb/launch';
  static const String adbWirelessPair = '/api/adb/wireless-pair';
  static const String adbLogcat = '/api/adb/logcat';

  // Binary file download
  static const String downloadFile = '/api/files/download';

  // File search (recursive)
  static const String searchFiles = '/api/files/search';

  // File delete
  static const String deleteFile = '/api/files/delete';

  // iOS / device management endpoints
  static const String iosDevices = '/api/ios/devices';
  static const String iosInstall = '/api/ios/install';

  // Change Review endpoints
  static const String setChangeReview = '/api/agent/set-change-review';
  static const String changeReviewStatus = '/api/agent/change-review-status';
  static const String pendingChanges = '/api/changes/pending';
  static const String respondToChange = '/api/changes/respond';
  static const String acceptAllChanges = '/api/changes/accept-all';
  static const String rejectAllChanges = '/api/changes/reject-all';
}

class StorageKeys {
  static const String serverUrl = 'server_url';
  static const String apiKey = 'api_key';
  static const String lastConnectedAt = 'last_connected_at';
  static const String conversationId = 'conversation_id';
  static const String settings = 'settings';
  static const String currentWorkspaceId = 'currentWorkspaceId';
  static const String selectedModel = 'selected_model';
  static const String selectedProvider = 'selected_provider';
  static const String selectedAiMode = 'selected_ai_mode';
}

class AppConstants {
  static const String appName = 'Omni Go';
  static const String appVersion = '1.0.0';
  static const int defaultPort = 3000;
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sseRetryDelay = 3000;
}

class Routes {
  static const String connect = '/connect';
  static const String home = '/home';
  static const String chat = '/chat';
  static const String files = '/files';
  static const String terminal = '/terminal';
  static const String settings = '/settings';
}
