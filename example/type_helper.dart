import 'dart:math';

class Parent {}

class Child implements Parent {
  String get childThing => 'Just kidding!';
}

class OtherChild implements Parent {}

List<X> listOfMaybe<X>(Object? perhapsInclude) =>
    perhapsInclude is X ? <X>[perhapsInclude] : <X>[];

TypeHelper<List<X>> listTypeHelper<X>() => TypeHelper<List<X>>();

void main() {
  Parent p = Random().nextBool() ? Child() : OtherChild();
  final typeParent = TypeHelper<Parent>();
  final typeChild = TypeHelper<Child>();

  print('p is typeParent: ${p.isA(typeParent)}');
  print('p is typeChild: ${p.isA(typeChild)}');
  print('typeChild <: typeParent: ${typeChild <= typeParent}'); // 'true'.
  print('typeParent <: typeChild: ${typeParent <= typeChild}'); // 'false'.

  // Create a `TypeHelper` for a `List` type whose type argument is `typeChild`.
  var typeListOfChild =
      typeChild.callWith<List<Object?>>(<X>() => TypeHelper<List<X>>());
  print(typeListOfChild); // `TypeHelper<List<Child>>`.

  // Create a `List` whose type argument is `typeChild`, containing `p` if OK.
  var listOfChild = typeChild.callWith(<X>() => listOfPerhaps<X>(p));
  print('listOfChild: $listOfChild, of type: ${listOfChild.runtimeType}');

  // Promote to the type of a `TypeHelper`. Note that we are using the
  // statically known bound `Child` of `typeChild`, but the promotion will
  // check that `p` has the actual type represented by `typeChild`, which
  // could be any subtype of `Child`.
  print('Promoting:');
  var children = typeChild.promoting(p, <X extends Child>(X promotedP) {
    print('  Yes, the promotion succeeded!');
    print('  Can do `Child` specific things: ${promotedP.childThing}');
    return <X>[promotedP];
  });
  print('Type of children: ${children.runtimeType}');
}
