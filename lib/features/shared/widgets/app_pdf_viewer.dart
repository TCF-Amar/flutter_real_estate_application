import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:real_estate_app/core/constants/environments.dart';
import 'package:real_estate_app/core/networks/dio_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class AppPdfViewer extends StatefulWidget {
  final String url;
  final bool showDownloadButton;

  const AppPdfViewer({
    super.key,
    required this.url,
    this.showDownloadButton = true,
  });

  @override
  AppPdfViewerState createState() => AppPdfViewerState();
}

class AppPdfViewerState extends State<AppPdfViewer> {
  String? localPath;
  String? finalNetworkUrl;
  bool isDownloading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _downloadAndSavePdf();
  }

  Future<void> _downloadAndSavePdf() async {
    setState(() {
      isDownloading = true;
    });

    try {
      String finalUrl = widget.url;
      if (!finalUrl.startsWith('http') &&
          !finalUrl.startsWith('assets/') &&
          !finalUrl.startsWith('/data/user/')) {
        final bUrl = Environments.baseUrl;
        if (bUrl.endsWith('/') && finalUrl.startsWith('/')) {
          finalUrl = "$bUrl${finalUrl.substring(1)}";
        } else if (!bUrl.endsWith('/') && !finalUrl.startsWith('/')) {
          finalUrl = "$bUrl/$finalUrl";
        } else {
          finalUrl = "$bUrl$finalUrl";
        }
      }

      finalNetworkUrl = finalUrl;

      if (finalUrl.startsWith('http')) {
        final dir = await getTemporaryDirectory();

        final fileName = 'pdf_view_${finalUrl.hashCode}.pdf';
        final savePath = '${dir.path}/$fileName';

        if (await File(savePath).exists()) {
          if (mounted) {
            setState(() {
              localPath = savePath;
              isDownloading = false;
            });
          }
          return;
        }

        final dioHelper = Get.find<DioHelper>();
        await dioHelper.dioClient.dio.download(finalUrl, savePath);

        if (mounted) {
          setState(() {
            localPath = savePath;
            isDownloading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            localPath = finalUrl;
            isDownloading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = "Error loading PDF: $e";
          isDownloading = false;
        });
      }
    }
  }

  Future<void> _downloadPdfExternally() async {
    if (finalNetworkUrl == null) return;

    final uri = Uri.parse(finalNetworkUrl!);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open download link.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isDownloading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (localPath != null) {
      return Stack(
        children: [
          PDFView(
            filePath: localPath,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
            backgroundColor: Colors.transparent,
            onRender: (pages) {},
            onError: (error) {
              debugPrint("PDF Error: $error");
            },
            onPageError: (page, error) {
              debugPrint('PDF Page $page Error: $error');
            },
          ),
          if (widget.showDownloadButton &&
              finalNetworkUrl != null &&
              finalNetworkUrl!.startsWith('http'))
            Positioned(
              bottom: 12,
              right: 12,
              child: FloatingActionButton(
                mini: true,
                heroTag: null, // Prevents errors if multiple are on screen
                onPressed: _downloadPdfExternally,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(
                  Icons.download,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      );
    }

    return const Center(child: Text("Could not load PDF"));
  }
}
