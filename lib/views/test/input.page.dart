import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../view_model/input.vm.dart';

class InputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InputViewModel>.reactive(
      viewModelBuilder: () => InputViewModel(),
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Nhập tên và email'),
            actions: [
              IconButton(
                icon: const Icon(Icons.list),
                onPressed: () {
                  Navigator.pushNamed(context, '/users');
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: viewModel.setName,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  onChanged: viewModel.setEmail,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: viewModel.addUser,
                  child: const Text('Thêm người dùng'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
