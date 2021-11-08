import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pronto_mia/core/models/external_news.dart';
import 'package:pronto_mia/ui/components/data_view_layout.dart';
import 'package:pronto_mia/ui/components/navigation_layout.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/ui/views/external_news/overview/external_news_overview_viewmodel.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

/// A widget, representing the news.
class ExternalNewsOverviewView extends StatelessWidget {
  final bool adminModeEnabled;

  /// Initializes a new instance of [ExternalNewsOverviewView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree and a
  /// [bool] wether to show admin level functionality as an input.
  const ExternalNewsOverviewView({
    Key key,
    this.adminModeEnabled = false,
  }) : super(key: key);

  /// Binds [ExternalNewsOverviewView] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<ExternalNewsOverviewViewModel>.reactive(
        viewModelBuilder: () => ExternalNewsOverviewViewModel(
          adminModeEnabled: adminModeEnabled,
        ),
        builder: (context, model, child) => NavigationLayout(
          title: "News",
          body: _buildDataView(context, model),
          actions: [
            if (adminModeEnabled)
              ActionSpecification(
                tooltip: 'Neuigkeit erstellen',
                icon: const Icon(Icons.post_add),
                onPressed: () => model.editExternalNews(
                  asDialog: getValueForScreenType<bool>(
                    context: context,
                    mobile: false,
                    desktop: true,
                  ),
                ),
              ),
            /*
            ActionSpecification(
              tooltip: 'Suche öffnen',
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
             */
          ],
        ),
      );

  Widget _buildDataView(
    BuildContext context,
    ExternalNewsOverviewViewModel model,
  ) =>
      DataViewLayout(
        isBusy: model.isBusy,
        errorMessage: model.errorMessage,
        noDataMessage: (model.data == null || model.data.isEmpty)
            ? 'Es sind keine News verfügbar.'
            : null,
        childBuilder: () => _buildList(context, model),
      );

  Widget _buildList(
    BuildContext context,
    ExternalNewsOverviewViewModel model,
  ) =>
      RefreshIndicator(
        onRefresh: model.initialise,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: model.data.length,
          itemBuilder: (context, index) =>
              _buildListItem(context, model, model.data[index]),
        ),
      );

  Widget _buildListItem(
    BuildContext context,
    ExternalNewsOverviewViewModel model,
    ExternalNews externalNews,
  ) =>
      Card(
        child: Row(
          children: [
            Expanded(
              child: ListTile(
                title: Text(model.getExternalNewsTitle(externalNews)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.getExternalNewsDate(externalNews)),
                  ],
                ),
                onTap: () {
                  if (adminModeEnabled) {
                    model.editExternalNews(
                      externalNews: externalNews,
                      asDialog: getValueForScreenType<bool>(
                        context: context,
                        mobile: false,
                        desktop: true,
                      ),
                    );
                  } else {
                    model.openExternalNews(externalNews);
                  }
                },
                leading: FutureBuilder(
                  future: model.getExternalNewsImage(externalNews),
                  builder: (BuildContext context, AsyncSnapshot<Image> image) {
                    if (image.hasData) {
                      return image.data; // image is ready
                    } else {
                      return Image.asset(
                        'assets/images/pronto_icon.png',
                      ); // placeholder
                    }
                  },
                ),
              ),
            ),
            if (adminModeEnabled)
              _buildPublishToggle(context, model, externalNews)
          ],
        ),
      );

  Widget _buildPublishToggle(
    BuildContext context,
    ExternalNewsOverviewViewModel model,
    ExternalNews externalNews,
  ) =>
      Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text("Veröffentlicht?"),
            Switch(
              value: externalNews.published,
              onChanged: (bool newValue) {
                if (newValue) {
                  model.publishExternalNews(externalNews);
                } else {
                  model.hideExternalNews(externalNews);
                }
              },
              activeColor: CustomColors.secondary,
            ),
          ],
        ),
      );
}
