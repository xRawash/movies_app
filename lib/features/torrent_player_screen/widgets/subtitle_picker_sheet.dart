import 'package:flutter/material.dart';

import 'package:movies_app/api/movie_detailed_response/movie.dart';
import 'package:movies_app/api/subdl_response/subdl_subtitle.dart';
import 'package:movies_app/core/sources/colors_manager.dart';
import 'package:movies_app/view_models/subtitle_view_model/subtitle_view_model.dart';

class SubtitlePickerSheet extends StatefulWidget {
  const SubtitlePickerSheet({
    super.key,
    required this.viewModel,
    required this.movie,
    required this.onSelected,
  });

  final SubtitleViewModel viewModel;
  final Movie movie;
  final Future<void> Function() onSelected;

  @override
  State<SubtitlePickerSheet> createState() =>
      _SubtitlePickerSheetState();
}

class _SubtitlePickerSheetState
    extends State<SubtitlePickerSheet> {
  String _language = 'EN';

  @override
  void initState() {
    super.initState();

    _search();
  }

  Future<void> _search() async {
    await widget.viewModel.searchSubtitles(
      title: widget.movie.title ?? '',
      year: widget.movie.year?.toInt() ?? 0,
      imdbId: widget.movie.imdbCode,
      language: _language,
    );
  }

  Future<void> _download(SubdlSubtitle subtitle) async {
    final success = await widget.viewModel.downloadSubtitle(
      subtitle,
    );

    if (!mounted) return;

    if (success) {
      await widget.onSelected();

      if (!mounted) return;

      Navigator.pop(context);
    }
  }

  Future<void> _turnOff() async {
    widget.viewModel.turnOffSubtitles();

    await widget.onSelected();

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Subtitles',
                style: Theme.of(context).textTheme.labelMedium,
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _language,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.grey),
                decoration:  InputDecoration(
                  labelText: 'Language',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'EN',
                    child: Text('English'),
                  ),
                  DropdownMenuItem(
                    value: 'AR',
                    child: Text('Arabic'),
                  ),
                  DropdownMenuItem(
                    value: 'FR',
                    child: Text('French'),
                  ),
                  DropdownMenuItem(
                    value: 'ES',
                    child: Text('Spanish'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;

                  setState(() {
                    _language = value;
                  });

                  _search();
                },
              ),

              const SizedBox(height: 12),

              ListenableBuilder(
                listenable: widget.viewModel,
                builder: (context, _) {
                  final vm = widget.viewModel;

                  if (vm.isLoading) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (vm.errorMessage != null) {
                    return Expanded(
                      child: Center(
                        child: Text(
                          vm.errorMessage!,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  if (vm.subtitles.isEmpty) {
                    return const Expanded(
                      child: Center(
                        child: Text('No subtitles found.'),
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.separated(
                      itemCount: vm.subtitles.length,
                      separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final subtitle = vm.subtitles[index];

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            subtitle.releaseName.isNotEmpty
                                ? subtitle.releaseName
                                : subtitle.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          subtitle: Text(
                            '${subtitle.language}'
                                '${subtitle.hearingImpaired ? ' • Hearing impaired' : ''}'
                                ' • ${subtitle.format.toUpperCase()}',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: ColorsManager.grey),
                          ),
                          trailing: vm.isDownloading
                              ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                              : IconButton(
                            icon: const Icon(
                              Icons.download,
                            ),
                            onPressed: () {
                              _download(subtitle);
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _turnOff,
                  child:  Text('Turn subtitles off', style: Theme.of(context).textTheme.labelMedium,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}