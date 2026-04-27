class MaterialAttachmentItem {
  final String path;
  final bool isFile;
  final bool isNetwork;

  const MaterialAttachmentItem({
    required this.path,
    required this.isFile,
    this.isNetwork = false,
  });

  factory MaterialAttachmentItem.file(String path) {
    return MaterialAttachmentItem(path: path, isFile: true);
  }

  factory MaterialAttachmentItem.asset(String path) {
    return MaterialAttachmentItem(path: path, isFile: false);
  }

  factory MaterialAttachmentItem.network(String path) {
    return MaterialAttachmentItem(path: path, isFile: false, isNetwork: true);
  }
}
