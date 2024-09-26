import 'package:billingsphere/data/models/item/item_model.dart';
import 'package:billingsphere/data/repository/item_repository.dart';
import 'package:billingsphere/logic/cubits/item_cubit/item_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemCubit extends Cubit<CubitItemStates> {
  ItemCubit() : super(CubitItemLoading()) {
    getItems();
  }

  final ItemsService itemsService = ItemsService();

  Future<void> getItems() async {
    try {
      emit(CubitItemLoading());
      final List<Item> items = await itemsService.fetchItems();
      emit(CubitItemLoaded(items: items));
    } catch (e) {
      emit(CubitItemError(e.toString()));
    }
  }
}
