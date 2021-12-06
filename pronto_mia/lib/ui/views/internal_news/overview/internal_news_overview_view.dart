import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pronto_mia/core/models/internal_news.dart';
import 'package:pronto_mia/ui/components/data_view_layout.dart';
import 'package:pronto_mia/ui/components/navigation_layout.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/ui/views/internal_news/overview/internal_news_overview_viewmodel.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

/// A widget, representing the news.
class InternalNewsOverviewView extends StatefulWidget {
  final bool adminModeEnabled;

  /// Initializes a new instance of [InternalNewsOverviewView].

  /// Takes a [Key] to uniquely identify the widget in the widget tree and a
  /// [bool] wether to show admin level functionality as an input.
  const InternalNewsOverviewView({
    Key key,
    this.adminModeEnabled = false,
  }) : super(key: key);

  @override
  InternalNewsOverviewViewState createState() =>
      InternalNewsOverviewViewState();
}

class InternalNewsOverviewViewState extends State<InternalNewsOverviewView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  List<InternalNews> selectedToDelete = [];
  List<InternalNews> filteredNews = [];
  bool filtered = false;
  bool selectMultiple = false;
  bool selectAll = false;

  /// Binds [InternalNewsOverviewView] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<InternalNewsOverviewViewModel>.reactive(
        viewModelBuilder: () => InternalNewsOverviewViewModel(
          adminModeEnabled: widget.adminModeEnabled,
        ),
        builder: (context, model, child) => NavigationLayout(
          title: "Aktuelles",
          body: _buildDataView(context, model),
          actions: [
            if (selectMultiple && widget.adminModeEnabled)
              ActionSpecification(
                tooltip: 'Abbrechen',
                icon: const Icon(Icons.cancel),
                onPressed: () => {
                  setState(() {
                    selectMultiple = false;
                    selectedToDelete = [];
                  })
                },
              ),
            if (!selectMultiple && widget.adminModeEnabled)
              ActionSpecification(
                tooltip: 'Neuigkeit erstellen',
                icon: const Icon(Icons.post_add),
                onPressed: () => model.editInternalNews(
                  asDialog: getValueForScreenType<bool>(
                    context: context,
                    mobile: false,
                    desktop: true,
                  ),
                ),
              ),
          ],
          actionsAppBar: [
            if (selectMultiple && widget.adminModeEnabled)
              ActionSpecification(
                tooltip: 'Alle auswählen',
                icon: const Icon(Icons.crop_square),
                onPressed: () => {
                  setState(() {
                    selectedToDelete = [];
                    filtered
                        ? selectedToDelete.addAll(filteredNews)
                        : selectedToDelete.addAll(model.data);
                    selectAll = true;
                  })
                },
              ),
            if (!selectMultiple && widget.adminModeEnabled)
              ActionSpecification(
                tooltip: 'Auswählen',
                icon: const Icon(Icons.select_all),
                onPressed: () => {
                  setState(() {
                    selectMultiple = !selectMultiple;
                  })
                },
              ),
          ],
        ),
      );

  Widget _buildDataView(
    BuildContext context,
    InternalNewsOverviewViewModel model,
  ) =>
      DataViewLayout(
        isBusy: model.isBusy,
        errorMessage: model.errorMessage,
        noDataMessage: (model.data == null || model.data.isEmpty)
            ? 'Es sind keine News verfügbar.'
            : null,
        childBuilder: () => _buildFilter(context, model),
      );

  Widget _buildFilter(
    BuildContext context,
    InternalNewsOverviewViewModel model,
  ) {
    if (widget.adminModeEnabled) {
      return Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (filter) => _applyFilter(model, filter),
            decoration: InputDecoration(
              labelText: 'News suchen',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => {
                  _searchController.clear(),
                  _applyFilter(model, ''),
                  filtered = false,
                },
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: filtered
                  ? _buildList(context, model, filteredNews)
                  : _buildList(context, model, model.data),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _buildDeleteFab(model),
            ),
          ),
        ],
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            if (filtered)
              _buildList(context, model, filteredNews)
            else
              _buildList(context, model, model.data)
          ],
        ),
      );
    }
  }

  Widget _buildList(
    BuildContext context,
    InternalNewsOverviewViewModel model,
    List<InternalNews> internalNews,
  ) =>
      RefreshIndicator(
        onRefresh: model.initialise,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: internalNews.length,
          itemBuilder: (context, index) =>
              _buildListItem(context, model, internalNews[index]),
        ),
      );

  Widget _buildListItem(
    BuildContext context,
    InternalNewsOverviewViewModel model,
    InternalNews internalNews,
  ) {
    if (widget.adminModeEnabled) {
      return Dismissible(
        key: Key(internalNews.id.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          setState(() {
            model.data.remove(internalNews);
          });
          model.removeInternalNews(internalNews);
        },
        confirmDismiss: (DismissDirection direction) async {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Löschen bestätigen"),
                content: Text(
                  "Soll '${internalNews.title}' wirklich gelöscht werden?",
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      "Löschen",
                      style: TextStyle(color: CustomColors.secondary),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Abbrechen"),
                  ),
                ],
              );
            },
          );
        },
        background: Container(
          color: Colors.red,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.centerRight,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        child: _buildCardListItem(context, model, internalNews),
      );
    } else {
      return _buildCardListItem(context, model, internalNews);
    }
  }

  Widget _buildCardListItem(
    BuildContext context,
    InternalNewsOverviewViewModel model,
    InternalNews internalNews,
  ) =>
      Card(
        color: selectedToDelete.map((e) => e.id).contains(internalNews.id)
            ? Colors.grey[200]
            : null,
        child: Row(
          children: [
            if (selectMultiple)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Checkbox(
                      activeColor: Colors.blue,
                      value: selectedToDelete
                          .map((e) => e.id)
                          .contains(internalNews.id),
                      onChanged: (value) {
                        _selectToDelete(internalNews);
                        _buildDeleteFab(model);
                      },
                    ),
                  ),
                ],
              ),
            Expanded(
              child: ListTile(
                title: Text(model.getInternalNewsTitle(internalNews)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.getInternalNewsDate(internalNews)),
                  ],
                ),
                onTap: () {
                  if (widget.adminModeEnabled) {
                    if (selectMultiple) {
                      _selectToDelete(internalNews);
                    } else {
                      model.editInternalNews(
                        internalNews: internalNews,
                        asDialog: getValueForScreenType<bool>(
                          context: context,
                          mobile: false,
                          desktop: true,
                        ),
                      );
                    }
                  } else {
                    model.openInternalNews(internalNews);
                  }
                },
                onLongPress: () {
                  if (!selectMultiple) {
                    selectMultiple = true;
                  }
                  _selectToDelete(internalNews);
                  _buildDeleteFab(model);
                },
                leading: FutureBuilder(
                  future: model.getInternalNewsImage(internalNews),
                  builder: (BuildContext context, AsyncSnapshot<Image> image) {
                    if (image.hasData) {
                      // return image.data; // image is ready
                      return Container(
                        width: kIsWeb
                            ? MediaQuery.of(context).size.width * 0.05
                            : MediaQuery.of(context).size.width * 0.2,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: image.data.image,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      );
                    } else {
                      return Image.asset(
                        'assets/images/pronto_icon.png',
                      ); // placeholder
                    }
                  },
                ),
              ),
            ),
            if (widget.adminModeEnabled)
              _buildPublishToggle(context, model, internalNews)
          ],
        ),
      );

  Widget _buildPublishToggle(
    BuildContext context,
    InternalNewsOverviewViewModel model,
    InternalNews internalNews,
  ) =>
      Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text("Veröffentlicht?"),
            Switch(
              value: internalNews.published,
              onChanged: (bool newValue) {
                if (newValue) {
                  model.publishInternalNews(internalNews);
                } else {
                  model.hideInternalNews(internalNews);
                }
              },
              activeColor: CustomColors.secondary,
            ),
          ],
        ),
      );

  Widget _buildDeleteFab(InternalNewsOverviewViewModel model) {
    return Visibility(
      visible: selectedToDelete.isNotEmpty,
      child: FloatingActionButton.extended(
        heroTag: "removeFab",
        elevation: 4.0,
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Löschen bestätigen"),
              content: Text(
                "Sollen ${selectedToDelete.length} " +
                    "News wirklich gelöscht werden?",
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                    await model.removeItems(selectedToDelete);
                    selectedToDelete = [];
                  },
                  child: const Text(
                    "Löschen",
                    style: TextStyle(color: CustomColors.secondary),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Abbrechen"),
                ),
              ],
            );
          },
        ),
        icon: const Icon(Icons.delete),
        label: selectedToDelete.isNotEmpty
            ? Text('${selectedToDelete.length} News löschen')
            : const Text('Löschen'),
      ),
    );
  }

  void _selectToDelete(InternalNews internalNews) {
    setState(() {
      if (!selectedToDelete.map((news) => news.id).contains(internalNews.id)) {
        selectedToDelete.add(internalNews);
      } else if (selectedToDelete
          .map((news) => news.id)
          .contains(internalNews.id)) {
        selectedToDelete.removeWhere(
          (news) => news.id == internalNews.id,
        );
      }
    });
  }

  void _applyFilter(InternalNewsOverviewViewModel model, String filter) {
    filtered = true;
    model.filterInternalNews(filter).then(
      (value) {
        setState(() {
          filteredNews = [];
          filteredNews.addAll(value);
        });
      },
    );
  }
}
