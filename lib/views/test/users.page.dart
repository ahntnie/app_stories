// import 'package:flutter/material.dart';
// import 'package:stacked/stacked.dart';

// import '../../view_model/users.vm.dart';

// class UsersPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<UsersViewModel>.reactive(
//       viewModelBuilder: () => UsersViewModel(),
//       onViewModelReady: (viewModel) => viewModel.listenToUsers(),
//       builder: (context, viewModel, child) {
//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Danh sách người dùng'),
//           ),
//           body: viewModel.users.isEmpty
//               ? const Center(child: CircularProgressIndicator())
//               : ListView.builder(
//                   itemCount: viewModel.users.length,
//                   itemBuilder: (context, index) {
//                     final user = viewModel.users[index];
//                     return ListTile(
//                       title: Text(user.name),
//                       subtitle: Text(user.email),
//                     );
//                   },
//                 ),
//         );
//       },
//     );
//   }
// }
