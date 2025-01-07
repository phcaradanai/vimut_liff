part of 'jobs_view.dart';

class SearchBox extends GetView<JobsController> {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController searchController) {
        return SearchBar(
          controller: searchController,
          hintText: 'Search by any service-type',
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
          ),
          onTap: () {
            searchController.openView();
          },
          onChanged: (_) {
            searchController.openView();
          },
          leading: const Icon(Icons.search),
          trailing: <Widget>[
            controller.searchBox.isNotEmpty
                ? Tooltip(
                    message: 'Clear filter',
                    child: IconButton(
                      onPressed: () async {
                        if (controller.searchBox.isEmpty) {
                          return;
                        }
                        controller.searchBox.clear();
                        searchController.text = '';
                        AppService.to.showLoading(controller.filterAllData);
                      },
                      icon: const Icon(
                        Icons.cancel,
                      ),
                      style: const ButtonStyle(
                        enableFeedback: true,
                      ),
                    ),
                  )
                : Container(),
          ],
        );
      },
      suggestionsBuilder: (context, searchController) {
        return List<ListTile>.generate(
          controller.serviceTypes.length,
          (int index) {
            final String item = controller.serviceTypes[index]['displayName'];
            return ListTile(
              title: Text(item),
              onTap: () async {
                controller.searchBox.addAll(controller.serviceTypes[index]);
                searchController.closeView(item);
                AppService.to.showLoading(controller.filterAllData);
              },
            );
          },
        );
      },
    );
  }
}
