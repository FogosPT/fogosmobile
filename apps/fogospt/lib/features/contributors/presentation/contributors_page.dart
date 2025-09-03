import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder;
import 'package:fogospt/features/contributors/application/cubit/contributors_cubit.dart';

class ContributorsPage extends StatelessWidget {
  const ContributorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContributorsCubit, ContributorsState>(
      builder: (context, state) {
        switch (state.runtimeType) {
          case ContributorsInitial:
            return const Center(child: CircularProgressIndicator());
          case ContributorsLoaded:
            final contributors = (state as ContributorsLoaded).contributors;
            return ListView.builder(
              itemCount: contributors.length,
              itemBuilder: (context, index) {
                final contributor = contributors[index];
                return ListTile(
                  title: Text(contributor.name),
                  subtitle: Text(contributor.bio),
                );
              },
            );
          case ContributorsError:
            final error = (state as ContributorsError).error;
            return Center(child: Text('Error: $error'));
          default:
            return const Center(child: Text('Unknown state'));
        }
      },
    );
  }
}
