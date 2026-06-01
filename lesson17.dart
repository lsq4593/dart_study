// Dart 第十七课：implements 接口

void main() {
  var tv = TV();
  tv.turnOn();

  var fan = Fan();
  fan.turnOn();
}

// 定义规范
class Electronic {
  void turnOn() {} // 有方法体，但为空
}

// implements 表示"按这个规范来"，必须重写所有方法
class TV implements Electronic {
  @override
  void turnOn() {
    print('电视开机');
  }
}

class Fan implements Electronic {
  @override
  void turnOn() {
    print('电扇开机');
  }
}
