import 'package:app_store/controller/search_screen_controller.dart';
import 'package:app_store/view/individual_screen/individual_screen.dart';
import 'package:app_store/view/individual_screen/saved_individual_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_store/utils/color_constants.dart';


class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = Provider.of<SearchScreenController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.darkNavyBlue,
        title: Text(
          "Search",
          style: TextStyle(
            color: ColorConstant.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: ColorConstant.darkNavyBlue,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // **SEARCH BAR**
            TextField(
              onChanged: (query) {
                searchController.updateSearchQuery(query);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: ColorConstant.white,
                hintText: "Search for apps, games, or more",
                hintStyle: TextStyle(
                  color: ColorConstant.coolGray,
                  fontSize: 16,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // **SEARCH RESULTS**
            Expanded(
              child: Consumer<SearchScreenController>(
                builder: (context, controller, _) {

                  if (controller.searchQuery.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 100,
                          color: ColorConstant.lightBlue,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Start Searching",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Type something in the search bar to get started.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: ColorConstant.coolGray,
                          ),
                        ),
                      ],
                    );
                  }

                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Show "No Results Found" if no data matches search
                  if (controller.filteredData.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 100,
                          color: ColorConstant.lightBlue,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "No Results Found",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Try searching for something else.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: ColorConstant.coolGray,
                          ),
                        ),
                      ],
                    );
                  }

                  // Show search results
                  return ListView.builder(
                    itemCount: controller.filteredData.length,
                    itemBuilder: (context, index) {
                      var app = controller.filteredData[index];

                      return ListTile(
                        leading: Image.network(
                          app['thumbnail'] ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
                          },
                        ),
                        title: Text(
                          app['title'] ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.white,
                          ),
                        ),
                        subtitle: Text(
                          app['author'] ?? '',
                          style: TextStyle(color: ColorConstant.coolGray),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, color: ColorConstant.lightBlue, size: 20),
                        onTap: () {
                           var selectedApp = controller.filteredData[index];
                          Navigator.push(context, MaterialPageRoute(builder: (context) => IndividualScreen(appData: selectedApp,),));
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
