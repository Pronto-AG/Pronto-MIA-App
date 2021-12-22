import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pronto_mia/core/models/external_news.dart';
import 'package:pronto_mia/ui/components/data_view_layout.dart';
import 'package:pronto_mia/ui/components/navigation_layout.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/ui/views/external_news/overview/external_news_overview_viewmodel.dart';
import 'package:stacked/stacked.dart';

/// A widget, representing the news.
class ExternalNewsOverviewView extends StatefulWidget {
  final bool adminModeEnabled;

  /// Initializes a new instance of [ExternalNewsOverviewView].

  /// Takes a [Key] to uniquely identify the widget in the widget tree and a
  /// [bool] wether to show admin level functionality as an input.
  const ExternalNewsOverviewView({
    Key key,
    this.adminModeEnabled = false,
  }) : super(key: key);

  @override
  ExternalNewsOverviewViewState createState() =>
      ExternalNewsOverviewViewState();
}

class ExternalNewsOverviewViewState extends State<ExternalNewsOverviewView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  List<ExternalNews> selectedToDelete = [];
  List<ExternalNews> filteredNews = [];
  bool filtered = false;
  bool selectMultiple = false;
  bool selectAll = false;

  /// Binds [ExternalNewsOverviewView] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<ExternalNewsOverviewViewModel>.reactive(
        viewModelBuilder: () => ExternalNewsOverviewViewModel(
          adminModeEnabled: widget.adminModeEnabled,
        ),
        builder: (context, model, child) => NavigationLayout(
          title: "News",
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
                icon: const Icon(Icons.add),
                onPressed: () => model.editExternalNews(),
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
    ExternalNewsOverviewViewModel model,
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
    ExternalNewsOverviewViewModel model,
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
    ExternalNewsOverviewViewModel model,
    List<ExternalNews> externalNews,
  ) =>
      RefreshIndicator(
        onRefresh: model.initialise,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: externalNews.length,
          itemBuilder: (context, index) =>
              _buildListItem(context, model, externalNews[index]),
        ),
      );

  Widget _buildListItem(
    BuildContext context,
    ExternalNewsOverviewViewModel model,
    ExternalNews externalNews,
  ) {
    if (widget.adminModeEnabled) {
      return Dismissible(
        key: Key(externalNews.id.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          setState(() {
            model.data.remove(externalNews);
          });
          model.removeExternalNews(externalNews);
        },
        confirmDismiss: (DismissDirection direction) async {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Löschen bestätigen"),
                content: Text(
                  "Soll '${externalNews.title}' wirklich gelöscht werden?",
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
        child: _buildCardListItem(context, model, externalNews),
      );
    } else {
      return _buildCardListItem(context, model, externalNews);
    }
  }

  Widget _buildCardListItem(
    BuildContext context,
    ExternalNewsOverviewViewModel model,
    ExternalNews externalNews,
  ) =>
      Card(
        color: selectedToDelete.map((e) => e.id).contains(externalNews.id)
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
                          .contains(externalNews.id),
                      onChanged: (value) {
                        _selectToDelete(externalNews);
                        _buildDeleteFab(model);
                      },
                    ),
                  ),
                ],
              ),
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
                  if (widget.adminModeEnabled) {
                    if (selectMultiple) {
                      _selectToDelete(externalNews);
                    } else {
                      model.editExternalNews(
                        externalNews: externalNews,
                      );
                    }
                  } else {
                    model.openExternalNews(externalNews);
                  }
                },
                onLongPress: () {
                  if (widget.adminModeEnabled) {
                    if (!selectMultiple) {
                      selectMultiple = true;
                    }
                    _selectToDelete(externalNews);
                    _buildDeleteFab(model);
                  }
                },
                leading: FutureBuilder(
                  future: model.getExternalNewsImage(externalNews),
                  builder: (BuildContext context, AsyncSnapshot<Image> image) {
                    if (image.hasData) {
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

  Widget _buildDeleteFab(ExternalNewsOverviewViewModel model) {
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

  void _selectToDelete(ExternalNews externalNews) {
    setState(() {
      if (!selectedToDelete.map((news) => news.id).contains(externalNews.id)) {
        selectedToDelete.add(externalNews);
      } else if (selectedToDelete
          .map((news) => news.id)
          .contains(externalNews.id)) {
        selectedToDelete.removeWhere(
          (news) => news.id == externalNews.id,
        );
      }
    });
  }

  void _applyFilter(ExternalNewsOverviewViewModel model, String filter) {
    filtered = true;
    model.filterExternalNews(filter).then(
      (value) {
        setState(() {
          filteredNews = [];
          filteredNews.addAll(value);
        });
      },
    );
  }
}
