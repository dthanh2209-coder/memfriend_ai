import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      // App
      'app_name': 'MemFriend',

      // Navigation
      'home': 'Home',
      'recognition': 'Recognition',
      'settings': 'Settings',

      // Person Management
      'person_management': 'MemFriend',
      'person_detail': 'Person Detail',
      'add_person': 'Add Person',
      'edit_person': 'Edit Person',
      'delete_person': 'Delete Person',
      'search_person': 'Search Person',
      'no_people_found': 'No people found',

      // Person Fields
      'name': 'Name',
      'phone': 'Phone',
      'address': 'Address',
      'relation': 'Relation',
      'note': 'Note',
      'name_required': 'Name is required',
      'enter_name': 'Enter name',
      'enter_phone': 'Enter phone number',
      'enter_address': 'Enter address',
      'enter_relation': 'Enter relation',
      'enter_note': 'Enter note',

      // Face Management
      'face': 'Face',
      'faces': 'Faces',
      'add_face': 'Add Face',
      'delete_face': 'Delete Face',
      'no_faces_found': 'No faces found',
      'face_added': 'Face added successfully',
      'face_deleted': 'Face deleted successfully',
      'invalid_face_image':
          'Invalid face image. Please select a clear face photo.',

      // Memory Event Management
      'memory_event': 'Memory Event',
      'memory_events': 'Memory Events',
      'add_memory_event': 'Add Memory Event',
      'edit_memory_event': 'Edit Memory Event',
      'delete_memory_event': 'Delete Memory Event',
      'memory_event_name': 'Event',
      'memory_event_content': 'Event Content',
      'memory_event_image': 'Event Image',
      'no_memory_events_found': 'No memory events found',
      'memory_event_name_required': 'Event content is required',
      'memory_event_image_required': 'Event image is required',
      'enter_event_name': 'Enter event content',
      'enter_event_description': 'Enter event content',

      // Recognition
      'live_mode': 'Live Mode',
      'image_mode': 'Image Mode',
      'switch_camera': 'Switch Camera',
      'take_photo': 'Take Photo',
      'select_from_gallery': 'Select from Gallery',
      'no_person_found': 'No person found',
      'recognizing': 'Recognizing...',
      'tap_to_select_image': 'Tap to select image',

      // Actions
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'add': 'Add',
      'search': 'Search',
      'confirm': 'Confirm',
      'ok': 'OK',
      'yes': 'Yes',
      'no': 'No',

      // Messages
      'save_changes': 'Save changes?',
      'discard_changes': 'Discard changes?',
      'confirm_delete': 'Are you sure you want to delete this?',
      'confirm_delete_person':
          'Are you sure you want to delete this person? This will also delete all associated faces and memory events.',
      'confirm_delete_face': 'Are you sure you want to delete this face?',
      'confirm_delete_memory_event':
          'Are you sure you want to delete this memory event?',
      'person_saved': 'Person saved successfully',
      'person_deleted': 'Person deleted successfully',
      'memory_event_saved': 'Memory event saved successfully',
      'memory_event_deleted': 'Memory event deleted successfully',
      'error_occurred': 'An error occurred',
      'try_again': 'Try again',

      // Camera and Gallery
      'camera': 'Camera',
      'gallery': 'Gallery',
      'select_image_source': 'Select Image Source',
      'camera_permission_denied': 'Camera permission denied',
      'storage_permission_denied': 'Storage permission denied',
      'permission_required': 'Permission required',
      'grant_permission': 'Grant Permission',

      // Settings
      'language': 'Language',
      'english': 'English',
      'vietnamese': 'Tiếng Việt',
      'theme': 'Theme',
      'light_theme': 'Light',
      'dark_theme': 'Dark',
      'system_theme': 'System',
      'about': 'About',
      'version': 'Version',
      'privacy': 'Privacy',
      'terms_of_service': 'Terms of Service',

      // Pronunciation
      'pronounce_vietnamese': 'This is ',
      'relation_vietnamese': ', relation: ',

      // Additional UI strings
      'error': 'Error',
      'success': 'Success',
      'loading': 'Loading',
      'refresh': 'Refresh',
      'close': 'Close',
      'back': 'Back',
      'done': 'Done',
      'next': 'Next',
      'previous': 'Previous',
      'retry': 'Retry',
      'warning': 'Warning',
      'information': 'Information',
      'not_available': 'N/A',

      // Face management additional
      'tap_to_add_face_image': 'Tap to add face image',
      'select_clear_face_photo': 'Select a clear photo of the person\'s face',
      'validating_face': 'Validating face...',
      'valid_face_detected': 'Valid face detected',
      'face_not_clearly_detected': 'Face not clearly detected',
      'face_detection_warning':
          'The image may not contain a clear face. You can still save it, but recognition may not work well.',
      'keep_image': 'Keep Image',
      'try_another': 'Try Another',
      'discard_face': 'Discard Face?',
      'discard_face_confirmation':
          'Are you sure you want to discard this face image?',
      'discard': 'Discard',

      // Memory management additional
      'add_memory_image': 'Add Memory Image',
      'tap_to_select_memory_image': 'Tap to select an image for this memory',
      'memory_events_count': 'Memory Events',
      'hide_memory_events': 'Hide Memory Events',
      'show_memory_events': 'Show Memory Events',

      // Person detail additional
      'confirm_delete_title': 'Confirm Delete',
      'tap_to_view_details': 'Tap to view details',
      'switch_mode': 'Switch Mode',
      'switch_camera_tooltip': 'Switch Camera',
      'flip_camera': 'Flip Camera',

      // Recognition additional
      'tap_camera_to_recognize': 'Tap the camera button to recognize',
      'select_image_to_recognize': 'Select an image to recognize',
      'recognition_failed': 'Recognition failed',
      'language_changed': 'Language Changed',
      'language_changed_message': 'Language has been changed to',

      // Settings additional
      'about_memfriend': 'About MemFriend',
      'about_description':
          'A memory app that helps older people with memory problems to remember and recognize their friends and family.',
      'features': 'Features:',
      'feature_person_management': '• Person management',
      'feature_face_recognition': '• Face recognition',
      'feature_memory_events': '• Memory events',
      'feature_voice_pronunciation': '• Voice pronunciation',
      'privacy_policy': 'Privacy Policy',
      'data_storage': 'Data Storage',
      'data_storage_local': '• All data is stored locally on your device',
      'data_storage_no_server': '• No data is sent to external servers',
      'data_storage_local_processing':
          '• Face recognition is processed locally',
      'permissions': 'Permissions',
      'permission_camera': '• Camera: For taking photos and live recognition',
      'permission_storage': '• Storage: For saving photos and app data',
      'data_security': 'Data Security',
      'data_security_private': '• Your data remains private and secure',
      'data_security_no_collection': '• No personal information is collected',

      // Additional validation and error messages
      'invalid_person_data': 'Invalid person data',
      'failed_to_pick_image': 'Failed to pick image',
      'failed_to_save_person': 'Failed to save person',
      'failed_to_delete_person': 'Failed to delete person',
      'failed_to_save_face': 'Failed to save face',
      'failed_to_delete_face': 'Failed to delete face',
      'failed_to_save_memory_event': 'Failed to save memory event',
      'failed_to_delete_memory_event': 'Failed to delete memory event',
      'failed_to_load_persons': 'Failed to load persons',
      'failed_to_load_person_details': 'Failed to load person details',
      'failed_to_save_image': 'Failed to save image',
      'failed_to_process_face_image': 'Failed to process face image',
      'no_results_found': 'No results found for',
      'unsaved_changes_warning':
          'You have unsaved changes. Are you sure you want to discard them?',
    },
    'vi_VN': {
      // App
      'app_name': 'MemFriend',

      // Navigation
      'home': 'Trang chủ',
      'recognition': 'Nhận diện',
      'settings': 'Cài đặt',

      // Person Management
      'person_management': 'MemFriend',
      'person_detail': 'Chi tiết người',
      'add_person': 'Thêm người',
      'edit_person': 'Sửa thông tin',
      'delete_person': 'Xóa người',
      'search_person': 'Tìm kiếm',
      'no_people_found': 'Không tìm thấy ai',

      // Person Fields
      'name': 'Tên',
      'phone': 'Điện thoại',
      'address': 'Địa chỉ',
      'relation': 'Quan hệ',
      'note': 'Ghi chú',
      'name_required': 'Tên là bắt buộc',
      'enter_name': 'Nhập tên',
      'enter_phone': 'Nhập số điện thoại',
      'enter_address': 'Nhập địa chỉ',
      'enter_relation': 'Nhập quan hệ',
      'enter_note': 'Nhập ghi chú',

      // Face Management
      'face': 'Khuôn mặt',
      'faces': 'Khuôn mặt',
      'add_face': 'Thêm khuôn mặt',
      'delete_face': 'Xóa khuôn mặt',
      'no_faces_found': 'Không có khuôn mặt',
      'face_added': 'Đã thêm khuôn mặt',
      'face_deleted': 'Đã xóa khuôn mặt',
      'invalid_face_image':
          'Hình ảnh khuôn mặt không hợp lệ. Vui lòng chọn ảnh khuôn mặt rõ ràng.',

      // Memory Event Management
      'memory_event': 'Sự kiện kỷ niệm',
      'memory_events': 'Sự kiện kỷ niệm',
      'add_memory_event': 'Thêm kỷ niệm',
      'edit_memory_event': 'Sửa kỷ niệm',
      'delete_memory_event': 'Xóa kỷ niệm',
      'memory_event_name': 'Nội dung',
      'memory_event_content': 'Mô tả sự kiện',
      'memory_event_image': 'Hình ảnh sự kiện',
      'no_memory_events_found': 'Không có kỷ niệm nào',
      'memory_event_name_required': 'Nội dung là bắt buộc',
      'memory_event_image_required': 'Hình ảnh sự kiện là bắt buộc',
      'enter_event_name': 'Nhập nội dung',
      'enter_event_description': 'Nhập mô tả sự kiện',

      // Recognition
      'live_mode': 'Chế độ trực tiếp',
      'image_mode': 'Chế độ hình ảnh',
      'switch_camera': 'Chuyển camera',
      'take_photo': 'Chụp ảnh',
      'select_from_gallery': 'Chọn từ thư viện',
      'no_person_found': 'Không tìm thấy người nào',
      'recognizing': 'Đang nhận diện...',
      'tap_to_select_image': 'Chạm để chọn hình ảnh',

      // Actions
      'save': 'Lưu',
      'cancel': 'Hủy',
      'delete': 'Xóa',
      'edit': 'Sửa',
      'add': 'Thêm',
      'search': 'Tìm kiếm',
      'confirm': 'Xác nhận',
      'ok': 'OK',
      'yes': 'Có',
      'no': 'Không',

      // Messages
      'save_changes': 'Lưu thay đổi?',
      'discard_changes': 'Bỏ thay đổi?',
      'confirm_delete': 'Bạn có chắc muốn xóa?',
      'confirm_delete_person':
          'Bạn có chắc muốn xóa người này? Điều này cũng sẽ xóa tất cả khuôn mặt và kỷ niệm liên quan.',
      'confirm_delete_face': 'Bạn có chắc muốn xóa khuôn mặt này?',
      'confirm_delete_memory_event': 'Bạn có chắc muốn xóa kỷ niệm này?',
      'person_saved': 'Đã lưu thông tin người',
      'person_deleted': 'Đã xóa người',
      'memory_event_saved': 'Đã lưu kỷ niệm',
      'memory_event_deleted': 'Đã xóa kỷ niệm',
      'error_occurred': 'Đã xảy ra lỗi',
      'try_again': 'Thử lại',

      // Camera and Gallery
      'camera': 'Camera',
      'gallery': 'Thư viện',
      'select_image_source': 'Chọn nguồn hình ảnh',
      'camera_permission_denied': 'Quyền camera bị từ chối',
      'storage_permission_denied': 'Quyền lưu trữ bị từ chối',
      'permission_required': 'Cần quyền truy cập',
      'grant_permission': 'Cấp quyền',

      // Settings
      'language': 'Ngôn ngữ',
      'english': 'English',
      'vietnamese': 'Tiếng Việt',
      'theme': 'Giao diện',
      'light_theme': 'Sáng',
      'dark_theme': 'Tối',
      'system_theme': 'Hệ thống',
      'about': 'Giới thiệu',
      'version': 'Phiên bản',
      'privacy': 'Quyền riêng tư',
      'terms_of_service': 'Điều khoản dịch vụ',

      // Pronunciation
      'pronounce_vietnamese': 'Đây là ',
      'relation_vietnamese': ', quan hệ: ',

      // Additional UI strings
      'error': 'Lỗi',
      'success': 'Thành công',
      'loading': 'Đang tải',
      'refresh': 'Làm mới',
      'close': 'Đóng',
      'back': 'Quay lại',
      'done': 'Hoàn thành',
      'next': 'Tiếp theo',
      'previous': 'Trước',
      'retry': 'Thử lại',
      'warning': 'Cảnh báo',
      'information': 'Thông tin',
      'not_available': 'Không có',

      // Face management additional
      'tap_to_add_face_image': 'Chạm để thêm ảnh khuôn mặt',
      'select_clear_face_photo': 'Chọn ảnh khuôn mặt rõ ràng của người này',
      'validating_face': 'Đang xác thực khuôn mặt...',
      'valid_face_detected': 'Đã phát hiện khuôn mặt hợp lệ',
      'face_not_clearly_detected': 'Không phát hiện rõ khuôn mặt',
      'face_detection_warning':
          'Hình ảnh có thể không chứa khuôn mặt rõ ràng. Bạn vẫn có thể lưu, nhưng việc nhận diện có thể không hoạt động tốt.',
      'keep_image': 'Giữ hình ảnh',
      'try_another': 'Thử ảnh khác',
      'discard_face': 'Bỏ khuôn mặt?',
      'discard_face_confirmation': 'Bạn có chắc muốn bỏ ảnh khuôn mặt này?',
      'discard': 'Bỏ',

      // Memory management additional
      'add_memory_image': 'Thêm ảnh kỷ niệm',
      'tap_to_select_memory_image': 'Chạm để chọn ảnh cho kỷ niệm này',
      'memory_events_count': 'Sự kiện kỷ niệm',
      'hide_memory_events': 'Ẩn sự kiện kỷ niệm',
      'show_memory_events': 'Hiển thị sự kiện kỷ niệm',

      // Person detail additional
      'confirm_delete_title': 'Xác nhận xóa',
      'tap_to_view_details': 'Chạm để xem chi tiết',
      'switch_mode': 'Chuyển chế độ',
      'switch_camera_tooltip': 'Chuyển camera',
      'flip_camera': 'Lật camera',

      // Recognition additional
      'tap_camera_to_recognize': 'Chạm nút camera để nhận diện',
      'select_image_to_recognize': 'Chọn ảnh để nhận diện',
      'recognition_failed': 'Nhận diện thất bại',
      'language_changed': 'Đã đổi ngôn ngữ',
      'language_changed_message': 'Ngôn ngữ đã được thay đổi thành',

      // Settings additional
      'about_memfriend': 'Về MemFriend',
      'about_description':
          'Ứng dụng trí nhớ giúp người lớn tuổi có vấn đề về trí nhớ nhớ và nhận diện bạn bè và gia đình.',
      'features': 'Tính năng:',
      'feature_person_management': '• Quản lý người thân',
      'feature_face_recognition': '• Nhận diện khuôn mặt',
      'feature_memory_events': '• Sự kiện kỷ niệm',
      'feature_voice_pronunciation': '• Phát âm giọng nói',
      'privacy_policy': 'Chính sách bảo mật',
      'data_storage': 'Lưu trữ dữ liệu',
      'data_storage_local':
          '• Tất cả dữ liệu được lưu trữ cục bộ trên thiết bị',
      'data_storage_no_server':
          '• Không có dữ liệu nào được gửi lên máy chủ bên ngoài',
      'data_storage_local_processing':
          '• Nhận diện khuôn mặt được xử lý cục bộ',
      'permissions': 'Quyền truy cập',
      'permission_camera': '• Camera: Để chụp ảnh và nhận diện trực tiếp',
      'permission_storage': '• Lưu trữ: Để lưu ảnh và dữ liệu ứng dụng',
      'data_security': 'Bảo mật dữ liệu',
      'data_security_private': '• Dữ liệu của bạn được giữ riêng tư và an toàn',
      'data_security_no_collection': '• Không thu thập thông tin cá nhân',

      // Additional validation and error messages
      'invalid_person_data': 'Dữ liệu người không hợp lệ',
      'failed_to_pick_image': 'Không thể chọn hình ảnh',
      'failed_to_save_person': 'Không thể lưu thông tin người',
      'failed_to_delete_person': 'Không thể xóa người',
      'failed_to_save_face': 'Không thể lưu khuôn mặt',
      'failed_to_delete_face': 'Không thể xóa khuôn mặt',
      'failed_to_save_memory_event': 'Không thể lưu sự kiện kỷ niệm',
      'failed_to_delete_memory_event': 'Không thể xóa sự kiện kỷ niệm',
      'failed_to_load_persons': 'Không thể tải danh sách người',
      'failed_to_load_person_details': 'Không thể tải chi tiết người',
      'failed_to_save_image': 'Không thể lưu hình ảnh',
      'failed_to_process_face_image': 'Không thể xử lý ảnh khuôn mặt',
      'no_results_found': 'Không tìm thấy kết quả cho',
      'unsaved_changes_warning':
          'Bạn có thay đổi chưa lưu. Bạn có chắc muốn bỏ qua chúng?',
    },
  };
}
