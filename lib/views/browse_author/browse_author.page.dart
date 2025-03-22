import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:app_stories/utils/build_context_extension.dart';
import 'package:app_stories/view_model/browse_author.vm.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:app_stories/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';
import '../../constants/app_color.dart';

class BrowseAuthorPage extends StatefulWidget {
  const BrowseAuthorPage({super.key});

  @override
  State<BrowseAuthorPage> createState() => _BrowseAuthorPageState();
}

class _BrowseAuthorPageState extends State<BrowseAuthorPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh(BrowseAuthorViewModel viewModel) async {
    await viewModel.getAuthorNotActive();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BrowseAuthorViewModel>.reactive(
      viewModelBuilder: () => BrowseAuthorViewModel(context: context),
      onViewModelReady: (viewModel) => viewModel.getAuthorNotActive(),
      builder: (context, viewModel, child) {
        return BasePage(
          isLoading: viewModel.isBusy,
          showAppBar: true,
          title: 'Phê duyệt tác giả',
          body: SmartRefresher(
            controller: _refreshController,
            onRefresh: () => _onRefresh(viewModel),
            child: viewModel.authorNotActive.isEmpty
                ? Center(
                    child: Text(
                      'Chưa có tác giả cần phê duyệt',
                      style: AppTheme.titleExtraLarge24,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    itemCount: viewModel.authorNotActive.length,
                    itemBuilder: (context, index) {
                      final author = viewModel.authorNotActive[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: context.primaryTextColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabelUser('Tên tác giả:', author.name),
                              const SizedBox(height: 8),
                              _buildLabelUser('Email:', author.email),
                              const SizedBox(height: 8),
                              _buildLabelUser(
                                  'Ngày sinh:', author.birthDate.toString()),
                              const SizedBox(height: 8),
                              _buildLabelUser('Bút danh:', author.penName),
                              const SizedBox(height: 8),
                              _buildLabelUser(
                                  'Tác phẩm trước đây:', author.previousWorks),
                              const SizedBox(height: 8),
                              _buildLabelUser('Mô tả:', author.bio),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerRight,
                                child: CustomButton(
                                  color: AppColors.watermelon70,
                                  title: Text('Phê duyệt',
                                      style: AppTheme.titleMedium18),
                                  onPressed: () {
                                    print('Nhấn phê duyệt: ${author.id}');
                                    viewModel.approveAuthor(author.id);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  Widget _buildLabelUser(String label, String text) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: '$label ', style: AppTheme.titleLarge20),
          TextSpan(
              text: text.isEmpty ? 'Không có' : text,
              style: AppTheme.bodyLarge16),
        ],
      ),
    );
  }
}
