import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/viewmodel/label_viewmodel.dart';

class LabelContent extends StatefulWidget {
  const LabelContent({super.key});

  @override
  State<LabelContent> createState() => _LabelContentState();
}

class _LabelContentState extends State<LabelContent> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      Future.microtask(() {
        Provider.of<LabelViewModel>(context, listen: false).fetchLabel();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelVM = Provider.of<LabelViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF485F88),
      appBar: AppBar(
        backgroundColor: const Color(0xFF485F88),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home');
            },
          ),
        ),
        title: const Text(
          "Label",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(238, 241, 248, 1.0),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: labelVM.labelList.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 80),
                          child: Text(
                            "Tidak ada label.",
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Card(
                              color: const Color(0xFF485F88),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 8),
                                child: Column(
                                  children: List.generate(
                                      labelVM.labelList.length, (index) {
                                    final label = labelVM.labelList[index];

                                    return Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context, '/tugasLabel', arguments: label.id);
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(Icons.tag, color: Colors.white),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  label.name ?? "-",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete, color: Colors.white),
                                                onPressed: () {
                                                  final labelVM = Provider.of<LabelViewModel>(context, listen: false);
                                                  labelVM.showDeleteLabelModal(context, label.id!, label.name ?? '');
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (index != labelVM.labelList.length - 1)
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 0),
                                            child: Divider(
                                              thickness: 1,
                                              color: Colors.white30,
                                            ),
                                          ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: Transform.translate(
        offset: const Offset(5, -20),
        child: FloatingActionButton(
          onPressed: () => labelVM.showAddLabelModal(context),
          backgroundColor: const Color(0xFF485F88),
          child: const Icon(Icons.add, color: Colors.white),
          shape: const CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
