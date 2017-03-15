import 'dart:async';
import 'package:charcode/ascii.dart';
import 'package:stream_reader/stream_reader.dart';

bool _isNum(int ch) => ch != null && ch >= $0 && ch <= $9;

bool _isWhitespace(int ch) =>
    ch == $space || ch == $cr || ch == $lf || ch == $tab;

class Scanner {
  bool _autoSkip = false;
  StreamReader<int> _reader;
  final Stream<List<int>> input;

  Scanner(this.input) {
    _reader = new StreamReader<int>();
    input.expand<int>((chunk) => chunk).pipe(_reader);
  }

  /// Creates a [Scanner] that automatically skips whitespace.
  factory Scanner.autoSkipWhitespace(Stream<List<int>> input) =>
      new Scanner(input).._autoSkip = true;

  Future _autoSkipWhitespace() async {
    if (_autoSkip) await skipWhitespace();
  }

  /// Closes the underlying [StreamReader].
  Future close() => _reader.close();

  /// Returns `true` if there is an integer at the current position in the [input] stream.
  Future<bool> hasNextInt() => _reader.current().then(_isNum);

  /// Returns `true` if there is more data yet to be read in the [input] stream.
  Future<bool> hasNext() async => !_reader.isDone;

  /// Returns `true` if there is more data yet to be read in the [input] stream.
  Future<bool> hasNextLine() async => !_reader.isDone;

  /// Consumes all whitespace characters starting from the current position,
  /// and stops when a non-whitespace character is encountered.
  ///
  /// Returns the number of whitespace characters skipped.
  Future<int> skipWhitespace() async {
    int count = 0;

    if (_isWhitespace(await _reader.consume())) {
      count++;

      while (_isWhitespace(await _reader.peek())) {
        count++;
        await _reader.consume();
      }
    }

    return count;
  }

  /// Reads characters from the [input] stream until reaching a whitespace character.
  Future<String> next() async {
    var buf = new StringBuffer();

    while (!_reader.isDone) {
      var ch = await _reader.consume();

      if (!_isWhitespace(ch))
        buf.writeCharCode(ch);
      else
        break;
    }

    await _autoSkipWhitespace();
    return buf.toString();
  }

  /// Reads a double, or `0` at the current position in the [input] stream.
  Future<double> nextDouble() async {
    double multiplier = 1.0;

    if (await _reader.current() == $minus) {
      multiplier = -1.0;
      await _reader.consume();
    }

    var buf = new StringBuffer();
    buf.writeCharCode(await _reader.current());

    while (!_reader.isDone) {
      var ch = await _reader.peek();

      if (_isNum(ch)) {
        buf.writeCharCode(ch);
        await _reader.consume();
      } else
        break;
    }

    // Maybe scan a decimal

    if (await _reader.peek() == $dot) {
      await _reader.consume();
      buf.write('.');

      while (!_reader.isDone) {
        var ch = await _reader.peek();

        if (_isNum(ch)) {
          buf.writeCharCode(ch);
          await _reader.consume();
        } else
          break;
      }
    }

    await _autoSkipWhitespace();
    return double.parse(buf.toString()) * multiplier;
  }

  /// Reads an integer, or `0` at the current position in the [input] stream.
  Future<int> nextInt() async {
    int multiplier = 1;

    if (await _reader.current() == $minus) {
      multiplier = -1;
      await _reader.consume();
    }

    var buf = new StringBuffer();
    buf.writeCharCode(await _reader.current());

    while (!_reader.isDone) {
      var ch = await _reader.peek();

      if (_isNum(ch)) {
        buf.writeCharCode(ch);
        await _reader.consume();
      } else
        break;
    }

    await _autoSkipWhitespace();
    return int.parse(buf.toString()) * multiplier;
  }

  /// Reads characters from the [input] stream until reaching a CRLF.
  Future<String> nextLine() async {
    var buf = new StringBuffer();

    while (!_reader.isDone) {
      var ch = await _reader.consume();

      if (ch == $lf) break;
      if (ch != $cr || (await _reader.peek() != $lf))
        buf.writeCharCode(ch);
      else {
        await _reader.consume();
        break;
      }
    }

    await _autoSkipWhitespace();
    return buf.toString();
  }

  /// Skips at most [n] characters.
  Future skip(int n) async {
    for (int i = 0; i < n; i++) {
      try {
        await _reader.consume();
      } catch (e) {
        //
      }
    }
  }
}
