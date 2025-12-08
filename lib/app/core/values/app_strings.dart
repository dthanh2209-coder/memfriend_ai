class AppStrings {
  // App
  static const String appName = 'app_name';

  // Navigation
  static const String home = 'home';
  static const String recognition = 'recognition';
  static const String settings = 'settings';

  // Person Management
  static const String personManagement = 'person_management';
  static const String personDetail = 'person_detail';
  static const String addPerson = 'add_person';
  static const String editPerson = 'edit_person';
  static const String deletePerson = 'delete_person';
  static const String searchPerson = 'search_person';
  static const String noPeopleFound = 'no_people_found';

  // Person Fields
  static const String name = 'name';
  static const String phone = 'phone';
  static const String address = 'address';
  static const String relation = 'relation';
  static const String note = 'note';
  static const String nameRequired = 'name_required';
  static const String enterName = 'enter_name';
  static const String enterPhone = 'enter_phone';
  static const String enterAddress = 'enter_address';
  static const String enterRelation = 'enter_relation';
  static const String enterNote = 'enter_note';

  // Face Management
  static const String face = 'face';
  static const String faces = 'faces';
  static const String addFace = 'add_face';
  static const String deleteFace = 'delete_face';
  static const String noFacesFound = 'no_faces_found';
  static const String faceAdded = 'face_added';
  static const String faceDeleted = 'face_deleted';
  static const String invalidFaceImage = 'invalid_face_image';

  // Memory Event Management
  static const String memoryEvent = 'memory_event';
  static const String memoryEvents = 'memory_events';
  static const String addMemoryEvent = 'add_memory_event';
  static const String editMemoryEvent = 'edit_memory_event';
  static const String deleteMemoryEvent = 'delete_memory_event';
  static const String memoryEventName = 'memory_event_name';
  static const String memoryEventContent = 'memory_event_content';
  static const String memoryEventImage = 'memory_event_image';
  static const String noMemoryEventsFound = 'no_memory_events_found';
  static const String memoryEventNameRequired = 'memory_event_name_required';
  static const String memoryEventImageRequired = 'memory_event_image_required';
  static const String enterEventName = 'enter_event_name';
  static const String enterEventDescription = 'enter_event_description';

  // Recognition
  static const String liveMode = 'live_mode';
  static const String imageMode = 'image_mode';
  static const String switchCamera = 'switch_camera';
  static const String takePhoto = 'take_photo';
  static const String selectFromGallery = 'select_from_gallery';
  static const String noPersonFound = 'no_person_found';
  static const String recognizing = 'recognizing';
  static const String tapToSelectImage = 'tap_to_select_image';

  // Actions
  static const String save = 'save';
  static const String cancel = 'cancel';
  static const String delete = 'delete';
  static const String edit = 'edit';
  static const String add = 'add';
  static const String search = 'search';
  static const String confirm = 'confirm';
  static const String ok = 'ok';
  static const String yes = 'yes';
  static const String no = 'no';

  // Messages
  static const String saveChanges = 'save_changes';
  static const String discardChanges = 'discard_changes';
  static const String confirmDelete = 'confirm_delete';
  static const String confirmDeletePerson = 'confirm_delete_person';
  static const String confirmDeleteFace = 'confirm_delete_face';
  static const String confirmDeleteMemoryEvent = 'confirm_delete_memory_event';
  static const String personSaved = 'person_saved';
  static const String personDeleted = 'person_deleted';
  static const String memoryEventSaved = 'memory_event_saved';
  static const String memoryEventDeleted = 'memory_event_deleted';
  static const String errorOccurred = 'error_occurred';
  static const String tryAgain = 'try_again';

  // Camera and Gallery
  static const String camera = 'camera';
  static const String gallery = 'gallery';
  static const String selectImageSource = 'select_image_source';
  static const String cameraPermissionDenied = 'camera_permission_denied';
  static const String storagePermissionDenied = 'storage_permission_denied';
  static const String permissionRequired = 'permission_required';
  static const String grantPermission = 'grant_permission';

  // Settings
  static const String language = 'language';
  static const String english = 'english';
  static const String vietnamese = 'vietnamese';
  static const String theme = 'theme';
  static const String lightTheme = 'light_theme';
  static const String darkTheme = 'dark_theme';
  static const String systemTheme = 'system_theme';
  static const String about = 'about';
  static const String version = 'version';
  static const String privacy = 'privacy';
  static const String termsOfService = 'terms_of_service';

  // Pronunciation (Vietnamese)
  static const String pronounceVietnamese = 'pronounce_vietnamese';
  static const String relationVietnamese = 'relation_vietnamese';

  // Additional UI strings
  static const String error = 'error';
  static const String success = 'success';
  static const String loading = 'loading';
  static const String refresh = 'refresh';
  static const String close = 'close';
  static const String back = 'back';
  static const String done = 'done';
  static const String next = 'next';
  static const String previous = 'previous';
  static const String retry = 'retry';
  static const String warning = 'warning';
  static const String information = 'information';
  static const String notAvailable = 'not_available';

  // Face management additional
  static const String tapToAddFaceImage = 'tap_to_add_face_image';
  static const String selectClearFacePhoto = 'select_clear_face_photo';
  static const String validatingFace = 'validating_face';
  static const String validFaceDetected = 'valid_face_detected';
  static const String faceNotClearlyDetected = 'face_not_clearly_detected';
  static const String faceDetectionWarning = 'face_detection_warning';
  static const String keepImage = 'keep_image';
  static const String tryAnother = 'try_another';
  static const String discardFace = 'discard_face';
  static const String discardFaceConfirmation = 'discard_face_confirmation';
  static const String discard = 'discard';

  // Memory management additional
  static const String addMemoryImage = 'add_memory_image';
  static const String tapToSelectMemoryImage = 'tap_to_select_memory_image';
  static const String memoryEventsCount = 'memory_events_count';
  static const String hideMemoryEvents = 'hide_memory_events';
  static const String showMemoryEvents = 'show_memory_events';

  // Person detail additional
  static const String confirmDeleteTitle = 'confirm_delete_title';
  static const String tapToViewDetails = 'tap_to_view_details';
  static const String switchMode = 'switch_mode';
  static const String switchCameraTooltip = 'switch_camera_tooltip';
  static const String flipCamera = 'flip_camera';

  // Recognition additional
  static const String tapCameraToRecognize = 'tap_camera_to_recognize';
  static const String selectImageToRecognize = 'select_image_to_recognize';
  static const String recognitionFailed = 'recognition_failed';
  static const String languageChanged = 'language_changed';
  static const String languageChangedMessage = 'language_changed_message';

  // Settings additional
  static const String aboutMemfriend = 'about_memfriend';
  static const String aboutDescription = 'about_description';
  static const String features = 'features';
  static const String featurePersonManagement = 'feature_person_management';
  static const String featureFaceRecognition = 'feature_face_recognition';
  static const String featureMemoryEvents = 'feature_memory_events';
  static const String featureVoicePronunciation = 'feature_voice_pronunciation';
  static const String privacyPolicy = 'privacy_policy';
  static const String dataStorage = 'data_storage';
  static const String dataStorageLocal = 'data_storage_local';
  static const String dataStorageNoServer = 'data_storage_no_server';
  static const String dataStorageLocalProcessing = 'data_storage_local_processing';
  static const String permissions = 'permissions';
  static const String permissionCamera = 'permission_camera';
  static const String permissionStorage = 'permission_storage';
  static const String dataSecurity = 'data_security';
  static const String dataSecurityPrivate = 'data_security_private';
  static const String dataSecurityNoCollection = 'data_security_no_collection';

  // Additional validation and error messages
  static const String invalidPersonData = 'invalid_person_data';
  static const String failedToPickImage = 'failed_to_pick_image';
  static const String failedToSavePerson = 'failed_to_save_person';
  static const String failedToDeletePerson = 'failed_to_delete_person';
  static const String failedToSaveFace = 'failed_to_save_face';
  static const String failedToDeleteFace = 'failed_to_delete_face';
  static const String failedToSaveMemoryEvent = 'failed_to_save_memory_event';
  static const String failedToDeleteMemoryEvent = 'failed_to_delete_memory_event';
  static const String failedToLoadPersons = 'failed_to_load_persons';
  static const String failedToLoadPersonDetails = 'failed_to_load_person_details';
  static const String failedToSaveImage = 'failed_to_save_image';
  static const String failedToProcessFaceImage = 'failed_to_process_face_image';
  static const String noResultsFound = 'no_results_found';
  static const String unsavedChangesWarning = 'unsaved_changes_warning';
}
