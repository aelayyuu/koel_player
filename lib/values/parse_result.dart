class ParseResult {
  late List _collection;
  late Map _index;

  ParseResult() {
    _collection = [];
    _index = {};
  }

  add(dynamic item, dynamic identifier) {
    _collection.add(item);
    _index[identifier] = item;
  }

  List get collection => _collection;
  Map get index => _index;
}
