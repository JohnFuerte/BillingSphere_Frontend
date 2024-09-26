import 'dart:typed_data';

import 'package:billingsphere/data/models/brand/item_brand_model.dart';
import 'package:billingsphere/data/models/item/item_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../data/repository/item_brand_repository.dart';
import '../logic/cubits/itemBrand_cubit/itemBrand_cubit.dart';
import 'DB_responsive/DB_desktop_body.dart';

class ItemBrandEdit extends StatefulWidget {
  const ItemBrandEdit({super.key});

  @override
  State<ItemBrandEdit> createState() => _ItemBrandEditState();
}

class _ItemBrandEditState extends State<ItemBrandEdit> {
  List<ItemsBrand> itemBrands = [];
  List<Uint8List> _selectedImages = [];
  ItemsBrandsService itemsBrandsService = ItemsBrandsService();

  Future<void> fetchItemBrands() async {
    final itemBrands = await itemsBrandsService.fetchItemBrands();
    setState(() {
      this.itemBrands = itemBrands;
    });

    print(itemBrands.length);
  }

  Future<void> _fetchData() async {
    await Future.wait([
      BlocProvider.of<ItemBrandCubit>(context).getItemBrand(),
    ]);
  }

  @override
  void initState() {
    super.initState();
    fetchItemBrands();
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
                  'ITEM BRAND MASTER',
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
              itemCount: itemBrands.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: ListTile(
                    title: Text(
                      itemBrands[index].name,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    subtitle: Text(itemBrands[index].name,
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
                            itemsBrandsService
                                .fetchItemBrandById(itemBrands[index].id)
                                .then((value) {
                              TextEditingController nameController =
                                  TextEditingController(text: value.name);
                              _selectedImages =
                                  value.images!.map((e) => e.data).toList();
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Edit Item Brand'),
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
                                                  labelText: 'Item Brand Name',
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              GestureDetector(
                                                onTap: () async {
                                                  FilePickerResult? result =
                                                      await FilePicker.platform
                                                          .pickFiles(
                                                    type: FileType.custom,
                                                    allowedExtensions: [
                                                      'jpg',
                                                      'jpeg',
                                                      'png',
                                                      'gif'
                                                    ],
                                                  );

                                                  if (result != null) {
                                                    List<Uint8List>
                                                        fileBytesList = [];

                                                    for (PlatformFile file
                                                        in result.files) {
                                                      Uint8List fileBytes =
                                                          file.bytes!;
                                                      fileBytesList
                                                          .add(fileBytes);
                                                    }

                                                    setState(() {
                                                      _selectedImages.addAll(
                                                          fileBytesList);
                                                    });
                                                  }
                                                },
                                                child: MouseRegion(
                                                  cursor:
                                                      SystemMouseCursors.click,
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white10,
                                                      border: Border.all(
                                                        color: Colors.white54,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Colors.white10,
                                                          blurRadius: 2,
                                                          offset: Offset(0, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: _selectedImages
                                                            .isNotEmpty
                                                        ? Center(
                                                            child: Image.memory(
                                                              _selectedImages[
                                                                  0],
                                                              fit: BoxFit.cover,
                                                            ),
                                                          )
                                                        : const Center(
                                                            child: Icon(
                                                              CupertinoIcons
                                                                  .camera,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    itemsBrandsService
                                                        .updateItemBrand(
                                                      id: value.id,
                                                      name: nameController.text,
                                                      images: _selectedImages
                                                              .isNotEmpty
                                                          ? ImageData(
                                                              data:
                                                                  _selectedImages[
                                                                      0],
                                                              contentType:
                                                                  'image/png',
                                                              filename:
                                                                  nameController
                                                                      .text,
                                                            )
                                                          : null,
                                                    );
                                                    setState(() {
                                                      _selectedImages.clear();
                                                      nameController.clear();
                                                    });
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const ItemBrandEdit(),
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
                                                      _selectedImages.clear();
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
                                  title: const Text('Delete Item Brand'),
                                  content: const Text(
                                      'Are you sure you want to delete this Item Brand?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await itemsBrandsService
                                            .deleteItemBrands(
                                                itemBrands[index].id);
                                        Navigator.of(context).pop();
                                        setState(() {
                                          itemBrands.removeAt(index);
                                        });
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ItemBrandEdit()));
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
          final TextEditingController catNameController =
              TextEditingController();
          final TextEditingController catBrandController =
              TextEditingController();

          final TextEditingController catDescController =
              TextEditingController();

          List<Uint8List> selectedImage = [];

          Alert(
              context: context,
              title: "ADD BRAND",
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: catBrandController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.category),
                          labelText: 'Brand Name',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
              ),
              buttons: [
                DialogButton(
                  color: Colors.yellow.shade100,
                  onPressed: () {
                    itemsBrandsService.createItemBrand(
                      name: catBrandController.text,
                    );

                    _fetchData();

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const ItemBrandEdit(),
                      ),
                    );
                  },
                  child: const Text(
                    "CREATE",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                DialogButton(
                  color: Colors.yellow.shade100,
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "CANCEL",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ]).show();
        },
        child: Text('Add'),
      ),
    );
  }
}
