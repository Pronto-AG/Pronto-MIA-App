import 'package:flutter/material.dart';
import 'package:pronto_mia/core/models/educational_content.dart';
import 'package:pronto_mia/ui/components/data_view_layout.dart';
import 'package:pronto_mia/ui/components/navigation_layout.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/ui/views/educational_content/overview/educational_content_overview_viewmodel.dart';
import 'package:stacked/stacked.dart';

/// A widget, representing the educational content.
class EducationalContentOverviewView extends StatefulWidget {
  final bool adminModeEnabled;

  /// Initializes a new instance of [EducationalContentOverviewView].

  /// Takes a [Key] to uniquely identify the widget in the widget tree and a
  /// [bool] wether to show admin level functionality as an input.
  const EducationalContentOverviewView({
    Key key,
    this.adminModeEnabled = false,
  }) : super(key: key);

  @override
  EducationalContentOverviewViewState createState() =>
      EducationalContentOverviewViewState();
}

class EducationalContentOverviewViewState
    extends State<EducationalContentOverviewView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  List<EducationalContent> selectedToDelete = [];
  List<EducationalContent> filteredNews = [];
  bool filtered = false;
  bool selectMultiple = false;
  bool selectAll = false;

  /// Binds [EducationalContentOverviewView] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<EducationalContentOverviewViewModel>.reactive(
        viewModelBuilder: () => EducationalContentOverviewViewModel(
          adminModeEnabled: widget.adminModeEnabled,
        ),
        builder: (context, model, child) => NavigationLayout(
          title: "Schulungsvideos",
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
                tooltip: 'Schulungsvideo erstellen',
                icon: const Icon(Icons.add),
                onPressed: () => model.editEducationalContent(),
              ),
          ],
          actionsAppBar: [
            if (selectMultiple && widget.adminModeEnabled)
              ActionSpecification(
                tooltip: 'Alle ausw??hlen',
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
                tooltip: 'Ausw??hlen',
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
    EducationalContentOverviewViewModel model,
  ) =>
      DataViewLayout(
        isBusy: model.isBusy,
        errorMessage: model.errorMessage,
        noDataMessage: (model.data == null || model.data.isEmpty)
            ? 'Es sind keine Schulungsvideos verf??gbar.'
            : null,
        childBuilder: () => _buildFilter(context, model),
      );

  Widget _buildFilter(
    BuildContext context,
    EducationalContentOverviewViewModel model,
  ) {
    // if (widget.adminModeEnabled) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: (filter) => _applyFilter(model, filter),
          decoration: InputDecoration(
            labelText: 'Schulungsvideo suchen',
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
  }

  Widget _buildList(
    BuildContext context,
    EducationalContentOverviewViewModel model,
    List<EducationalContent> educationalContent,
  ) =>
      RefreshIndicator(
        onRefresh: model.initialise,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: educationalContent.length,
          itemBuilder: (context, index) =>
              _buildListItem(context, model, educationalContent[index]),
        ),
      );

  Widget _buildListItem(
    BuildContext context,
    EducationalContentOverviewViewModel model,
    EducationalContent educationalContent,
  ) {
    if (widget.adminModeEnabled) {
      return Dismissible(
        key: Key(educationalContent.id.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          setState(() {
            model.data.remove(educationalContent);
          });
          model.removeEducationalContent(educationalContent);
        },
        confirmDismiss: (DismissDirection direction) async {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("L??schen best??tigen"),
                content: Text(
                  "Soll '${educationalContent.title}' wirklich gel??scht"
                  " werden?",
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      "L??schen",
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
        child: _buildCardListItem(context, model, educationalContent),
      );
    } else {
      return _buildCardListItem(context, model, educationalContent);
    }
  }

  Widget _buildCardListItem(
    BuildContext context,
    EducationalContentOverviewViewModel model,
    EducationalContent educationalContent,
  ) =>
      Card(
        color: selectedToDelete.map((e) => e.id).contains(educationalContent.id)
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
                          .contains(educationalContent.id),
                      onChanged: (value) {
                        _selectToDelete(educationalContent);
                        _buildDeleteFab(model);
                      },
                    ),
                  ),
                ],
              ),
            Expanded(
              child: ListTile(
                title:
                    Text(model.getEducationalContentTitle(educationalContent)),
                onTap: () {
                  if (widget.adminModeEnabled) {
                    if (selectMultiple) {
                      _selectToDelete(educationalContent);
                    } else {
                      model.editEducationalContent(
                        educationalContent: educationalContent,
                      );
                    }
                  } else {
                    if (model.getEducationalContentFileExtension(
                          educationalContent,
                        ) ==
                        'pdf') {
                      model.openPdf(educationalContent);
                    } else {
                      model.openEducationalContent(educationalContent);
                    }
                  }
                },
                onLongPress: () {
                  if (!selectMultiple) {
                    selectMultiple = true;
                  }
                  _selectToDelete(educationalContent);
                  _buildDeleteFab(model);
                },
              ),
            ),
            if (widget.adminModeEnabled)
              _buildPublishToggle(context, model, educationalContent)
          ],
        ),
      );

  Widget _buildPublishToggle(
    BuildContext context,
    EducationalContentOverviewViewModel model,
    EducationalContent educationalContent,
  ) =>
      Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text("Ver??ffentlicht?"),
            Switch(
              value: educationalContent.published,
              onChanged: (bool newValue) {
                if (newValue) {
                  model.publishEducationalContent(educationalContent);
                } else {
                  model.hideEducationalContent(educationalContent);
                }
              },
              activeColor: CustomColors.secondary,
            ),
          ],
        ),
      );

  Widget _buildDeleteFab(EducationalContentOverviewViewModel model) {
    return Visibility(
      visible: selectedToDelete.isNotEmpty,
      child: FloatingActionButton.extended(
        heroTag: "removeFab",
        elevation: 4.0,
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("L??schen best??tigen"),
              content: Text(
                "Sollen ${selectedToDelete.length} " +
                    "Schulungsvideo wirklich gel??scht werden?",
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                    await model.removeItems(selectedToDelete);
                    selectedToDelete = [];
                  },
                  child: const Text(
                    "L??schen",
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
            ? Text('${selectedToDelete.length} News l??schen')
            : const Text('L??schen'),
      ),
    );
  }

  void _selectToDelete(EducationalContent educationalContent) {
    setState(() {
      if (!selectedToDelete
          .map((news) => news.id)
          .contains(educationalContent.id)) {
        selectedToDelete.add(educationalContent);
      } else if (selectedToDelete
          .map((news) => news.id)
          .contains(educationalContent.id)) {
        selectedToDelete.removeWhere(
          (news) => news.id == educationalContent.id,
        );
      }
    });
  }

  void _applyFilter(EducationalContentOverviewViewModel model, String filter) {
    filtered = true;
    model.filterEducationalContent(filter).then(
      (value) {
        setState(() {
          filteredNews = [];
          filteredNews.addAll(value);
        });
      },
    );
  }
}
