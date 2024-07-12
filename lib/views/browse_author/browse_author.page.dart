import 'package:app_stories/view_model/browse_author.vm.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:app_stories/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../constants/app_color.dart';

class BrowseAuthorPage extends StatefulWidget {
  const BrowseAuthorPage({super.key});

  @override
  State<BrowseAuthorPage> createState() => _BrowseAuthorPageState();
}

class _BrowseAuthorPageState extends State<BrowseAuthorPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => BrowseAuthorViewModel(context: context),
      onViewModelReady: (viewModel) {
        viewModel.getAuthorNotActive();
      },
      builder: (context, viewModel, child) {
        return BasePage(
          isLoading: viewModel.isBusy,
          showAppBar: true,
          title: 'Phê duyệt tác giả',
          body: ListView.builder(
            itemCount: viewModel.authorNotActive.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColor.buttonColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    LabelUser(
                        'Tên tác giả: ', viewModel.authorNotActive[index].name),
                    LabelUser(
                        'Email: ', viewModel.authorNotActive[index].email),
                    LabelUser('Ngày sinh: ',
                        viewModel.authorNotActive[index].birthDate.toString()),
                    LabelUser(
                        'Bút danh: ', viewModel.authorNotActive[index].penName),
                    LabelUser('Đường dẫn các tác phẩm (Nếu có): ',
                        viewModel.authorNotActive[index].previousWorks),
                    LabelUser('Mô tả: ', viewModel.authorNotActive[index].bio),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomButton(
                          color: AppColor.primary,
                          title: Text(
                            'Phê duyệt',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            print('Nhấn phê duyệt');
                            viewModel.approveAuthor(
                                viewModel.authorNotActive[index].id);
                          }),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Row LabelUser(String label, String text) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
