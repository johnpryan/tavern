// source: https://github.com/montyr75/dart_snake

import 'dart:async';
import 'dart:html';
import 'dart:math';
import 'dart:collection';

const int CELL_SIZE = 10;

CanvasElement canvas;
CanvasRenderingContext2D ctx;
Keyboard keyboard = Keyboard();

void main() {
  canvas = querySelector('#canvas')..focus();
  ctx = canvas.getContext('2d');

  Game()..run();
}

void drawCell(Point coords, String color) {
  ctx
    ..fillStyle = color
    ..strokeStyle = 'white';

  final int x = coords.x * CELL_SIZE;
  final int y = coords.y * CELL_SIZE;

  ctx
    ..fillRect(x, y, CELL_SIZE, CELL_SIZE)
    ..strokeRect(x, y, CELL_SIZE, CELL_SIZE);
}

void clear() {
  ctx
    ..fillStyle = 'white'
    ..fillRect(0, 0, canvas.width, canvas.height);
}

class Game {
  // smaller numbers make the game run faster
  static const num GAME_SPEED = 50;

  num _lastTimeStamp = 0;

  // a few convenience variables to simplify calculations
  int _rightEdgeX;
  int _bottomEdgeY;

  Snake _snake;
  Point _food;

  Game() {
    _rightEdgeX = canvas.width ~/ CELL_SIZE;
    _bottomEdgeY = canvas.height ~/ CELL_SIZE;

    init();
  }

  void init() {
    _snake = Snake();
    _food = _randomPoint();
  }

  Point _randomPoint() {
    var random = Random();
    return Point(random.nextInt(_rightEdgeX), random.nextInt(_bottomEdgeY));
  }

  void _checkForCollisions() {
    // check for collision with food
    if (_snake.head == _food) {
      _snake.grow();
      _food = _randomPoint();
    }

    // check death conditions
    if (_snake.head.x <= -1 ||
        _snake.head.x >= _rightEdgeX ||
        _snake.head.y <= -1 ||
        _snake.head.y >= _bottomEdgeY ||
        _snake.checkForBodyCollision()) {
      init();
    }
  }

  Future run() async {
    update(await window.animationFrame);
  }

  void update(num delta) {
    final diff = delta - _lastTimeStamp;

    if (diff > GAME_SPEED) {
      _lastTimeStamp = delta;
      clear();
      drawCell(_food, 'blue');
      _snake.update();
      _checkForCollisions();
    }

    // keep looping
    run();
  }
}

class Snake {
  static const Point LEFT = Point(-1, 0);
  static const Point RIGHT = Point(1, 0);
  static const Point UP = Point(0, -1);
  static const Point DOWN = Point(0, 1);

  static const int START_LENGTH = 6;

  List<Point> _body; // coordinates of the body segments
  Point _dir = RIGHT; // current travel direction

  Snake() {
    var i = START_LENGTH - 1;
    _body = List<Point>.generate(START_LENGTH, (int index) => Point(i--, 0));
  }

  Point get head => _body.first;

  void _checkInput() {
    if (keyboard.isPressed(KeyCode.LEFT) && _dir != RIGHT) {
      _dir = LEFT;
    } else if (keyboard.isPressed(KeyCode.RIGHT) && _dir != LEFT) {
      _dir = RIGHT;
    } else if (keyboard.isPressed(KeyCode.UP) && _dir != DOWN) {
      _dir = UP;
    } else if (keyboard.isPressed(KeyCode.DOWN) && _dir != UP) {
      _dir = DOWN;
    }
  }

  void grow() {
    // add new head based on current direction
    _body.insert(0, head + _dir);
  }

  void _move() {
    // add a new head segment
    grow();

    // remove the tail segment
    _body.removeLast();
  }

  void _draw() {
    // starting with the head, draw each body segment
    for (var p in _body) {
      drawCell(p, 'green');
    }
  }

  bool checkForBodyCollision() {
    for (var p in _body.skip(1)) {
      if (p == head) {
        return true;
      }
    }

    return false;
  }

  void update() {
    _checkInput();
    _move();
    _draw();
  }
}

class Keyboard {
  final HashMap<int, num> _keys = HashMap<int, num>();

  Keyboard() {
    window.onKeyDown.listen((KeyboardEvent event) {
      event.preventDefault();
      _keys.putIfAbsent(event.keyCode, () => event.timeStamp);
    });

    window.onKeyUp.listen((KeyboardEvent event) {
      _keys.remove(event.keyCode);
    });
  }

  bool isPressed(int keyCode) => _keys.containsKey(keyCode);
}
