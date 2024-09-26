import 'package:billingsphere/data/repository/item_group_repository.dart';
import 'package:billingsphere/logic/cubits/itemGroup_cubit/itemGroup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemGroupCubit extends Cubit<CubitItemGroupStates> {
  ItemGroupCubit() : super(CubitItemGroupLoading());

  final ItemsGroupService itemsGroupService = ItemsGroupService();

  Future<void> getItemGroups() async {
    emit(CubitItemGroupLoading());
    try {
      final itemGroups = await itemsGroupService.fetchItemGroups();
      emit(CubitItemGroupLoaded(itemGroups: itemGroups));
    } catch (e) {
      emit(CubitItemGroupError(e.toString()));
    }
  }
}
