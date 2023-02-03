import "dart:io";

void main() {
  var skip = 0;
  final columnNum = 4;

  for (var row = 0; row < 4; row++) {
    skip = columnNum - (row + 1);
    stdout.write('   ' * skip);
    for (var column = 0; column < columnNum; column++) {
      stdout.write('[] ');
    }
    stdout.write('\n');
  }
}
