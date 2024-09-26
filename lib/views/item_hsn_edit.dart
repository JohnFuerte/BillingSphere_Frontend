import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/models/hsn/hsn_model.dart';
import '../data/repository/hsn_repository.dart';
import '../logic/cubits/itemBrand_cubit/itemBrand_cubit.dart';
import 'DB_responsive/DB_desktop_body.dart';
import 'sumit_screen/hsn_code/hsn_code.dart';

class ItemHSNEdit extends StatefulWidget {
  const ItemHSNEdit({super.key});

  @override
  State<ItemHSNEdit> createState() => _ItemHSNEditState();
}

class _ItemHSNEditState extends State<ItemHSNEdit> {
  List<HSNCode> hsnCode = [];
  HSNCodeService hsnCodeService = HSNCodeService();

  Future<void> fetchItemHsn() async {
    final hsnCode = await hsnCodeService.fetchItemHSN();
    setState(() {
      this.hsnCode = hsnCode;
    });

    print(hsnCode.length);
  }

  Future<void> _fetchData() async {
    await Future.wait([
      BlocProvider.of<ItemBrandCubit>(context).getItemBrand(),
    ]);
  }

  @override
  void initState() {
    super.initState();
    fetchItemHsn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.cyan,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const DBMyDesktopBody(),
                      ),
                    );
                  },
                  icon: const Icon(
                    CupertinoIcons.arrow_left,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.45),
                Text(
                  'ITEM HSN CODE MASTER',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
              child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white10,
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListView.builder(
              itemCount: hsnCode.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: ListTile(
                    title: Text(
                      hsnCode[index].hsn,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    subtitle:
                        Text('Description : ${hsnCode[index].description}',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            )),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            hsnCodeService
                                .fetchHsnById(hsnCode[index].id)
                                .then((value) {
                              TextEditingController nameController =
                                  TextEditingController(text: value!.hsn);
                              TextEditingController descController =
                                  TextEditingController(
                                      text: value!.description);
                              TextEditingController unitController =
                                  TextEditingController(text: value!.unit);
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Edit Item Hsn'),
                                    content: SizedBox(
                                      width: 300,
                                      height: 280,
                                      child: StatefulBuilder(
                                        builder: (context, setState) {
                                          return Column(
                                            children: [
                                              TextField(
                                                controller: nameController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Item HSN Code',
                                                ),
                                              ),
                                              TextField(
                                                controller: descController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Description',
                                                ),
                                              ),
                                              TextField(
                                                controller: unitController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Unit',
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    hsnCodeService
                                                        .updateItemHsn(
                                                      id: value.id,
                                                      hsn: nameController.text,
                                                      description:
                                                          descController.text,
                                                      unit: nameController.text,
                                                    );
                                                    setState(() {
                                                      nameController.clear();
                                                    });
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const ItemHSNEdit(),
                                                      ),
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.cyan,
                                                    foregroundColor:
                                                        Colors.white,
                                                    elevation: 2,
                                                    animationDuration:
                                                        const Duration(
                                                            seconds: 2),
                                                  ),
                                                  child: const Text('Submit'),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      nameController.clear();
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                    foregroundColor:
                                                        Colors.white,
                                                    elevation: 2,
                                                    animationDuration:
                                                        const Duration(
                                                            seconds: 2),
                                                  ),
                                                  child: const Text('Cancel'),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                          },
                          icon: const Icon(
                            CupertinoIcons.eye,
                            color: Colors.cyan,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            CupertinoIcons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete Sales'),
                                  content: const Text(
                                      'Are you sure you want to delete this sales?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await hsnCodeService
                                            .deleteHsnCode(hsnCode[index].id);
                                        Navigator.of(context).pop();
                                        setState(() {
                                          hsnCode.removeAt(index);
                                        });
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ItemHSNEdit()));
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Responsive_NewHSNCommodity(),
            ),
          );
        },
        child: Text('Add'),
      ),
    );
  }
}
