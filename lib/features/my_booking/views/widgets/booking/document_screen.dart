import 'package:flutter/material.dart';
import 'package:real_estate_app/core/constants/app_colors.dart';
import 'package:real_estate_app/core/constants/environments.dart';
import 'package:real_estate_app/features/my_booking/models/booking_detail_model.dart';
import 'package:real_estate_app/features/shared/widgets/app_pdf_viewer.dart';
import 'package:real_estate_app/features/shared/widgets/index.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumentScreen extends StatelessWidget {
  final List<DocumentItem> documents;
  final VoidCallback? onUploadDocument;
  const DocumentScreen({
    super.key,
    required this.documents,
    this.onUploadDocument,
  });

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Resolve relative URLs to absolute ones
  String _resolveUrl(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    if (raw.startsWith('http')) return raw;
    final base = Environments.baseUrl;
    if (base.endsWith('/') && raw.startsWith('/')) {
      return '$base${raw.substring(1)}';
    } else if (!base.endsWith('/') && !raw.startsWith('/')) {
      return '$base/$raw';
    }
    return '$base$raw';
  }

  /// Human-readable label for document_type
  String _documentTypeLabel(String? type) {
    switch (type) {
      case '360':
        return '360° View';
      case 'rera_certificate':
        return 'RERA Certificate';
      case 'floor_plan':
        return 'Floor Plan';
      case 'legal_noc':
        return 'Legal NOC';
      case 'ownership_proof':
        return 'Ownership Proof';
      default:
        return type?.replaceAll('_', ' ').toUpperCase() ?? 'Document';
    }
  }

  /// Derive a display filename from the URL
  String _fileName(String? url) {
    if (url == null || url.isEmpty) return 'Untitled';
    final segments = url.split('/');
    return segments.isNotEmpty ? segments.last : 'Untitled';
  }

  bool _isPdf(DocumentItem doc) =>
      doc.fileType == 'document' ||
      (doc.url?.toLowerCase().endsWith('.pdf') ?? false);

  bool _is360(DocumentItem doc) => doc.documentType == '360';

  /// Get document category
  String _getCategory(String? documentType) {
    switch (documentType) {
      case '360':
      case 'floor_plan':
        return 'Property Documents';
      case 'rera_certificate':
      case 'legal_noc':
      case 'ownership_proof':
        return 'Legal Documents';
      default:
        return 'Other Documents';
    }
  }

  /// Group documents by category
  Map<String, List<DocumentItem>> _groupByCategory(List<DocumentItem> docs) {
    final Map<String, List<DocumentItem>> grouped = {};
    for (final doc in docs) {
      final category = _getCategory(doc.documentType);
      grouped.putIfAbsent(category, () => []).add(doc);
    }
    return grouped;
  }

  Future<void> _downloadOrOpen(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Could not open link.')));
      }
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (documents.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        appBar: DefaultAppBar(title: 'Property Document'),
        body: const Center(child: Text('No documents available.')),
      );
    }

    final grouped = _groupByCategory(documents);
    final categories = grouped.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: DefaultAppBar(title: 'Property Document'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              itemCount: categories.length,
              itemBuilder: (context, categoryIndex) {
                final category = categories[categoryIndex];
                final categoryDocs = grouped[category]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Category Header ──────────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 12),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    // ── Category Documents ───────────────────────────────────────────
                    ...categoryDocs.asMap().entries.map((entry) {
                      final index = entry.key;
                      final doc = entry.value;
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == categoryDocs.length - 1 ? 24 : 12,
                        ),
                        child: _DocumentCard(
                          doc: doc,
                          resolvedUrl: _resolveUrl(doc.url),
                          typeLabel: _documentTypeLabel(doc.documentType),
                          fileName: _fileName(doc.url),
                          isPdf: _isPdf(doc),
                          is360: _is360(doc),
                          onDownload: () =>
                              _downloadOrOpen(context, _resolveUrl(doc.url)),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 100),
          // ── Upload Button ─────────────────────────────────────────────────────
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AppButton(
          text: "Upload Document",
          onPressed: () {},
          width: double.infinity,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// ─── Document Card ────────────────────────────────────────────────────────────

class _DocumentCard extends StatelessWidget {
  final DocumentItem doc;
  final String resolvedUrl;
  final String typeLabel;
  final String fileName;
  final bool isPdf;
  final bool is360;
  final VoidCallback onDownload;

  const _DocumentCard({
    required this.doc,
    required this.resolvedUrl,
    required this.typeLabel,
    required this.fileName,
    required this.isPdf,
    required this.is360,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Preview ───────────────────────────────────────────────────
            _PreviewSection(
              resolvedUrl: resolvedUrl,
              isPdf: isPdf,
              is360: is360,
            ),

            // ── Meta Row ─────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 14),
              child: Row(
                children: [
                  // Icon badge
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isPdf
                          ? Icons.picture_as_pdf_rounded
                          : is360
                          ? Icons.panorama_rounded
                          : Icons.image_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name + type
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          typeLabel,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          fileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Download / open button
                  GestureDetector(
                    onTap: onDownload,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.download_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Preview Section ──────────────────────────────────────────────────────────

class _PreviewSection extends StatelessWidget {
  final String resolvedUrl;
  final bool isPdf;
  final bool is360;

  const _PreviewSection({
    required this.resolvedUrl,
    required this.isPdf,
    required this.is360,
  });

  @override
  Widget build(BuildContext context) {
    const double previewHeight = 200;

    if (resolvedUrl.isEmpty) {
      return _PlaceholderPreview(height: previewHeight);
    }

    if (isPdf) {
      return SizedBox(
        height: previewHeight,
        child: AppPdfViewer(url: resolvedUrl, showDownloadButton: false),
      );
    }

    // Image (360 or floor plan image etc.)
    return Stack(
      children: [
        SizedBox(
          height: previewHeight,
          width: double.infinity,
          child: Image.network(
            resolvedUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                _PlaceholderPreview(height: previewHeight),
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Container(
                height: previewHeight,
                color: const Color(0xFFF0EEF8),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2,
                  ),
                ),
              );
            },
          ),
        ),
        if (is360)
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.threesixty, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text(
                    '360°',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ─── Placeholder ──────────────────────────────────────────────────────────────

class _PlaceholderPreview extends StatelessWidget {
  final double height;
  const _PlaceholderPreview({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: const Color(0xFFF0EEF8),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.insert_drive_file_rounded,
            size: 48,
            color: AppColors.primary,
          ),
          SizedBox(height: 8),
          Text(
            'Preview not available',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
