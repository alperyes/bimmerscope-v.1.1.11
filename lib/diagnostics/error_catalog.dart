/// Internal developer reference for connection and transport error IDs.
/// Do not display these descriptions directly in the user interface.
const connectionErrorCatalog = <String, String>{
  'NET-001': 'The connection or diagnostic request exceeded its timeout.',
  'NET-002': 'The target rejected the TCP connection.',
  'NET-003': 'The established TCP connection was reset or aborted.',
  'NET-004': 'The host route or network interface is unavailable.',
  'NET-005': 'The vehicle or simulator endpoint could not be reached.',
  'NET-999': 'An unclassified connection or transport error occurred.',
};
