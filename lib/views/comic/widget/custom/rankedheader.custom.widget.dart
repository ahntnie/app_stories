import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/views/comic/widget/custom/items/ranked.items.widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RankedHeader extends StatelessWidget {
  const RankedHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => ComicViewModel(),
        onViewModelReady: (viewModel) {
          viewModel.viewContext = context;
          viewModel.init();
        },
        builder: (context, viewModel, child) {
          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(
                  labelColor: Colors.red,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'Top ngày'),
                    Tab(text: 'Top tuần'),
                    Tab(text: 'Top tháng'),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 1,
                  child: TabBarView(
                    children: [
                      Column(
                        children: List.generate(
                            viewModel.storiesIsActive.length, (index) {
                          return RankedItems(
                            tabName: 'Top ngày',
                            data: viewModel.storiesIsActive[index],
                            onTap: () {
                              viewModel.currentStory =
                                  viewModel.storiesIsActive[index];
                              viewModel.nextDetailStory();
                            },
                          );
                        }),
                      ),
                      Column(
                        children: List.generate(
                            viewModel.storiesIsActive.length, (index) {
                          return RankedItems(
                            tabName: 'Top tuần',
                            data: viewModel.storiesIsActive[index],
                            onTap: () {
                              viewModel.currentStory =
                                  viewModel.storiesIsActive[index];
                              viewModel.nextDetailStory();
                            },
                          );
                        }),
                      ),
                      Column(
                        children: List.generate(
                            viewModel.storiesIsActive.length, (index) {
                          return RankedItems(
                            tabName: 'Top tháng',
                            data: viewModel.storiesIsActive[index],
                            onTap: () {
                              viewModel.currentStory =
                                  viewModel.storiesIsActive[index];
                              viewModel.nextDetailStory();
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Xem thêm >'),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
