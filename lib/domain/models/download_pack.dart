class DownloadPack {
  const DownloadPack({
    required this.id,
    required this.title,
    required this.area,
    required this.questionCount,
    this.isDownloaded = false,
  });

  final String id;
  final String title;
  final String area;
  final int questionCount;
  final bool isDownloaded;

  DownloadPack toggleDownloaded(bool value) {
    return DownloadPack(
      id: id,
      title: title,
      area: area,
      questionCount: questionCount,
      isDownloaded: value,
    );
  }
}
